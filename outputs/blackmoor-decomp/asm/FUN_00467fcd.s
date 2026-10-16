# FUN_00467fcd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467fcd
# extent:       0x00467fcd-0x00468adb (2830 code bytes)
# span:         0x00467fcd-0x00468aeb (code 2830, tables 16, padding 0)
# sha256:       f9707da080fc12c1f5b27323b5d7bc4fcc8e5aa148b8739785605d81f5343ea9
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00467fcd
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_8, field_c, field_10, field_12, field_16, field_1a, field_1e, field_122, field_126, field_1aa, field_1b2, field_242 and 3 more; [ecx + n] field_4, field_8, field_10, field_1aa, field_1ae, field_1b6, field_1be, field_241, field_242, field_244, field_246, field_24a and 12 more; [edi + n] field_12, field_16; [edx + n] field_8, field_c, field_10, field_12, field_16, field_21, field_25, field_29, field_2d, field_1aa, field_1ae, field_1b2 and 21 more; [esi + n] field_1a, field_1e
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_00467608
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 647 instruction(s), 32 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_122, 0x122  # offset +0x122
.equ field_126, 0x126  # offset +0x126
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1ae, 0x1ae  # offset +0x1ae
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1be, 0x1be  # offset +0x1be
.equ field_241, 0x241  # offset +0x241
.equ field_242, 0x242  # offset +0x242
.equ field_243, 0x243  # offset +0x243
.equ field_244, 0x244  # offset +0x244
.equ field_246, 0x246  # offset +0x246
.equ field_248, 0x248  # offset +0x248
.equ field_24a, 0x24a  # offset +0x24a
.equ field_250, 0x250  # offset +0x250
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_26c, 0x26c  # offset +0x26c
.equ field_2bc, 0x2bc  # offset +0x2bc
.equ field_393, 0x393  # offset +0x393
.equ field_395, 0x395  # offset +0x395
.equ field_397, 0x397  # offset +0x397
.equ field_399, 0x399  # offset +0x399
.equ field_39b, 0x39b  # offset +0x39b
.equ field_39f, 0x39f  # offset +0x39f
.equ field_3a3, 0x3a3  # offset +0x3a3
.equ field_3a7, 0x3a7  # offset +0x3a7
.equ field_3a9, 0x3a9  # offset +0x3a9
.equ field_3ab, 0x3ab  # offset +0x3ab
.equ field_3ac, 0x3ac  # offset +0x3ac
.equ field_3cf, 0x3cf  # offset +0x3cf
.equ field_3df, 0x3df  # offset +0x3df
.equ field_3e1, 0x3e1  # offset +0x3e1
.equ field_3e3, 0x3e3  # offset +0x3e3
.equ field_3e5, 0x3e5  # offset +0x3e5
.equ field_3e7, 0x3e7  # offset +0x3e7
.equ field_3eb, 0x3eb  # offset +0x3eb
.equ field_3ef, 0x3ef  # offset +0x3ef
.equ field_3f3, 0x3f3  # offset +0x3f3
.equ field_3f5, 0x3f5  # offset +0x3f5
.equ field_3f7, 0x3f7  # offset +0x3f7

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00467608, .text + (0x00467608 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x00467fcd - 0x401000
.globl FUN_00467fcd
FUN_00467fcd:
    # block 0x00467fcd: entry, 17 instruction(s), ends with je to 0x00468023 (forward)
    push ebp                                     # 00467fcd
    {load} mov ebp, esp                          # 00467fce
    sub esp, 0x14                                # 00467fd0
    push esi                                     # 00467fd3
    push edi                                     # 00467fd4
    mov dword ptr [ebp - local_c], ecx           # 00467fd5
    movsx eax, word ptr [ebp + arg_8]            # 00467fd8
    imul eax, eax, 0x8d                          # 00467fdc
    mov ecx, dword ptr [ebp - local_c]           # 00467fe2
    mov edx, dword ptr [eax + 0x5bb5e5]          # 00467fe5
    mov dword ptr [ecx + field_1aa], edx         # 00467feb
    movsx eax, word ptr [ebp + arg_8]            # 00467ff1
    imul eax, eax, 0x8d                          # 00467ff5
    mov ecx, dword ptr [eax + 0x5bb632]          # 00467ffb
    mov dword ptr [ebp - local_10], ecx          # 00468001
    cmp dword ptr [ebp - local_10], 0x0          # 00468004
    je.d8 L_00468023                             # 00468008
    # block 0x0046800a: entered by fall-through of je at 0x00468008, 2 instruction(s), ends with je to 0x00468611 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0046800a
    je.d32 L_00468611                            # 0046800e
    # block 0x00468014: entered by fall-through of je at 0x0046800e, 2 instruction(s), ends with je to 0x004687b2 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 00468014
    je.d32 L_004687b2                            # 00468018
    # block 0x0046801e: entered by fall-through of je at 0x00468018, 1 instruction(s), ends with forward jump to 0x00468ad3
    jmp.d32 L_00468ad3                           # 0046801e
L_00468023:
    # block 0x00468023: entered by je at 0x00468008, 64 instruction(s), calls FUN_004e8d96, FUN_004d39f9, ends with jne to 0x00468161 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00468023
    mov ax, word ptr [ebp + arg_8]               # 00468026
    mov word ptr [edx + field_8], ax             # 0046802a
    mov ecx, dword ptr [ebp - local_c]           # 0046802e
    mov dword ptr [ecx + field_1ae], 0x1         # 00468031
    mov edx, dword ptr [ebp - local_c]           # 0046803b
    mov dword ptr [edx + field_1b6], 0x0         # 0046803e
    mov eax, dword ptr [ebp - local_c]           # 00468048
    mov dword ptr [eax + field_1b2], 0x0         # 0046804b
    mov dword ptr [0x5bb1ca], 0x1                # 00468055
    mov ecx, 0x571442                            # 0046805f
    call FUN_004e8d96                            # 00468064
    call FUN_004d39f9                            # 00468069
    mov ecx, dword ptr [ebp - local_c]           # 0046806e
    mov word ptr [ecx + field_10], ax            # 00468071
    mov edx, dword ptr [ebp - local_c]           # 00468075
    movsx eax, word ptr [edx + field_10]         # 00468078
    imul eax, eax, 0x4a                          # 0046807c
    mov dword ptr [eax + 0x5d1591], 0xa          # 0046807f
    mov ecx, dword ptr [ebp - local_c]           # 00468089
    movsx edx, word ptr [ecx + field_10]         # 0046808c
    imul edx, edx, 0x4a                          # 00468090
    mov dword ptr [edx + 0x5d1595], 0x468aeb     # 00468093
    mov eax, dword ptr [ebp - local_c]           # 0046809d
    movsx ecx, word ptr [eax + field_10]         # 004680a0
    imul ecx, ecx, 0x4a                          # 004680a4
    mov dword ptr [ecx + 0x5d159d], 0x0          # 004680a7
    mov edx, dword ptr [ebp - local_c]           # 004680b1
    movsx eax, word ptr [edx + field_10]         # 004680b4
    imul eax, eax, 0x4a                          # 004680b8
    mov dword ptr [eax + 0x5d15a1], 0x0          # 004680bb
    mov ecx, dword ptr [ebp - local_c]           # 004680c5
    movsx edx, word ptr [ecx + field_10]         # 004680c8
    imul edx, edx, 0x4a                          # 004680cc
    mov dword ptr [edx + 0x5d15a5], 0x1          # 004680cf
    mov eax, dword ptr [ebp - local_c]           # 004680d9
    movsx ecx, word ptr [eax + field_10]         # 004680dc
    imul ecx, ecx, 0x4a                          # 004680e0
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 004680e3
    mov edx, dword ptr [ebp - local_c]           # 004680ed
    movsx eax, word ptr [edx + field_10]         # 004680f0
    imul eax, eax, 0x4a                          # 004680f4
    mov word ptr [eax + 0x5d15ad], 0x0           # 004680f7
    mov edi, 0x54b854                            # 00468100
    mov ecx, dword ptr [ebp - local_c]           # 00468105
    movsx edx, word ptr [ecx + field_10]         # 00468108
    imul edx, edx, 0x4a                          # 0046810c
    add edx, 0x5d15b3                            # 0046810f
    or ecx, -0x1                                 # 00468115
    {load} xor eax, eax                          # 00468118
    repne scasb al, byte ptr es:[edi]            # 0046811a
    not ecx                                      # 0046811c
    {load} sub edi, ecx                          # 0046811e
    {load} mov esi, edi                          # 00468120
    {load} mov eax, ecx                          # 00468122
    {load} mov edi, edx                          # 00468124
    shr ecx, 0x2                                 # 00468126
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00468129
    {load} mov ecx, eax                          # 0046812b
    and ecx, 0x3                                 # 0046812d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00468130
    mov ecx, dword ptr [ebp - local_c]           # 00468132
    cmp dword ptr [ecx + field_4], 0x0           # 00468135
    jne.d8 L_00468161                            # 00468139
    # block 0x0046813b: entered by fall-through of jne at 0x00468139, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x00468161
    push 0x54b868                                # 0046813b
    push 0x6                                     # 00468140
    mov edx, dword ptr [ebp - local_c]           # 00468142
    mov eax, dword ptr [edx + field_1aa]         # 00468145
    push eax                                     # 0046814b
    push 0x54b890                                # 0046814c
    mov ecx, 0x5cf659                            # 00468151
    call FUN_004c2790                            # 00468156
    mov ecx, dword ptr [ebp - local_c]           # 0046815b
    mov dword ptr [ecx + field_4], eax           # 0046815e
L_00468161:
    # block 0x00468161: entered by jne at 0x00468139, 8 instruction(s), ends with forward jump to 0x00468189
    mov edx, dword ptr [ebp - local_c]           # 00468161
    movsx eax, word ptr [edx + field_10]         # 00468164
    imul eax, eax, 0x4a                          # 00468168
    mov ecx, dword ptr [ebp - local_c]           # 0046816b
    mov edx, dword ptr [ecx + field_4]           # 0046816e
    mov dword ptr [eax + 0x5d1599], edx          # 00468171
    mov dword ptr [ebp - local_4], 0x0           # 00468177
    jmp.d8 L_00468189                            # 0046817e
L_00468180:
    # block 0x00468180: entered by jmp at 0x004682a5, 3 instruction(s), falls into the block at 0x00468189
    mov eax, dword ptr [ebp - local_4]           # 00468180
    add eax, 0x1                                 # 00468183
    mov dword ptr [ebp - local_4], eax           # 00468186
L_00468189:
    # block 0x00468189: entered by jmp at 0x0046817e, 2 instruction(s), ends with jge to 0x004682aa (forward)
    cmp dword ptr [ebp - local_4], 0x11          # 00468189
    jge.d32 L_004682aa                           # 0046818d
    # block 0x00468193: entered by fall-through of jge at 0x0046818d, 81 instruction(s), ends with backward jump to 0x00468180
    mov ecx, dword ptr [ebp - local_c]           # 00468193
    mov edx, dword ptr [ecx + field_1aa]         # 00468196
    mov eax, dword ptr [ebp - local_4]           # 0046819c
    shl eax, 0x4                                 # 0046819f
    mov ecx, dword ptr [edx + eax + field_21]    # 004681a2
    add ecx, dword ptr [0x583186]                # 004681a6
    mov edx, dword ptr [ebp - local_4]           # 004681ac
    shl edx, 0x4                                 # 004681af
    mov eax, dword ptr [ebp - local_c]           # 004681b2
    mov dword ptr [eax + edx + field_12], ecx    # 004681b5
    mov ecx, dword ptr [ebp - local_c]           # 004681b9
    mov edx, dword ptr [ecx + field_1aa]         # 004681bc
    mov eax, dword ptr [ebp - local_4]           # 004681c2
    shl eax, 0x4                                 # 004681c5
    mov ecx, dword ptr [edx + eax + field_29]    # 004681c8
    add ecx, dword ptr [0x583186]                # 004681cc
    mov edx, dword ptr [ebp - local_4]           # 004681d2
    shl edx, 0x4                                 # 004681d5
    mov eax, dword ptr [ebp - local_c]           # 004681d8
    mov dword ptr [eax + edx + field_1a], ecx    # 004681db
    mov ecx, dword ptr [ebp - local_c]           # 004681df
    mov edx, dword ptr [ecx + field_1aa]         # 004681e2
    mov eax, dword ptr [ebp - local_4]           # 004681e8
    shl eax, 0x4                                 # 004681eb
    mov ecx, dword ptr [edx + eax + field_25]    # 004681ee
    add ecx, dword ptr [0x58318a]                # 004681f2
    mov edx, dword ptr [ebp - local_4]           # 004681f8
    shl edx, 0x4                                 # 004681fb
    mov eax, dword ptr [ebp - local_c]           # 004681fe
    mov dword ptr [eax + edx + field_16], ecx    # 00468201
    mov ecx, dword ptr [ebp - local_c]           # 00468205
    mov edx, dword ptr [ecx + field_1aa]         # 00468208
    mov eax, dword ptr [ebp - local_4]           # 0046820e
    shl eax, 0x4                                 # 00468211
    mov ecx, dword ptr [edx + eax + field_2d]    # 00468214
    add ecx, dword ptr [0x58318a]                # 00468218
    mov edx, dword ptr [ebp - local_4]           # 0046821e
    shl edx, 0x4                                 # 00468221
    mov eax, dword ptr [ebp - local_c]           # 00468224
    mov dword ptr [eax + edx + field_1e], ecx    # 00468227
    mov ecx, dword ptr [ebp - local_4]           # 0046822b
    shl ecx, 0x4                                 # 0046822e
    mov edx, dword ptr [ebp - local_4]           # 00468231
    shl edx, 0x4                                 # 00468234
    mov eax, dword ptr [ebp - local_4]           # 00468237
    shl eax, 0x4                                 # 0046823a
    mov esi, dword ptr [ebp - local_c]           # 0046823d
    mov edi, dword ptr [ebp - local_c]           # 00468240
    mov edx, dword ptr [esi + edx + field_1a]    # 00468243
    sub edx, dword ptr [edi + eax + field_12]    # 00468247
    {load} mov eax, edx                          # 0046824b
    cdq                                          # 0046824d
    {load} sub eax, edx                          # 0046824e
    sar eax                                      # 00468250
    mov edx, dword ptr [ebp - local_c]           # 00468252
    mov ecx, dword ptr [edx + ecx + field_12]    # 00468255
    {load} add ecx, eax                          # 00468259
    mov edx, dword ptr [ebp - local_4]           # 0046825b
    mov eax, dword ptr [ebp - local_c]           # 0046825e
    mov dword ptr [eax + 8*edx + field_122], ecx # 00468261
    mov ecx, dword ptr [ebp - local_4]           # 00468268
    shl ecx, 0x4                                 # 0046826b
    mov edx, dword ptr [ebp - local_4]           # 0046826e
    shl edx, 0x4                                 # 00468271
    mov eax, dword ptr [ebp - local_4]           # 00468274
    shl eax, 0x4                                 # 00468277
    mov esi, dword ptr [ebp - local_c]           # 0046827a
    mov edi, dword ptr [ebp - local_c]           # 0046827d
    mov edx, dword ptr [esi + edx + field_1e]    # 00468280
    sub edx, dword ptr [edi + eax + field_16]    # 00468284
    {load} mov eax, edx                          # 00468288
    cdq                                          # 0046828a
    {load} sub eax, edx                          # 0046828b
    sar eax                                      # 0046828d
    mov edx, dword ptr [ebp - local_c]           # 0046828f
    mov ecx, dword ptr [edx + ecx + field_16]    # 00468292
    {load} add ecx, eax                          # 00468296
    mov edx, dword ptr [ebp - local_4]           # 00468298
    mov eax, dword ptr [ebp - local_c]           # 0046829b
    mov dword ptr [eax + 8*edx + field_126], ecx # 0046829e
    jmp.d32 L_00468180                           # 004682a5
L_004682aa:
    # block 0x004682aa: entered by jge at 0x0046818d, 8 instruction(s), ends with forward jump to 0x004682e0
    mov ecx, 0x11                                # 004682aa
    {load} xor eax, eax                          # 004682af
    mov edi, dword ptr [ebp - local_c]           # 004682b1
    add edi, 0x2bc                               # 004682b4
    rep stosd dword ptr es:[edi], eax            # 004682ba
    mov ecx, dword ptr [ebp - local_c]           # 004682bc
    mov dword ptr [ecx + field_26c], 0x0         # 004682bf
    jmp.d8 L_004682e0                            # 004682c9
L_004682cb:
    # block 0x004682cb: entered by jmp at 0x0046833a, 5 instruction(s), falls into the block at 0x004682e0
    mov edx, dword ptr [ebp - local_c]           # 004682cb
    mov eax, dword ptr [edx + field_26c]         # 004682ce
    add eax, 0x1                                 # 004682d4
    mov ecx, dword ptr [ebp - local_c]           # 004682d7
    mov dword ptr [ecx + field_26c], eax         # 004682da
L_004682e0:
    # block 0x004682e0: entered by jmp at 0x004682c9, 3 instruction(s), ends with jge to 0x0046833c (forward)
    mov edx, dword ptr [ebp - local_c]           # 004682e0
    cmp dword ptr [edx + field_26c], 0xb         # 004682e3
    jge.d8 L_0046833c                            # 004682ea
    # block 0x004682ec: entered by fall-through of jge at 0x004682ea, 15 instruction(s), ends with backward jump to 0x004682cb
    mov eax, dword ptr [ebp - local_c]           # 004682ec
    mov ecx, dword ptr [eax + field_1aa]         # 004682ef
    mov edx, dword ptr [ebp - local_c]           # 004682f5
    mov eax, dword ptr [edx + field_26c]         # 004682f8
    mov ecx, dword ptr [ecx + 8*eax + field_246] # 004682fe
    mov edx, dword ptr [ebp - local_c]           # 00468305
    mov dword ptr [edx + 4*ecx + field_2bc], 0x1 # 00468308
    mov eax, dword ptr [ebp - local_c]           # 00468313
    mov ecx, dword ptr [eax + field_1aa]         # 00468316
    mov edx, dword ptr [ebp - local_c]           # 0046831c
    mov eax, dword ptr [edx + field_26c]         # 0046831f
    mov ecx, dword ptr [ecx + 8*eax + field_24a] # 00468325
    mov edx, dword ptr [ebp - local_c]           # 0046832c
    mov dword ptr [edx + 4*ecx + field_2bc], 0x1 # 0046832f
    jmp.d8 L_004682cb                            # 0046833a
L_0046833c:
    # block 0x0046833c: entered by jge at 0x004682ea, 8 instruction(s), ends with je to 0x00468382 (forward)
    mov edi, 0x54b898                            # 0046833c
    mov eax, dword ptr [ebp - local_c]           # 00468341
    mov esi, dword ptr [eax + field_1aa]         # 00468344
    add esi, 0x29e                               # 0046834a
    mov ecx, 0x9                                 # 00468350
    {load} xor edx, edx                          # 00468355
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00468357
    je.d8 L_00468382                             # 00468359
    # block 0x0046835b: entered by fall-through of je at 0x00468359, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x00468382
    mov eax, dword ptr [ebp - local_c]           # 0046835b
    mov ecx, dword ptr [eax + field_1aa]         # 0046835e
    add ecx, 0x29e                               # 00468364
    push ecx                                     # 0046836a
    mov ecx, 0x5c3a67                            # 0046836b
    call FUN_004fb77a                            # 00468370
    mov edx, dword ptr [ebp - local_c]           # 00468375
    mov dword ptr [edx + field_248], 0x1         # 00468378
L_00468382:
    # block 0x00468382: entered by je at 0x00468359, 8 instruction(s), ends with je to 0x004683c8 (forward)
    mov edi, 0x54b8a4                            # 00468382
    mov eax, dword ptr [ebp - local_c]           # 00468387
    mov esi, dword ptr [eax + field_1aa]         # 0046838a
    add esi, 0x2cf                               # 00468390
    mov ecx, 0x9                                 # 00468396
    {load} xor edx, edx                          # 0046839b
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046839d
    je.d8 L_004683c8                             # 0046839f
    # block 0x004683a1: entered by fall-through of je at 0x0046839f, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x004683c8
    mov eax, dword ptr [ebp - local_c]           # 004683a1
    mov ecx, dword ptr [eax + field_1aa]         # 004683a4
    add ecx, 0x2cf                               # 004683aa
    push ecx                                     # 004683b0
    mov ecx, 0x5c3a67                            # 004683b1
    call FUN_004fb77a                            # 004683b6
    mov edx, dword ptr [ebp - local_c]           # 004683bb
    mov dword ptr [edx + field_250], 0x1         # 004683be
L_004683c8:
    # block 0x004683c8: entered by je at 0x0046839f, 8 instruction(s), ends with je to 0x0046840e (forward)
    mov edi, 0x54b8b0                            # 004683c8
    mov eax, dword ptr [ebp - local_c]           # 004683cd
    mov esi, dword ptr [eax + field_1aa]         # 004683d0
    add esi, 0x300                               # 004683d6
    mov ecx, 0x9                                 # 004683dc
    {load} xor edx, edx                          # 004683e1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004683e3
    je.d8 L_0046840e                             # 004683e5
    # block 0x004683e7: entered by fall-through of je at 0x004683e5, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046840e
    mov eax, dword ptr [ebp - local_c]           # 004683e7
    mov ecx, dword ptr [eax + field_1aa]         # 004683ea
    add ecx, 0x300                               # 004683f0
    push ecx                                     # 004683f6
    mov ecx, 0x5c3a67                            # 004683f7
    call FUN_004fb77a                            # 004683fc
    mov edx, dword ptr [ebp - local_c]           # 00468401
    mov dword ptr [edx + field_258], 0x1         # 00468404
L_0046840e:
    # block 0x0046840e: entered by je at 0x004683e5, 8 instruction(s), ends with je to 0x00468454 (forward)
    mov edi, 0x54b8bc                            # 0046840e
    mov eax, dword ptr [ebp - local_c]           # 00468413
    mov esi, dword ptr [eax + field_1aa]         # 00468416
    add esi, 0x331                               # 0046841c
    mov ecx, 0x9                                 # 00468422
    {load} xor edx, edx                          # 00468427
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00468429
    je.d8 L_00468454                             # 0046842b
    # block 0x0046842d: entered by fall-through of je at 0x0046842b, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x00468454
    mov eax, dword ptr [ebp - local_c]           # 0046842d
    mov ecx, dword ptr [eax + field_1aa]         # 00468430
    add ecx, 0x331                               # 00468436
    push ecx                                     # 0046843c
    mov ecx, 0x5c3a67                            # 0046843d
    call FUN_004fb77a                            # 00468442
    mov edx, dword ptr [ebp - local_c]           # 00468447
    mov dword ptr [edx + field_25c], 0x1         # 0046844a
L_00468454:
    # block 0x00468454: entered by je at 0x0046842b, 8 instruction(s), ends with je to 0x0046849a (forward)
    mov edi, 0x54b8c8                            # 00468454
    mov eax, dword ptr [ebp - local_c]           # 00468459
    mov esi, dword ptr [eax + field_1aa]         # 0046845c
    add esi, 0x362                               # 00468462
    mov ecx, 0x9                                 # 00468468
    {load} xor edx, edx                          # 0046846d
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046846f
    je.d8 L_0046849a                             # 00468471
    # block 0x00468473: entered by fall-through of je at 0x00468471, 8 instruction(s), calls FUN_004fb77a, falls into the block at 0x0046849a
    mov eax, dword ptr [ebp - local_c]           # 00468473
    mov ecx, dword ptr [eax + field_1aa]         # 00468476
    add ecx, 0x362                               # 0046847c
    push ecx                                     # 00468482
    mov ecx, 0x5c3a67                            # 00468483
    call FUN_004fb77a                            # 00468488
    mov edx, dword ptr [ebp - local_c]           # 0046848d
    mov dword ptr [edx + field_260], 0x1         # 00468490
L_0046849a:
    # block 0x0046849a: entered by je at 0x00468471, 25 instruction(s), ends with je to 0x00468532 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0046849a
    mov ecx, dword ptr [eax + field_1aa]         # 0046849d
    mov dl, byte ptr [ecx + field_241]           # 004684a3
    and dl, byte ptr [0x5d2f1f]                  # 004684a9
    mov eax, dword ptr [ebp - local_c]           # 004684af
    mov ecx, dword ptr [eax + field_1aa]         # 004684b2
    mov byte ptr [ecx + field_241], dl           # 004684b8
    mov edx, dword ptr [ebp - local_c]           # 004684be
    mov eax, dword ptr [edx + field_1aa]         # 004684c1
    mov cl, byte ptr [eax + field_242]           # 004684c7
    and cl, byte ptr [0x5d2f1e]                  # 004684cd
    mov edx, dword ptr [ebp - local_c]           # 004684d3
    mov eax, dword ptr [edx + field_1aa]         # 004684d6
    mov byte ptr [eax + field_242], cl           # 004684dc
    mov ecx, dword ptr [ebp - local_c]           # 004684e2
    mov edx, dword ptr [ecx + field_1aa]         # 004684e5
    mov al, byte ptr [edx + field_243]           # 004684eb
    and al, byte ptr [0x5d2f1d]                  # 004684f1
    mov ecx, dword ptr [ebp - local_c]           # 004684f7
    mov edx, dword ptr [ecx + field_1aa]         # 004684fa
    mov byte ptr [edx + field_243], al           # 00468500
    {load} xor eax, eax                          # 00468506
    mov al, byte ptr [0x5d2f23]                  # 00468508
    cmp eax, 0x5                                 # 0046850d
    je.d8 L_00468532                             # 00468510
    # block 0x00468512: entered by fall-through of je at 0x00468510, 7 instruction(s), falls into the block at 0x00468532
    mov ecx, dword ptr [ebp - local_c]           # 00468512
    mov edx, dword ptr [ecx + field_1aa]         # 00468515
    mov al, byte ptr [edx + field_241]           # 0046851b
    shl al                                       # 00468521
    mov ecx, dword ptr [ebp - local_c]           # 00468523
    mov edx, dword ptr [ecx + field_1aa]         # 00468526
    mov byte ptr [edx + field_241], al           # 0046852c
L_00468532:
    # block 0x00468532: entered by je at 0x00468510, 4 instruction(s), ends with je to 0x0046855e (forward)
    {load} xor eax, eax                          # 00468532
    mov al, byte ptr [0x5d2f22]                  # 00468534
    cmp eax, 0x5                                 # 00468539
    je.d8 L_0046855e                             # 0046853c
    # block 0x0046853e: entered by fall-through of je at 0x0046853c, 7 instruction(s), falls into the block at 0x0046855e
    mov ecx, dword ptr [ebp - local_c]           # 0046853e
    mov edx, dword ptr [ecx + field_1aa]         # 00468541
    mov al, byte ptr [edx + field_242]           # 00468547
    shl al                                       # 0046854d
    mov ecx, dword ptr [ebp - local_c]           # 0046854f
    mov edx, dword ptr [ecx + field_1aa]         # 00468552
    mov byte ptr [edx + field_242], al           # 00468558
L_0046855e:
    # block 0x0046855e: entered by je at 0x0046853c, 4 instruction(s), ends with je to 0x0046858a (forward)
    {load} xor eax, eax                          # 0046855e
    mov al, byte ptr [0x5d2f21]                  # 00468560
    cmp eax, 0x5                                 # 00468565
    je.d8 L_0046858a                             # 00468568
    # block 0x0046856a: entered by fall-through of je at 0x00468568, 7 instruction(s), falls into the block at 0x0046858a
    mov ecx, dword ptr [ebp - local_c]           # 0046856a
    mov edx, dword ptr [ecx + field_1aa]         # 0046856d
    mov al, byte ptr [edx + field_243]           # 00468573
    shl al                                       # 00468579
    mov ecx, dword ptr [ebp - local_c]           # 0046857b
    mov edx, dword ptr [ecx + field_1aa]         # 0046857e
    mov byte ptr [edx + field_243], al           # 00468584
L_0046858a:
    # block 0x0046858a: entered by je at 0x00468568, 33 instruction(s), ends with forward jump to 0x00468ad3
    mov eax, dword ptr [ebp - local_c]           # 0046858a
    mov ecx, dword ptr [eax + field_1aa]         # 0046858d
    {load} xor edx, edx                          # 00468593
    mov dl, byte ptr [ecx + field_241]           # 00468595
    {load} xor ecx, ecx                          # 0046859b
    mov cl, byte ptr [0x5d2f1b]                  # 0046859d
    shl edx, cl                                  # 004685a3
    mov eax, dword ptr [ebp - local_c]           # 004685a5
    mov ecx, dword ptr [eax + field_1aa]         # 004685a8
    {load} xor eax, eax                          # 004685ae
    mov al, byte ptr [ecx + field_242]           # 004685b0
    {load} xor ecx, ecx                          # 004685b6
    mov cl, byte ptr [0x5d2f1a]                  # 004685b8
    shl eax, cl                                  # 004685be
    {load} or edx, eax                           # 004685c0
    mov ecx, dword ptr [ebp - local_c]           # 004685c2
    mov eax, dword ptr [ecx + field_1aa]         # 004685c5
    {load} xor ecx, ecx                          # 004685cb
    mov cl, byte ptr [eax + field_243]           # 004685cd
    {load} mov eax, ecx                          # 004685d3
    {load} xor ecx, ecx                          # 004685d5
    mov cl, byte ptr [0x5d2f19]                  # 004685d7
    shl eax, cl                                  # 004685dd
    {load} or edx, eax                           # 004685df
    mov ecx, dword ptr [ebp - local_c]           # 004685e1
    mov word ptr [ecx + field_1be], dx           # 004685e4
    mov edx, dword ptr [ebp - local_c]           # 004685eb
    mov dword ptr [edx + field_c], 0x0           # 004685ee
    mov eax, dword ptr [ebp - local_c]           # 004685f5
    movsx ecx, word ptr [eax + field_8]          # 004685f8
    imul ecx, ecx, 0x8d                          # 004685fc
    mov dword ptr [ecx + 0x5bb632], 0x1          # 00468602
    jmp.d32 L_00468ad3                           # 0046860c
L_00468611:
    # block 0x00468611: entered by je at 0x0046800e, 5 instruction(s), ends with ja to 0x004687ad (forward)
    mov edx, dword ptr [ebp - local_c]           # 00468611
    mov eax, dword ptr [edx + field_c]           # 00468614
    mov dword ptr [ebp - local_14], eax          # 00468617
    cmp dword ptr [ebp - local_14], 0x3          # 0046861a
    ja.d32 L_004687ad                            # 0046861e
    # block 0x00468624: entered by fall-through of ja at 0x0046861e, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x468adb]
    mov ecx, dword ptr [ebp - local_14]          # 00468624
    jmp dword ptr [4*ecx + SWTAB_00468adb_VA]    # 00468627
L_0046862e:
    # block 0x0046862e: entered by switch case, 3 instruction(s), ends with je to 0x00468649 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046862e
    cmp dword ptr [edx + field_1b6], 0x0         # 00468631
    je.d8 L_00468649                             # 00468638
    # block 0x0046863a: entered by fall-through of je at 0x00468638, 3 instruction(s), ends with forward jump to 0x004687ad
    mov eax, dword ptr [ebp - local_c]           # 0046863a
    mov dword ptr [eax + field_c], 0x1           # 0046863d
    jmp.d32 L_004687ad                           # 00468644
L_00468649:
    # block 0x00468649: entered by je at 0x00468638, 1 instruction(s), ends with forward jump to 0x004687ad
    jmp.d32 L_004687ad                           # 00468649
L_0046864e:
    # block 0x0046864e: entered by switch case, 3 instruction(s), ends with je to 0x00468697 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0046864e
    cmp dword ptr [ecx + field_1b6], 0x0         # 00468651
    je.d8 L_00468697                             # 00468658
    # block 0x0046865a: entered by fall-through of je at 0x00468658, 5 instruction(s), ends with je to 0x00468697 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046865a
    mov eax, dword ptr [edx + field_1aa]         # 0046865d
    movsx ecx, word ptr [eax + field_3a9]        # 00468663
    cmp ecx, -0x1                                # 0046866a
    je.d8 L_00468697                             # 0046866d
    # block 0x0046866f: entered by fall-through of je at 0x0046866d, 8 instruction(s), falls into the block at 0x00468697
    mov edx, dword ptr [ebp - local_c]           # 0046866f
    mov eax, dword ptr [edx + field_1aa]         # 00468672
    {load} xor ecx, ecx                          # 00468678
    mov cl, byte ptr [eax + field_3ab]           # 0046867a
    mov edx, dword ptr [ebp - local_c]           # 00468680
    mov eax, dword ptr [edx + field_1aa]         # 00468683
    movsx edx, word ptr [eax + field_3a9]        # 00468689
    mov dword ptr [4*edx + 0x585801], ecx        # 00468690
L_00468697:
    # block 0x00468697: entered by je at 0x00468658; je at 0x0046866d, 11 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x004687ad
    call dword ptr [0x52a23c]                    # 00468697
    mov ecx, dword ptr [ebp - local_c]           # 0046869d
    mov edx, dword ptr [ecx + field_1aa]         # 004686a0
    movsx ecx, word ptr [edx + field_3ac]        # 004686a6
    imul ecx, ecx, 0x3e8                         # 004686ad
    {load} add eax, ecx                          # 004686b3
    mov edx, dword ptr [ebp - local_c]           # 004686b5
    mov dword ptr [edx + field_244], eax         # 004686b8
    mov eax, dword ptr [ebp - local_c]           # 004686be
    mov dword ptr [eax + field_c], 0x2           # 004686c1
    jmp.d32 L_004687ad                           # 004686c8
L_004686cd:
    # block 0x004686cd: entered by switch case, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x00468755 (forward)
    call dword ptr [0x52a23c]                    # 004686cd
    mov ecx, dword ptr [ebp - local_c]           # 004686d3
    cmp eax, dword ptr [ecx + field_244]         # 004686d6
    jb.d8 L_00468755                             # 004686dc
    # block 0x004686de: entered by fall-through of jb at 0x004686dc, 8 instruction(s), ends with je to 0x0046873e (forward)
    mov edi, 0x54b8d4                            # 004686de
    mov edx, dword ptr [ebp - local_c]           # 004686e3
    mov esi, dword ptr [edx + field_1aa]         # 004686e6
    add esi, 0x3ae                               # 004686ec
    mov ecx, 0x9                                 # 004686f2
    {load} xor eax, eax                          # 004686f7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004686f9
    je.d8 L_0046873e                             # 004686fb
    # block 0x004686fd: entered by fall-through of je at 0x004686fb, 15 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00468755
    mov ecx, dword ptr [ebp - local_c]           # 004686fd
    mov edx, dword ptr [ecx + field_1aa]         # 00468700
    add edx, 0x3ae                               # 00468706
    push edx                                     # 0046870c
    mov ecx, 0x5c3a67                            # 0046870d
    call FUN_004fb77a                            # 00468712
    mov eax, dword ptr [ebp - local_c]           # 00468717
    mov ecx, dword ptr [eax + field_1aa]         # 0046871a
    mov dx, word ptr [ecx + field_3cf]           # 00468720
    push edx                                     # 00468727
    mov ecx, 0x5c3a67                            # 00468728
    call FUN_004fb2e3                            # 0046872d
    mov eax, dword ptr [ebp - local_c]           # 00468732
    mov dword ptr [eax + field_c], 0x3           # 00468735
    jmp.d8 L_00468755                            # 0046873c
L_0046873e:
    # block 0x0046873e: entered by je at 0x004686fb, 4 instruction(s), falls into the block at 0x00468755
    mov ecx, dword ptr [ebp - local_c]           # 0046873e
    movsx edx, word ptr [ecx + field_8]          # 00468741
    imul edx, edx, 0x8d                          # 00468745
    mov dword ptr [edx + 0x5bb632], 0x2          # 0046874b
L_00468755:
    # block 0x00468755: entered by jb at 0x004686dc; jmp at 0x0046873c, 1 instruction(s), ends with forward jump to 0x004687ad
    jmp.d8 L_004687ad                            # 00468755
L_00468757:
    # block 0x00468757: entered by switch case, 10 instruction(s), calls FUN_004f6334, ends with jne to 0x004687ad (forward)
    mov eax, dword ptr [ebp - local_c]           # 00468757
    mov ecx, dword ptr [eax + field_1aa]         # 0046875a
    movsx edx, word ptr [ecx + field_3cf]        # 00468760
    mov dword ptr [ebp - local_8], edx           # 00468767
    mov eax, dword ptr [ebp - local_8]           # 0046876a
    push eax                                     # 0046876d
    mov ecx, 0x5cf1eb                            # 0046876e
    call FUN_004f6334                            # 00468773
    test eax, eax                                # 00468778
    jne.d8 L_004687ad                            # 0046877a
    # block 0x0046877c: entered by fall-through of jne at 0x0046877a, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x004687ad
    mov ecx, dword ptr [ebp - local_c]           # 0046877c
    mov edx, dword ptr [ecx + field_1aa]         # 0046877f
    add edx, 0x3ae                               # 00468785
    push edx                                     # 0046878b
    mov ecx, 0x5c3a67                            # 0046878c
    call FUN_004fba69                            # 00468791
    mov eax, dword ptr [ebp - local_c]           # 00468796
    movsx ecx, word ptr [eax + field_8]          # 00468799
    imul ecx, ecx, 0x8d                          # 0046879d
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004687a3
L_004687ad:
    # block 0x004687ad: entered by ja at 0x0046861e; jmp at 0x00468644; jmp at 0x00468649; jmp at 0x004686c8; more, 1 instruction(s), ends with forward jump to 0x00468ad3
    jmp.d32 L_00468ad3                           # 004687ad
L_004687b2:
    # block 0x004687b2: entered by je at 0x00468018, 10 instruction(s), ends with je to 0x00468803 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004687b2
    mov edx, dword ptr [ebp - local_c]           # 004687bc
    mov dword ptr [edx + field_1ae], 0x0         # 004687bf
    mov eax, dword ptr [ebp - local_c]           # 004687c9
    movsx ecx, word ptr [eax + field_10]         # 004687cc
    imul ecx, ecx, 0x4a                          # 004687d0
    mov dword ptr [ecx + 0x5d15a5], 0x0          # 004687d3
    mov edx, dword ptr [ebp - local_c]           # 004687dd
    cmp dword ptr [edx + field_248], 0x0         # 004687e0
    je.d8 L_00468803                             # 004687e7
    # block 0x004687e9: entered by fall-through of je at 0x004687e7, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00468803
    mov eax, dword ptr [ebp - local_c]           # 004687e9
    mov ecx, dword ptr [eax + field_1aa]         # 004687ec
    add ecx, 0x29e                               # 004687f2
    push ecx                                     # 004687f8
    mov ecx, 0x5c3a67                            # 004687f9
    call FUN_004fba69                            # 004687fe
L_00468803:
    # block 0x00468803: entered by je at 0x004687e7, 3 instruction(s), ends with je to 0x00468829 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00468803
    cmp dword ptr [edx + field_250], 0x0         # 00468806
    je.d8 L_00468829                             # 0046880d
    # block 0x0046880f: entered by fall-through of je at 0x0046880d, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00468829
    mov eax, dword ptr [ebp - local_c]           # 0046880f
    mov ecx, dword ptr [eax + field_1aa]         # 00468812
    add ecx, 0x2cf                               # 00468818
    push ecx                                     # 0046881e
    mov ecx, 0x5c3a67                            # 0046881f
    call FUN_004fba69                            # 00468824
L_00468829:
    # block 0x00468829: entered by je at 0x0046880d, 3 instruction(s), ends with je to 0x0046884f (forward)
    mov edx, dword ptr [ebp - local_c]           # 00468829
    cmp dword ptr [edx + field_258], 0x0         # 0046882c
    je.d8 L_0046884f                             # 00468833
    # block 0x00468835: entered by fall-through of je at 0x00468833, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x0046884f
    mov eax, dword ptr [ebp - local_c]           # 00468835
    mov ecx, dword ptr [eax + field_1aa]         # 00468838
    add ecx, 0x300                               # 0046883e
    push ecx                                     # 00468844
    mov ecx, 0x5c3a67                            # 00468845
    call FUN_004fba69                            # 0046884a
L_0046884f:
    # block 0x0046884f: entered by je at 0x00468833, 3 instruction(s), ends with je to 0x00468875 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046884f
    cmp dword ptr [edx + field_25c], 0x0         # 00468852
    je.d8 L_00468875                             # 00468859
    # block 0x0046885b: entered by fall-through of je at 0x00468859, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x00468875
    mov eax, dword ptr [ebp - local_c]           # 0046885b
    mov ecx, dword ptr [eax + field_1aa]         # 0046885e
    add ecx, 0x331                               # 00468864
    push ecx                                     # 0046886a
    mov ecx, 0x5c3a67                            # 0046886b
    call FUN_004fba69                            # 00468870
L_00468875:
    # block 0x00468875: entered by je at 0x00468859, 3 instruction(s), ends with je to 0x0046889b (forward)
    mov edx, dword ptr [ebp - local_c]           # 00468875
    cmp dword ptr [edx + field_260], 0x0         # 00468878
    je.d8 L_0046889b                             # 0046887f
    # block 0x00468881: entered by fall-through of je at 0x0046887f, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x0046889b
    mov eax, dword ptr [ebp - local_c]           # 00468881
    mov ecx, dword ptr [eax + field_1aa]         # 00468884
    add ecx, 0x362                               # 0046888a
    push ecx                                     # 00468890
    mov ecx, 0x5c3a67                            # 00468891
    call FUN_004fba69                            # 00468896
L_0046889b:
    # block 0x0046889b: entered by je at 0x0046887f, 3 instruction(s), ends with je to 0x004689d8 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0046889b
    cmp dword ptr [edx + field_1b2], 0x0         # 0046889e
    je.d32 L_004689d8                            # 004688a5
    # block 0x004688ab: entered by fall-through of je at 0x004688a5, 5 instruction(s), ends with je to 0x00468996 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004688ab
    mov ecx, dword ptr [eax + field_1aa]         # 004688ae
    movsx edx, word ptr [ecx + field_3df]        # 004688b4
    cmp edx, 0x270f                              # 004688bb
    je.d32 L_00468996                            # 004688c1
    # block 0x004688c7: entered by fall-through of je at 0x004688c1, 33 instruction(s), ends with jne to 0x00468982 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004688c7
    mov ecx, dword ptr [eax + field_1aa]         # 004688ca
    movsx edx, word ptr [ecx + field_3df]        # 004688d0
    mov dword ptr [0x5bb57b], edx                # 004688d7
    mov eax, dword ptr [ebp - local_c]           # 004688dd
    mov ecx, dword ptr [eax + field_1aa]         # 004688e0
    mov dx, word ptr [ecx + field_3e1]           # 004688e6
    mov word ptr [0x5bb599], dx                  # 004688ed
    mov eax, dword ptr [ebp - local_c]           # 004688f4
    mov ecx, dword ptr [eax + field_1aa]         # 004688f7
    mov dx, word ptr [ecx + field_3e3]           # 004688fd
    mov word ptr [0x5bb595], dx                  # 00468904
    mov eax, dword ptr [ebp - local_c]           # 0046890b
    mov ecx, dword ptr [eax + field_1aa]         # 0046890e
    mov dx, word ptr [ecx + field_3e5]           # 00468914
    mov word ptr [0x5c39ff], dx                  # 0046891b
    mov eax, dword ptr [ebp - local_c]           # 00468922
    mov ecx, dword ptr [eax + field_1aa]         # 00468925
    mov edx, dword ptr [ecx + field_3e7]         # 0046892b
    mov dword ptr [0x5bb59b], edx                # 00468931
    mov eax, dword ptr [ebp - local_c]           # 00468937
    mov ecx, dword ptr [eax + field_1aa]         # 0046893a
    mov edx, dword ptr [ecx + field_3eb]         # 00468940
    mov dword ptr [0x5bb59f], edx                # 00468946
    mov eax, dword ptr [ebp - local_c]           # 0046894c
    mov ecx, dword ptr [eax + field_1aa]         # 0046894f
    mov edx, dword ptr [ecx + field_3ef]         # 00468955
    mov dword ptr [0x5bb5a3], edx                # 0046895b
    mov eax, dword ptr [ebp - local_c]           # 00468961
    mov ecx, dword ptr [eax + field_1aa]         # 00468964
    movsx edx, word ptr [ecx + field_3f3]        # 0046896a
    cmp edx, 0x1                                 # 00468971
    jne.d8 L_00468982                            # 00468974
    # block 0x00468976: entered by fall-through of jne at 0x00468974, 2 instruction(s), ends with forward jump to 0x0046898c
    mov dword ptr [0x5bb1ca], 0x0                # 00468976
    jmp.d8 L_0046898c                            # 00468980
L_00468982:
    # block 0x00468982: entered by jne at 0x00468974, 1 instruction(s), falls into the block at 0x0046898c
    mov dword ptr [0x5bb1ca], 0x1                # 00468982
L_0046898c:
    # block 0x0046898c: entered by jmp at 0x00468980, 1 instruction(s), falls into the block at 0x00468996
    mov dword ptr [0x583999], 0x4                # 0046898c
L_00468996:
    # block 0x00468996: entered by je at 0x004688c1, 5 instruction(s), ends with je to 0x004689d3 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00468996
    mov ecx, dword ptr [eax + field_1aa]         # 00468999
    movsx edx, word ptr [ecx + field_3f5]        # 0046899f
    cmp edx, -0x1                                # 004689a6
    je.d8 L_004689d3                             # 004689a9
    # block 0x004689ab: entered by fall-through of je at 0x004689a9, 8 instruction(s), falls into the block at 0x004689d3
    mov eax, dword ptr [ebp - local_c]           # 004689ab
    mov ecx, dword ptr [eax + field_1aa]         # 004689ae
    {load} xor edx, edx                          # 004689b4
    mov dl, byte ptr [ecx + field_3f7]           # 004689b6
    mov eax, dword ptr [ebp - local_c]           # 004689bc
    mov ecx, dword ptr [eax + field_1aa]         # 004689bf
    movsx eax, word ptr [ecx + field_3f5]        # 004689c5
    mov dword ptr [4*eax + 0x585801], edx        # 004689cc
L_004689d3:
    # block 0x004689d3: entered by je at 0x004689a9, 1 instruction(s), ends with forward jump to 0x00468abb
    jmp.d32 L_00468abb                           # 004689d3
L_004689d8:
    # block 0x004689d8: entered by je at 0x004688a5, 5 instruction(s), ends with je to 0x00468abb (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004689d8
    mov edx, dword ptr [ecx + field_1aa]         # 004689db
    movsx eax, word ptr [edx + field_393]        # 004689e1
    cmp eax, 0x270f                              # 004689e8
    je.d32 L_00468abb                            # 004689ed
    # block 0x004689f3: entered by fall-through of je at 0x004689ed, 33 instruction(s), ends with jne to 0x00468aa7 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004689f3
    mov edx, dword ptr [ecx + field_1aa]         # 004689f6
    movsx eax, word ptr [edx + field_393]        # 004689fc
    mov dword ptr [0x5bb57b], eax                # 00468a03
    mov ecx, dword ptr [ebp - local_c]           # 00468a08
    mov edx, dword ptr [ecx + field_1aa]         # 00468a0b
    mov ax, word ptr [edx + field_395]           # 00468a11
    mov word ptr [0x5bb599], ax                  # 00468a18
    mov ecx, dword ptr [ebp - local_c]           # 00468a1e
    mov edx, dword ptr [ecx + field_1aa]         # 00468a21
    mov ax, word ptr [edx + field_397]           # 00468a27
    mov word ptr [0x5bb595], ax                  # 00468a2e
    mov ecx, dword ptr [ebp - local_c]           # 00468a34
    mov edx, dword ptr [ecx + field_1aa]         # 00468a37
    mov ax, word ptr [edx + field_399]           # 00468a3d
    mov word ptr [0x5c39ff], ax                  # 00468a44
    mov ecx, dword ptr [ebp - local_c]           # 00468a4a
    mov edx, dword ptr [ecx + field_1aa]         # 00468a4d
    mov eax, dword ptr [edx + field_39b]         # 00468a53
    mov dword ptr [0x5bb59b], eax                # 00468a59
    mov ecx, dword ptr [ebp - local_c]           # 00468a5e
    mov edx, dword ptr [ecx + field_1aa]         # 00468a61
    mov eax, dword ptr [edx + field_39f]         # 00468a67
    mov dword ptr [0x5bb59f], eax                # 00468a6d
    mov ecx, dword ptr [ebp - local_c]           # 00468a72
    mov edx, dword ptr [ecx + field_1aa]         # 00468a75
    mov eax, dword ptr [edx + field_3a3]         # 00468a7b
    mov dword ptr [0x5bb5a3], eax                # 00468a81
    mov ecx, dword ptr [ebp - local_c]           # 00468a86
    mov edx, dword ptr [ecx + field_1aa]         # 00468a89
    movsx eax, word ptr [edx + field_3a7]        # 00468a8f
    cmp eax, 0x1                                 # 00468a96
    jne.d8 L_00468aa7                            # 00468a99
    # block 0x00468a9b: entered by fall-through of jne at 0x00468a99, 2 instruction(s), ends with forward jump to 0x00468ab1
    mov dword ptr [0x5bb1ca], 0x0                # 00468a9b
    jmp.d8 L_00468ab1                            # 00468aa5
L_00468aa7:
    # block 0x00468aa7: entered by jne at 0x00468a99, 1 instruction(s), falls into the block at 0x00468ab1
    mov dword ptr [0x5bb1ca], 0x1                # 00468aa7
L_00468ab1:
    # block 0x00468ab1: entered by jmp at 0x00468aa5, 1 instruction(s), falls into the block at 0x00468abb
    mov dword ptr [0x583999], 0x4                # 00468ab1
L_00468abb:
    # block 0x00468abb: entered by jmp at 0x004689d3; je at 0x004689ed, 7 instruction(s), calls FUN_0042ba3a, FUN_00467608, falls into the block at 0x00468ad3
    mov ecx, dword ptr [ebp - local_c]           # 00468abb
    mov dx, word ptr [ecx + field_8]             # 00468abe
    push edx                                     # 00468ac2
    call FUN_0042ba3a                            # 00468ac3
    add esp, 0x4                                 # 00468ac8
    mov ecx, dword ptr [ebp - local_c]           # 00468acb
    call FUN_00467608                            # 00468ace
L_00468ad3:
    # block 0x00468ad3: entered by jmp at 0x0046801e; jmp at 0x0046860c; jmp at 0x004687ad, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00468ad3
    pop esi                                      # 00468ad4
    {load} mov esp, ebp                          # 00468ad5
    pop ebp                                      # 00468ad7
    ret 0x4                                      # 00468ad8

# --- data items (not part of the function) -------------------------
.org 0x00468adb - 0x401000
SWTAB_00468adb:  # 4 case address(es)
    .long L_0046862e - .text + 0x401000
    .long L_0046864e - .text + 0x401000
    .long L_004686cd - .text + 0x401000
    .long L_00468757 - .text + 0x401000
.set SWTAB_00468adb_VA, SWTAB_00468adb - .text + 0x401000

