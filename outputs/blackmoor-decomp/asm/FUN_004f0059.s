# FUN_004f0059
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f0059
# extent:       0x004f0059-0x004f257c (9507 code bytes)
# span:         0x004f0059-0x004f2610 (code 9507, tables 148, padding 0)
# sha256:       b1f07ba04af6c06c802a3cedb860b07a0bea5bacd29088b002d4768b7905abea
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f0059
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_6, field_8, field_c, field_10, field_21, field_28, field_34, field_38, field_3c, field_40, field_4a and 32 more; [ecx + n] field_4, field_8, field_c, field_10, field_28, field_2f, field_34, field_38, field_3c, field_40, field_48, field_4a and 22 more; [edx + n] field_4, field_8, field_c, field_10, field_21, field_23, field_28, field_2d, field_34, field_38, field_40, field_48 and 25 more
# callees:      calls FUN_00469057, FUN_004b42d3, FUN_00459cc9, FUN_004a3f40, FUN_004acf45, FUN_0048a920, FUN_004a1e16, FUN_0048e628, FUN_0048d1e8, FUN_004a6574, FUN_004b5d17, FUN_004ab528, FUN_00465c99, FUN_00462c39, FUN_00487c92, FUN_004b2250 and 29 more
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_pointer_consume (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 2237 instruction(s), 255 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_28, 0x28  # offset +0x28
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_48, 0x48  # offset +0x48
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_50, 0x50  # offset +0x50
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6e, 0x6e  # offset +0x6e
.equ field_72, 0x72  # offset +0x72
.equ field_76, 0x76  # offset +0x76
.equ field_7a, 0x7a  # offset +0x7a
.equ field_e1, 0xe1  # offset +0xe1
.equ field_e5, 0xe5  # offset +0xe5
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed
.equ field_123, 0x123  # offset +0x123
.equ field_127, 0x127  # offset +0x127
.equ field_12b, 0x12b  # offset +0x12b
.equ field_12f, 0x12f  # offset +0x12f
.equ field_165, 0x165  # offset +0x165
.equ field_169, 0x169  # offset +0x169
.equ field_16d, 0x16d  # offset +0x16d
.equ field_171, 0x171  # offset +0x171
.equ field_1de, 0x1de  # offset +0x1de
.equ field_1e2, 0x1e2  # offset +0x1e2
.equ field_1e5, 0x1e5  # offset +0x1e5
.equ field_1e6, 0x1e6  # offset +0x1e6
.equ field_1e9, 0x1e9  # offset +0x1e9
.equ field_1ea, 0x1ea  # offset +0x1ea
.equ field_1ed, 0x1ed  # offset +0x1ed
.equ field_1f1, 0x1f1  # offset +0x1f1
.equ field_22f, 0x22f  # offset +0x22f
.equ field_233, 0x233  # offset +0x233
.equ field_237, 0x237  # offset +0x237
.equ field_23b, 0x23b  # offset +0x23b
.equ field_265, 0x265  # offset +0x265
.equ field_26d, 0x26d  # offset +0x26d
.equ field_26f, 0x26f  # offset +0x26f
.equ field_2cb, 0x2cb  # offset +0x2cb
.equ field_2cf, 0x2cf  # offset +0x2cf
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_307, 0x307  # offset +0x307
.equ field_30b, 0x30b  # offset +0x30b
.equ field_30f, 0x30f  # offset +0x30f
.equ field_313, 0x313  # offset +0x313
.equ field_5ca, 0x5ca  # offset +0x5ca
.equ field_5ce, 0x5ce  # offset +0x5ce
.equ field_5d2, 0x5d2  # offset +0x5d2
.equ field_5d6, 0x5d6  # offset +0x5d6
.equ field_617, 0x617  # offset +0x617
.equ field_61b, 0x61b  # offset +0x61b
.equ field_61f, 0x61f  # offset +0x61f
.equ field_623, 0x623  # offset +0x623

# --- external targets -----------------------------------------------
.set FUN_0040b2d0, .text + (0x0040b2d0 - 0x401000)
.set FUN_0044d28c, .text + (0x0044d28c - 0x401000)
.set FUN_0044eab1, .text + (0x0044eab1 - 0x401000)
.set FUN_00455180, .text + (0x00455180 - 0x401000)
.set FUN_004571e1, .text + (0x004571e1 - 0x401000)
.set FUN_0045841e, .text + (0x0045841e - 0x401000)
.set FUN_00459cc9, .text + (0x00459cc9 - 0x401000)
.set FUN_0045b5bb, .text + (0x0045b5bb - 0x401000)
.set FUN_0045e1ca, .text + (0x0045e1ca - 0x401000)
.set FUN_00462c39, .text + (0x00462c39 - 0x401000)
.set FUN_00464792, .text + (0x00464792 - 0x401000)
.set FUN_00465c99, .text + (0x00465c99 - 0x401000)
.set FUN_00467740, .text + (0x00467740 - 0x401000)
.set FUN_00469057, .text + (0x00469057 - 0x401000)
.set FUN_0046bca9, .text + (0x0046bca9 - 0x401000)
.set FUN_0046ea16, .text + (0x0046ea16 - 0x401000)
.set FUN_00470ffe, .text + (0x00470ffe - 0x401000)
.set FUN_00473206, .text + (0x00473206 - 0x401000)
.set FUN_00475da4, .text + (0x00475da4 - 0x401000)
.set FUN_00479deb, .text + (0x00479deb - 0x401000)
.set FUN_0047b4aa, .text + (0x0047b4aa - 0x401000)
.set FUN_0047d734, .text + (0x0047d734 - 0x401000)
.set FUN_0047f421, .text + (0x0047f421 - 0x401000)
.set FUN_00482359, .text + (0x00482359 - 0x401000)
.set FUN_00484f42, .text + (0x00484f42 - 0x401000)
.set FUN_00487c92, .text + (0x00487c92 - 0x401000)
.set FUN_004897cd, .text + (0x004897cd - 0x401000)
.set FUN_0048a920, .text + (0x0048a920 - 0x401000)
.set FUN_0048bd91, .text + (0x0048bd91 - 0x401000)
.set FUN_0048d1e8, .text + (0x0048d1e8 - 0x401000)
.set FUN_0048e628, .text + (0x0048e628 - 0x401000)
.set FUN_004a1e16, .text + (0x004a1e16 - 0x401000)
.set FUN_004a3f40, .text + (0x004a3f40 - 0x401000)
.set FUN_004a6574, .text + (0x004a6574 - 0x401000)
.set FUN_004a835c, .text + (0x004a835c - 0x401000)
.set FUN_004aa0f0, .text + (0x004aa0f0 - 0x401000)
.set FUN_004ab528, .text + (0x004ab528 - 0x401000)
.set FUN_004acf45, .text + (0x004acf45 - 0x401000)
.set FUN_004b2250, .text + (0x004b2250 - 0x401000)
.set FUN_004b42d3, .text + (0x004b42d3 - 0x401000)
.set FUN_004b5d17, .text + (0x004b5d17 - 0x401000)
.set FUN_004b7389, .text + (0x004b7389 - 0x401000)
.set FUN_004b81ff, .text + (0x004b81ff - 0x401000)
.set FUN_004ba377, .text + (0x004ba377 - 0x401000)
.set FUN_004cb058, .text + (0x004cb058 - 0x401000)

.org 0x004f0059 - 0x401000
.globl FUN_004f0059
FUN_004f0059:
    # block 0x004f0059: entry, 8 instruction(s), ends with jge to 0x004f0093 (forward)
    push ebp                                     # 004f0059
    {load} mov ebp, esp                          # 004f005a
    sub esp, 0x10                                # 004f005c
    mov dword ptr [ebp - local_4], ecx           # 004f005f
    mov eax, dword ptr [ebp - local_4]           # 004f0062
    mov ecx, dword ptr [0x583102]                # 004f0065
    cmp ecx, dword ptr [eax + field_4]           # 004f006b
    jge.d8 L_004f0093                            # 004f006e
    # block 0x004f0070: entered by fall-through of jge at 0x004f006e, 4 instruction(s), ends with jg to 0x004f2576 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0070
    mov eax, dword ptr [0x583102]                # 004f0073
    cmp eax, dword ptr [edx + field_4]           # 004f0078
    jg.d32 L_004f2576                            # 004f007b
    # block 0x004f0081: entered by fall-through of jg at 0x004f007b, 4 instruction(s), ends with jl to 0x004f2576 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0081
    mov edx, dword ptr [0x58310a]                # 004f0084
    cmp edx, dword ptr [ecx + field_4]           # 004f008a
    jl.d32 L_004f2576                            # 004f008d
L_004f0093:
    # block 0x004f0093: entered by jge at 0x004f006e; fall-through of jl at 0x004f008d, 4 instruction(s), ends with jle to 0x004f00c4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0093
    mov ecx, dword ptr [0x58310a]                # 004f0096
    cmp ecx, dword ptr [eax + field_c]           # 004f009c
    jle.d8 L_004f00c4                            # 004f009f
    # block 0x004f00a1: entered by fall-through of jle at 0x004f009f, 4 instruction(s), ends with jg to 0x004f2576 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f00a1
    mov eax, dword ptr [0x583102]                # 004f00a4
    cmp eax, dword ptr [edx + field_c]           # 004f00a9
    jg.d32 L_004f2576                            # 004f00ac
    # block 0x004f00b2: entered by fall-through of jg at 0x004f00ac, 4 instruction(s), ends with jl to 0x004f2576 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f00b2
    mov edx, dword ptr [0x58310a]                # 004f00b5
    cmp edx, dword ptr [ecx + field_c]           # 004f00bb
    jl.d32 L_004f2576                            # 004f00be
L_004f00c4:
    # block 0x004f00c4: entered by jle at 0x004f009f; fall-through of jl at 0x004f00be, 4 instruction(s), ends with jge to 0x004f00f5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f00c4
    mov ecx, dword ptr [0x583106]                # 004f00c7
    cmp ecx, dword ptr [eax + field_8]           # 004f00cd
    jge.d8 L_004f00f5                            # 004f00d0
    # block 0x004f00d2: entered by fall-through of jge at 0x004f00d0, 4 instruction(s), ends with jg to 0x004f2576 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f00d2
    mov eax, dword ptr [0x583106]                # 004f00d5
    cmp eax, dword ptr [edx + field_8]           # 004f00da
    jg.d32 L_004f2576                            # 004f00dd
    # block 0x004f00e3: entered by fall-through of jg at 0x004f00dd, 4 instruction(s), ends with jl to 0x004f2576 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f00e3
    mov edx, dword ptr [0x58310e]                # 004f00e6
    cmp edx, dword ptr [ecx + field_8]           # 004f00ec
    jl.d32 L_004f2576                            # 004f00ef
L_004f00f5:
    # block 0x004f00f5: entered by jge at 0x004f00d0; fall-through of jl at 0x004f00ef, 4 instruction(s), ends with jle to 0x004f0126 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f00f5
    mov ecx, dword ptr [0x58310e]                # 004f00f8
    cmp ecx, dword ptr [eax + field_10]          # 004f00fe
    jle.d8 L_004f0126                            # 004f0101
    # block 0x004f0103: entered by fall-through of jle at 0x004f0101, 4 instruction(s), ends with jg to 0x004f2576 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0103
    mov eax, dword ptr [0x583106]                # 004f0106
    cmp eax, dword ptr [edx + field_10]          # 004f010b
    jg.d32 L_004f2576                            # 004f010e
    # block 0x004f0114: entered by fall-through of jg at 0x004f010e, 4 instruction(s), ends with jl to 0x004f2576 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0114
    mov edx, dword ptr [0x58310e]                # 004f0117
    cmp edx, dword ptr [ecx + field_10]          # 004f011d
    jl.d32 L_004f2576                            # 004f0120
L_004f0126:
    # block 0x004f0126: entered by jle at 0x004f0101; fall-through of jl at 0x004f0120, 3 instruction(s), ends with jne to 0x004f0154 (forward)
    movsx eax, word ptr [0x583a29]               # 004f0126
    cmp eax, -0x1                                # 004f012d
    jne.d8 L_004f0154                            # 004f0130
    # block 0x004f0132: entered by fall-through of jne at 0x004f0130, 5 instruction(s), ends with forward jump to 0x004f01ae
    mov dword ptr [0x5b44f0], 0x0                # 004f0132
    mov dword ptr [0x5b44f4], 0x0                # 004f013c
    mov ecx, dword ptr [0x5d0377]                # 004f0146
    mov dword ptr [0x5d162d], ecx                # 004f014c
    jmp.d8 L_004f01ae                            # 004f0152
L_004f0154:
    # block 0x004f0154: entered by jne at 0x004f0130, 3 instruction(s), ends with je to 0x004f017f (forward)
    movsx edx, word ptr [0x583a29]               # 004f0154
    cmp edx, -0x1                                # 004f015b
    je.d8 L_004f017f                             # 004f015e
    # block 0x004f0160: entered by fall-through of je at 0x004f015e, 2 instruction(s), ends with je to 0x004f017f (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 004f0160
    je.d8 L_004f017f                             # 004f0167
    # block 0x004f0169: entered by fall-through of je at 0x004f0167, 4 instruction(s), ends with forward jump to 0x004f01ae
    mov dword ptr [0x5b44f4], 0x0                # 004f0169
    mov eax, dword ptr [0x5d0377]                # 004f0173
    mov dword ptr [0x5d162d], eax                # 004f0178
    jmp.d8 L_004f01ae                            # 004f017d
L_004f017f:
    # block 0x004f017f: entered by je at 0x004f015e; je at 0x004f0167, 3 instruction(s), ends with je to 0x004f01ae (forward)
    movsx ecx, word ptr [0x583a29]               # 004f017f
    cmp ecx, -0x1                                # 004f0186
    je.d8 L_004f01ae                             # 004f0189
    # block 0x004f018b: entered by fall-through of je at 0x004f0189, 2 instruction(s), ends with jne to 0x004f01ae (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 004f018b
    jne.d8 L_004f01ae                            # 004f0192
    # block 0x004f0194: entered by fall-through of jne at 0x004f0192, 5 instruction(s), falls into the block at 0x004f01ae
    movsx edx, word ptr [0x583a29]               # 004f0194
    add edx, 0x25                                # 004f019b
    mov dword ptr [0x5b44f0], edx                # 004f019e
    mov eax, dword ptr [0x571ad3]                # 004f01a4
    mov dword ptr [0x5d162d], eax                # 004f01a9
L_004f01ae:
    # block 0x004f01ae: entered by jmp at 0x004f0152; jmp at 0x004f017d; je at 0x004f0189; jne at 0x004f0192, 56 instruction(s), ends with je to 0x004f04b6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f01ae
    mov edx, dword ptr [0x583102]                # 004f01b1
    sub edx, dword ptr [ecx + field_4]           # 004f01b7
    mov dword ptr [0x583172], edx                # 004f01ba
    mov eax, dword ptr [ebp - local_4]           # 004f01c0
    mov ecx, dword ptr [0x58310a]                # 004f01c3
    sub ecx, dword ptr [eax + field_4]           # 004f01c9
    mov dword ptr [0x58317a], ecx                # 004f01cc
    mov edx, dword ptr [ebp - local_4]           # 004f01d2
    mov eax, dword ptr [0x583106]                # 004f01d5
    sub eax, dword ptr [edx + field_8]           # 004f01da
    mov dword ptr [0x583176], eax                # 004f01dd
    mov ecx, dword ptr [ebp - local_4]           # 004f01e2
    mov edx, dword ptr [0x58310e]                # 004f01e5
    sub edx, dword ptr [ecx + field_8]           # 004f01eb
    mov dword ptr [0x58317e], edx                # 004f01ee
    mov eax, dword ptr [ebp - local_4]           # 004f01f4
    mov ecx, dword ptr [0x583172]                # 004f01f7
    mov dword ptr [eax + field_4a], ecx          # 004f01fd
    mov edx, dword ptr [ebp - local_4]           # 004f0200
    mov eax, dword ptr [0x58317a]                # 004f0203
    mov dword ptr [edx + field_52], eax          # 004f0208
    mov ecx, dword ptr [0x583176]                # 004f020b
    add ecx, dword ptr [0x5bb587]                # 004f0211
    mov edx, dword ptr [ebp - local_4]           # 004f0217
    mov dword ptr [edx + field_4e], ecx          # 004f021a
    mov eax, dword ptr [0x58317e]                # 004f021d
    add eax, dword ptr [0x5bb587]                # 004f0222
    mov ecx, dword ptr [ebp - local_4]           # 004f0228
    mov dword ptr [ecx + field_56], eax          # 004f022b
    mov edx, dword ptr [0x5b44f0]                # 004f022e
    shl edx, 0x4                                 # 004f0234
    mov eax, dword ptr [ebp - local_4]           # 004f0237
    mov ecx, dword ptr [eax + field_4e]          # 004f023a
    mov eax, dword ptr [0x5b44f4]                # 004f023d
    add ecx, dword ptr [edx + 8*eax + 0x5b30d0]  # 004f0242
    mov edx, dword ptr [ebp - local_4]           # 004f0249
    mov dword ptr [edx + field_5a], ecx          # 004f024c
    mov eax, dword ptr [0x5b44f0]                # 004f024f
    shl eax, 0x4                                 # 004f0254
    mov ecx, dword ptr [ebp - local_4]           # 004f0257
    mov edx, dword ptr [ecx + field_4a]          # 004f025a
    mov ecx, dword ptr [0x5b44f4]                # 004f025d
    add edx, dword ptr [eax + 8*ecx + 0x5b30cc]  # 004f0263
    mov eax, dword ptr [ebp - local_4]           # 004f026a
    mov dword ptr [eax + field_5e], edx          # 004f026d
    mov ecx, dword ptr [ebp - local_4]           # 004f0270
    mov edx, dword ptr [ecx + field_5e]          # 004f0273
    mov dword ptr [0x5c3a5b], edx                # 004f0276
    mov eax, dword ptr [ebp - local_4]           # 004f027c
    mov ecx, dword ptr [eax + field_5a]          # 004f027f
    mov dword ptr [0x5c3a5f], ecx                # 004f0282
    {load} xor edx, edx                          # 004f0288
    mov dl, byte ptr [0x5b5158]                  # 004f028a
    test edx, edx                                # 004f0290
    je.d32 L_004f04b6                            # 004f0292
    # block 0x004f0298: entered by fall-through of je at 0x004f0292, 3 instruction(s), ends with forward jump to 0x004f02b3
    mov eax, dword ptr [ebp - local_4]           # 004f0298
    mov dword ptr [eax + field_62], 0x0          # 004f029b
    jmp.d8 L_004f02b3                            # 004f02a2
L_004f02a4:
    # block 0x004f02a4: entered by jmp at 0x004f03d3, 5 instruction(s), falls into the block at 0x004f02b3
    mov ecx, dword ptr [ebp - local_4]           # 004f02a4
    mov edx, dword ptr [ecx + field_62]          # 004f02a7
    add edx, 0x1                                 # 004f02aa
    mov eax, dword ptr [ebp - local_4]           # 004f02ad
    mov dword ptr [eax + field_62], edx          # 004f02b0
L_004f02b3:
    # block 0x004f02b3: entered by jmp at 0x004f02a2, 7 instruction(s), ends with jge to 0x004f03d8 (forward)
    movsx ecx, word ptr [0x5b5159]               # 004f02b3
    imul ecx, ecx, 0x8d                          # 004f02ba
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f02c0
    movsx eax, word ptr [edx + field_21]         # 004f02c6
    mov ecx, dword ptr [ebp - local_4]           # 004f02ca
    cmp dword ptr [ecx + field_62], eax          # 004f02cd
    jge.d32 L_004f03d8                           # 004f02d0
    # block 0x004f02d6: entered by fall-through of jge at 0x004f02d0, 10 instruction(s), ends with jl to 0x004f03d3 (forward)
    movsx edx, word ptr [0x5b5159]               # 004f02d6
    imul edx, edx, 0x8d                          # 004f02dd
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f02e3
    mov ecx, dword ptr [ebp - local_4]           # 004f02e9
    mov edx, dword ptr [ecx + field_62]          # 004f02ec
    shl edx, 0x4                                 # 004f02ef
    mov ecx, dword ptr [ebp - local_4]           # 004f02f2
    mov ecx, dword ptr [ecx + field_5a]          # 004f02f5
    cmp ecx, dword ptr [eax + edx + field_127]   # 004f02f8
    jl.d32 L_004f03d3                            # 004f02ff
    # block 0x004f0305: entered by fall-through of jl at 0x004f02ff, 10 instruction(s), ends with jg to 0x004f03d3 (forward)
    movsx edx, word ptr [0x5b5159]               # 004f0305
    imul edx, edx, 0x8d                          # 004f030c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f0312
    mov ecx, dword ptr [ebp - local_4]           # 004f0318
    mov edx, dword ptr [ecx + field_62]          # 004f031b
    shl edx, 0x4                                 # 004f031e
    mov ecx, dword ptr [ebp - local_4]           # 004f0321
    mov ecx, dword ptr [ecx + field_5a]          # 004f0324
    cmp ecx, dword ptr [eax + edx + field_12f]   # 004f0327
    jg.d32 L_004f03d3                            # 004f032e
    # block 0x004f0334: entered by fall-through of jg at 0x004f032e, 10 instruction(s), ends with jl to 0x004f03d3 (forward)
    movsx edx, word ptr [0x5b5159]               # 004f0334
    imul edx, edx, 0x8d                          # 004f033b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f0341
    mov ecx, dword ptr [ebp - local_4]           # 004f0347
    mov edx, dword ptr [ecx + field_62]          # 004f034a
    shl edx, 0x4                                 # 004f034d
    mov ecx, dword ptr [ebp - local_4]           # 004f0350
    mov ecx, dword ptr [ecx + field_5e]          # 004f0353
    cmp ecx, dword ptr [eax + edx + field_123]   # 004f0356
    jl.d8 L_004f03d3                             # 004f035d
    # block 0x004f035f: entered by fall-through of jl at 0x004f035d, 10 instruction(s), ends with jg to 0x004f03d3 (forward)
    movsx edx, word ptr [0x5b5159]               # 004f035f
    imul edx, edx, 0x8d                          # 004f0366
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f036c
    mov ecx, dword ptr [ebp - local_4]           # 004f0372
    mov edx, dword ptr [ecx + field_62]          # 004f0375
    shl edx, 0x4                                 # 004f0378
    mov ecx, dword ptr [ebp - local_4]           # 004f037b
    mov ecx, dword ptr [ecx + field_5e]          # 004f037e
    cmp ecx, dword ptr [eax + edx + field_12b]   # 004f0381
    jg.d8 L_004f03d3                             # 004f0388
    # block 0x004f038a: entered by fall-through of jg at 0x004f0388, 13 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f4], 0x1                # 004f038a
    mov edx, dword ptr [0x5b44f0]                # 004f0394
    shl edx, 0x5                                 # 004f039a
    mov eax, dword ptr [0x5b44f4]                # 004f039d
    shl eax, 0x4                                 # 004f03a2
    lea ecx, [edx + eax + 0x5b160c]              # 004f03a5
    mov dword ptr [0x5d1631], ecx                # 004f03ac
    mov dword ptr [0x5c39e5], 0x2719             # 004f03b2
    mov edx, dword ptr [ebp - local_4]           # 004f03bc
    mov ax, word ptr [edx + field_62]            # 004f03bf
    mov word ptr [0x5b515b], ax                  # 004f03c3
    mov eax, 0x1                                 # 004f03c9
    jmp.d32 L_004f2578                           # 004f03ce
L_004f03d3:
    # block 0x004f03d3: entered by jl at 0x004f02ff; jg at 0x004f032e; jl at 0x004f035d; jg at 0x004f0388, 1 instruction(s), ends with backward jump to 0x004f02a4
    jmp.d32 L_004f02a4                           # 004f03d3
L_004f03d8:
    # block 0x004f03d8: entered by jge at 0x004f02d0, 7 instruction(s), ends with jl to 0x004f04b6 (forward)
    movsx ecx, word ptr [0x5b5159]               # 004f03d8
    imul ecx, ecx, 0x8d                          # 004f03df
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f03e5
    mov eax, dword ptr [ebp - local_4]           # 004f03eb
    mov ecx, dword ptr [eax + field_5a]          # 004f03ee
    cmp ecx, dword ptr [edx + field_2cf]         # 004f03f1
    jl.d32 L_004f04b6                            # 004f03f7
    # block 0x004f03fd: entered by fall-through of jl at 0x004f03f7, 7 instruction(s), ends with jg to 0x004f04b6 (forward)
    movsx edx, word ptr [0x5b5159]               # 004f03fd
    imul edx, edx, 0x8d                          # 004f0404
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f040a
    mov ecx, dword ptr [ebp - local_4]           # 004f0410
    mov edx, dword ptr [ecx + field_5a]          # 004f0413
    cmp edx, dword ptr [eax + field_2d7]         # 004f0416
    jg.d32 L_004f04b6                            # 004f041c
    # block 0x004f0422: entered by fall-through of jg at 0x004f041c, 7 instruction(s), ends with jl to 0x004f04b6 (forward)
    movsx eax, word ptr [0x5b5159]               # 004f0422
    imul eax, eax, 0x8d                          # 004f0429
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f042f
    mov edx, dword ptr [ebp - local_4]           # 004f0435
    mov eax, dword ptr [edx + field_5e]          # 004f0438
    cmp eax, dword ptr [ecx + field_2cb]         # 004f043b
    jl.d8 L_004f04b6                             # 004f0441
    # block 0x004f0443: entered by fall-through of jl at 0x004f0441, 7 instruction(s), ends with jg to 0x004f04b6 (forward)
    movsx ecx, word ptr [0x5b5159]               # 004f0443
    imul ecx, ecx, 0x8d                          # 004f044a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f0450
    mov eax, dword ptr [ebp - local_4]           # 004f0456
    mov ecx, dword ptr [eax + field_5e]          # 004f0459
    cmp ecx, dword ptr [edx + field_2d3]         # 004f045c
    jg.d8 L_004f04b6                             # 004f0462
    # block 0x004f0464: entered by fall-through of jg at 0x004f0462, 13 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f0], 0x9                # 004f0464
    mov edx, dword ptr [0x5d0377]                # 004f046e
    mov dword ptr [0x5d162d], edx                # 004f0474
    mov eax, dword ptr [0x5b44f0]                # 004f047a
    shl eax, 0x5                                 # 004f047f
    mov ecx, dword ptr [0x5b44f4]                # 004f0482
    shl ecx, 0x4                                 # 004f0488
    lea edx, [eax + ecx + 0x5b160c]              # 004f048b
    mov dword ptr [0x5d1631], edx                # 004f0492
    mov dword ptr [0x5d1639], 0x1                # 004f0498
    mov dword ptr [0x5c39e5], 0x271a             # 004f04a2
    mov eax, 0x1                                 # 004f04ac
    jmp.d32 L_004f2578                           # 004f04b1
L_004f04b6:
    # block 0x004f04b6: entered by je at 0x004f0292; jl at 0x004f03f7; jg at 0x004f041c; jl at 0x004f0441; jg at 0x004f0462, 4 instruction(s), ends with je to 0x004f05a3 (forward)
    {load} xor eax, eax                          # 004f04b6
    mov al, byte ptr [0x5b61af]                  # 004f04b8
    test eax, eax                                # 004f04bd
    je.d32 L_004f05a3                            # 004f04bf
    # block 0x004f04c5: entered by fall-through of je at 0x004f04bf, 7 instruction(s), ends with jl to 0x004f05a3 (forward)
    movsx ecx, word ptr [0x5b61b0]               # 004f04c5
    imul ecx, ecx, 0x8d                          # 004f04cc
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f04d2
    mov eax, dword ptr [ebp - local_4]           # 004f04d8
    mov ecx, dword ptr [eax + field_5a]          # 004f04db
    cmp ecx, dword ptr [edx + field_233]         # 004f04de
    jl.d32 L_004f05a3                            # 004f04e4
    # block 0x004f04ea: entered by fall-through of jl at 0x004f04e4, 7 instruction(s), ends with jg to 0x004f05a3 (forward)
    movsx edx, word ptr [0x5b61b0]               # 004f04ea
    imul edx, edx, 0x8d                          # 004f04f1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f04f7
    mov ecx, dword ptr [ebp - local_4]           # 004f04fd
    mov edx, dword ptr [ecx + field_5a]          # 004f0500
    cmp edx, dword ptr [eax + field_23b]         # 004f0503
    jg.d32 L_004f05a3                            # 004f0509
    # block 0x004f050f: entered by fall-through of jg at 0x004f0509, 7 instruction(s), ends with jl to 0x004f05a3 (forward)
    movsx eax, word ptr [0x5b61b0]               # 004f050f
    imul eax, eax, 0x8d                          # 004f0516
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f051c
    mov edx, dword ptr [ebp - local_4]           # 004f0522
    mov eax, dword ptr [edx + field_5e]          # 004f0525
    cmp eax, dword ptr [ecx + field_22f]         # 004f0528
    jl.d8 L_004f05a3                             # 004f052e
    # block 0x004f0530: entered by fall-through of jl at 0x004f052e, 7 instruction(s), ends with jg to 0x004f05a3 (forward)
    movsx ecx, word ptr [0x5b61b0]               # 004f0530
    imul ecx, ecx, 0x8d                          # 004f0537
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f053d
    mov eax, dword ptr [ebp - local_4]           # 004f0543
    mov ecx, dword ptr [eax + field_5e]          # 004f0546
    cmp ecx, dword ptr [edx + field_237]         # 004f0549
    jg.d8 L_004f05a3                             # 004f054f
    # block 0x004f0551: entered by fall-through of jg at 0x004f054f, 13 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f0], 0x9                # 004f0551
    mov edx, dword ptr [0x5d0377]                # 004f055b
    mov dword ptr [0x5d162d], edx                # 004f0561
    mov eax, dword ptr [0x5b44f0]                # 004f0567
    shl eax, 0x5                                 # 004f056c
    mov ecx, dword ptr [0x5b44f4]                # 004f056f
    shl ecx, 0x4                                 # 004f0575
    lea edx, [eax + ecx + 0x5b160c]              # 004f0578
    mov dword ptr [0x5d1631], edx                # 004f057f
    mov dword ptr [0x5d1639], 0x1                # 004f0585
    mov dword ptr [0x5c39e5], 0x2724             # 004f058f
    mov eax, 0x1                                 # 004f0599
    jmp.d32 L_004f2578                           # 004f059e
L_004f05a3:
    # block 0x004f05a3: entered by je at 0x004f04bf; jl at 0x004f04e4; jg at 0x004f0509; jl at 0x004f052e; jg at 0x004f054f, 4 instruction(s), ends with je to 0x004f0969 (forward)
    {load} xor eax, eax                          # 004f05a3
    mov al, byte ptr [0x5b615e]                  # 004f05a5
    test eax, eax                                # 004f05aa
    je.d32 L_004f0969                            # 004f05ac
    # block 0x004f05b2: entered by fall-through of je at 0x004f05ac, 17 instruction(s), ends with forward jump to 0x004f0619
    movsx ecx, word ptr [0x5b615f]               # 004f05b2
    imul ecx, ecx, 0x8d                          # 004f05b9
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f05bf
    movsx eax, word ptr [edx + field_23]         # 004f05c5
    mov ecx, dword ptr [ebp - local_4]           # 004f05c9
    mov dword ptr [ecx + field_6a], eax          # 004f05cc
    movsx edx, word ptr [0x5b615f]               # 004f05cf
    imul edx, edx, 0x8d                          # 004f05d6
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f05dc
    movsx ecx, word ptr [eax + field_21]         # 004f05e2
    mov edx, dword ptr [ebp - local_4]           # 004f05e6
    mov dword ptr [edx + field_66], ecx          # 004f05e9
    mov word ptr [0x5b6161], 0xffff              # 004f05ec
    mov word ptr [0x5b6163], 0xffff              # 004f05f5
    mov eax, dword ptr [ebp - local_4]           # 004f05fe
    mov dword ptr [eax + field_7a], 0x0          # 004f0601
    jmp.d8 L_004f0619                            # 004f0608
L_004f060a:
    # block 0x004f060a: entered by jmp at 0x004f0888, 5 instruction(s), falls into the block at 0x004f0619
    mov ecx, dword ptr [ebp - local_4]           # 004f060a
    mov edx, dword ptr [ecx + field_7a]          # 004f060d
    add edx, 0x1                                 # 004f0610
    mov eax, dword ptr [ebp - local_4]           # 004f0613
    mov dword ptr [eax + field_7a], edx          # 004f0616
L_004f0619:
    # block 0x004f0619: entered by jmp at 0x004f0608, 5 instruction(s), ends with jge to 0x004f088d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0619
    mov edx, dword ptr [ebp - local_4]           # 004f061c
    mov eax, dword ptr [ecx + field_7a]          # 004f061f
    cmp eax, dword ptr [edx + field_6a]          # 004f0622
    jge.d32 L_004f088d                           # 004f0625
    # block 0x004f062b: entered by fall-through of jge at 0x004f0625, 3 instruction(s), ends with forward jump to 0x004f0646
    mov ecx, dword ptr [ebp - local_4]           # 004f062b
    mov dword ptr [ecx + field_76], 0x0          # 004f062e
    jmp.d8 L_004f0646                            # 004f0635
L_004f0637:
    # block 0x004f0637: entered by jmp at 0x004f0883, 5 instruction(s), falls into the block at 0x004f0646
    mov edx, dword ptr [ebp - local_4]           # 004f0637
    mov eax, dword ptr [edx + field_76]          # 004f063a
    add eax, 0x1                                 # 004f063d
    mov ecx, dword ptr [ebp - local_4]           # 004f0640
    mov dword ptr [ecx + field_76], eax          # 004f0643
L_004f0646:
    # block 0x004f0646: entered by jmp at 0x004f0635, 5 instruction(s), ends with jge to 0x004f0888 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0646
    mov eax, dword ptr [ebp - local_4]           # 004f0649
    mov ecx, dword ptr [edx + field_76]          # 004f064c
    cmp ecx, dword ptr [eax + field_66]          # 004f064f
    jge.d32 L_004f0888                           # 004f0652
    # block 0x004f0658: entered by fall-through of jge at 0x004f0652, 14 instruction(s), ends with jl to 0x004f0883 (forward)
    movsx edx, word ptr [0x5b615f]               # 004f0658
    imul edx, edx, 0x8d                          # 004f065f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f0665
    mov ecx, dword ptr [ebp - local_4]           # 004f066b
    mov edx, dword ptr [ecx + field_7a]          # 004f066e
    imul edx, edx, 0x60                          # 004f0671
    lea eax, [eax + edx + field_265]             # 004f0674
    mov ecx, dword ptr [ebp - local_4]           # 004f067b
    mov edx, dword ptr [ecx + field_76]          # 004f067e
    shl edx, 0x4                                 # 004f0681
    mov ecx, dword ptr [ebp - local_4]           # 004f0684
    mov ecx, dword ptr [ecx + field_5a]          # 004f0687
    cmp ecx, dword ptr [eax + edx + field_4]     # 004f068a
    jl.d32 L_004f0883                            # 004f068e
    # block 0x004f0694: entered by fall-through of jl at 0x004f068e, 14 instruction(s), ends with jg to 0x004f0883 (forward)
    movsx edx, word ptr [0x5b615f]               # 004f0694
    imul edx, edx, 0x8d                          # 004f069b
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f06a1
    mov ecx, dword ptr [ebp - local_4]           # 004f06a7
    mov edx, dword ptr [ecx + field_7a]          # 004f06aa
    imul edx, edx, 0x60                          # 004f06ad
    lea eax, [eax + edx + field_265]             # 004f06b0
    mov ecx, dword ptr [ebp - local_4]           # 004f06b7
    mov edx, dword ptr [ecx + field_76]          # 004f06ba
    shl edx, 0x4                                 # 004f06bd
    mov ecx, dword ptr [ebp - local_4]           # 004f06c0
    mov ecx, dword ptr [ecx + field_5a]          # 004f06c3
    cmp ecx, dword ptr [eax + edx + field_c]     # 004f06c6
    jg.d32 L_004f0883                            # 004f06ca
    # block 0x004f06d0: entered by fall-through of jg at 0x004f06ca, 14 instruction(s), ends with jl to 0x004f0883 (forward)
    movsx edx, word ptr [0x5b615f]               # 004f06d0
    imul edx, edx, 0x8d                          # 004f06d7
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f06dd
    mov ecx, dword ptr [ebp - local_4]           # 004f06e3
    mov edx, dword ptr [ecx + field_7a]          # 004f06e6
    imul edx, edx, 0x60                          # 004f06e9
    lea eax, [eax + edx + field_265]             # 004f06ec
    mov ecx, dword ptr [ebp - local_4]           # 004f06f3
    mov edx, dword ptr [ecx + field_76]          # 004f06f6
    shl edx, 0x4                                 # 004f06f9
    mov ecx, dword ptr [ebp - local_4]           # 004f06fc
    mov ecx, dword ptr [ecx + field_5e]          # 004f06ff
    cmp ecx, dword ptr [eax + edx]               # 004f0702
    jl.d32 L_004f0883                            # 004f0705
    # block 0x004f070b: entered by fall-through of jl at 0x004f0705, 14 instruction(s), ends with jg to 0x004f0883 (forward)
    movsx edx, word ptr [0x5b615f]               # 004f070b
    imul edx, edx, 0x8d                          # 004f0712
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f0718
    mov ecx, dword ptr [ebp - local_4]           # 004f071e
    mov edx, dword ptr [ecx + field_7a]          # 004f0721
    imul edx, edx, 0x60                          # 004f0724
    lea eax, [eax + edx + field_265]             # 004f0727
    mov ecx, dword ptr [ebp - local_4]           # 004f072e
    mov edx, dword ptr [ecx + field_76]          # 004f0731
    shl edx, 0x4                                 # 004f0734
    mov ecx, dword ptr [ebp - local_4]           # 004f0737
    mov ecx, dword ptr [ecx + field_5e]          # 004f073a
    cmp ecx, dword ptr [eax + edx + field_8]     # 004f073d
    jg.d32 L_004f0883                            # 004f0741
    # block 0x004f0747: entered by fall-through of jg at 0x004f0741, 8 instruction(s), ends with je to 0x004f0883 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0747
    mov eax, dword ptr [edx + field_7a]          # 004f074a
    imul eax, eax, 0xc                           # 004f074d
    mov ecx, dword ptr [ebp - local_4]           # 004f0750
    mov edx, dword ptr [ecx + field_76]          # 004f0753
    movsx eax, word ptr [eax + 2*edx + 0x591992] # 004f0756
    cmp eax, -0xa                                # 004f075e
    je.d32 L_004f0883                            # 004f0761
    # block 0x004f0767: entered by fall-through of je at 0x004f0761, 6 instruction(s), ends with jge to 0x004f0798 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0767
    mov edx, dword ptr [ecx + field_76]          # 004f076a
    add edx, 0x1                                 # 004f076d
    mov eax, dword ptr [ebp - local_4]           # 004f0770
    cmp edx, dword ptr [eax + field_66]          # 004f0773
    jge.d8 L_004f0798                            # 004f0776
    # block 0x004f0778: entered by fall-through of jge at 0x004f0776, 8 instruction(s), ends with je to 0x004f0821 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0778
    mov edx, dword ptr [ecx + field_7a]          # 004f077b
    imul edx, edx, 0xc                           # 004f077e
    mov eax, dword ptr [ebp - local_4]           # 004f0781
    mov ecx, dword ptr [eax + field_76]          # 004f0784
    movsx edx, word ptr [edx + 2*ecx + 0x591994] # 004f0787
    cmp edx, -0xa                                # 004f078f
    je.d32 L_004f0821                            # 004f0792
L_004f0798:
    # block 0x004f0798: entered by jge at 0x004f0776; fall-through of je at 0x004f0792, 5 instruction(s), ends with jl to 0x004f07c1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0798
    mov ecx, dword ptr [eax + field_76]          # 004f079b
    sub ecx, 0x1                                 # 004f079e
    test ecx, ecx                                # 004f07a1
    jl.d8 L_004f07c1                             # 004f07a3
    # block 0x004f07a5: entered by fall-through of jl at 0x004f07a3, 8 instruction(s), ends with je to 0x004f0821 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f07a5
    mov eax, dword ptr [edx + field_7a]          # 004f07a8
    imul eax, eax, 0xc                           # 004f07ab
    mov ecx, dword ptr [ebp - local_4]           # 004f07ae
    mov edx, dword ptr [ecx + field_76]          # 004f07b1
    movsx eax, word ptr [eax + 2*edx + 0x591990] # 004f07b4
    cmp eax, -0xa                                # 004f07bc
    je.d8 L_004f0821                             # 004f07bf
L_004f07c1:
    # block 0x004f07c1: entered by jl at 0x004f07a3; fall-through of je at 0x004f07bf, 6 instruction(s), ends with jge to 0x004f07f1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f07c1
    mov edx, dword ptr [ecx + field_7a]          # 004f07c4
    add edx, 0x1                                 # 004f07c7
    mov eax, dword ptr [ebp - local_4]           # 004f07ca
    cmp edx, dword ptr [eax + field_6a]          # 004f07cd
    jge.d8 L_004f07f1                            # 004f07d0
    # block 0x004f07d2: entered by fall-through of jge at 0x004f07d0, 9 instruction(s), ends with je to 0x004f0821 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f07d2
    mov edx, dword ptr [ecx + field_7a]          # 004f07d5
    add edx, 0x1                                 # 004f07d8
    imul edx, edx, 0xc                           # 004f07db
    mov eax, dword ptr [ebp - local_4]           # 004f07de
    mov ecx, dword ptr [eax + field_76]          # 004f07e1
    movsx edx, word ptr [edx + 2*ecx + 0x591992] # 004f07e4
    cmp edx, -0xa                                # 004f07ec
    je.d8 L_004f0821                             # 004f07ef
L_004f07f1:
    # block 0x004f07f1: entered by jge at 0x004f07d0; fall-through of je at 0x004f07ef, 5 instruction(s), ends with jl to 0x004f0883 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f07f1
    mov ecx, dword ptr [eax + field_7a]          # 004f07f4
    sub ecx, 0x1                                 # 004f07f7
    test ecx, ecx                                # 004f07fa
    jl.d32 L_004f0883                            # 004f07fc
    # block 0x004f0802: entered by fall-through of jl at 0x004f07fc, 9 instruction(s), ends with jne to 0x004f0883 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0802
    mov eax, dword ptr [edx + field_7a]          # 004f0805
    sub eax, 0x1                                 # 004f0808
    imul eax, eax, 0xc                           # 004f080b
    mov ecx, dword ptr [ebp - local_4]           # 004f080e
    mov edx, dword ptr [ecx + field_76]          # 004f0811
    movsx eax, word ptr [eax + 2*edx + 0x591992] # 004f0814
    cmp eax, -0xa                                # 004f081c
    jne.d8 L_004f0883                            # 004f081f
L_004f0821:
    # block 0x004f0821: entered by je at 0x004f0792; je at 0x004f07bf; je at 0x004f07ef; fall-through of jne at 0x004f081f, 17 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f4], 0x1                # 004f0821
    mov ecx, dword ptr [0x5b44f0]                # 004f082b
    shl ecx, 0x5                                 # 004f0831
    mov edx, dword ptr [0x5b44f4]                # 004f0834
    shl edx, 0x4                                 # 004f083a
    lea eax, [ecx + edx + 0x5b160c]              # 004f083d
    mov dword ptr [0x5d1631], eax                # 004f0844
    mov dword ptr [0x5d1639], 0x1                # 004f0849
    mov dword ptr [0x5c39e5], 0x2722             # 004f0853
    mov ecx, dword ptr [ebp - local_4]           # 004f085d
    mov dx, word ptr [ecx + field_76]            # 004f0860
    mov word ptr [0x5b6161], dx                  # 004f0864
    mov eax, dword ptr [ebp - local_4]           # 004f086b
    mov cx, word ptr [eax + field_7a]            # 004f086e
    mov word ptr [0x5b6163], cx                  # 004f0872
    mov eax, 0x1                                 # 004f0879
    jmp.d32 L_004f2578                           # 004f087e
L_004f0883:
    # block 0x004f0883: entered by jl at 0x004f068e; jg at 0x004f06ca; jl at 0x004f0705; jg at 0x004f0741; more, 1 instruction(s), ends with backward jump to 0x004f0637
    jmp.d32 L_004f0637                           # 004f0883
L_004f0888:
    # block 0x004f0888: entered by jge at 0x004f0652, 1 instruction(s), ends with backward jump to 0x004f060a
    jmp.d32 L_004f060a                           # 004f0888
L_004f088d:
    # block 0x004f088d: entered by jge at 0x004f0625, 7 instruction(s), ends with jl to 0x004f0969 (forward)
    movsx edx, word ptr [0x5b615f]               # 004f088d
    imul edx, edx, 0x8d                          # 004f0894
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f089a
    mov ecx, dword ptr [ebp - local_4]           # 004f08a0
    mov edx, dword ptr [ecx + field_5a]          # 004f08a3
    cmp edx, dword ptr [eax + field_5ce]         # 004f08a6
    jl.d32 L_004f0969                            # 004f08ac
    # block 0x004f08b2: entered by fall-through of jl at 0x004f08ac, 7 instruction(s), ends with jg to 0x004f0969 (forward)
    movsx eax, word ptr [0x5b615f]               # 004f08b2
    imul eax, eax, 0x8d                          # 004f08b9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f08bf
    mov edx, dword ptr [ebp - local_4]           # 004f08c5
    mov eax, dword ptr [edx + field_5a]          # 004f08c8
    cmp eax, dword ptr [ecx + field_5d6]         # 004f08cb
    jg.d32 L_004f0969                            # 004f08d1
    # block 0x004f08d7: entered by fall-through of jg at 0x004f08d1, 7 instruction(s), ends with jl to 0x004f0969 (forward)
    movsx ecx, word ptr [0x5b615f]               # 004f08d7
    imul ecx, ecx, 0x8d                          # 004f08de
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f08e4
    mov eax, dword ptr [ebp - local_4]           # 004f08ea
    mov ecx, dword ptr [eax + field_5e]          # 004f08ed
    cmp ecx, dword ptr [edx + field_5ca]         # 004f08f0
    jl.d8 L_004f0969                             # 004f08f6
    # block 0x004f08f8: entered by fall-through of jl at 0x004f08f6, 7 instruction(s), ends with jg to 0x004f0969 (forward)
    movsx edx, word ptr [0x5b615f]               # 004f08f8
    imul edx, edx, 0x8d                          # 004f08ff
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f0905
    mov ecx, dword ptr [ebp - local_4]           # 004f090b
    mov edx, dword ptr [ecx + field_5e]          # 004f090e
    cmp edx, dword ptr [eax + field_5d2]         # 004f0911
    jg.d8 L_004f0969                             # 004f0917
    # block 0x004f0919: entered by fall-through of jg at 0x004f0917, 13 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f0], 0x9                # 004f0919
    mov eax, dword ptr [0x5d0377]                # 004f0923
    mov dword ptr [0x5d162d], eax                # 004f0928
    mov ecx, dword ptr [0x5b44f0]                # 004f092d
    shl ecx, 0x5                                 # 004f0933
    mov edx, dword ptr [0x5b44f4]                # 004f0936
    shl edx, 0x4                                 # 004f093c
    lea eax, [ecx + edx + 0x5b160c]              # 004f093f
    mov dword ptr [0x5d1631], eax                # 004f0946
    mov dword ptr [0x5d1639], 0x1                # 004f094b
    mov dword ptr [0x5c39e5], 0x2723             # 004f0955
    mov eax, 0x1                                 # 004f095f
    jmp.d32 L_004f2578                           # 004f0964
L_004f0969:
    # block 0x004f0969: entered by je at 0x004f05ac; jl at 0x004f08ac; jg at 0x004f08d1; jl at 0x004f08f6; jg at 0x004f0917, 10 instruction(s), calls FUN_00469057, ends with je to 0x004f0991 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0969
    mov dx, word ptr [ecx + field_5a]            # 004f096c
    push edx                                     # 004f0970
    mov eax, dword ptr [ebp - local_4]           # 004f0971
    mov cx, word ptr [eax + field_5e]            # 004f0974
    push ecx                                     # 004f0978
    mov ecx, 0x616ab2                            # 004f0979
    call FUN_00469057                            # 004f097e
    test eax, eax                                # 004f0983
    je.d8 L_004f0991                             # 004f0985
    # block 0x004f0987: entered by fall-through of je at 0x004f0985, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0987
    jmp.d32 L_004f2578                           # 004f098c
L_004f0991:
    # block 0x004f0991: entered by je at 0x004f0985, 13 instruction(s), calls FUN_004b42d3, ends with je to 0x004f09c0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0991
    add edx, 0x4a                                # 004f0994
    push edx                                     # 004f0997
    mov eax, dword ptr [ebp - local_4]           # 004f0998
    mov cx, word ptr [eax + field_5a]            # 004f099b
    push ecx                                     # 004f099f
    mov edx, dword ptr [ebp - local_4]           # 004f09a0
    mov ax, word ptr [edx + field_5e]            # 004f09a3
    push eax                                     # 004f09a7
    mov ecx, 0x617066                            # 004f09a8
    call FUN_004b42d3                            # 004f09ad
    test eax, eax                                # 004f09b2
    je.d8 L_004f09c0                             # 004f09b4
    # block 0x004f09b6: entered by fall-through of je at 0x004f09b4, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f09b6
    jmp.d32 L_004f2578                           # 004f09bb
L_004f09c0:
    # block 0x004f09c0: entered by je at 0x004f09b4, 10 instruction(s), calls FUN_00459cc9, ends with je to 0x004f09e8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f09c0
    mov dx, word ptr [ecx + field_5a]            # 004f09c3
    push edx                                     # 004f09c7
    mov eax, dword ptr [ebp - local_4]           # 004f09c8
    mov cx, word ptr [eax + field_5e]            # 004f09cb
    push ecx                                     # 004f09cf
    mov ecx, 0x61c7ed                            # 004f09d0
    call FUN_00459cc9                            # 004f09d5
    test eax, eax                                # 004f09da
    je.d8 L_004f09e8                             # 004f09dc
    # block 0x004f09de: entered by fall-through of je at 0x004f09dc, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f09de
    jmp.d32 L_004f2578                           # 004f09e3
L_004f09e8:
    # block 0x004f09e8: entered by je at 0x004f09dc, 13 instruction(s), calls FUN_004a3f40, ends with je to 0x004f0a17 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f09e8
    add edx, 0x4a                                # 004f09eb
    push edx                                     # 004f09ee
    mov eax, dword ptr [ebp - local_4]           # 004f09ef
    mov cx, word ptr [eax + field_5a]            # 004f09f2
    push ecx                                     # 004f09f6
    mov edx, dword ptr [ebp - local_4]           # 004f09f7
    mov ax, word ptr [edx + field_5e]            # 004f09fa
    push eax                                     # 004f09fe
    mov ecx, 0x61c8cf                            # 004f09ff
    call FUN_004a3f40                            # 004f0a04
    test eax, eax                                # 004f0a09
    je.d8 L_004f0a17                             # 004f0a0b
    # block 0x004f0a0d: entered by fall-through of je at 0x004f0a0b, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0a0d
    jmp.d32 L_004f2578                           # 004f0a12
L_004f0a17:
    # block 0x004f0a17: entered by je at 0x004f0a0b, 13 instruction(s), calls FUN_004acf45, ends with je to 0x004f0a46 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0a17
    add ecx, 0x4a                                # 004f0a1a
    push ecx                                     # 004f0a1d
    mov edx, dword ptr [ebp - local_4]           # 004f0a1e
    mov ax, word ptr [edx + field_5a]            # 004f0a21
    push eax                                     # 004f0a25
    mov ecx, dword ptr [ebp - local_4]           # 004f0a26
    mov dx, word ptr [ecx + field_5e]            # 004f0a29
    push edx                                     # 004f0a2d
    mov ecx, 0x6369e4                            # 004f0a2e
    call FUN_004acf45                            # 004f0a33
    test eax, eax                                # 004f0a38
    je.d8 L_004f0a46                             # 004f0a3a
    # block 0x004f0a3c: entered by fall-through of je at 0x004f0a3a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0a3c
    jmp.d32 L_004f2578                           # 004f0a41
L_004f0a46:
    # block 0x004f0a46: entered by je at 0x004f0a3a, 10 instruction(s), calls FUN_0048a920, ends with je to 0x004f0a6e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0a46
    mov cx, word ptr [eax + field_5a]            # 004f0a49
    push ecx                                     # 004f0a4d
    mov edx, dword ptr [ebp - local_4]           # 004f0a4e
    mov ax, word ptr [edx + field_5e]            # 004f0a51
    push eax                                     # 004f0a55
    mov ecx, 0x61d10f                            # 004f0a56
    call FUN_0048a920                            # 004f0a5b
    test eax, eax                                # 004f0a60
    je.d8 L_004f0a6e                             # 004f0a62
    # block 0x004f0a64: entered by fall-through of je at 0x004f0a62, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0a64
    jmp.d32 L_004f2578                           # 004f0a69
L_004f0a6e:
    # block 0x004f0a6e: entered by je at 0x004f0a62, 10 instruction(s), calls FUN_004a1e16, ends with je to 0x004f0a96 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0a6e
    mov dx, word ptr [ecx + field_5a]            # 004f0a71
    push edx                                     # 004f0a75
    mov eax, dword ptr [ebp - local_4]           # 004f0a76
    mov cx, word ptr [eax + field_5e]            # 004f0a79
    push ecx                                     # 004f0a7d
    mov ecx, 0x61d2dd                            # 004f0a7e
    call FUN_004a1e16                            # 004f0a83
    test eax, eax                                # 004f0a88
    je.d8 L_004f0a96                             # 004f0a8a
    # block 0x004f0a8c: entered by fall-through of je at 0x004f0a8a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0a8c
    jmp.d32 L_004f2578                           # 004f0a91
L_004f0a96:
    # block 0x004f0a96: entered by je at 0x004f0a8a, 10 instruction(s), calls FUN_0048e628, ends with je to 0x004f0abe (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0a96
    mov ax, word ptr [edx + field_5a]            # 004f0a99
    push eax                                     # 004f0a9d
    mov ecx, dword ptr [ebp - local_4]           # 004f0a9e
    mov dx, word ptr [ecx + field_5e]            # 004f0aa1
    push edx                                     # 004f0aa5
    mov ecx, 0x624dc9                            # 004f0aa6
    call FUN_0048e628                            # 004f0aab
    test eax, eax                                # 004f0ab0
    je.d8 L_004f0abe                             # 004f0ab2
    # block 0x004f0ab4: entered by fall-through of je at 0x004f0ab2, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0ab4
    jmp.d32 L_004f2578                           # 004f0ab9
L_004f0abe:
    # block 0x004f0abe: entered by je at 0x004f0ab2, 10 instruction(s), calls FUN_0048d1e8, ends with je to 0x004f0ae6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0abe
    mov cx, word ptr [eax + field_5a]            # 004f0ac1
    push ecx                                     # 004f0ac5
    mov edx, dword ptr [ebp - local_4]           # 004f0ac6
    mov ax, word ptr [edx + field_5e]            # 004f0ac9
    push eax                                     # 004f0acd
    mov ecx, 0x61d345                            # 004f0ace
    call FUN_0048d1e8                            # 004f0ad3
    test eax, eax                                # 004f0ad8
    je.d8 L_004f0ae6                             # 004f0ada
    # block 0x004f0adc: entered by fall-through of je at 0x004f0ada, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0adc
    jmp.d32 L_004f2578                           # 004f0ae1
L_004f0ae6:
    # block 0x004f0ae6: entered by je at 0x004f0ada, 10 instruction(s), calls FUN_004a6574, ends with je to 0x004f0b0e (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0ae6
    mov dx, word ptr [ecx + field_5a]            # 004f0ae9
    push edx                                     # 004f0aed
    mov eax, dword ptr [ebp - local_4]           # 004f0aee
    mov cx, word ptr [eax + field_5e]            # 004f0af1
    push ecx                                     # 004f0af5
    mov ecx, 0x61d3a1                            # 004f0af6
    call FUN_004a6574                            # 004f0afb
    test eax, eax                                # 004f0b00
    je.d8 L_004f0b0e                             # 004f0b02
    # block 0x004f0b04: entered by fall-through of je at 0x004f0b02, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0b04
    jmp.d32 L_004f2578                           # 004f0b09
L_004f0b0e:
    # block 0x004f0b0e: entered by je at 0x004f0b02, 10 instruction(s), calls FUN_004b5d17, ends with je to 0x004f0b36 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0b0e
    mov ax, word ptr [edx + field_5a]            # 004f0b11
    push eax                                     # 004f0b15
    mov ecx, dword ptr [ebp - local_4]           # 004f0b16
    mov dx, word ptr [ecx + field_5e]            # 004f0b19
    push edx                                     # 004f0b1d
    mov ecx, 0x61d449                            # 004f0b1e
    call FUN_004b5d17                            # 004f0b23
    test eax, eax                                # 004f0b28
    je.d8 L_004f0b36                             # 004f0b2a
    # block 0x004f0b2c: entered by fall-through of je at 0x004f0b2a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0b2c
    jmp.d32 L_004f2578                           # 004f0b31
L_004f0b36:
    # block 0x004f0b36: entered by je at 0x004f0b2a, 10 instruction(s), calls FUN_004ab528, ends with je to 0x004f0b5e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0b36
    mov cx, word ptr [eax + field_5a]            # 004f0b39
    push ecx                                     # 004f0b3d
    mov edx, dword ptr [ebp - local_4]           # 004f0b3e
    mov ax, word ptr [edx + field_5e]            # 004f0b41
    push eax                                     # 004f0b45
    mov ecx, 0x61d6c1                            # 004f0b46
    call FUN_004ab528                            # 004f0b4b
    test eax, eax                                # 004f0b50
    je.d8 L_004f0b5e                             # 004f0b52
    # block 0x004f0b54: entered by fall-through of je at 0x004f0b52, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0b54
    jmp.d32 L_004f2578                           # 004f0b59
L_004f0b5e:
    # block 0x004f0b5e: entered by je at 0x004f0b52, 10 instruction(s), calls FUN_00465c99, ends with je to 0x004f0b86 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0b5e
    mov dx, word ptr [ecx + field_5a]            # 004f0b61
    push edx                                     # 004f0b65
    mov eax, dword ptr [ebp - local_4]           # 004f0b66
    mov cx, word ptr [eax + field_5e]            # 004f0b69
    push ecx                                     # 004f0b6d
    mov ecx, 0x61d723                            # 004f0b6e
    call FUN_00465c99                            # 004f0b73
    test eax, eax                                # 004f0b78
    je.d8 L_004f0b86                             # 004f0b7a
    # block 0x004f0b7c: entered by fall-through of je at 0x004f0b7a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0b7c
    jmp.d32 L_004f2578                           # 004f0b81
L_004f0b86:
    # block 0x004f0b86: entered by je at 0x004f0b7a, 10 instruction(s), calls FUN_00462c39, ends with je to 0x004f0bae (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0b86
    mov ax, word ptr [edx + field_5a]            # 004f0b89
    push eax                                     # 004f0b8d
    mov ecx, dword ptr [ebp - local_4]           # 004f0b8e
    mov dx, word ptr [ecx + field_5e]            # 004f0b91
    push edx                                     # 004f0b95
    mov ecx, 0x61d779                            # 004f0b96
    call FUN_00462c39                            # 004f0b9b
    test eax, eax                                # 004f0ba0
    je.d8 L_004f0bae                             # 004f0ba2
    # block 0x004f0ba4: entered by fall-through of je at 0x004f0ba2, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0ba4
    jmp.d32 L_004f2578                           # 004f0ba9
L_004f0bae:
    # block 0x004f0bae: entered by je at 0x004f0ba2, 10 instruction(s), calls FUN_00487c92, ends with je to 0x004f0bd6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0bae
    mov cx, word ptr [eax + field_5a]            # 004f0bb1
    push ecx                                     # 004f0bb5
    mov edx, dword ptr [ebp - local_4]           # 004f0bb6
    mov ax, word ptr [edx + field_5e]            # 004f0bb9
    push eax                                     # 004f0bbd
    mov ecx, 0x61d7d8                            # 004f0bbe
    call FUN_00487c92                            # 004f0bc3
    test eax, eax                                # 004f0bc8
    je.d8 L_004f0bd6                             # 004f0bca
    # block 0x004f0bcc: entered by fall-through of je at 0x004f0bca, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0bcc
    jmp.d32 L_004f2578                           # 004f0bd1
L_004f0bd6:
    # block 0x004f0bd6: entered by je at 0x004f0bca, 10 instruction(s), calls FUN_004b2250, ends with je to 0x004f0bfe (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0bd6
    mov dx, word ptr [ecx + field_5a]            # 004f0bd9
    push edx                                     # 004f0bdd
    mov eax, dword ptr [ebp - local_4]           # 004f0bde
    mov cx, word ptr [eax + field_5e]            # 004f0be1
    push ecx                                     # 004f0be5
    mov ecx, 0x6204c1                            # 004f0be6
    call FUN_004b2250                            # 004f0beb
    test eax, eax                                # 004f0bf0
    je.d8 L_004f0bfe                             # 004f0bf2
    # block 0x004f0bf4: entered by fall-through of je at 0x004f0bf2, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0bf4
    jmp.d32 L_004f2578                           # 004f0bf9
L_004f0bfe:
    # block 0x004f0bfe: entered by je at 0x004f0bf2, 10 instruction(s), calls FUN_00479deb, ends with je to 0x004f0c26 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0bfe
    mov ax, word ptr [edx + field_5a]            # 004f0c01
    push eax                                     # 004f0c05
    mov ecx, dword ptr [ebp - local_4]           # 004f0c06
    mov dx, word ptr [ecx + field_5e]            # 004f0c09
    push edx                                     # 004f0c0d
    mov ecx, 0x621a02                            # 004f0c0e
    call FUN_00479deb                            # 004f0c13
    test eax, eax                                # 004f0c18
    je.d8 L_004f0c26                             # 004f0c1a
    # block 0x004f0c1c: entered by fall-through of je at 0x004f0c1a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0c1c
    jmp.d32 L_004f2578                           # 004f0c21
L_004f0c26:
    # block 0x004f0c26: entered by je at 0x004f0c1a, 10 instruction(s), calls FUN_00475da4, ends with je to 0x004f0c4e (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0c26
    mov cx, word ptr [eax + field_5a]            # 004f0c29
    push ecx                                     # 004f0c2d
    mov edx, dword ptr [ebp - local_4]           # 004f0c2e
    mov ax, word ptr [edx + field_5e]            # 004f0c31
    push eax                                     # 004f0c35
    mov ecx, 0x622fa2                            # 004f0c36
    call FUN_00475da4                            # 004f0c3b
    test eax, eax                                # 004f0c40
    je.d8 L_004f0c4e                             # 004f0c42
    # block 0x004f0c44: entered by fall-through of je at 0x004f0c42, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0c44
    jmp.d32 L_004f2578                           # 004f0c49
L_004f0c4e:
    # block 0x004f0c4e: entered by je at 0x004f0c42, 10 instruction(s), calls FUN_0045b5bb, ends with je to 0x004f0c76 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0c4e
    mov dx, word ptr [ecx + field_5a]            # 004f0c51
    push edx                                     # 004f0c55
    mov eax, dword ptr [ebp - local_4]           # 004f0c56
    mov cx, word ptr [eax + field_5e]            # 004f0c59
    push ecx                                     # 004f0c5d
    mov ecx, 0x624734                            # 004f0c5e
    call FUN_0045b5bb                            # 004f0c63
    test eax, eax                                # 004f0c68
    je.d8 L_004f0c76                             # 004f0c6a
    # block 0x004f0c6c: entered by fall-through of je at 0x004f0c6a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0c6c
    jmp.d32 L_004f2578                           # 004f0c71
L_004f0c76:
    # block 0x004f0c76: entered by je at 0x004f0c6a, 10 instruction(s), calls FUN_004571e1, ends with je to 0x004f0c9e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0c76
    mov ax, word ptr [edx + field_5a]            # 004f0c79
    push eax                                     # 004f0c7d
    mov ecx, dword ptr [ebp - local_4]           # 004f0c7e
    mov dx, word ptr [ecx + field_5e]            # 004f0c81
    push edx                                     # 004f0c85
    mov ecx, 0x6248ed                            # 004f0c86
    call FUN_004571e1                            # 004f0c8b
    test eax, eax                                # 004f0c90
    je.d8 L_004f0c9e                             # 004f0c92
    # block 0x004f0c94: entered by fall-through of je at 0x004f0c92, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0c94
    jmp.d32 L_004f2578                           # 004f0c99
L_004f0c9e:
    # block 0x004f0c9e: entered by je at 0x004f0c92, 10 instruction(s), calls FUN_0044eab1, ends with je to 0x004f0cc6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0c9e
    mov cx, word ptr [eax + field_5a]            # 004f0ca1
    push ecx                                     # 004f0ca5
    mov edx, dword ptr [ebp - local_4]           # 004f0ca6
    mov ax, word ptr [edx + field_5e]            # 004f0ca9
    push eax                                     # 004f0cad
    mov ecx, 0x624931                            # 004f0cae
    call FUN_0044eab1                            # 004f0cb3
    test eax, eax                                # 004f0cb8
    je.d8 L_004f0cc6                             # 004f0cba
    # block 0x004f0cbc: entered by fall-through of je at 0x004f0cba, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0cbc
    jmp.d32 L_004f2578                           # 004f0cc1
L_004f0cc6:
    # block 0x004f0cc6: entered by je at 0x004f0cba, 10 instruction(s), calls FUN_004b7389, ends with je to 0x004f0cee (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0cc6
    mov dx, word ptr [ecx + field_5a]            # 004f0cc9
    push edx                                     # 004f0ccd
    mov eax, dword ptr [ebp - local_4]           # 004f0cce
    mov cx, word ptr [eax + field_5e]            # 004f0cd1
    push ecx                                     # 004f0cd5
    mov ecx, 0x6249a0                            # 004f0cd6
    call FUN_004b7389                            # 004f0cdb
    test eax, eax                                # 004f0ce0
    je.d8 L_004f0cee                             # 004f0ce2
    # block 0x004f0ce4: entered by fall-through of je at 0x004f0ce2, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0ce4
    jmp.d32 L_004f2578                           # 004f0ce9
L_004f0cee:
    # block 0x004f0cee: entered by je at 0x004f0ce2, 13 instruction(s), calls FUN_00455180, ends with je to 0x004f0d1d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0cee
    add edx, 0x4a                                # 004f0cf1
    push edx                                     # 004f0cf4
    mov eax, dword ptr [ebp - local_4]           # 004f0cf5
    mov cx, word ptr [eax + field_5a]            # 004f0cf8
    push ecx                                     # 004f0cfc
    mov edx, dword ptr [ebp - local_4]           # 004f0cfd
    mov ax, word ptr [edx + field_5e]            # 004f0d00
    push eax                                     # 004f0d04
    mov ecx, 0x6249dc                            # 004f0d05
    call FUN_00455180                            # 004f0d0a
    test eax, eax                                # 004f0d0f
    je.d8 L_004f0d1d                             # 004f0d11
    # block 0x004f0d13: entered by fall-through of je at 0x004f0d11, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0d13
    jmp.d32 L_004f2578                           # 004f0d18
L_004f0d1d:
    # block 0x004f0d1d: entered by je at 0x004f0d11, 10 instruction(s), calls FUN_004aa0f0, ends with je to 0x004f0d45 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0d1d
    mov dx, word ptr [ecx + field_5a]            # 004f0d20
    push edx                                     # 004f0d24
    mov eax, dword ptr [ebp - local_4]           # 004f0d25
    mov cx, word ptr [eax + field_5e]            # 004f0d28
    push ecx                                     # 004f0d2c
    mov ecx, 0x630a34                            # 004f0d2d
    call FUN_004aa0f0                            # 004f0d32
    test eax, eax                                # 004f0d37
    je.d8 L_004f0d45                             # 004f0d39
    # block 0x004f0d3b: entered by fall-through of je at 0x004f0d39, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0d3b
    jmp.d32 L_004f2578                           # 004f0d40
L_004f0d45:
    # block 0x004f0d45: entered by je at 0x004f0d39, 13 instruction(s), calls FUN_00484f42, ends with je to 0x004f0d74 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0d45
    add edx, 0x4a                                # 004f0d48
    push edx                                     # 004f0d4b
    mov eax, dword ptr [ebp - local_4]           # 004f0d4c
    mov cx, word ptr [eax + field_5a]            # 004f0d4f
    push ecx                                     # 004f0d53
    mov edx, dword ptr [ebp - local_4]           # 004f0d54
    mov ax, word ptr [edx + field_5e]            # 004f0d57
    push eax                                     # 004f0d5b
    mov ecx, 0x6252ad                            # 004f0d5c
    call FUN_00484f42                            # 004f0d61
    test eax, eax                                # 004f0d66
    je.d8 L_004f0d74                             # 004f0d68
    # block 0x004f0d6a: entered by fall-through of je at 0x004f0d68, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0d6a
    jmp.d32 L_004f2578                           # 004f0d6f
L_004f0d74:
    # block 0x004f0d74: entered by je at 0x004f0d68, 13 instruction(s), calls FUN_0047f421, ends with je to 0x004f0da3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0d74
    add ecx, 0x4a                                # 004f0d77
    push ecx                                     # 004f0d7a
    mov edx, dword ptr [ebp - local_4]           # 004f0d7b
    mov ax, word ptr [edx + field_5a]            # 004f0d7e
    push eax                                     # 004f0d82
    mov ecx, dword ptr [ebp - local_4]           # 004f0d83
    mov dx, word ptr [ecx + field_5e]            # 004f0d86
    push edx                                     # 004f0d8a
    mov ecx, 0x625ee8                            # 004f0d8b
    call FUN_0047f421                            # 004f0d90
    test eax, eax                                # 004f0d95
    je.d8 L_004f0da3                             # 004f0d97
    # block 0x004f0d99: entered by fall-through of je at 0x004f0d97, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0d99
    jmp.d32 L_004f2578                           # 004f0d9e
L_004f0da3:
    # block 0x004f0da3: entered by je at 0x004f0d97, 13 instruction(s), calls FUN_004a835c, ends with je to 0x004f0dd2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0da3
    add eax, 0x4a                                # 004f0da6
    push eax                                     # 004f0da9
    mov ecx, dword ptr [ebp - local_4]           # 004f0daa
    mov dx, word ptr [ecx + field_5a]            # 004f0dad
    push edx                                     # 004f0db1
    mov eax, dword ptr [ebp - local_4]           # 004f0db2
    mov cx, word ptr [eax + field_5e]            # 004f0db5
    push ecx                                     # 004f0db9
    mov ecx, 0x627335                            # 004f0dba
    call FUN_004a835c                            # 004f0dbf
    test eax, eax                                # 004f0dc4
    je.d8 L_004f0dd2                             # 004f0dc6
    # block 0x004f0dc8: entered by fall-through of je at 0x004f0dc6, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0dc8
    jmp.d32 L_004f2578                           # 004f0dcd
L_004f0dd2:
    # block 0x004f0dd2: entered by je at 0x004f0dc6, 13 instruction(s), calls FUN_0046bca9, ends with je to 0x004f0e01 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0dd2
    add edx, 0x4a                                # 004f0dd5
    push edx                                     # 004f0dd8
    mov eax, dword ptr [ebp - local_4]           # 004f0dd9
    mov cx, word ptr [eax + field_5a]            # 004f0ddc
    push ecx                                     # 004f0de0
    mov edx, dword ptr [ebp - local_4]           # 004f0de1
    mov ax, word ptr [edx + field_5e]            # 004f0de4
    push eax                                     # 004f0de8
    mov ecx, 0x628732                            # 004f0de9
    call FUN_0046bca9                            # 004f0dee
    test eax, eax                                # 004f0df3
    je.d8 L_004f0e01                             # 004f0df5
    # block 0x004f0df7: entered by fall-through of je at 0x004f0df5, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0df7
    jmp.d32 L_004f2578                           # 004f0dfc
L_004f0e01:
    # block 0x004f0e01: entered by je at 0x004f0df5, 13 instruction(s), calls FUN_00464792, ends with je to 0x004f0e30 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0e01
    add ecx, 0x4a                                # 004f0e04
    push ecx                                     # 004f0e07
    mov edx, dword ptr [ebp - local_4]           # 004f0e08
    mov ax, word ptr [edx + field_5a]            # 004f0e0b
    push eax                                     # 004f0e0f
    mov ecx, dword ptr [ebp - local_4]           # 004f0e10
    mov dx, word ptr [ecx + field_5e]            # 004f0e13
    push edx                                     # 004f0e17
    mov ecx, 0x624b50                            # 004f0e18
    call FUN_00464792                            # 004f0e1d
    test eax, eax                                # 004f0e22
    je.d8 L_004f0e30                             # 004f0e24
    # block 0x004f0e26: entered by fall-through of je at 0x004f0e24, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0e26
    jmp.d32 L_004f2578                           # 004f0e2b
L_004f0e30:
    # block 0x004f0e30: entered by je at 0x004f0e24, 10 instruction(s), calls FUN_0046ea16, ends with je to 0x004f0e58 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0e30
    mov cx, word ptr [eax + field_5a]            # 004f0e33
    push ecx                                     # 004f0e37
    mov edx, dword ptr [ebp - local_4]           # 004f0e38
    mov ax, word ptr [edx + field_5e]            # 004f0e3b
    push eax                                     # 004f0e3f
    mov ecx, 0x624c2a                            # 004f0e40
    call FUN_0046ea16                            # 004f0e45
    test eax, eax                                # 004f0e4a
    je.d8 L_004f0e58                             # 004f0e4c
    # block 0x004f0e4e: entered by fall-through of je at 0x004f0e4c, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0e4e
    jmp.d32 L_004f2578                           # 004f0e53
L_004f0e58:
    # block 0x004f0e58: entered by je at 0x004f0e4c, 10 instruction(s), calls FUN_00470ffe, ends with je to 0x004f0e80 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0e58
    mov dx, word ptr [ecx + field_5a]            # 004f0e5b
    push edx                                     # 004f0e5f
    mov eax, dword ptr [ebp - local_4]           # 004f0e60
    mov cx, word ptr [eax + field_5e]            # 004f0e63
    push ecx                                     # 004f0e67
    mov ecx, 0x62387c                            # 004f0e68
    call FUN_00470ffe                            # 004f0e6d
    test eax, eax                                # 004f0e72
    je.d8 L_004f0e80                             # 004f0e74
    # block 0x004f0e76: entered by fall-through of je at 0x004f0e74, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0e76
    jmp.d32 L_004f2578                           # 004f0e7b
L_004f0e80:
    # block 0x004f0e80: entered by je at 0x004f0e74, 10 instruction(s), calls FUN_00467740, ends with je to 0x004f0ea8 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0e80
    mov ax, word ptr [edx + field_5a]            # 004f0e83
    push eax                                     # 004f0e87
    mov ecx, dword ptr [ebp - local_4]           # 004f0e88
    mov dx, word ptr [ecx + field_5e]            # 004f0e8b
    push edx                                     # 004f0e8f
    mov ecx, 0x61e65c                            # 004f0e90
    call FUN_00467740                            # 004f0e95
    test eax, eax                                # 004f0e9a
    je.d8 L_004f0ea8                             # 004f0e9c
    # block 0x004f0e9e: entered by fall-through of je at 0x004f0e9c, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0e9e
    jmp.d32 L_004f2578                           # 004f0ea3
L_004f0ea8:
    # block 0x004f0ea8: entered by je at 0x004f0e9c, 10 instruction(s), calls FUN_00473206, ends with je to 0x004f0ed0 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0ea8
    mov cx, word ptr [eax + field_5a]            # 004f0eab
    push ecx                                     # 004f0eaf
    mov edx, dword ptr [ebp - local_4]           # 004f0eb0
    mov ax, word ptr [edx + field_5e]            # 004f0eb3
    push eax                                     # 004f0eb7
    mov ecx, 0x61e95c                            # 004f0eb8
    call FUN_00473206                            # 004f0ebd
    test eax, eax                                # 004f0ec2
    je.d8 L_004f0ed0                             # 004f0ec4
    # block 0x004f0ec6: entered by fall-through of je at 0x004f0ec4, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0ec6
    jmp.d32 L_004f2578                           # 004f0ecb
L_004f0ed0:
    # block 0x004f0ed0: entered by je at 0x004f0ec4, 13 instruction(s), calls FUN_0045841e, ends with je to 0x004f0eff (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0ed0
    add ecx, 0x4a                                # 004f0ed3
    push ecx                                     # 004f0ed6
    mov edx, dword ptr [ebp - local_4]           # 004f0ed7
    mov ax, word ptr [edx + field_5a]            # 004f0eda
    push eax                                     # 004f0ede
    mov ecx, dword ptr [ebp - local_4]           # 004f0edf
    mov dx, word ptr [ecx + field_5e]            # 004f0ee2
    push edx                                     # 004f0ee6
    mov ecx, 0x61ed7b                            # 004f0ee7
    call FUN_0045841e                            # 004f0eec
    test eax, eax                                # 004f0ef1
    je.d8 L_004f0eff                             # 004f0ef3
    # block 0x004f0ef5: entered by fall-through of je at 0x004f0ef3, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0ef5
    jmp.d32 L_004f2578                           # 004f0efa
L_004f0eff:
    # block 0x004f0eff: entered by je at 0x004f0ef3, 10 instruction(s), calls FUN_0045e1ca, ends with je to 0x004f0f27 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0eff
    mov cx, word ptr [eax + field_5a]            # 004f0f02
    push ecx                                     # 004f0f06
    mov edx, dword ptr [ebp - local_4]           # 004f0f07
    mov ax, word ptr [edx + field_5e]            # 004f0f0a
    push eax                                     # 004f0f0e
    mov ecx, 0x61f4b1                            # 004f0f0f
    call FUN_0045e1ca                            # 004f0f14
    test eax, eax                                # 004f0f19
    je.d8 L_004f0f27                             # 004f0f1b
    # block 0x004f0f1d: entered by fall-through of je at 0x004f0f1b, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0f1d
    jmp.d32 L_004f2578                           # 004f0f22
L_004f0f27:
    # block 0x004f0f27: entered by je at 0x004f0f1b, 10 instruction(s), calls FUN_004b81ff, ends with je to 0x004f0f4f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0f27
    mov dx, word ptr [ecx + field_5a]            # 004f0f2a
    push edx                                     # 004f0f2e
    mov eax, dword ptr [ebp - local_4]           # 004f0f2f
    mov cx, word ptr [eax + field_5e]            # 004f0f32
    push ecx                                     # 004f0f36
    mov ecx, 0x61ee6e                            # 004f0f37
    call FUN_004b81ff                            # 004f0f3c
    test eax, eax                                # 004f0f41
    je.d8 L_004f0f4f                             # 004f0f43
    # block 0x004f0f45: entered by fall-through of je at 0x004f0f43, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0f45
    jmp.d32 L_004f2578                           # 004f0f4a
L_004f0f4f:
    # block 0x004f0f4f: entered by je at 0x004f0f43, 10 instruction(s), calls FUN_0048bd91, ends with je to 0x004f0f77 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0f4f
    mov ax, word ptr [edx + field_5a]            # 004f0f52
    push eax                                     # 004f0f56
    mov ecx, dword ptr [ebp - local_4]           # 004f0f57
    mov dx, word ptr [ecx + field_5e]            # 004f0f5a
    push edx                                     # 004f0f5e
    mov ecx, 0x624686                            # 004f0f5f
    call FUN_0048bd91                            # 004f0f64
    test eax, eax                                # 004f0f69
    je.d8 L_004f0f77                             # 004f0f6b
    # block 0x004f0f6d: entered by fall-through of je at 0x004f0f6b, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0f6d
    jmp.d32 L_004f2578                           # 004f0f72
L_004f0f77:
    # block 0x004f0f77: entered by je at 0x004f0f6b, 10 instruction(s), calls FUN_004ba377, ends with je to 0x004f0f9f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0f77
    mov cx, word ptr [eax + field_5a]            # 004f0f7a
    push ecx                                     # 004f0f7e
    mov edx, dword ptr [ebp - local_4]           # 004f0f7f
    mov ax, word ptr [edx + field_5e]            # 004f0f82
    push eax                                     # 004f0f86
    mov ecx, 0x61df56                            # 004f0f87
    call FUN_004ba377                            # 004f0f8c
    test eax, eax                                # 004f0f91
    je.d8 L_004f0f9f                             # 004f0f93
    # block 0x004f0f95: entered by fall-through of je at 0x004f0f93, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0f95
    jmp.d32 L_004f2578                           # 004f0f9a
L_004f0f9f:
    # block 0x004f0f9f: entered by je at 0x004f0f93, 10 instruction(s), calls FUN_0047b4aa, ends with je to 0x004f0fc7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f0f9f
    mov dx, word ptr [ecx + field_5a]            # 004f0fa2
    push edx                                     # 004f0fa6
    mov eax, dword ptr [ebp - local_4]           # 004f0fa7
    mov cx, word ptr [eax + field_5e]            # 004f0faa
    push ecx                                     # 004f0fae
    mov ecx, 0x61e398                            # 004f0faf
    call FUN_0047b4aa                            # 004f0fb4
    test eax, eax                                # 004f0fb9
    je.d8 L_004f0fc7                             # 004f0fbb
    # block 0x004f0fbd: entered by fall-through of je at 0x004f0fbb, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0fbd
    jmp.d32 L_004f2578                           # 004f0fc2
L_004f0fc7:
    # block 0x004f0fc7: entered by je at 0x004f0fbb, 10 instruction(s), calls FUN_0047d734, ends with je to 0x004f0fef (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f0fc7
    mov ax, word ptr [edx + field_5a]            # 004f0fca
    push eax                                     # 004f0fce
    mov ecx, dword ptr [ebp - local_4]           # 004f0fcf
    mov dx, word ptr [ecx + field_5e]            # 004f0fd2
    push edx                                     # 004f0fd6
    mov ecx, 0x6246dc                            # 004f0fd7
    call FUN_0047d734                            # 004f0fdc
    test eax, eax                                # 004f0fe1
    je.d8 L_004f0fef                             # 004f0fe3
    # block 0x004f0fe5: entered by fall-through of je at 0x004f0fe3, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f0fe5
    jmp.d32 L_004f2578                           # 004f0fea
L_004f0fef:
    # block 0x004f0fef: entered by je at 0x004f0fe3, 10 instruction(s), calls FUN_0044d28c, ends with je to 0x004f1017 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f0fef
    mov cx, word ptr [eax + field_5a]            # 004f0ff2
    push ecx                                     # 004f0ff6
    mov edx, dword ptr [ebp - local_4]           # 004f0ff7
    mov ax, word ptr [edx + field_5e]            # 004f0ffa
    push eax                                     # 004f0ffe
    mov ecx, 0x624cbf                            # 004f0fff
    call FUN_0044d28c                            # 004f1004
    test eax, eax                                # 004f1009
    je.d8 L_004f1017                             # 004f100b
    # block 0x004f100d: entered by fall-through of je at 0x004f100b, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f100d
    jmp.d32 L_004f2578                           # 004f1012
L_004f1017:
    # block 0x004f1017: entered by je at 0x004f100b, 10 instruction(s), calls FUN_00482359, ends with je to 0x004f103f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1017
    mov dx, word ptr [ecx + field_5a]            # 004f101a
    push edx                                     # 004f101e
    mov eax, dword ptr [ebp - local_4]           # 004f101f
    mov cx, word ptr [eax + field_5e]            # 004f1022
    push ecx                                     # 004f1026
    mov ecx, 0x624d12                            # 004f1027
    call FUN_00482359                            # 004f102c
    test eax, eax                                # 004f1031
    je.d8 L_004f103f                             # 004f1033
    # block 0x004f1035: entered by fall-through of je at 0x004f1033, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f1035
    jmp.d32 L_004f2578                           # 004f103a
L_004f103f:
    # block 0x004f103f: entered by je at 0x004f1033, 10 instruction(s), calls FUN_004897cd, ends with je to 0x004f1067 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f103f
    mov ax, word ptr [edx + field_5a]            # 004f1042
    push eax                                     # 004f1046
    mov ecx, dword ptr [ebp - local_4]           # 004f1047
    mov dx, word ptr [ecx + field_5e]            # 004f104a
    push edx                                     # 004f104e
    mov ecx, 0x619935                            # 004f104f
    call FUN_004897cd                            # 004f1054
    test eax, eax                                # 004f1059
    je.d8 L_004f1067                             # 004f105b
    # block 0x004f105d: entered by fall-through of je at 0x004f105b, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f105d
    jmp.d32 L_004f2578                           # 004f1062
L_004f1067:
    # block 0x004f1067: entered by je at 0x004f105b, 10 instruction(s), calls FUN_004cb058, ends with je to 0x004f108f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1067
    mov cx, word ptr [eax + field_5a]            # 004f106a
    push ecx                                     # 004f106e
    mov edx, dword ptr [ebp - local_4]           # 004f106f
    mov ax, word ptr [edx + field_5e]            # 004f1072
    push eax                                     # 004f1076
    mov ecx, 0x63847b                            # 004f1077
    call FUN_004cb058                            # 004f107c
    test eax, eax                                # 004f1081
    je.d8 L_004f108f                             # 004f1083
    # block 0x004f1085: entered by fall-through of je at 0x004f1083, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f1085
    jmp.d32 L_004f2578                           # 004f108a
L_004f108f:
    # block 0x004f108f: entered by je at 0x004f1083, 4 instruction(s), ends with je to 0x004f12b2 (forward)
    {load} xor ecx, ecx                          # 004f108f
    mov cl, byte ptr [0x5b51f6]                  # 004f1091
    test ecx, ecx                                # 004f1097
    je.d32 L_004f12b2                            # 004f1099
    # block 0x004f109f: entered by fall-through of je at 0x004f1099, 3 instruction(s), ends with forward jump to 0x004f10ba
    mov edx, dword ptr [ebp - local_4]           # 004f109f
    mov dword ptr [edx + field_62], 0x0          # 004f10a2
    jmp.d8 L_004f10ba                            # 004f10a9
L_004f10ab:
    # block 0x004f10ab: entered by jmp at 0x004f11cf, 5 instruction(s), falls into the block at 0x004f10ba
    mov eax, dword ptr [ebp - local_4]           # 004f10ab
    mov ecx, dword ptr [eax + field_62]          # 004f10ae
    add ecx, 0x1                                 # 004f10b1
    mov edx, dword ptr [ebp - local_4]           # 004f10b4
    mov dword ptr [edx + field_62], ecx          # 004f10b7
L_004f10ba:
    # block 0x004f10ba: entered by jmp at 0x004f10a9, 3 instruction(s), ends with jge to 0x004f11d4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f10ba
    cmp dword ptr [eax + field_62], 0xc          # 004f10bd
    jge.d32 L_004f11d4                           # 004f10c1
    # block 0x004f10c7: entered by fall-through of jge at 0x004f10c1, 10 instruction(s), ends with jl to 0x004f11cf (forward)
    movsx ecx, word ptr [0x5b51fb]               # 004f10c7
    imul ecx, ecx, 0x8d                          # 004f10ce
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f10d4
    mov eax, dword ptr [ebp - local_4]           # 004f10da
    mov ecx, dword ptr [eax + field_62]          # 004f10dd
    shl ecx, 0x4                                 # 004f10e0
    mov eax, dword ptr [ebp - local_4]           # 004f10e3
    mov eax, dword ptr [eax + field_5a]          # 004f10e6
    cmp eax, dword ptr [edx + ecx + field_e5]    # 004f10e9
    jl.d32 L_004f11cf                            # 004f10f0
    # block 0x004f10f6: entered by fall-through of jl at 0x004f10f0, 10 instruction(s), ends with jg to 0x004f11cf (forward)
    movsx ecx, word ptr [0x5b51fb]               # 004f10f6
    imul ecx, ecx, 0x8d                          # 004f10fd
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f1103
    mov eax, dword ptr [ebp - local_4]           # 004f1109
    mov ecx, dword ptr [eax + field_62]          # 004f110c
    shl ecx, 0x4                                 # 004f110f
    mov eax, dword ptr [ebp - local_4]           # 004f1112
    mov eax, dword ptr [eax + field_5a]          # 004f1115
    cmp eax, dword ptr [edx + ecx + field_ed]    # 004f1118
    jg.d32 L_004f11cf                            # 004f111f
    # block 0x004f1125: entered by fall-through of jg at 0x004f111f, 10 instruction(s), ends with jl to 0x004f11cf (forward)
    movsx ecx, word ptr [0x5b51fb]               # 004f1125
    imul ecx, ecx, 0x8d                          # 004f112c
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f1132
    mov eax, dword ptr [ebp - local_4]           # 004f1138
    mov ecx, dword ptr [eax + field_62]          # 004f113b
    shl ecx, 0x4                                 # 004f113e
    mov eax, dword ptr [ebp - local_4]           # 004f1141
    mov eax, dword ptr [eax + field_5e]          # 004f1144
    cmp eax, dword ptr [edx + ecx + field_e1]    # 004f1147
    jl.d8 L_004f11cf                             # 004f114e
    # block 0x004f1150: entered by fall-through of jl at 0x004f114e, 10 instruction(s), ends with jg to 0x004f11cf (forward)
    movsx ecx, word ptr [0x5b51fb]               # 004f1150
    imul ecx, ecx, 0x8d                          # 004f1157
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f115d
    mov eax, dword ptr [ebp - local_4]           # 004f1163
    mov ecx, dword ptr [eax + field_62]          # 004f1166
    shl ecx, 0x4                                 # 004f1169
    mov eax, dword ptr [ebp - local_4]           # 004f116c
    mov eax, dword ptr [eax + field_5e]          # 004f116f
    cmp eax, dword ptr [edx + ecx + field_e9]    # 004f1172
    jg.d8 L_004f11cf                             # 004f1179
    # block 0x004f117b: entered by fall-through of jg at 0x004f1179, 14 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f4], 0x1                # 004f117b
    mov ecx, dword ptr [0x5b44f0]                # 004f1185
    shl ecx, 0x5                                 # 004f118b
    mov edx, dword ptr [0x5b44f4]                # 004f118e
    shl edx, 0x4                                 # 004f1194
    lea eax, [ecx + edx + 0x5b160c]              # 004f1197
    mov dword ptr [0x5d1631], eax                # 004f119e
    mov dword ptr [0x5d1639], 0x1                # 004f11a3
    mov dword ptr [0x5c39e5], 0x2720             # 004f11ad
    mov ecx, dword ptr [ebp - local_4]           # 004f11b7
    mov dx, word ptr [ecx + field_62]            # 004f11ba
    mov word ptr [0x5b51fd], dx                  # 004f11be
    mov eax, 0x1                                 # 004f11c5
    jmp.d32 L_004f2578                           # 004f11ca
L_004f11cf:
    # block 0x004f11cf: entered by jl at 0x004f10f0; jg at 0x004f111f; jl at 0x004f114e; jg at 0x004f1179, 1 instruction(s), ends with backward jump to 0x004f10ab
    jmp.d32 L_004f10ab                           # 004f11cf
L_004f11d4:
    # block 0x004f11d4: entered by jge at 0x004f10c1, 7 instruction(s), ends with jl to 0x004f12b2 (forward)
    movsx eax, word ptr [0x5b51fb]               # 004f11d4
    imul eax, eax, 0x8d                          # 004f11db
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f11e1
    mov edx, dword ptr [ebp - local_4]           # 004f11e7
    mov eax, dword ptr [edx + field_5a]          # 004f11ea
    cmp eax, dword ptr [ecx + field_61b]         # 004f11ed
    jl.d32 L_004f12b2                            # 004f11f3
    # block 0x004f11f9: entered by fall-through of jl at 0x004f11f3, 7 instruction(s), ends with jg to 0x004f12b2 (forward)
    movsx ecx, word ptr [0x5b51fb]               # 004f11f9
    imul ecx, ecx, 0x8d                          # 004f1200
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f1206
    mov eax, dword ptr [ebp - local_4]           # 004f120c
    mov ecx, dword ptr [eax + field_5a]          # 004f120f
    cmp ecx, dword ptr [edx + field_623]         # 004f1212
    jg.d32 L_004f12b2                            # 004f1218
    # block 0x004f121e: entered by fall-through of jg at 0x004f1218, 7 instruction(s), ends with jl to 0x004f12b2 (forward)
    movsx edx, word ptr [0x5b51fb]               # 004f121e
    imul edx, edx, 0x8d                          # 004f1225
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f122b
    mov ecx, dword ptr [ebp - local_4]           # 004f1231
    mov edx, dword ptr [ecx + field_5e]          # 004f1234
    cmp edx, dword ptr [eax + field_617]         # 004f1237
    jl.d8 L_004f12b2                             # 004f123d
    # block 0x004f123f: entered by fall-through of jl at 0x004f123d, 7 instruction(s), ends with jg to 0x004f12b2 (forward)
    movsx eax, word ptr [0x5b51fb]               # 004f123f
    imul eax, eax, 0x8d                          # 004f1246
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f124c
    mov edx, dword ptr [ebp - local_4]           # 004f1252
    mov eax, dword ptr [edx + field_5e]          # 004f1255
    cmp eax, dword ptr [ecx + field_61f]         # 004f1258
    jg.d8 L_004f12b2                             # 004f125e
    # block 0x004f1260: entered by fall-through of jg at 0x004f125e, 13 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f0], 0x9                # 004f1260
    mov ecx, dword ptr [0x5d0377]                # 004f126a
    mov dword ptr [0x5d162d], ecx                # 004f1270
    mov edx, dword ptr [0x5b44f0]                # 004f1276
    shl edx, 0x5                                 # 004f127c
    mov eax, dword ptr [0x5b44f4]                # 004f127f
    shl eax, 0x4                                 # 004f1284
    lea ecx, [edx + eax + 0x5b160c]              # 004f1287
    mov dword ptr [0x5d1631], ecx                # 004f128e
    mov dword ptr [0x5d1639], 0x1                # 004f1294
    mov dword ptr [0x5c39e5], 0x2721             # 004f129e
    mov eax, 0x1                                 # 004f12a8
    jmp.d32 L_004f2578                           # 004f12ad
L_004f12b2:
    # block 0x004f12b2: entered by je at 0x004f1099; jl at 0x004f11f3; jg at 0x004f1218; jl at 0x004f123d; jg at 0x004f125e, 4 instruction(s), ends with je to 0x004f14d4 (forward)
    {load} xor edx, edx                          # 004f12b2
    mov dl, byte ptr [0x5b51c6]                  # 004f12b4
    test edx, edx                                # 004f12ba
    je.d32 L_004f14d4                            # 004f12bc
    # block 0x004f12c2: entered by fall-through of je at 0x004f12bc, 3 instruction(s), ends with forward jump to 0x004f12dd
    mov eax, dword ptr [ebp - local_4]           # 004f12c2
    mov dword ptr [eax + field_62], 0x0          # 004f12c5
    jmp.d8 L_004f12dd                            # 004f12cc
L_004f12ce:
    # block 0x004f12ce: entered by jmp at 0x004f13f1, 5 instruction(s), falls into the block at 0x004f12dd
    mov ecx, dword ptr [ebp - local_4]           # 004f12ce
    mov edx, dword ptr [ecx + field_62]          # 004f12d1
    add edx, 0x1                                 # 004f12d4
    mov eax, dword ptr [ebp - local_4]           # 004f12d7
    mov dword ptr [eax + field_62], edx          # 004f12da
L_004f12dd:
    # block 0x004f12dd: entered by jmp at 0x004f12cc, 3 instruction(s), ends with jge to 0x004f13f6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f12dd
    cmp dword ptr [ecx + field_62], 0x3          # 004f12e0
    jge.d32 L_004f13f6                           # 004f12e4
    # block 0x004f12ea: entered by fall-through of jge at 0x004f12e4, 10 instruction(s), ends with jl to 0x004f13f1 (forward)
    movsx edx, word ptr [0x5b51c7]               # 004f12ea
    imul edx, edx, 0x8d                          # 004f12f1
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f12f7
    mov ecx, dword ptr [ebp - local_4]           # 004f12fd
    mov edx, dword ptr [ecx + field_62]          # 004f1300
    shl edx, 0x4                                 # 004f1303
    mov ecx, dword ptr [ebp - local_4]           # 004f1306
    mov ecx, dword ptr [ecx + field_5a]          # 004f1309
    cmp ecx, dword ptr [eax + edx + field_e5]    # 004f130c
    jl.d32 L_004f13f1                            # 004f1313
    # block 0x004f1319: entered by fall-through of jl at 0x004f1313, 10 instruction(s), ends with jg to 0x004f13f1 (forward)
    movsx edx, word ptr [0x5b51c7]               # 004f1319
    imul edx, edx, 0x8d                          # 004f1320
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1326
    mov ecx, dword ptr [ebp - local_4]           # 004f132c
    mov edx, dword ptr [ecx + field_62]          # 004f132f
    shl edx, 0x4                                 # 004f1332
    mov ecx, dword ptr [ebp - local_4]           # 004f1335
    mov ecx, dword ptr [ecx + field_5a]          # 004f1338
    cmp ecx, dword ptr [eax + edx + field_ed]    # 004f133b
    jg.d32 L_004f13f1                            # 004f1342
    # block 0x004f1348: entered by fall-through of jg at 0x004f1342, 10 instruction(s), ends with jl to 0x004f13f1 (forward)
    movsx edx, word ptr [0x5b51c7]               # 004f1348
    imul edx, edx, 0x8d                          # 004f134f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1355
    mov ecx, dword ptr [ebp - local_4]           # 004f135b
    mov edx, dword ptr [ecx + field_62]          # 004f135e
    shl edx, 0x4                                 # 004f1361
    mov ecx, dword ptr [ebp - local_4]           # 004f1364
    mov ecx, dword ptr [ecx + field_5e]          # 004f1367
    cmp ecx, dword ptr [eax + edx + field_e1]    # 004f136a
    jl.d8 L_004f13f1                             # 004f1371
    # block 0x004f1373: entered by fall-through of jl at 0x004f1371, 10 instruction(s), ends with jg to 0x004f13f1 (forward)
    movsx edx, word ptr [0x5b51c7]               # 004f1373
    imul edx, edx, 0x8d                          # 004f137a
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1380
    mov ecx, dword ptr [ebp - local_4]           # 004f1386
    mov edx, dword ptr [ecx + field_62]          # 004f1389
    shl edx, 0x4                                 # 004f138c
    mov ecx, dword ptr [ebp - local_4]           # 004f138f
    mov ecx, dword ptr [ecx + field_5e]          # 004f1392
    cmp ecx, dword ptr [eax + edx + field_e9]    # 004f1395
    jg.d8 L_004f13f1                             # 004f139c
    # block 0x004f139e: entered by fall-through of jg at 0x004f139c, 14 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f4], 0x1                # 004f139e
    mov edx, dword ptr [0x5b44f0]                # 004f13a8
    shl edx, 0x5                                 # 004f13ae
    mov eax, dword ptr [0x5b44f4]                # 004f13b1
    shl eax, 0x4                                 # 004f13b6
    lea ecx, [edx + eax + 0x5b160c]              # 004f13b9
    mov dword ptr [0x5d1631], ecx                # 004f13c0
    mov dword ptr [0x5d1639], 0x1                # 004f13c6
    mov dword ptr [0x5c39e5], 0x271e             # 004f13d0
    mov edx, dword ptr [ebp - local_4]           # 004f13da
    mov ax, word ptr [edx + field_62]            # 004f13dd
    mov word ptr [0x5b51c9], ax                  # 004f13e1
    mov eax, 0x1                                 # 004f13e7
    jmp.d32 L_004f2578                           # 004f13ec
L_004f13f1:
    # block 0x004f13f1: entered by jl at 0x004f1313; jg at 0x004f1342; jl at 0x004f1371; jg at 0x004f139c, 1 instruction(s), ends with backward jump to 0x004f12ce
    jmp.d32 L_004f12ce                           # 004f13f1
L_004f13f6:
    # block 0x004f13f6: entered by jge at 0x004f12e4, 7 instruction(s), ends with jl to 0x004f14d4 (forward)
    movsx ecx, word ptr [0x5b51c7]               # 004f13f6
    imul ecx, ecx, 0x8d                          # 004f13fd
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f1403
    mov eax, dword ptr [ebp - local_4]           # 004f1409
    mov ecx, dword ptr [eax + field_5a]          # 004f140c
    cmp ecx, dword ptr [edx + field_1e2]         # 004f140f
    jl.d32 L_004f14d4                            # 004f1415
    # block 0x004f141b: entered by fall-through of jl at 0x004f1415, 7 instruction(s), ends with jg to 0x004f14d4 (forward)
    movsx edx, word ptr [0x5b51c7]               # 004f141b
    imul edx, edx, 0x8d                          # 004f1422
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1428
    mov ecx, dword ptr [ebp - local_4]           # 004f142e
    mov edx, dword ptr [ecx + field_5a]          # 004f1431
    cmp edx, dword ptr [eax + field_1ea]         # 004f1434
    jg.d32 L_004f14d4                            # 004f143a
    # block 0x004f1440: entered by fall-through of jg at 0x004f143a, 7 instruction(s), ends with jl to 0x004f14d4 (forward)
    movsx eax, word ptr [0x5b51c7]               # 004f1440
    imul eax, eax, 0x8d                          # 004f1447
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f144d
    mov edx, dword ptr [ebp - local_4]           # 004f1453
    mov eax, dword ptr [edx + field_5e]          # 004f1456
    cmp eax, dword ptr [ecx + field_1de]         # 004f1459
    jl.d8 L_004f14d4                             # 004f145f
    # block 0x004f1461: entered by fall-through of jl at 0x004f145f, 7 instruction(s), ends with jg to 0x004f14d4 (forward)
    movsx ecx, word ptr [0x5b51c7]               # 004f1461
    imul ecx, ecx, 0x8d                          # 004f1468
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f146e
    mov eax, dword ptr [ebp - local_4]           # 004f1474
    mov ecx, dword ptr [eax + field_5e]          # 004f1477
    cmp ecx, dword ptr [edx + field_1e6]         # 004f147a
    jg.d8 L_004f14d4                             # 004f1480
    # block 0x004f1482: entered by fall-through of jg at 0x004f1480, 13 instruction(s), ends with forward jump to 0x004f2578
    mov edx, dword ptr [0x5d0377]                # 004f1482
    mov dword ptr [0x5d162d], edx                # 004f1488
    mov dword ptr [0x5b44f0], 0x9                # 004f148e
    mov eax, dword ptr [0x5b44f0]                # 004f1498
    shl eax, 0x5                                 # 004f149d
    mov ecx, dword ptr [0x5b44f4]                # 004f14a0
    shl ecx, 0x4                                 # 004f14a6
    lea edx, [eax + ecx + 0x5b160c]              # 004f14a9
    mov dword ptr [0x5d1631], edx                # 004f14b0
    mov dword ptr [0x5d1639], 0x1                # 004f14b6
    mov dword ptr [0x5c39e5], 0x271f             # 004f14c0
    mov eax, 0x1                                 # 004f14ca
    jmp.d32 L_004f2578                           # 004f14cf
L_004f14d4:
    # block 0x004f14d4: entered by je at 0x004f12bc; jl at 0x004f1415; jg at 0x004f143a; jl at 0x004f145f; jg at 0x004f1480, 4 instruction(s), ends with je to 0x004f18fa (forward)
    {load} xor eax, eax                          # 004f14d4
    mov al, byte ptr [0x5b51ab]                  # 004f14d6
    test eax, eax                                # 004f14db
    je.d32 L_004f18fa                            # 004f14dd
    # block 0x004f14e3: entered by fall-through of je at 0x004f14dd, 3 instruction(s), ends with forward jump to 0x004f14fe
    mov ecx, dword ptr [ebp - local_4]           # 004f14e3
    mov dword ptr [ecx + field_62], 0x0          # 004f14e6
    jmp.d8 L_004f14fe                            # 004f14ed
L_004f14ef:
    # block 0x004f14ef: entered by jmp at 0x004f167a, 5 instruction(s), falls into the block at 0x004f14fe
    mov edx, dword ptr [ebp - local_4]           # 004f14ef
    mov eax, dword ptr [edx + field_62]          # 004f14f2
    add eax, 0x1                                 # 004f14f5
    mov ecx, dword ptr [ebp - local_4]           # 004f14f8
    mov dword ptr [ecx + field_62], eax          # 004f14fb
L_004f14fe:
    # block 0x004f14fe: entered by jmp at 0x004f14ed, 7 instruction(s), ends with jge to 0x004f167f (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f14fe
    imul edx, edx, 0x8d                          # 004f1505
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f150b
    movsx ecx, word ptr [eax + field_21]         # 004f1511
    mov edx, dword ptr [ebp - local_4]           # 004f1515
    cmp dword ptr [edx + field_62], ecx          # 004f1518
    jge.d32 L_004f167f                           # 004f151b
    # block 0x004f1521: entered by fall-through of jge at 0x004f151b, 10 instruction(s), ends with jl to 0x004f167a (forward)
    movsx eax, word ptr [0x5b51ac]               # 004f1521
    imul eax, eax, 0x8d                          # 004f1528
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f152e
    mov edx, dword ptr [ebp - local_4]           # 004f1534
    mov eax, dword ptr [edx + field_62]          # 004f1537
    shl eax, 0x4                                 # 004f153a
    mov edx, dword ptr [ebp - local_4]           # 004f153d
    mov edx, dword ptr [edx + field_5a]          # 004f1540
    cmp edx, dword ptr [ecx + eax + field_169]   # 004f1543
    jl.d32 L_004f167a                            # 004f154a
    # block 0x004f1550: entered by fall-through of jl at 0x004f154a, 10 instruction(s), ends with jg to 0x004f167a (forward)
    movsx eax, word ptr [0x5b51ac]               # 004f1550
    imul eax, eax, 0x8d                          # 004f1557
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f155d
    mov edx, dword ptr [ebp - local_4]           # 004f1563
    mov eax, dword ptr [edx + field_62]          # 004f1566
    shl eax, 0x4                                 # 004f1569
    mov edx, dword ptr [ebp - local_4]           # 004f156c
    mov edx, dword ptr [edx + field_5a]          # 004f156f
    cmp edx, dword ptr [ecx + eax + field_171]   # 004f1572
    jg.d32 L_004f167a                            # 004f1579
    # block 0x004f157f: entered by fall-through of jg at 0x004f1579, 10 instruction(s), ends with jl to 0x004f167a (forward)
    movsx eax, word ptr [0x5b51ac]               # 004f157f
    imul eax, eax, 0x8d                          # 004f1586
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f158c
    mov edx, dword ptr [ebp - local_4]           # 004f1592
    mov eax, dword ptr [edx + field_62]          # 004f1595
    shl eax, 0x4                                 # 004f1598
    mov edx, dword ptr [ebp - local_4]           # 004f159b
    mov edx, dword ptr [edx + field_5e]          # 004f159e
    cmp edx, dword ptr [ecx + eax + field_165]   # 004f15a1
    jl.d32 L_004f167a                            # 004f15a8
    # block 0x004f15ae: entered by fall-through of jl at 0x004f15a8, 10 instruction(s), ends with jg to 0x004f167a (forward)
    movsx eax, word ptr [0x5b51ac]               # 004f15ae
    imul eax, eax, 0x8d                          # 004f15b5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f15bb
    mov edx, dword ptr [ebp - local_4]           # 004f15c1
    mov eax, dword ptr [edx + field_62]          # 004f15c4
    shl eax, 0x4                                 # 004f15c7
    mov edx, dword ptr [ebp - local_4]           # 004f15ca
    mov edx, dword ptr [edx + field_5e]          # 004f15cd
    cmp edx, dword ptr [ecx + eax + field_16d]   # 004f15d0
    jg.d32 L_004f167a                            # 004f15d7
    # block 0x004f15dd: entered by fall-through of jg at 0x004f15d7, 8 instruction(s), ends with jne to 0x004f1611 (forward)
    mov eax, dword ptr [0x5d0377]                # 004f15dd
    mov dword ptr [0x5d162d], eax                # 004f15e2
    movsx ecx, word ptr [0x5b51ac]               # 004f15e7
    imul ecx, ecx, 0x8d                          # 004f15ee
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f15f4
    movsx eax, word ptr [edx + field_26d]        # 004f15fa
    test eax, eax                                # 004f1601
    jne.d8 L_004f1611                            # 004f1603
    # block 0x004f1605: entered by fall-through of jne at 0x004f1603, 2 instruction(s), ends with forward jump to 0x004f1630
    mov dword ptr [0x5b44f0], 0xa                # 004f1605
    jmp.d8 L_004f1630                            # 004f160f
L_004f1611:
    # block 0x004f1611: entered by jne at 0x004f1603, 5 instruction(s), falls into the block at 0x004f1630
    movsx ecx, word ptr [0x5b51ac]               # 004f1611
    imul ecx, ecx, 0x8d                          # 004f1618
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f161e
    movsx eax, word ptr [edx + field_26d]        # 004f1624
    mov dword ptr [0x5b44f0], eax                # 004f162b
L_004f1630:
    # block 0x004f1630: entered by jmp at 0x004f160f, 13 instruction(s), ends with forward jump to 0x004f2578
    mov ecx, dword ptr [0x5b44f0]                # 004f1630
    shl ecx, 0x5                                 # 004f1636
    mov edx, dword ptr [0x5b44f4]                # 004f1639
    shl edx, 0x4                                 # 004f163f
    lea eax, [ecx + edx + 0x5b160c]              # 004f1642
    mov dword ptr [0x5d1631], eax                # 004f1649
    mov dword ptr [0x5d1639], 0x1                # 004f164e
    mov dword ptr [0x5c39e5], 0x271b             # 004f1658
    mov ecx, dword ptr [ebp - local_4]           # 004f1662
    mov dx, word ptr [ecx + field_62]            # 004f1665
    mov word ptr [0x5b51ae], dx                  # 004f1669
    mov eax, 0x1                                 # 004f1670
    jmp.d32 L_004f2578                           # 004f1675
L_004f167a:
    # block 0x004f167a: entered by jl at 0x004f154a; jg at 0x004f1579; jl at 0x004f15a8; jg at 0x004f15d7, 1 instruction(s), ends with backward jump to 0x004f14ef
    jmp.d32 L_004f14ef                           # 004f167a
L_004f167f:
    # block 0x004f167f: entered by jge at 0x004f151b, 3 instruction(s), ends with forward jump to 0x004f169a
    mov eax, dword ptr [ebp - local_4]           # 004f167f
    mov dword ptr [eax + field_62], 0x0          # 004f1682
    jmp.d8 L_004f169a                            # 004f1689
L_004f168b:
    # block 0x004f168b: entered by jmp at 0x004f1819, 5 instruction(s), falls into the block at 0x004f169a
    mov ecx, dword ptr [ebp - local_4]           # 004f168b
    mov edx, dword ptr [ecx + field_62]          # 004f168e
    add edx, 0x1                                 # 004f1691
    mov eax, dword ptr [ebp - local_4]           # 004f1694
    mov dword ptr [eax + field_62], edx          # 004f1697
L_004f169a:
    # block 0x004f169a: entered by jmp at 0x004f1689, 7 instruction(s), ends with jge to 0x004f181e (forward)
    movsx ecx, word ptr [0x5b51ac]               # 004f169a
    imul ecx, ecx, 0x8d                          # 004f16a1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f16a7
    movsx eax, word ptr [edx + field_21]         # 004f16ad
    mov ecx, dword ptr [ebp - local_4]           # 004f16b1
    cmp dword ptr [ecx + field_62], eax          # 004f16b4
    jge.d32 L_004f181e                           # 004f16b7
    # block 0x004f16bd: entered by fall-through of jge at 0x004f16b7, 10 instruction(s), ends with jl to 0x004f1819 (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f16bd
    imul edx, edx, 0x8d                          # 004f16c4
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f16ca
    mov ecx, dword ptr [ebp - local_4]           # 004f16d0
    mov edx, dword ptr [ecx + field_62]          # 004f16d3
    shl edx, 0x4                                 # 004f16d6
    mov ecx, dword ptr [ebp - local_4]           # 004f16d9
    mov ecx, dword ptr [ecx + field_5a]          # 004f16dc
    cmp ecx, dword ptr [eax + edx + field_1e9]   # 004f16df
    jl.d32 L_004f1819                            # 004f16e6
    # block 0x004f16ec: entered by fall-through of jl at 0x004f16e6, 10 instruction(s), ends with jg to 0x004f1819 (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f16ec
    imul edx, edx, 0x8d                          # 004f16f3
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f16f9
    mov ecx, dword ptr [ebp - local_4]           # 004f16ff
    mov edx, dword ptr [ecx + field_62]          # 004f1702
    shl edx, 0x4                                 # 004f1705
    mov ecx, dword ptr [ebp - local_4]           # 004f1708
    mov ecx, dword ptr [ecx + field_5a]          # 004f170b
    cmp ecx, dword ptr [eax + edx + field_1f1]   # 004f170e
    jg.d32 L_004f1819                            # 004f1715
    # block 0x004f171b: entered by fall-through of jg at 0x004f1715, 10 instruction(s), ends with jl to 0x004f1819 (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f171b
    imul edx, edx, 0x8d                          # 004f1722
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1728
    mov ecx, dword ptr [ebp - local_4]           # 004f172e
    mov edx, dword ptr [ecx + field_62]          # 004f1731
    shl edx, 0x4                                 # 004f1734
    mov ecx, dword ptr [ebp - local_4]           # 004f1737
    mov ecx, dword ptr [ecx + field_5e]          # 004f173a
    cmp ecx, dword ptr [eax + edx + field_1e5]   # 004f173d
    jl.d32 L_004f1819                            # 004f1744
    # block 0x004f174a: entered by fall-through of jl at 0x004f1744, 10 instruction(s), ends with jg to 0x004f1819 (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f174a
    imul edx, edx, 0x8d                          # 004f1751
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1757
    mov ecx, dword ptr [ebp - local_4]           # 004f175d
    mov edx, dword ptr [ecx + field_62]          # 004f1760
    shl edx, 0x4                                 # 004f1763
    mov ecx, dword ptr [ebp - local_4]           # 004f1766
    mov ecx, dword ptr [ecx + field_5e]          # 004f1769
    cmp ecx, dword ptr [eax + edx + field_1ed]   # 004f176c
    jg.d32 L_004f1819                            # 004f1773
    # block 0x004f1779: entered by fall-through of jg at 0x004f1773, 8 instruction(s), ends with jne to 0x004f17af (forward)
    mov edx, dword ptr [0x5d0377]                # 004f1779
    mov dword ptr [0x5d162d], edx                # 004f177f
    movsx eax, word ptr [0x5b51ac]               # 004f1785
    imul eax, eax, 0x8d                          # 004f178c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f1792
    movsx edx, word ptr [ecx + field_26f]        # 004f1798
    test edx, edx                                # 004f179f
    jne.d8 L_004f17af                            # 004f17a1
    # block 0x004f17a3: entered by fall-through of jne at 0x004f17a1, 2 instruction(s), ends with forward jump to 0x004f17cf
    mov dword ptr [0x5b44f0], 0xb                # 004f17a3
    jmp.d8 L_004f17cf                            # 004f17ad
L_004f17af:
    # block 0x004f17af: entered by jne at 0x004f17a1, 5 instruction(s), falls into the block at 0x004f17cf
    movsx eax, word ptr [0x5b51ac]               # 004f17af
    imul eax, eax, 0x8d                          # 004f17b6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f17bc
    movsx edx, word ptr [ecx + field_26f]        # 004f17c2
    mov dword ptr [0x5b44f0], edx                # 004f17c9
L_004f17cf:
    # block 0x004f17cf: entered by jmp at 0x004f17ad, 13 instruction(s), ends with forward jump to 0x004f2578
    mov eax, dword ptr [0x5b44f0]                # 004f17cf
    shl eax, 0x5                                 # 004f17d4
    mov ecx, dword ptr [0x5b44f4]                # 004f17d7
    shl ecx, 0x4                                 # 004f17dd
    lea edx, [eax + ecx + 0x5b160c]              # 004f17e0
    mov dword ptr [0x5d1631], edx                # 004f17e7
    mov dword ptr [0x5d1639], 0x1                # 004f17ed
    mov dword ptr [0x5c39e5], 0x271c             # 004f17f7
    mov eax, dword ptr [ebp - local_4]           # 004f1801
    mov cx, word ptr [eax + field_62]            # 004f1804
    mov word ptr [0x5b51ae], cx                  # 004f1808
    mov eax, 0x1                                 # 004f180f
    jmp.d32 L_004f2578                           # 004f1814
L_004f1819:
    # block 0x004f1819: entered by jl at 0x004f16e6; jg at 0x004f1715; jl at 0x004f1744; jg at 0x004f1773, 1 instruction(s), ends with backward jump to 0x004f168b
    jmp.d32 L_004f168b                           # 004f1819
L_004f181e:
    # block 0x004f181e: entered by jge at 0x004f16b7, 7 instruction(s), ends with jl to 0x004f18fa (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f181e
    imul edx, edx, 0x8d                          # 004f1825
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f182b
    mov ecx, dword ptr [ebp - local_4]           # 004f1831
    mov edx, dword ptr [ecx + field_5a]          # 004f1834
    cmp edx, dword ptr [eax + field_30b]         # 004f1837
    jl.d32 L_004f18fa                            # 004f183d
    # block 0x004f1843: entered by fall-through of jl at 0x004f183d, 7 instruction(s), ends with jg to 0x004f18fa (forward)
    movsx eax, word ptr [0x5b51ac]               # 004f1843
    imul eax, eax, 0x8d                          # 004f184a
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f1850
    mov edx, dword ptr [ebp - local_4]           # 004f1856
    mov eax, dword ptr [edx + field_5a]          # 004f1859
    cmp eax, dword ptr [ecx + field_313]         # 004f185c
    jg.d32 L_004f18fa                            # 004f1862
    # block 0x004f1868: entered by fall-through of jg at 0x004f1862, 7 instruction(s), ends with jl to 0x004f18fa (forward)
    movsx ecx, word ptr [0x5b51ac]               # 004f1868
    imul ecx, ecx, 0x8d                          # 004f186f
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f1875
    mov eax, dword ptr [ebp - local_4]           # 004f187b
    mov ecx, dword ptr [eax + field_5e]          # 004f187e
    cmp ecx, dword ptr [edx + field_307]         # 004f1881
    jl.d8 L_004f18fa                             # 004f1887
    # block 0x004f1889: entered by fall-through of jl at 0x004f1887, 7 instruction(s), ends with jg to 0x004f18fa (forward)
    movsx edx, word ptr [0x5b51ac]               # 004f1889
    imul edx, edx, 0x8d                          # 004f1890
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f1896
    mov ecx, dword ptr [ebp - local_4]           # 004f189c
    mov edx, dword ptr [ecx + field_5e]          # 004f189f
    cmp edx, dword ptr [eax + field_30f]         # 004f18a2
    jg.d8 L_004f18fa                             # 004f18a8
    # block 0x004f18aa: entered by fall-through of jg at 0x004f18a8, 13 instruction(s), ends with forward jump to 0x004f2578
    mov dword ptr [0x5b44f0], 0x9                # 004f18aa
    mov eax, dword ptr [0x5d0377]                # 004f18b4
    mov dword ptr [0x5d162d], eax                # 004f18b9
    mov ecx, dword ptr [0x5b44f0]                # 004f18be
    shl ecx, 0x5                                 # 004f18c4
    mov edx, dword ptr [0x5b44f4]                # 004f18c7
    shl edx, 0x4                                 # 004f18cd
    lea eax, [ecx + edx + 0x5b160c]              # 004f18d0
    mov dword ptr [0x5d1631], eax                # 004f18d7
    mov dword ptr [0x5d1639], 0x1                # 004f18dc
    mov dword ptr [0x5c39e5], 0x271d             # 004f18e6
    mov eax, 0x1                                 # 004f18f0
    jmp.d32 L_004f2578                           # 004f18f5
L_004f18fa:
    # block 0x004f18fa: entered by je at 0x004f14dd; jl at 0x004f183d; jg at 0x004f1862; jl at 0x004f1887; jg at 0x004f18a8, 2 instruction(s), ends with jne to 0x004f190f (forward)
    cmp dword ptr [0x5a4c1c], 0x0                # 004f18fa
    jne.d8 L_004f190f                            # 004f1901
    # block 0x004f1903: entered by fall-through of jne at 0x004f1901, 3 instruction(s), ends with forward jump to 0x004f1919
    mov ecx, dword ptr [ebp - local_4]           # 004f1903
    mov dword ptr [ecx + field_72], 0x0          # 004f1906
    jmp.d8 L_004f1919                            # 004f190d
L_004f190f:
    # block 0x004f190f: entered by jne at 0x004f1901, 2 instruction(s), falls into the block at 0x004f1919
    mov edx, dword ptr [ebp - local_4]           # 004f190f
    mov dword ptr [edx + field_72], 0x1          # 004f1912
L_004f1919:
    # block 0x004f1919: entered by jmp at 0x004f190d, 3 instruction(s), ends with je to 0x004f1dc4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1919
    cmp dword ptr [eax + field_72], 0x0          # 004f191c
    je.d32 L_004f1dc4                            # 004f1920
    # block 0x004f1926: entered by fall-through of je at 0x004f1920, 3 instruction(s), ends with je to 0x004f198c (forward)
    movsx ecx, word ptr [0x5bb2cc]               # 004f1926
    test ecx, ecx                                # 004f192d
    je.d8 L_004f198c                             # 004f192f
    # block 0x004f1931: entered by fall-through of je at 0x004f192f, 2 instruction(s), ends with jle to 0x004f198c (forward)
    cmp dword ptr [0x5bb587], 0x0                # 004f1931
    jle.d8 L_004f198c                            # 004f1938
    # block 0x004f193a: entered by fall-through of jle at 0x004f1938, 7 instruction(s), ends with jl to 0x004f198c (forward)
    movsx edx, word ptr [0x5bb2cc]               # 004f193a
    mov eax, dword ptr [ebp - local_4]           # 004f1941
    mov ecx, dword ptr [eax + field_8]           # 004f1944
    {load} sub ecx, edx                          # 004f1947
    sub ecx, 0xa                                 # 004f1949
    cmp dword ptr [0x58316a], ecx                # 004f194c
    jl.d8 L_004f198c                             # 004f1952
    # block 0x004f1954: entered by fall-through of jl at 0x004f1952, 4 instruction(s), ends with jg to 0x004f198c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f1954
    mov eax, dword ptr [0x58316a]                # 004f1957
    cmp eax, dword ptr [edx + field_38]          # 004f195c
    jg.d8 L_004f198c                             # 004f195f
    # block 0x004f1961: entered by fall-through of jg at 0x004f195f, 4 instruction(s), ends with jl to 0x004f198c (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1961
    mov edx, dword ptr [0x58316e]                # 004f1964
    cmp edx, dword ptr [ecx + field_34]          # 004f196a
    jl.d8 L_004f198c                             # 004f196d
    # block 0x004f196f: entered by fall-through of jl at 0x004f196d, 4 instruction(s), ends with jg to 0x004f198c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f196f
    mov ecx, dword ptr [0x58316e]                # 004f1972
    cmp ecx, dword ptr [eax + field_3c]          # 004f1978
    jg.d8 L_004f198c                             # 004f197b
    # block 0x004f197d: entered by fall-through of jg at 0x004f197b, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x3                # 004f197d
    jmp.d32 L_004f1dc4                           # 004f1987
L_004f198c:
    # block 0x004f198c: entered by je at 0x004f192f; jle at 0x004f1938; jl at 0x004f1952; jg at 0x004f195f; more, 3 instruction(s), ends with je to 0x004f19f6 (forward)
    movsx edx, word ptr [0x5bb2cc]               # 004f198c
    test edx, edx                                # 004f1993
    je.d8 L_004f19f6                             # 004f1995
    # block 0x004f1997: entered by fall-through of je at 0x004f1995, 3 instruction(s), ends with je to 0x004f19f6 (forward)
    mov eax, dword ptr [0x5bb58f]                # 004f1997
    cmp eax, dword ptr [0x5bb4fd]                # 004f199c
    je.d8 L_004f19f6                             # 004f19a2
    # block 0x004f19a4: entered by fall-through of je at 0x004f19a2, 4 instruction(s), ends with jl to 0x004f19f6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f19a4
    mov edx, dword ptr [0x58316a]                # 004f19a7
    cmp edx, dword ptr [ecx + field_40]          # 004f19ad
    jl.d8 L_004f19f6                             # 004f19b0
    # block 0x004f19b2: entered by fall-through of jl at 0x004f19b0, 6 instruction(s), ends with jg to 0x004f19f6 (forward)
    movsx eax, word ptr [0x5bb2cc]               # 004f19b2
    mov ecx, dword ptr [ebp - local_4]           # 004f19b9
    mov edx, dword ptr [ecx + field_10]          # 004f19bc
    lea eax, [edx + eax + field_28]              # 004f19bf
    cmp dword ptr [0x58316a], eax                # 004f19c3
    jg.d8 L_004f19f6                             # 004f19c9
    # block 0x004f19cb: entered by fall-through of jg at 0x004f19c9, 4 instruction(s), ends with jl to 0x004f19f6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f19cb
    mov edx, dword ptr [0x58316e]                # 004f19ce
    cmp edx, dword ptr [ecx + field_34]          # 004f19d4
    jl.d8 L_004f19f6                             # 004f19d7
    # block 0x004f19d9: entered by fall-through of jl at 0x004f19d7, 4 instruction(s), ends with jg to 0x004f19f6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f19d9
    mov ecx, dword ptr [0x58316e]                # 004f19dc
    cmp ecx, dword ptr [eax + field_3c]          # 004f19e2
    jg.d8 L_004f19f6                             # 004f19e5
    # block 0x004f19e7: entered by fall-through of jg at 0x004f19e5, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x4                # 004f19e7
    jmp.d32 L_004f1dc4                           # 004f19f1
L_004f19f6:
    # block 0x004f19f6: entered by je at 0x004f1995; je at 0x004f19a2; jl at 0x004f19b0; jg at 0x004f19c9; more, 3 instruction(s), ends with je to 0x004f1a7d (forward)
    movsx edx, word ptr [0x5bb2ca]               # 004f19f6
    test edx, edx                                # 004f19fd
    je.d8 L_004f1a7d                             # 004f19ff
    # block 0x004f1a01: entered by fall-through of je at 0x004f19ff, 3 instruction(s), ends with je to 0x004f1a2b (forward)
    movsx eax, word ptr [0x5bb2b6]               # 004f1a01
    cmp eax, 0x1                                 # 004f1a08
    je.d8 L_004f1a2b                             # 004f1a0b
    # block 0x004f1a0d: entered by fall-through of je at 0x004f1a0b, 3 instruction(s), ends with jne to 0x004f1a7d (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 004f1a0d
    cmp ecx, 0x2                                 # 004f1a14
    jne.d8 L_004f1a7d                            # 004f1a17
    # block 0x004f1a19: entered by fall-through of jne at 0x004f1a17, 4 instruction(s), ends with je to 0x004f1a7d (forward)
    movsx edx, word ptr [0x5bb50b]               # 004f1a19
    movsx eax, word ptr [0x5bb4e5]               # 004f1a20
    {load} cmp edx, eax                          # 004f1a27
    je.d8 L_004f1a7d                             # 004f1a29
L_004f1a2b:
    # block 0x004f1a2b: entered by je at 0x004f1a0b; fall-through of je at 0x004f1a29, 4 instruction(s), ends with jl to 0x004f1a7d (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1a2b
    mov edx, dword ptr [0x58316a]                # 004f1a2e
    cmp edx, dword ptr [ecx + field_38]          # 004f1a34
    jl.d8 L_004f1a7d                             # 004f1a37
    # block 0x004f1a39: entered by fall-through of jl at 0x004f1a37, 4 instruction(s), ends with jg to 0x004f1a7d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1a39
    mov ecx, dword ptr [0x58316a]                # 004f1a3c
    cmp ecx, dword ptr [eax + field_40]          # 004f1a42
    jg.d8 L_004f1a7d                             # 004f1a45
    # block 0x004f1a47: entered by fall-through of jg at 0x004f1a45, 7 instruction(s), ends with jl to 0x004f1a7d (forward)
    movsx edx, word ptr [0x5bb2ca]               # 004f1a47
    mov eax, dword ptr [ebp - local_4]           # 004f1a4e
    mov ecx, dword ptr [eax + field_4]           # 004f1a51
    {load} sub ecx, edx                          # 004f1a54
    sub ecx, 0x2d                                # 004f1a56
    cmp dword ptr [0x58316e], ecx                # 004f1a59
    jl.d8 L_004f1a7d                             # 004f1a5f
    # block 0x004f1a61: entered by fall-through of jl at 0x004f1a5f, 4 instruction(s), ends with jg to 0x004f1a7d (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f1a61
    mov eax, dword ptr [0x58316e]                # 004f1a64
    cmp eax, dword ptr [edx + field_34]          # 004f1a69
    jg.d8 L_004f1a7d                             # 004f1a6c
    # block 0x004f1a6e: entered by fall-through of jg at 0x004f1a6c, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x1                # 004f1a6e
    jmp.d32 L_004f1dc4                           # 004f1a78
L_004f1a7d:
    # block 0x004f1a7d: entered by je at 0x004f19ff; jne at 0x004f1a17; je at 0x004f1a29; jl at 0x004f1a37; more, 3 instruction(s), ends with je to 0x004f1b03 (forward)
    movsx ecx, word ptr [0x5bb2ca]               # 004f1a7d
    test ecx, ecx                                # 004f1a84
    je.d8 L_004f1b03                             # 004f1a86
    # block 0x004f1a88: entered by fall-through of je at 0x004f1a86, 3 instruction(s), ends with je to 0x004f1ab2 (forward)
    movsx edx, word ptr [0x5bb2b6]               # 004f1a88
    cmp edx, 0x1                                 # 004f1a8f
    je.d8 L_004f1ab2                             # 004f1a92
    # block 0x004f1a94: entered by fall-through of je at 0x004f1a92, 3 instruction(s), ends with jne to 0x004f1b03 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 004f1a94
    cmp eax, 0x2                                 # 004f1a9b
    jne.d8 L_004f1b03                            # 004f1a9e
    # block 0x004f1aa0: entered by fall-through of jne at 0x004f1a9e, 4 instruction(s), ends with je to 0x004f1b03 (forward)
    movsx ecx, word ptr [0x5bb50b]               # 004f1aa0
    movsx edx, word ptr [0x5bb4e3]               # 004f1aa7
    {load} cmp ecx, edx                          # 004f1aae
    je.d8 L_004f1b03                             # 004f1ab0
L_004f1ab2:
    # block 0x004f1ab2: entered by je at 0x004f1a92; fall-through of je at 0x004f1ab0, 4 instruction(s), ends with jl to 0x004f1b03 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1ab2
    mov ecx, dword ptr [0x58316a]                # 004f1ab5
    cmp ecx, dword ptr [eax + field_38]          # 004f1abb
    jl.d8 L_004f1b03                             # 004f1abe
    # block 0x004f1ac0: entered by fall-through of jl at 0x004f1abe, 4 instruction(s), ends with jg to 0x004f1b03 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f1ac0
    mov eax, dword ptr [0x58316a]                # 004f1ac3
    cmp eax, dword ptr [edx + field_40]          # 004f1ac8
    jg.d8 L_004f1b03                             # 004f1acb
    # block 0x004f1acd: entered by fall-through of jg at 0x004f1acb, 4 instruction(s), ends with jl to 0x004f1b03 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1acd
    mov edx, dword ptr [0x58316e]                # 004f1ad0
    cmp edx, dword ptr [ecx + field_3c]          # 004f1ad6
    jl.d8 L_004f1b03                             # 004f1ad9
    # block 0x004f1adb: entered by fall-through of jl at 0x004f1ad9, 6 instruction(s), ends with jg to 0x004f1b03 (forward)
    movsx eax, word ptr [0x5bb2ca]               # 004f1adb
    mov ecx, dword ptr [ebp - local_4]           # 004f1ae2
    mov edx, dword ptr [ecx + field_c]           # 004f1ae5
    lea eax, [edx + eax + field_2d]              # 004f1ae8
    cmp dword ptr [0x58316e], eax                # 004f1aec
    jg.d8 L_004f1b03                             # 004f1af2
    # block 0x004f1af4: entered by fall-through of jg at 0x004f1af2, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x2                # 004f1af4
    jmp.d32 L_004f1dc4                           # 004f1afe
L_004f1b03:
    # block 0x004f1b03: entered by je at 0x004f1a86; jne at 0x004f1a9e; je at 0x004f1ab0; jl at 0x004f1abe; more, 3 instruction(s), ends with je to 0x004f1bb7 (forward)
    movsx ecx, word ptr [0x5bb2cc]               # 004f1b03
    test ecx, ecx                                # 004f1b0a
    je.d32 L_004f1bb7                            # 004f1b0c
    # block 0x004f1b12: entered by fall-through of je at 0x004f1b0c, 3 instruction(s), ends with je to 0x004f1bb7 (forward)
    movsx edx, word ptr [0x5bb2ca]               # 004f1b12
    test edx, edx                                # 004f1b19
    je.d32 L_004f1bb7                            # 004f1b1b
    # block 0x004f1b21: entered by fall-through of je at 0x004f1b1b, 2 instruction(s), ends with jle to 0x004f1bb7 (forward)
    cmp dword ptr [0x5bb587], 0x0                # 004f1b21
    jle.d32 L_004f1bb7                           # 004f1b28
    # block 0x004f1b2e: entered by fall-through of jle at 0x004f1b28, 3 instruction(s), ends with je to 0x004f1b58 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 004f1b2e
    cmp eax, 0x1                                 # 004f1b35
    je.d8 L_004f1b58                             # 004f1b38
    # block 0x004f1b3a: entered by fall-through of je at 0x004f1b38, 3 instruction(s), ends with jne to 0x004f1bb7 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 004f1b3a
    cmp ecx, 0x2                                 # 004f1b41
    jne.d8 L_004f1bb7                            # 004f1b44
    # block 0x004f1b46: entered by fall-through of jne at 0x004f1b44, 4 instruction(s), ends with je to 0x004f1bb7 (forward)
    movsx edx, word ptr [0x5bb50b]               # 004f1b46
    movsx eax, word ptr [0x5bb4e5]               # 004f1b4d
    {load} cmp edx, eax                          # 004f1b54
    je.d8 L_004f1bb7                             # 004f1b56
L_004f1b58:
    # block 0x004f1b58: entered by je at 0x004f1b38; fall-through of je at 0x004f1b56, 7 instruction(s), ends with jl to 0x004f1bb7 (forward)
    movsx ecx, word ptr [0x5bb2cc]               # 004f1b58
    mov edx, dword ptr [ebp - local_4]           # 004f1b5f
    mov eax, dword ptr [edx + field_8]           # 004f1b62
    {load} sub eax, ecx                          # 004f1b65
    sub eax, 0xa                                 # 004f1b67
    cmp dword ptr [0x58316a], eax                # 004f1b6a
    jl.d8 L_004f1bb7                             # 004f1b70
    # block 0x004f1b72: entered by fall-through of jl at 0x004f1b70, 4 instruction(s), ends with jg to 0x004f1bb7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1b72
    mov edx, dword ptr [0x58316a]                # 004f1b75
    cmp edx, dword ptr [ecx + field_38]          # 004f1b7b
    jg.d8 L_004f1bb7                             # 004f1b7e
    # block 0x004f1b80: entered by fall-through of jg at 0x004f1b7e, 7 instruction(s), ends with jl to 0x004f1bb7 (forward)
    movsx eax, word ptr [0x5bb2ca]               # 004f1b80
    mov ecx, dword ptr [ebp - local_4]           # 004f1b87
    mov edx, dword ptr [ecx + field_4]           # 004f1b8a
    {load} sub edx, eax                          # 004f1b8d
    sub edx, 0x2d                                # 004f1b8f
    cmp dword ptr [0x58316e], edx                # 004f1b92
    jl.d8 L_004f1bb7                             # 004f1b98
    # block 0x004f1b9a: entered by fall-through of jl at 0x004f1b98, 4 instruction(s), ends with jg to 0x004f1bb7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1b9a
    mov ecx, dword ptr [0x58316e]                # 004f1b9d
    cmp ecx, dword ptr [eax + field_34]          # 004f1ba3
    jg.d8 L_004f1bb7                             # 004f1ba6
    # block 0x004f1ba8: entered by fall-through of jg at 0x004f1ba6, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x5                # 004f1ba8
    jmp.d32 L_004f1dc4                           # 004f1bb2
L_004f1bb7:
    # block 0x004f1bb7: entered by je at 0x004f1b0c; je at 0x004f1b1b; jle at 0x004f1b28; jne at 0x004f1b44; more, 3 instruction(s), ends with je to 0x004f1c69 (forward)
    movsx edx, word ptr [0x5bb2cc]               # 004f1bb7
    test edx, edx                                # 004f1bbe
    je.d32 L_004f1c69                            # 004f1bc0
    # block 0x004f1bc6: entered by fall-through of je at 0x004f1bc0, 3 instruction(s), ends with je to 0x004f1c69 (forward)
    movsx eax, word ptr [0x5bb2ca]               # 004f1bc6
    test eax, eax                                # 004f1bcd
    je.d32 L_004f1c69                            # 004f1bcf
    # block 0x004f1bd5: entered by fall-through of je at 0x004f1bcf, 2 instruction(s), ends with jle to 0x004f1c69 (forward)
    cmp dword ptr [0x5bb587], 0x0                # 004f1bd5
    jle.d32 L_004f1c69                           # 004f1bdc
    # block 0x004f1be2: entered by fall-through of jle at 0x004f1bdc, 3 instruction(s), ends with je to 0x004f1c0c (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 004f1be2
    cmp ecx, 0x1                                 # 004f1be9
    je.d8 L_004f1c0c                             # 004f1bec
    # block 0x004f1bee: entered by fall-through of je at 0x004f1bec, 3 instruction(s), ends with jne to 0x004f1c69 (forward)
    movsx edx, word ptr [0x5bb2b6]               # 004f1bee
    cmp edx, 0x2                                 # 004f1bf5
    jne.d8 L_004f1c69                            # 004f1bf8
    # block 0x004f1bfa: entered by fall-through of jne at 0x004f1bf8, 4 instruction(s), ends with je to 0x004f1c69 (forward)
    movsx eax, word ptr [0x5bb50b]               # 004f1bfa
    movsx ecx, word ptr [0x5bb4e3]               # 004f1c01
    {load} cmp eax, ecx                          # 004f1c08
    je.d8 L_004f1c69                             # 004f1c0a
L_004f1c0c:
    # block 0x004f1c0c: entered by je at 0x004f1bec; fall-through of je at 0x004f1c0a, 7 instruction(s), ends with jl to 0x004f1c69 (forward)
    movsx edx, word ptr [0x5bb2cc]               # 004f1c0c
    mov eax, dword ptr [ebp - local_4]           # 004f1c13
    mov ecx, dword ptr [eax + field_8]           # 004f1c16
    {load} sub ecx, edx                          # 004f1c19
    sub ecx, 0xa                                 # 004f1c1b
    cmp dword ptr [0x58316a], ecx                # 004f1c1e
    jl.d8 L_004f1c69                             # 004f1c24
    # block 0x004f1c26: entered by fall-through of jl at 0x004f1c24, 4 instruction(s), ends with jg to 0x004f1c69 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f1c26
    mov eax, dword ptr [0x58316a]                # 004f1c29
    cmp eax, dword ptr [edx + field_38]          # 004f1c2e
    jg.d8 L_004f1c69                             # 004f1c31
    # block 0x004f1c33: entered by fall-through of jg at 0x004f1c31, 4 instruction(s), ends with jl to 0x004f1c69 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1c33
    mov edx, dword ptr [0x58316e]                # 004f1c36
    cmp edx, dword ptr [ecx + field_3c]          # 004f1c3c
    jl.d8 L_004f1c69                             # 004f1c3f
    # block 0x004f1c41: entered by fall-through of jl at 0x004f1c3f, 6 instruction(s), ends with jg to 0x004f1c69 (forward)
    movsx eax, word ptr [0x5bb2ca]               # 004f1c41
    mov ecx, dword ptr [ebp - local_4]           # 004f1c48
    mov edx, dword ptr [ecx + field_c]           # 004f1c4b
    lea eax, [edx + eax + field_2d]              # 004f1c4e
    cmp dword ptr [0x58316e], eax                # 004f1c52
    jg.d8 L_004f1c69                             # 004f1c58
    # block 0x004f1c5a: entered by fall-through of jg at 0x004f1c58, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x6                # 004f1c5a
    jmp.d32 L_004f1dc4                           # 004f1c64
L_004f1c69:
    # block 0x004f1c69: entered by je at 0x004f1bc0; je at 0x004f1bcf; jle at 0x004f1bdc; jne at 0x004f1bf8; more, 3 instruction(s), ends with je to 0x004f1d1a (forward)
    movsx ecx, word ptr [0x5bb2cc]               # 004f1c69
    test ecx, ecx                                # 004f1c70
    je.d32 L_004f1d1a                            # 004f1c72
    # block 0x004f1c78: entered by fall-through of je at 0x004f1c72, 3 instruction(s), ends with je to 0x004f1d1a (forward)
    movsx edx, word ptr [0x5bb2ca]               # 004f1c78
    test edx, edx                                # 004f1c7f
    je.d32 L_004f1d1a                            # 004f1c81
    # block 0x004f1c87: entered by fall-through of je at 0x004f1c81, 3 instruction(s), ends with je to 0x004f1d1a (forward)
    mov eax, dword ptr [0x5bb58f]                # 004f1c87
    cmp eax, dword ptr [0x5bb4fd]                # 004f1c8c
    je.d32 L_004f1d1a                            # 004f1c92
    # block 0x004f1c98: entered by fall-through of je at 0x004f1c92, 3 instruction(s), ends with je to 0x004f1cc2 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 004f1c98
    cmp ecx, 0x1                                 # 004f1c9f
    je.d8 L_004f1cc2                             # 004f1ca2
    # block 0x004f1ca4: entered by fall-through of je at 0x004f1ca2, 3 instruction(s), ends with jne to 0x004f1d1a (forward)
    movsx edx, word ptr [0x5bb2b6]               # 004f1ca4
    cmp edx, 0x2                                 # 004f1cab
    jne.d8 L_004f1d1a                            # 004f1cae
    # block 0x004f1cb0: entered by fall-through of jne at 0x004f1cae, 4 instruction(s), ends with je to 0x004f1d1a (forward)
    movsx eax, word ptr [0x5bb50b]               # 004f1cb0
    movsx ecx, word ptr [0x5bb4e5]               # 004f1cb7
    {load} cmp eax, ecx                          # 004f1cbe
    je.d8 L_004f1d1a                             # 004f1cc0
L_004f1cc2:
    # block 0x004f1cc2: entered by je at 0x004f1ca2; fall-through of je at 0x004f1cc0, 4 instruction(s), ends with jl to 0x004f1d1a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f1cc2
    mov eax, dword ptr [0x58316a]                # 004f1cc5
    cmp eax, dword ptr [edx + field_40]          # 004f1cca
    jl.d8 L_004f1d1a                             # 004f1ccd
    # block 0x004f1ccf: entered by fall-through of jl at 0x004f1ccd, 6 instruction(s), ends with jg to 0x004f1d1a (forward)
    movsx ecx, word ptr [0x5bb2cc]               # 004f1ccf
    mov edx, dword ptr [ebp - local_4]           # 004f1cd6
    mov eax, dword ptr [edx + field_10]          # 004f1cd9
    {load} add eax, ecx                          # 004f1cdc
    cmp dword ptr [0x58316a], eax                # 004f1cde
    jg.d8 L_004f1d1a                             # 004f1ce4
    # block 0x004f1ce6: entered by fall-through of jg at 0x004f1ce4, 6 instruction(s), ends with jl to 0x004f1d1a (forward)
    movsx ecx, word ptr [0x5bb2ca]               # 004f1ce6
    mov edx, dword ptr [ebp - local_4]           # 004f1ced
    mov eax, dword ptr [edx + field_4]           # 004f1cf0
    {load} sub eax, ecx                          # 004f1cf3
    cmp dword ptr [0x58316e], eax                # 004f1cf5
    jl.d8 L_004f1d1a                             # 004f1cfb
    # block 0x004f1cfd: entered by fall-through of jl at 0x004f1cfb, 4 instruction(s), ends with jg to 0x004f1d1a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1cfd
    mov edx, dword ptr [0x58316e]                # 004f1d00
    cmp edx, dword ptr [ecx + field_34]          # 004f1d06
    jg.d8 L_004f1d1a                             # 004f1d09
    # block 0x004f1d0b: entered by fall-through of jg at 0x004f1d09, 2 instruction(s), ends with forward jump to 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x7                # 004f1d0b
    jmp.d32 L_004f1dc4                           # 004f1d15
L_004f1d1a:
    # block 0x004f1d1a: entered by je at 0x004f1c72; je at 0x004f1c81; je at 0x004f1c92; jne at 0x004f1cae; more, 3 instruction(s), ends with je to 0x004f1dc4 (forward)
    movsx eax, word ptr [0x5bb2cc]               # 004f1d1a
    test eax, eax                                # 004f1d21
    je.d32 L_004f1dc4                            # 004f1d23
    # block 0x004f1d29: entered by fall-through of je at 0x004f1d23, 3 instruction(s), ends with je to 0x004f1dc4 (forward)
    movsx ecx, word ptr [0x5bb2ca]               # 004f1d29
    test ecx, ecx                                # 004f1d30
    je.d32 L_004f1dc4                            # 004f1d32
    # block 0x004f1d38: entered by fall-through of je at 0x004f1d32, 3 instruction(s), ends with je to 0x004f1dc4 (forward)
    mov edx, dword ptr [0x5bb58f]                # 004f1d38
    cmp edx, dword ptr [0x5bb4fd]                # 004f1d3e
    je.d8 L_004f1dc4                             # 004f1d44
    # block 0x004f1d46: entered by fall-through of je at 0x004f1d44, 3 instruction(s), ends with je to 0x004f1d70 (forward)
    movsx eax, word ptr [0x5bb2b6]               # 004f1d46
    cmp eax, 0x1                                 # 004f1d4d
    je.d8 L_004f1d70                             # 004f1d50
    # block 0x004f1d52: entered by fall-through of je at 0x004f1d50, 3 instruction(s), ends with jne to 0x004f1dc4 (forward)
    movsx ecx, word ptr [0x5bb2b6]               # 004f1d52
    cmp ecx, 0x2                                 # 004f1d59
    jne.d8 L_004f1dc4                            # 004f1d5c
    # block 0x004f1d5e: entered by fall-through of jne at 0x004f1d5c, 4 instruction(s), ends with je to 0x004f1dc4 (forward)
    movsx edx, word ptr [0x5bb50b]               # 004f1d5e
    movsx eax, word ptr [0x5bb4e3]               # 004f1d65
    {load} cmp edx, eax                          # 004f1d6c
    je.d8 L_004f1dc4                             # 004f1d6e
L_004f1d70:
    # block 0x004f1d70: entered by je at 0x004f1d50; fall-through of je at 0x004f1d6e, 4 instruction(s), ends with jl to 0x004f1dc4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1d70
    mov edx, dword ptr [0x58316a]                # 004f1d73
    cmp edx, dword ptr [ecx + field_40]          # 004f1d79
    jl.d8 L_004f1dc4                             # 004f1d7c
    # block 0x004f1d7e: entered by fall-through of jl at 0x004f1d7c, 6 instruction(s), ends with jg to 0x004f1dc4 (forward)
    movsx eax, word ptr [0x5bb2cc]               # 004f1d7e
    mov ecx, dword ptr [ebp - local_4]           # 004f1d85
    mov edx, dword ptr [ecx + field_10]          # 004f1d88
    {load} add edx, eax                          # 004f1d8b
    cmp dword ptr [0x58316a], edx                # 004f1d8d
    jg.d8 L_004f1dc4                             # 004f1d93
    # block 0x004f1d95: entered by fall-through of jg at 0x004f1d93, 4 instruction(s), ends with jl to 0x004f1dc4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1d95
    mov ecx, dword ptr [0x58316e]                # 004f1d98
    cmp ecx, dword ptr [eax + field_3c]          # 004f1d9e
    jl.d8 L_004f1dc4                             # 004f1da1
    # block 0x004f1da3: entered by fall-through of jl at 0x004f1da1, 6 instruction(s), ends with jg to 0x004f1dc4 (forward)
    movsx edx, word ptr [0x5bb2ca]               # 004f1da3
    mov eax, dword ptr [ebp - local_4]           # 004f1daa
    mov ecx, dword ptr [eax + field_c]           # 004f1dad
    {load} add ecx, edx                          # 004f1db0
    cmp dword ptr [0x58316e], ecx                # 004f1db2
    jg.d8 L_004f1dc4                             # 004f1db8
    # block 0x004f1dba: entered by fall-through of jg at 0x004f1db8, 1 instruction(s), falls into the block at 0x004f1dc4
    mov dword ptr [0x5a4c18], 0x8                # 004f1dba
L_004f1dc4:
    # block 0x004f1dc4: entered by je at 0x004f1920; jmp at 0x004f1987; jmp at 0x004f19f1; jmp at 0x004f1a78; more, 2 instruction(s), ends with je to 0x004f1e7d (forward)
    cmp dword ptr [0x5a4c18], 0x0                # 004f1dc4
    je.d32 L_004f1e7d                            # 004f1dcb
    # block 0x004f1dd1: entered by fall-through of je at 0x004f1dcb, 2 instruction(s), ends with jne to 0x004f1e08 (forward)
    cmp dword ptr [0x5a4c18], 0x1                # 004f1dd1
    jne.d8 L_004f1e08                            # 004f1dd8
    # block 0x004f1dda: entered by fall-through of jne at 0x004f1dd8, 3 instruction(s), ends with jne to 0x004f1df2 (forward)
    movsx edx, word ptr [0x5bb2d0]               # 004f1dda
    cmp edx, 0x4d                                # 004f1de1
    jne.d8 L_004f1df2                            # 004f1de4
    # block 0x004f1de6: entered by fall-through of jne at 0x004f1de4, 2 instruction(s), ends with forward jump to 0x004f1dfc
    mov dword ptr [0x5b44f0], 0x11               # 004f1de6
    jmp.d8 L_004f1dfc                            # 004f1df0
L_004f1df2:
    # block 0x004f1df2: entered by jne at 0x004f1de4, 1 instruction(s), falls into the block at 0x004f1dfc
    mov dword ptr [0x5b44f0], 0xe                # 004f1df2
L_004f1dfc:
    # block 0x004f1dfc: entered by jmp at 0x004f1df0, 3 instruction(s), ends with forward jump to 0x004f1e4b
    mov eax, dword ptr [0x5d0377]                # 004f1dfc
    mov dword ptr [0x5d162d], eax                # 004f1e01
    jmp.d8 L_004f1e4b                            # 004f1e06
L_004f1e08:
    # block 0x004f1e08: entered by jne at 0x004f1dd8, 2 instruction(s), ends with jne to 0x004f1e41 (forward)
    cmp dword ptr [0x5a4c18], 0x2                # 004f1e08
    jne.d8 L_004f1e41                            # 004f1e0f
    # block 0x004f1e11: entered by fall-through of jne at 0x004f1e0f, 3 instruction(s), ends with jne to 0x004f1e29 (forward)
    movsx ecx, word ptr [0x5bb2d0]               # 004f1e11
    cmp ecx, 0x4d                                # 004f1e18
    jne.d8 L_004f1e29                            # 004f1e1b
    # block 0x004f1e1d: entered by fall-through of jne at 0x004f1e1b, 2 instruction(s), ends with forward jump to 0x004f1e33
    mov dword ptr [0x5b44f0], 0x10               # 004f1e1d
    jmp.d8 L_004f1e33                            # 004f1e27
L_004f1e29:
    # block 0x004f1e29: entered by jne at 0x004f1e1b, 1 instruction(s), falls into the block at 0x004f1e33
    mov dword ptr [0x5b44f0], 0xf                # 004f1e29
L_004f1e33:
    # block 0x004f1e33: entered by jmp at 0x004f1e27, 3 instruction(s), ends with forward jump to 0x004f1e4b
    mov edx, dword ptr [0x5d0377]                # 004f1e33
    mov dword ptr [0x5d162d], edx                # 004f1e39
    jmp.d8 L_004f1e4b                            # 004f1e3f
L_004f1e41:
    # block 0x004f1e41: entered by jne at 0x004f1e0f, 1 instruction(s), falls into the block at 0x004f1e4b
    mov dword ptr [0x5b44f0], 0x0                # 004f1e41
L_004f1e4b:
    # block 0x004f1e4b: entered by jmp at 0x004f1e06; jmp at 0x004f1e3f, 9 instruction(s), ends with forward jump to 0x004f2578
    mov eax, dword ptr [0x5b44f0]                # 004f1e4b
    shl eax, 0x5                                 # 004f1e50
    mov ecx, dword ptr [0x5b44f4]                # 004f1e53
    shl ecx, 0x4                                 # 004f1e59
    lea edx, [eax + ecx + 0x5b160c]              # 004f1e5c
    mov dword ptr [0x5d1631], edx                # 004f1e63
    mov dword ptr [0x5d1639], 0x1                # 004f1e69
    mov eax, 0x1                                 # 004f1e73
    jmp.d32 L_004f2578                           # 004f1e78
L_004f1e7d:
    # block 0x004f1e7d: entered by je at 0x004f1dcb, 2 instruction(s), ends with jne to 0x004f1eb8 (forward)
    cmp dword ptr [0x5a4c18], 0x0                # 004f1e7d
    jne.d8 L_004f1eb8                            # 004f1e84
    # block 0x004f1e86: entered by fall-through of jne at 0x004f1e84, 8 instruction(s), falls into the block at 0x004f1eb8
    mov dword ptr [0x5b44f4], 0x0                # 004f1e86
    mov eax, dword ptr [0x5b44f0]                # 004f1e90
    shl eax, 0x5                                 # 004f1e95
    mov ecx, dword ptr [0x5b44f4]                # 004f1e98
    shl ecx, 0x4                                 # 004f1e9e
    lea edx, [eax + ecx + 0x5b160c]              # 004f1ea1
    mov dword ptr [0x5d1631], edx                # 004f1ea8
    mov dword ptr [0x5d1639], 0x1                # 004f1eae
L_004f1eb8:
    # block 0x004f1eb8: entered by jne at 0x004f1e84, 4 instruction(s), ends with forward jump to 0x004f1edd
    mov dword ptr [0x5b44f8], 0x0                # 004f1eb8
    mov eax, dword ptr [ebp - local_4]           # 004f1ec2
    mov dword ptr [eax + field_6e], 0x0          # 004f1ec5
    jmp.d8 L_004f1edd                            # 004f1ecc
L_004f1ece:
    # block 0x004f1ece: entered by jmp at 0x004f256a, 5 instruction(s), falls into the block at 0x004f1edd
    mov ecx, dword ptr [ebp - local_4]           # 004f1ece
    mov edx, dword ptr [ecx + field_6e]          # 004f1ed1
    add edx, 0x1                                 # 004f1ed4
    mov eax, dword ptr [ebp - local_4]           # 004f1ed7
    mov dword ptr [eax + field_6e], edx          # 004f1eda
L_004f1edd:
    # block 0x004f1edd: entered by jmp at 0x004f1ecc, 4 instruction(s), ends with jge to 0x004f256f (forward)
    movsx ecx, word ptr [0x5c39e3]               # 004f1edd
    mov edx, dword ptr [ebp - local_4]           # 004f1ee4
    cmp dword ptr [edx + field_6e], ecx          # 004f1ee7
    jge.d32 L_004f256f                           # 004f1eea
    # block 0x004f1ef0: entered by fall-through of jge at 0x004f1eea, 4 instruction(s), ends with je to 0x004f2395 (forward)
    movsx eax, word ptr [0x5b4e89]               # 004f1ef0
    mov ecx, dword ptr [ebp - local_4]           # 004f1ef7
    cmp dword ptr [ecx + field_6e], eax          # 004f1efa
    je.d32 L_004f2395                            # 004f1efd
    # block 0x004f1f03: entered by fall-through of je at 0x004f1efd, 4 instruction(s), ends with je to 0x004f2395 (forward)
    movsx edx, word ptr [0x5b5100]               # 004f1f03
    mov eax, dword ptr [ebp - local_4]           # 004f1f0a
    cmp dword ptr [eax + field_6e], edx          # 004f1f0d
    je.d32 L_004f2395                            # 004f1f10
    # block 0x004f1f16: entered by fall-through of je at 0x004f1f10, 5 instruction(s), ends with je to 0x004f2395 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1f16
    mov edx, dword ptr [ecx + field_6e]          # 004f1f19
    imul edx, edx, 0x8d                          # 004f1f1c
    cmp dword ptr [edx + 0x5bb626], 0x0          # 004f1f22
    je.d32 L_004f2395                            # 004f1f29
    # block 0x004f1f2f: entered by fall-through of je at 0x004f1f29, 7 instruction(s), ends with jl to 0x004f2395 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1f2f
    mov ecx, dword ptr [eax + field_6e]          # 004f1f32
    imul ecx, ecx, 0x8d                          # 004f1f35
    movsx edx, word ptr [ecx + 0x5bb62c]         # 004f1f3b
    mov eax, dword ptr [ebp - local_4]           # 004f1f42
    cmp dword ptr [eax + field_5a], edx          # 004f1f45
    jl.d32 L_004f2395                            # 004f1f48
    # block 0x004f1f4e: entered by fall-through of jl at 0x004f1f48, 7 instruction(s), ends with jg to 0x004f2395 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1f4e
    mov edx, dword ptr [ecx + field_6e]          # 004f1f51
    imul edx, edx, 0x8d                          # 004f1f54
    movsx eax, word ptr [edx + 0x5bb630]         # 004f1f5a
    mov ecx, dword ptr [ebp - local_4]           # 004f1f61
    cmp dword ptr [ecx + field_5a], eax          # 004f1f64
    jg.d32 L_004f2395                            # 004f1f67
    # block 0x004f1f6d: entered by fall-through of jg at 0x004f1f67, 7 instruction(s), ends with jl to 0x004f2395 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f1f6d
    mov eax, dword ptr [edx + field_6e]          # 004f1f70
    imul eax, eax, 0x8d                          # 004f1f73
    movsx ecx, word ptr [eax + 0x5bb62a]         # 004f1f79
    mov edx, dword ptr [ebp - local_4]           # 004f1f80
    cmp dword ptr [edx + field_5e], ecx          # 004f1f83
    jl.d32 L_004f2395                            # 004f1f86
    # block 0x004f1f8c: entered by fall-through of jl at 0x004f1f86, 7 instruction(s), ends with jg to 0x004f2395 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f1f8c
    mov ecx, dword ptr [eax + field_6e]          # 004f1f8f
    imul ecx, ecx, 0x8d                          # 004f1f92
    movsx edx, word ptr [ecx + 0x5bb62e]         # 004f1f98
    mov eax, dword ptr [ebp - local_4]           # 004f1f9f
    cmp dword ptr [eax + field_5e], edx          # 004f1fa2
    jg.d32 L_004f2395                            # 004f1fa5
    # block 0x004f1fab: entered by fall-through of jg at 0x004f1fa5, 14 instruction(s), ends with ja to 0x004f22ef (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f1fab
    mov edx, dword ptr [ecx + field_6e]          # 004f1fae
    mov dword ptr [0x5c39e5], edx                # 004f1fb1
    mov eax, dword ptr [ebp - local_4]           # 004f1fb7
    mov ecx, dword ptr [eax + field_6e]          # 004f1fba
    imul ecx, ecx, 0x8d                          # 004f1fbd
    {load} xor edx, edx                          # 004f1fc3
    mov dl, byte ptr [ecx + 0x5bb5e3]            # 004f1fc5
    mov dword ptr [ebp - local_8], edx           # 004f1fcb
    mov eax, dword ptr [ebp - local_8]           # 004f1fce
    sub eax, 0xb                                 # 004f1fd1
    mov dword ptr [ebp - local_8], eax           # 004f1fd4
    cmp dword ptr [ebp - local_8], 0x6f          # 004f1fd7
    ja.d32 L_004f22ef                            # 004f1fdb
    # block 0x004f1fe1: entered by fall-through of ja at 0x004f1fdb, 4 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4f257c]
    mov edx, dword ptr [ebp - local_8]           # 004f1fe1
    {load} xor ecx, ecx                          # 004f1fe4
    mov cl, byte ptr [edx + IDXTAB_004f25a0_VA]  # 004f1fe6
    jmp dword ptr [4*ecx + SWTAB_004f257c_VA]    # 004f1fec
L_004f1ff3:
    # block 0x004f1ff3: entered by switch case, 3 instruction(s), ends with je to 0x004f2009 (forward)
    movsx eax, word ptr [0x583a29]               # 004f1ff3
    cmp eax, -0x1                                # 004f1ffa
    je.d8 L_004f2009                             # 004f1ffd
    # block 0x004f1fff: entered by fall-through of je at 0x004f1ffd, 1 instruction(s), falls into the block at 0x004f2009
    mov dword ptr [0x5b44f8], 0x1                # 004f1fff
L_004f2009:
    # block 0x004f2009: entered by je at 0x004f1ffd, 10 instruction(s), calls FUN_0040b2d0, ends with forward jump to 0x004f2305
    mov ecx, dword ptr [ebp - local_4]           # 004f2009
    mov edx, dword ptr [ecx + field_6e]          # 004f200c
    imul edx, edx, 0x8d                          # 004f200f
    mov al, byte ptr [edx + 0x5bb5e3]            # 004f2015
    push eax                                     # 004f201b
    call FUN_0040b2d0                            # 004f201c
    add esp, 0x4                                 # 004f2021
    and eax, 0xff                                # 004f2024
    mov dword ptr [0x5b44f0], eax                # 004f2029
    jmp.d32 L_004f2305                           # 004f202e
L_004f2033:
    # block 0x004f2033: entered by switch case, 7 instruction(s), ends with jle to 0x004f209a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f2033
    mov edx, dword ptr [ecx + field_6e]          # 004f2036
    imul edx, edx, 0x8d                          # 004f2039
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f203f
    movsx ecx, word ptr [eax]                    # 004f2045
    cmp ecx, 0x3                                 # 004f2048
    jle.d8 L_004f209a                            # 004f204b
    # block 0x004f204d: entered by fall-through of jle at 0x004f204b, 7 instruction(s), ends with jge to 0x004f209a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f204d
    mov eax, dword ptr [edx + field_6e]          # 004f2050
    imul eax, eax, 0x8d                          # 004f2053
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f2059
    movsx edx, word ptr [ecx]                    # 004f205f
    cmp edx, 0x1b                                # 004f2062
    jge.d8 L_004f209a                            # 004f2065
    # block 0x004f2067: entered by fall-through of jge at 0x004f2065, 3 instruction(s), ends with je to 0x004f209a (forward)
    movsx eax, word ptr [0x583a29]               # 004f2067
    cmp eax, -0x1                                # 004f206e
    je.d8 L_004f209a                             # 004f2071
    # block 0x004f2073: entered by fall-through of je at 0x004f2071, 8 instruction(s), ends with forward jump to 0x004f20c0
    mov dword ptr [0x5b44f8], 0x1                # 004f2073
    mov ecx, dword ptr [ebp - local_4]           # 004f207d
    mov edx, dword ptr [ecx + field_6e]          # 004f2080
    imul edx, edx, 0x8d                          # 004f2083
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f2089
    movsx ecx, word ptr [eax]                    # 004f208f
    mov dword ptr [0x5b44f0], ecx                # 004f2092
    jmp.d8 L_004f20c0                            # 004f2098
L_004f209a:
    # block 0x004f209a: entered by jle at 0x004f204b; jge at 0x004f2065; je at 0x004f2071, 3 instruction(s), ends with jne to 0x004f20c0 (forward)
    movsx edx, word ptr [0x583a29]               # 004f209a
    cmp edx, -0x1                                # 004f20a1
    jne.d8 L_004f20c0                            # 004f20a4
    # block 0x004f20a6: entered by fall-through of jne at 0x004f20a4, 6 instruction(s), falls into the block at 0x004f20c0
    mov eax, dword ptr [ebp - local_4]           # 004f20a6
    mov ecx, dword ptr [eax + field_6e]          # 004f20a9
    imul ecx, ecx, 0x8d                          # 004f20ac
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f20b2
    movsx eax, word ptr [edx]                    # 004f20b8
    mov dword ptr [0x5b44f0], eax                # 004f20bb
L_004f20c0:
    # block 0x004f20c0: entered by jmp at 0x004f2098; jne at 0x004f20a4, 1 instruction(s), ends with forward jump to 0x004f2305
    jmp.d32 L_004f2305                           # 004f20c0
L_004f20c5:
    # block 0x004f20c5: entered by switch case, 7 instruction(s), ends with jle to 0x004f212f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f20c5
    mov edx, dword ptr [ecx + field_6e]          # 004f20c8
    imul edx, edx, 0x8d                          # 004f20cb
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f20d1
    movsx ecx, word ptr [eax + field_28]         # 004f20d7
    cmp ecx, 0x3                                 # 004f20db
    jle.d8 L_004f212f                            # 004f20de
    # block 0x004f20e0: entered by fall-through of jle at 0x004f20de, 7 instruction(s), ends with jge to 0x004f212f (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f20e0
    mov eax, dword ptr [edx + field_6e]          # 004f20e3
    imul eax, eax, 0x8d                          # 004f20e6
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f20ec
    movsx edx, word ptr [ecx + field_28]         # 004f20f2
    cmp edx, 0x1b                                # 004f20f6
    jge.d8 L_004f212f                            # 004f20f9
    # block 0x004f20fb: entered by fall-through of jge at 0x004f20f9, 3 instruction(s), ends with je to 0x004f212f (forward)
    movsx eax, word ptr [0x583a29]               # 004f20fb
    cmp eax, -0x1                                # 004f2102
    je.d8 L_004f212f                             # 004f2105
    # block 0x004f2107: entered by fall-through of je at 0x004f2105, 8 instruction(s), ends with forward jump to 0x004f2156
    mov dword ptr [0x5b44f8], 0x1                # 004f2107
    mov ecx, dword ptr [ebp - local_4]           # 004f2111
    mov edx, dword ptr [ecx + field_6e]          # 004f2114
    imul edx, edx, 0x8d                          # 004f2117
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f211d
    movsx ecx, word ptr [eax + field_28]         # 004f2123
    mov dword ptr [0x5b44f0], ecx                # 004f2127
    jmp.d8 L_004f2156                            # 004f212d
L_004f212f:
    # block 0x004f212f: entered by jle at 0x004f20de; jge at 0x004f20f9; je at 0x004f2105, 3 instruction(s), ends with jne to 0x004f2156 (forward)
    movsx edx, word ptr [0x583a29]               # 004f212f
    cmp edx, -0x1                                # 004f2136
    jne.d8 L_004f2156                            # 004f2139
    # block 0x004f213b: entered by fall-through of jne at 0x004f2139, 6 instruction(s), falls into the block at 0x004f2156
    mov eax, dword ptr [ebp - local_4]           # 004f213b
    mov ecx, dword ptr [eax + field_6e]          # 004f213e
    imul ecx, ecx, 0x8d                          # 004f2141
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f2147
    movsx eax, word ptr [edx + field_28]         # 004f214d
    mov dword ptr [0x5b44f0], eax                # 004f2151
L_004f2156:
    # block 0x004f2156: entered by jmp at 0x004f212d; jne at 0x004f2139, 1 instruction(s), ends with forward jump to 0x004f2305
    jmp.d32 L_004f2305                           # 004f2156
L_004f215b:
    # block 0x004f215b: entered by switch case, 7 instruction(s), ends with jle to 0x004f21c5 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f215b
    mov edx, dword ptr [ecx + field_6e]          # 004f215e
    imul edx, edx, 0x8d                          # 004f2161
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f2167
    movsx ecx, word ptr [eax + field_8]          # 004f216d
    cmp ecx, 0x3                                 # 004f2171
    jle.d8 L_004f21c5                            # 004f2174
    # block 0x004f2176: entered by fall-through of jle at 0x004f2174, 7 instruction(s), ends with jge to 0x004f21c5 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f2176
    mov eax, dword ptr [edx + field_6e]          # 004f2179
    imul eax, eax, 0x8d                          # 004f217c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f2182
    movsx edx, word ptr [ecx + field_8]          # 004f2188
    cmp edx, 0x1b                                # 004f218c
    jge.d8 L_004f21c5                            # 004f218f
    # block 0x004f2191: entered by fall-through of jge at 0x004f218f, 3 instruction(s), ends with je to 0x004f21c5 (forward)
    movsx eax, word ptr [0x583a29]               # 004f2191
    cmp eax, -0x1                                # 004f2198
    je.d8 L_004f21c5                             # 004f219b
    # block 0x004f219d: entered by fall-through of je at 0x004f219b, 8 instruction(s), ends with forward jump to 0x004f21ec
    mov dword ptr [0x5b44f8], 0x1                # 004f219d
    mov ecx, dword ptr [ebp - local_4]           # 004f21a7
    mov edx, dword ptr [ecx + field_6e]          # 004f21aa
    imul edx, edx, 0x8d                          # 004f21ad
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f21b3
    movsx ecx, word ptr [eax + field_8]          # 004f21b9
    mov dword ptr [0x5b44f0], ecx                # 004f21bd
    jmp.d8 L_004f21ec                            # 004f21c3
L_004f21c5:
    # block 0x004f21c5: entered by jle at 0x004f2174; jge at 0x004f218f; je at 0x004f219b, 3 instruction(s), ends with jne to 0x004f21ec (forward)
    movsx edx, word ptr [0x583a29]               # 004f21c5
    cmp edx, -0x1                                # 004f21cc
    jne.d8 L_004f21ec                            # 004f21cf
    # block 0x004f21d1: entered by fall-through of jne at 0x004f21cf, 6 instruction(s), falls into the block at 0x004f21ec
    mov eax, dword ptr [ebp - local_4]           # 004f21d1
    mov ecx, dword ptr [eax + field_6e]          # 004f21d4
    imul ecx, ecx, 0x8d                          # 004f21d7
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f21dd
    movsx eax, word ptr [edx + field_8]          # 004f21e3
    mov dword ptr [0x5b44f0], eax                # 004f21e7
L_004f21ec:
    # block 0x004f21ec: entered by jmp at 0x004f21c3; jne at 0x004f21cf, 1 instruction(s), ends with forward jump to 0x004f2305
    jmp.d32 L_004f2305                           # 004f21ec
L_004f21f1:
    # block 0x004f21f1: entered by switch case, 3 instruction(s), ends with jne to 0x004f2219 (forward)
    movsx ecx, word ptr [0x583a29]               # 004f21f1
    cmp ecx, -0x1                                # 004f21f8
    jne.d8 L_004f2219                            # 004f21fb
    # block 0x004f21fd: entered by fall-through of jne at 0x004f21fb, 6 instruction(s), falls into the block at 0x004f2219
    mov edx, dword ptr [ebp - local_4]           # 004f21fd
    mov eax, dword ptr [edx + field_6e]          # 004f2200
    imul eax, eax, 0x8d                          # 004f2203
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f2209
    movsx edx, word ptr [ecx + field_2f]         # 004f220f
    mov dword ptr [0x5b44f0], edx                # 004f2213
L_004f2219:
    # block 0x004f2219: entered by jne at 0x004f21fb, 1 instruction(s), ends with forward jump to 0x004f2305
    jmp.d32 L_004f2305                           # 004f2219
L_004f221e:
    # block 0x004f221e: entered by switch case, 7 instruction(s), ends with jle to 0x004f2284 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f221e
    mov ecx, dword ptr [eax + field_6e]          # 004f2221
    imul ecx, ecx, 0x8d                          # 004f2224
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f222a
    movsx eax, word ptr [edx]                    # 004f2230
    cmp eax, 0x3                                 # 004f2233
    jle.d8 L_004f2284                            # 004f2236
    # block 0x004f2238: entered by fall-through of jle at 0x004f2236, 7 instruction(s), ends with jge to 0x004f2284 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f2238
    mov edx, dword ptr [ecx + field_6e]          # 004f223b
    imul edx, edx, 0x8d                          # 004f223e
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f2244
    movsx ecx, word ptr [eax]                    # 004f224a
    cmp ecx, 0x1b                                # 004f224d
    jge.d8 L_004f2284                            # 004f2250
    # block 0x004f2252: entered by fall-through of jge at 0x004f2250, 3 instruction(s), ends with je to 0x004f2284 (forward)
    movsx edx, word ptr [0x583a29]               # 004f2252
    cmp edx, -0x1                                # 004f2259
    je.d8 L_004f2284                             # 004f225c
    # block 0x004f225e: entered by fall-through of je at 0x004f225c, 8 instruction(s), ends with forward jump to 0x004f22ab
    mov dword ptr [0x5b44f8], 0x1                # 004f225e
    mov eax, dword ptr [ebp - local_4]           # 004f2268
    mov ecx, dword ptr [eax + field_6e]          # 004f226b
    imul ecx, ecx, 0x8d                          # 004f226e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f2274
    movsx eax, word ptr [edx]                    # 004f227a
    mov dword ptr [0x5b44f0], eax                # 004f227d
    jmp.d8 L_004f22ab                            # 004f2282
L_004f2284:
    # block 0x004f2284: entered by jle at 0x004f2236; jge at 0x004f2250; je at 0x004f225c, 3 instruction(s), ends with jne to 0x004f22ab (forward)
    movsx ecx, word ptr [0x583a29]               # 004f2284
    cmp ecx, -0x1                                # 004f228b
    jne.d8 L_004f22ab                            # 004f228e
    # block 0x004f2290: entered by fall-through of jne at 0x004f228e, 6 instruction(s), falls into the block at 0x004f22ab
    mov edx, dword ptr [ebp - local_4]           # 004f2290
    mov eax, dword ptr [edx + field_6e]          # 004f2293
    imul eax, eax, 0x8d                          # 004f2296
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f229c
    movsx edx, word ptr [ecx]                    # 004f22a2
    mov dword ptr [0x5b44f0], edx                # 004f22a5
L_004f22ab:
    # block 0x004f22ab: entered by jmp at 0x004f2282; jne at 0x004f228e, 1 instruction(s), ends with forward jump to 0x004f2305
    jmp.d8 L_004f2305                            # 004f22ab
L_004f22ad:
    # block 0x004f22ad: entered by switch case, 3 instruction(s), ends with jne to 0x004f22d5 (forward)
    movsx eax, word ptr [0x583a29]               # 004f22ad
    cmp eax, -0x1                                # 004f22b4
    jne.d8 L_004f22d5                            # 004f22b7
    # block 0x004f22b9: entered by fall-through of jne at 0x004f22b7, 6 instruction(s), falls into the block at 0x004f22d5
    mov ecx, dword ptr [ebp - local_4]           # 004f22b9
    mov edx, dword ptr [ecx + field_6e]          # 004f22bc
    imul edx, edx, 0x8d                          # 004f22bf
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f22c5
    movsx ecx, word ptr [eax + field_6]          # 004f22cb
    mov dword ptr [0x5b44f0], ecx                # 004f22cf
L_004f22d5:
    # block 0x004f22d5: entered by jne at 0x004f22b7, 1 instruction(s), ends with forward jump to 0x004f2305
    jmp.d8 L_004f2305                            # 004f22d5
L_004f22d7:
    # block 0x004f22d7: entered by switch case, 4 instruction(s), ends with forward jump to 0x004f2305
    mov edx, dword ptr [0x5d0377]                # 004f22d7
    mov dword ptr [0x5d162d], edx                # 004f22dd
    mov dword ptr [0x5b44f0], 0x2                # 004f22e3
    jmp.d8 L_004f2305                            # 004f22ed
L_004f22ef:
    # block 0x004f22ef: entered by ja at 0x004f1fdb; switch case, 3 instruction(s), ends with jne to 0x004f2305 (forward)
    movsx eax, word ptr [0x583a29]               # 004f22ef
    cmp eax, -0x1                                # 004f22f6
    jne.d8 L_004f2305                            # 004f22f9
    # block 0x004f22fb: entered by fall-through of jne at 0x004f22f9, 1 instruction(s), falls into the block at 0x004f2305
    mov dword ptr [0x5b44f0], 0x0                # 004f22fb
L_004f2305:
    # block 0x004f2305: entered by jmp at 0x004f202e; jmp at 0x004f20c0; jmp at 0x004f2156; jmp at 0x004f21ec; more, 4 instruction(s), ends with je to 0x004f2332 (forward)
    mov dword ptr [0x5b44f4], 0x1                # 004f2305
    movsx ecx, word ptr [0x583a29]               # 004f230f
    cmp ecx, -0x1                                # 004f2316
    je.d8 L_004f2332                             # 004f2319
    # block 0x004f231b: entered by fall-through of je at 0x004f2319, 2 instruction(s), ends with je to 0x004f2332 (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 004f231b
    je.d8 L_004f2332                             # 004f2322
    # block 0x004f2324: entered by fall-through of je at 0x004f2322, 3 instruction(s), ends with forward jump to 0x004f2363
    mov edx, dword ptr [0x5d0377]                # 004f2324
    mov dword ptr [0x5d162d], edx                # 004f232a
    jmp.d8 L_004f2363                            # 004f2330
L_004f2332:
    # block 0x004f2332: entered by je at 0x004f2319; je at 0x004f2322, 3 instruction(s), ends with je to 0x004f2363 (forward)
    movsx eax, word ptr [0x583a29]               # 004f2332
    cmp eax, -0x1                                # 004f2339
    je.d8 L_004f2363                             # 004f233c
    # block 0x004f233e: entered by fall-through of je at 0x004f233c, 2 instruction(s), ends with jne to 0x004f2363 (forward)
    cmp dword ptr [0x5b44f8], 0x0                # 004f233e
    jne.d8 L_004f2363                            # 004f2345
    # block 0x004f2347: entered by fall-through of jne at 0x004f2345, 5 instruction(s), falls into the block at 0x004f2363
    movsx ecx, word ptr [0x583a29]               # 004f2347
    add ecx, 0x25                                # 004f234e
    mov dword ptr [0x5b44f0], ecx                # 004f2351
    mov edx, dword ptr [0x571ad3]                # 004f2357
    mov dword ptr [0x5d162d], edx                # 004f235d
L_004f2363:
    # block 0x004f2363: entered by jmp at 0x004f2330; je at 0x004f233c; jne at 0x004f2345, 9 instruction(s), ends with forward jump to 0x004f2578
    mov eax, dword ptr [0x5b44f0]                # 004f2363
    shl eax, 0x5                                 # 004f2368
    mov ecx, dword ptr [0x5b44f4]                # 004f236b
    shl ecx, 0x4                                 # 004f2371
    lea edx, [eax + ecx + 0x5b160c]              # 004f2374
    mov dword ptr [0x5d1631], edx                # 004f237b
    mov dword ptr [0x5d1639], 0x1                # 004f2381
    mov eax, 0x1                                 # 004f238b
    jmp.d32 L_004f2578                           # 004f2390
L_004f2395:
    # block 0x004f2395: entered by je at 0x004f1efd; je at 0x004f1f10; je at 0x004f1f29; jl at 0x004f1f48; more, 4 instruction(s), ends with je to 0x004f23b7 (forward)
    movsx eax, word ptr [0x5b4e89]               # 004f2395
    mov ecx, dword ptr [ebp - local_4]           # 004f239c
    cmp dword ptr [ecx + field_6e], eax          # 004f239f
    je.d8 L_004f23b7                             # 004f23a2
    # block 0x004f23a4: entered by fall-through of je at 0x004f23a2, 4 instruction(s), ends with jne to 0x004f256a (forward)
    movsx edx, word ptr [0x5b5100]               # 004f23a4
    mov eax, dword ptr [ebp - local_4]           # 004f23ab
    cmp dword ptr [eax + field_6e], edx          # 004f23ae
    jne.d32 L_004f256a                           # 004f23b1
L_004f23b7:
    # block 0x004f23b7: entered by je at 0x004f23a2; fall-through of jne at 0x004f23b1, 5 instruction(s), ends with je to 0x004f256a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f23b7
    mov edx, dword ptr [ecx + field_6e]          # 004f23ba
    imul edx, edx, 0x8d                          # 004f23bd
    cmp dword ptr [edx + 0x5bb626], 0x0          # 004f23c3
    je.d32 L_004f256a                            # 004f23ca
    # block 0x004f23d0: entered by fall-through of je at 0x004f23ca, 7 instruction(s), ends with jl to 0x004f256a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f23d0
    mov ecx, dword ptr [eax + field_6e]          # 004f23d3
    imul ecx, ecx, 0x8d                          # 004f23d6
    movsx edx, word ptr [ecx + 0x5bb62c]         # 004f23dc
    mov eax, dword ptr [ebp - local_4]           # 004f23e3
    cmp dword ptr [eax + field_5a], edx          # 004f23e6
    jl.d32 L_004f256a                            # 004f23e9
    # block 0x004f23ef: entered by fall-through of jl at 0x004f23e9, 7 instruction(s), ends with jg to 0x004f256a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f23ef
    mov edx, dword ptr [ecx + field_6e]          # 004f23f2
    imul edx, edx, 0x8d                          # 004f23f5
    movsx eax, word ptr [edx + 0x5bb630]         # 004f23fb
    mov ecx, dword ptr [ebp - local_4]           # 004f2402
    cmp dword ptr [ecx + field_5a], eax          # 004f2405
    jg.d32 L_004f256a                            # 004f2408
    # block 0x004f240e: entered by fall-through of jg at 0x004f2408, 7 instruction(s), ends with jl to 0x004f256a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f240e
    mov eax, dword ptr [edx + field_6e]          # 004f2411
    imul eax, eax, 0x8d                          # 004f2414
    movsx ecx, word ptr [eax + 0x5bb62a]         # 004f241a
    mov edx, dword ptr [ebp - local_4]           # 004f2421
    cmp dword ptr [edx + field_5e], ecx          # 004f2424
    jl.d32 L_004f256a                            # 004f2427
    # block 0x004f242d: entered by fall-through of jl at 0x004f2427, 7 instruction(s), ends with jg to 0x004f256a (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f242d
    mov ecx, dword ptr [eax + field_6e]          # 004f2430
    imul ecx, ecx, 0x8d                          # 004f2433
    movsx edx, word ptr [ecx + 0x5bb62e]         # 004f2439
    mov eax, dword ptr [ebp - local_4]           # 004f2440
    cmp dword ptr [eax + field_5e], edx          # 004f2443
    jg.d32 L_004f256a                            # 004f2446
    # block 0x004f244c: entered by fall-through of jg at 0x004f2446, 18 instruction(s), ends with jne to 0x004f2502 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004f244c
    mov edx, dword ptr [ecx + field_6e]          # 004f244f
    mov dword ptr [0x5c39e5], edx                # 004f2452
    mov dword ptr [0x5b44f4], 0x1                # 004f2458
    mov dword ptr [0x5b44f0], 0x3                # 004f2462
    mov eax, dword ptr [0x5d0377]                # 004f246c
    mov dword ptr [0x5d162d], eax                # 004f2471
    mov ecx, dword ptr [0x5b44f0]                # 004f2476
    shl ecx, 0x5                                 # 004f247c
    mov edx, dword ptr [0x5b44f4]                # 004f247f
    shl edx, 0x4                                 # 004f2485
    lea eax, [ecx + edx + 0x5b160c]              # 004f2488
    mov dword ptr [0x5d1631], eax                # 004f248f
    mov dword ptr [0x5d1639], 0x1                # 004f2494
    movsx ecx, word ptr [0x5b4e89]               # 004f249e
    mov edx, dword ptr [ebp - local_4]           # 004f24a5
    cmp dword ptr [edx + field_6e], ecx          # 004f24a8
    jne.d8 L_004f2502                            # 004f24ab
    # block 0x004f24ad: entered by fall-through of jne at 0x004f24ab, 7 instruction(s), ends with jne to 0x004f2502 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004f24ad
    mov ecx, dword ptr [eax + field_6e]          # 004f24b0
    imul ecx, ecx, 0x8d                          # 004f24b3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004f24b9
    movsx eax, word ptr [edx + field_48]         # 004f24bf
    cmp eax, 0x1                                 # 004f24c3
    jne.d8 L_004f2502                            # 004f24c6
    # block 0x004f24c8: entered by fall-through of jne at 0x004f24c6, 4 instruction(s), ends with je to 0x004f24d9 (forward)
    mov ecx, dword ptr [0x5b4e14]                # 004f24c8
    mov dword ptr [ebp - local_c], ecx           # 004f24ce
    cmp dword ptr [ebp - local_c], 0x0           # 004f24d1
    je.d8 L_004f24d9                             # 004f24d5
    # block 0x004f24d7: entered by fall-through of je at 0x004f24d5, 1 instruction(s), ends with forward jump to 0x004f2500
    jmp.d8 L_004f2500                            # 004f24d7
L_004f24d9:
    # block 0x004f24d9: entered by je at 0x004f24d5, 7 instruction(s), falls into the block at 0x004f2500
    mov dword ptr [0x5b4e14], 0x1                # 004f24d9
    mov edx, dword ptr [ebp - local_4]           # 004f24e3
    mov eax, dword ptr [edx + field_6e]          # 004f24e6
    imul eax, eax, 0x8d                          # 004f24e9
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f24ef
    mov dx, word ptr [ecx + field_50]            # 004f24f5
    mov word ptr [0x5b4e00], dx                  # 004f24f9
L_004f2500:
    # block 0x004f2500: entered by jmp at 0x004f24d7, 1 instruction(s), ends with forward jump to 0x004f2563
    jmp.d8 L_004f2563                            # 004f2500
L_004f2502:
    # block 0x004f2502: entered by jne at 0x004f24ab; jne at 0x004f24c6, 4 instruction(s), ends with jne to 0x004f2563 (forward)
    movsx eax, word ptr [0x5b5100]               # 004f2502
    mov ecx, dword ptr [ebp - local_4]           # 004f2509
    cmp dword ptr [ecx + field_6e], eax          # 004f250c
    jne.d8 L_004f2563                            # 004f250f
    # block 0x004f2511: entered by fall-through of jne at 0x004f250f, 7 instruction(s), ends with jne to 0x004f2563 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004f2511
    mov eax, dword ptr [edx + field_6e]          # 004f2514
    imul eax, eax, 0x8d                          # 004f2517
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004f251d
    movsx edx, word ptr [ecx + field_48]         # 004f2523
    cmp edx, 0x1                                 # 004f2527
    jne.d8 L_004f2563                            # 004f252a
    # block 0x004f252c: entered by fall-through of jne at 0x004f252a, 4 instruction(s), ends with je to 0x004f253c (forward)
    mov eax, dword ptr [0x5b508b]                # 004f252c
    mov dword ptr [ebp - local_10], eax          # 004f2531
    cmp dword ptr [ebp - local_10], 0x0          # 004f2534
    je.d8 L_004f253c                             # 004f2538
    # block 0x004f253a: entered by fall-through of je at 0x004f2538, 1 instruction(s), ends with forward jump to 0x004f2563
    jmp.d8 L_004f2563                            # 004f253a
L_004f253c:
    # block 0x004f253c: entered by je at 0x004f2538, 7 instruction(s), falls into the block at 0x004f2563
    mov dword ptr [0x5b508b], 0x1                # 004f253c
    mov ecx, dword ptr [ebp - local_4]           # 004f2546
    mov edx, dword ptr [ecx + field_6e]          # 004f2549
    imul edx, edx, 0x8d                          # 004f254c
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004f2552
    mov cx, word ptr [eax + field_50]            # 004f2558
    mov word ptr [0x5b5077], cx                  # 004f255c
L_004f2563:
    # block 0x004f2563: entered by jmp at 0x004f2500; jne at 0x004f250f; jne at 0x004f252a; jmp at 0x004f253a, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f2563
    jmp.d8 L_004f2578                            # 004f2568
L_004f256a:
    # block 0x004f256a: entered by jne at 0x004f23b1; je at 0x004f23ca; jl at 0x004f23e9; jg at 0x004f2408; more, 1 instruction(s), ends with backward jump to 0x004f1ece
    jmp.d32 L_004f1ece                           # 004f256a
L_004f256f:
    # block 0x004f256f: entered by jge at 0x004f1eea, 2 instruction(s), ends with forward jump to 0x004f2578
    mov eax, 0x1                                 # 004f256f
    jmp.d8 L_004f2578                            # 004f2574
L_004f2576:
    # block 0x004f2576: entered by jg at 0x004f007b; jl at 0x004f008d; jg at 0x004f00ac; jl at 0x004f00be; more, 1 instruction(s), falls into the block at 0x004f2578
    {load} xor eax, eax                          # 004f2576
L_004f2578:
    # block 0x004f2578: entered by jmp at 0x004f03ce; jmp at 0x004f04b1; jmp at 0x004f059e; jmp at 0x004f087e; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004f2578
    pop ebp                                      # 004f257a
    ret                                          # 004f257b

# --- data items (not part of the function) -------------------------
.org 0x004f257c - 0x401000
SWTAB_004f257c:  # 9 case address(es)
    .long L_004f221e - .text + 0x401000
    .long L_004f2033 - .text + 0x401000
    .long L_004f1ff3 - .text + 0x401000
    .long L_004f22ad - .text + 0x401000
    .long L_004f21f1 - .text + 0x401000
    .long L_004f215b - .text + 0x401000
    .long L_004f20c5 - .text + 0x401000
    .long L_004f22d7 - .text + 0x401000
    .long L_004f22ef - .text + 0x401000
.org 0x004f25a0 - 0x401000
IDXTAB_004f25a0:  # index table of FUN_004f0059 for the switch jump at 0x004f1fec (112 byte(s))
    .byte 0, 1, 8, 2, 2, 2, 2, 2, 2, 2, 8, 8, 2, 2, 2, 8
    .byte 3, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
    .byte 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
    .byte 8, 8, 8, 8, 8, 8, 8, 4, 8, 8, 8, 8, 8, 8, 8, 8
    .byte 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
    .byte 8, 8, 8, 8, 8, 8, 8, 5, 6, 8, 8, 8, 8, 8, 8, 8
    .byte 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 7
.set SWTAB_004f257c_VA, SWTAB_004f257c - .text + 0x401000
.set IDXTAB_004f25a0_VA, IDXTAB_004f25a0 - .text + 0x401000

