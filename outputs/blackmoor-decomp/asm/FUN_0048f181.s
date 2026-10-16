# FUN_0048f181
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048f181
# extent:       0x0048f181-0x00490248 (4295 code bytes)
# span:         0x0048f181-0x0049026c (code 4295, tables 36, padding 0)
# sha256:       a5a0eb3182a6530f60ab450262f9a32b4af1a27177eb6136f1b263fa18e8fa43
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048f181
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       31 ebp-relative slot(s): local_3, local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c and 19 more
# fields:       [eax + n] field_1, field_4, field_8, field_c, field_10, field_1b, field_1c, field_1e, field_21, field_2c, field_2d, field_2f and 20 more; [ecx + n] field_1, field_2, field_4, field_8, field_c, field_10, field_19, field_1c, field_1e, field_1f, field_24, field_28 and 21 more; [edi + n] field_20; [edx + n] field_1, field_4, field_19, field_1c, field_1d, field_1e, field_20, field_25, field_2f, field_53, field_81, field_87 and 14 more; [esi + n] field_28
# callees:      calls FUN_004e8d96, FUN_0050ca3e, FUN_004264e8, FUN_004d39f9, FUN_004fb77a, FUN_004c924d, KERNEL32.dll!GetTickCount, FUN_0048ef40, FUN_004d3836, FUN_0050d8e0, FUN_0048ec4a, FUN_0048e9bf, FUN_0048ea24, FUN_00448d11, FUN_0048efe8, FUN_004f6334 and 5 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 1076 instruction(s), 73 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_3, 0x3  # offset -0x3
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
.equ local_31, 0x31  # offset -0x31
.equ local_32, 0x32  # offset -0x32
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_44, 0x44  # offset -0x44
.equ local_48, 0x48  # offset -0x48
.equ local_4c, 0x4c  # offset -0x4c
.equ local_4d, 0x4d  # offset -0x4d
.equ local_4e, 0x4e  # offset -0x4e
.equ local_54, 0x54  # offset -0x54
.equ local_58, 0x58  # offset -0x58
.equ local_5c, 0x5c  # offset -0x5c
.equ local_60, 0x60  # offset -0x60
.equ local_61, 0x61  # offset -0x61
.equ local_62, 0x62  # offset -0x62
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ field_1, 0x1  # offset +0x1
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_19, 0x19  # offset +0x19
.equ field_1b, 0x1b  # offset +0x1b
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1f, 0x1f  # offset +0x1f
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_28, 0x28  # offset +0x28
.equ field_29, 0x29  # offset +0x29
.equ field_2c, 0x2c  # offset +0x2c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_53, 0x53  # offset +0x53
.equ field_81, 0x81  # offset +0x81
.equ field_83, 0x83  # offset +0x83
.equ field_85, 0x85  # offset +0x85
.equ field_87, 0x87  # offset +0x87
.equ field_89, 0x89  # offset +0x89
.equ field_8d, 0x8d  # offset +0x8d
.equ field_91, 0x91  # offset +0x91
.equ field_95, 0x95  # offset +0x95
.equ field_97, 0x97  # offset +0x97
.equ field_99, 0x99  # offset +0x99
.equ field_ae, 0xae  # offset +0xae
.equ field_af, 0xaf  # offset +0xaf
.equ field_b0, 0xb0  # offset +0xb0
.equ field_b2, 0xb2  # offset +0xb2
.equ field_b6, 0xb6  # offset +0xb6
.equ field_ba, 0xba  # offset +0xba
.equ field_be, 0xbe  # offset +0xbe
.equ field_100, 0x100  # offset +0x100
.equ field_123, 0x123  # offset +0x123
.equ field_141, 0x141  # offset +0x141
.equ field_164, 0x164  # offset +0x164
.equ field_200, 0x200  # offset +0x200
.equ field_3fe, 0x3fe  # offset +0x3fe
.equ field_421, 0x421  # offset +0x421
.equ field_433, 0x433  # offset +0x433
.equ field_451, 0x451  # offset +0x451
.equ field_452, 0x452  # offset +0x452
.equ field_456, 0x456  # offset +0x456
.equ field_45a, 0x45a  # offset +0x45a
.equ field_45b, 0x45b  # offset +0x45b
.equ field_45c, 0x45c  # offset +0x45c
.equ field_45d, 0x45d  # offset +0x45d
.equ field_461, 0x461  # offset +0x461
.equ field_462, 0x462  # offset +0x462
.equ field_466, 0x466  # offset +0x466
.equ field_46a, 0x46a  # offset +0x46a
.equ field_4e2, 0x4e2  # offset +0x4e2

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_0048e2f5, .text + (0x0048e2f5 - 0x401000)
.set FUN_0048e9bf, .text + (0x0048e9bf - 0x401000)
.set FUN_0048ea24, .text + (0x0048ea24 - 0x401000)
.set FUN_0048ec4a, .text + (0x0048ec4a - 0x401000)
.set FUN_0048ef40, .text + (0x0048ef40 - 0x401000)
.set FUN_0048efe8, .text + (0x0048efe8 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004d3836, .text + (0x004d3836 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)

.org 0x0048f181 - 0x401000
.globl FUN_0048f181
FUN_0048f181:
    # block 0x0048f181: entry, 16 instruction(s), ends with je to 0x0048f1d1 (forward)
    push ebp                                     # 0048f181
    {load} mov ebp, esp                          # 0048f182
    sub esp, 0x6c                                # 0048f184
    push esi                                     # 0048f187
    push edi                                     # 0048f188
    mov dword ptr [ebp - local_24], ecx          # 0048f189
    movsx eax, word ptr [ebp + arg_8]            # 0048f18c
    imul eax, eax, 0x8d                          # 0048f190
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0048f196
    mov dword ptr [ebp - local_10], ecx          # 0048f19c
    movsx edx, word ptr [ebp + arg_8]            # 0048f19f
    imul edx, edx, 0x8d                          # 0048f1a3
    mov eax, dword ptr [edx + 0x5bb632]          # 0048f1a9
    mov dword ptr [ebp - local_28], eax          # 0048f1af
    cmp dword ptr [ebp - local_28], 0x0          # 0048f1b2
    je.d8 L_0048f1d1                             # 0048f1b6
    # block 0x0048f1b8: entered by fall-through of je at 0x0048f1b6, 2 instruction(s), ends with je to 0x0048f71d (forward)
    cmp dword ptr [ebp - local_28], 0x1          # 0048f1b8
    je.d32 L_0048f71d                            # 0048f1bc
    # block 0x0048f1c2: entered by fall-through of je at 0x0048f1bc, 2 instruction(s), ends with je to 0x00490040 (forward)
    cmp dword ptr [ebp - local_28], 0x2          # 0048f1c2
    je.d32 L_00490040                            # 0048f1c6
    # block 0x0048f1cc: entered by fall-through of je at 0x0048f1c6, 1 instruction(s), ends with forward jump to 0x00490240
    jmp.d32 L_00490240                           # 0048f1cc
L_0048f1d1:
    # block 0x0048f1d1: entered by je at 0x0048f1b6, 23 instruction(s), calls FUN_004e8d96, ends with forward jump to 0x0048f241
    mov ecx, dword ptr [ebp - local_24]          # 0048f1d1
    mov dx, word ptr [ebp + arg_8]               # 0048f1d4
    mov word ptr [ecx + field_1e], dx            # 0048f1d8
    mov eax, dword ptr [ebp - local_24]          # 0048f1dc
    mov dword ptr [eax + field_462], 0x1         # 0048f1df
    mov dword ptr [0x5bb1ca], 0x1                # 0048f1e9
    mov ecx, 0x571442                            # 0048f1f3
    call FUN_004e8d96                            # 0048f1f8
    mov ecx, 0x7f                                # 0048f1fd
    {load} xor eax, eax                          # 0048f202
    mov edi, dword ptr [ebp - local_24]          # 0048f204
    add edi, 0x200                               # 0048f207
    rep stosd dword ptr es:[edi], eax            # 0048f20d
    stosw word ptr es:[edi], ax                  # 0048f20f
    mov ecx, 0x1e                                # 0048f211
    {load} xor eax, eax                          # 0048f216
    mov edi, dword ptr [ebp - local_24]          # 0048f218
    add edi, 0x46a                               # 0048f21b
    rep stosd dword ptr es:[edi], eax            # 0048f221
    mov ecx, dword ptr [ebp - local_24]          # 0048f223
    mov word ptr [ecx + field_4e2], 0xffff       # 0048f226
    mov dword ptr [ebp - local_c], 0x0           # 0048f22f
    jmp.d8 L_0048f241                            # 0048f236
L_0048f238:
    # block 0x0048f238: entered by jmp at 0x0048f3d7, 3 instruction(s), falls into the block at 0x0048f241
    mov edx, dword ptr [ebp - local_c]           # 0048f238
    add edx, 0x1                                 # 0048f23b
    mov dword ptr [ebp - local_c], edx           # 0048f23e
L_0048f241:
    # block 0x0048f241: entered by jmp at 0x0048f236, 2 instruction(s), ends with jge to 0x0048f3dc (forward)
    cmp dword ptr [ebp - local_c], 0x19          # 0048f241
    jge.d32 L_0048f3dc                           # 0048f245
    # block 0x0048f24b: entered by fall-through of jge at 0x0048f245, 4 instruction(s), ends with jne to 0x0048f3dc (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048f24b
    movsx ecx, word ptr [eax + field_4e2]        # 0048f24e
    cmp ecx, -0x1                                # 0048f255
    jne.d32 L_0048f3dc                           # 0048f258
    # block 0x0048f25e: entered by fall-through of jne at 0x0048f258, 5 instruction(s), ends with jne to 0x0048f288 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048f25e
    imul edx, edx, 0x204                         # 0048f261
    movsx eax, word ptr [edx + 0x591b1e]         # 0048f267
    cmp eax, 0x270f                              # 0048f26e
    jne.d8 L_0048f288                            # 0048f273
    # block 0x0048f275: entered by fall-through of jne at 0x0048f273, 4 instruction(s), ends with forward jump to 0x0048f3d7
    mov ecx, dword ptr [ebp - local_24]          # 0048f275
    mov dx, word ptr [ebp - local_c]             # 0048f278
    mov word ptr [ecx + field_4e2], dx           # 0048f27c
    jmp.d32 L_0048f3d7                           # 0048f283
L_0048f288:
    # block 0x0048f288: entered by jne at 0x0048f273, 5 instruction(s), ends with je to 0x0048f3d7 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0048f288
    imul eax, eax, 0x204                         # 0048f28b
    movsx ecx, word ptr [eax + 0x591b1c]         # 0048f291
    test ecx, ecx                                # 0048f298
    je.d32 L_0048f3d7                            # 0048f29a
    # block 0x0048f2a0: entered by fall-through of je at 0x0048f29a, 5 instruction(s), ends with jne to 0x0048f3d7 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0048f2a0
    imul edx, edx, 0x204                         # 0048f2a3
    movsx eax, word ptr [edx + 0x591b1e]         # 0048f2a9
    cmp dword ptr [0x5bb57b], eax                # 0048f2b0
    jne.d32 L_0048f3d7                           # 0048f2b6
    # block 0x0048f2bc: entered by fall-through of jne at 0x0048f2b6, 22 instruction(s), ends with forward jump to 0x0048f324
    mov esi, dword ptr [ebp - local_c]           # 0048f2bc
    imul esi, esi, 0x204                         # 0048f2bf
    add esi, 0x591b22                            # 0048f2c5
    mov edi, dword ptr [ebp - local_24]          # 0048f2cb
    add edi, 0x200                               # 0048f2ce
    mov ecx, 0x7f                                # 0048f2d4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048f2d9
    movsw word ptr es:[edi], word ptr [esi]      # 0048f2db
    mov ecx, dword ptr [ebp - local_c]           # 0048f2dd
    imul ecx, ecx, 0x204                         # 0048f2e0
    mov edx, dword ptr [ebp - local_24]          # 0048f2e6
    mov ax, word ptr [ecx + 0x591b20]            # 0048f2e9
    mov word ptr [edx + field_3fe], ax           # 0048f2f0
    mov ecx, dword ptr [ebp - local_24]          # 0048f2f7
    mov dx, word ptr [ebp - local_c]             # 0048f2fa
    mov word ptr [ecx + field_4e2], dx           # 0048f2fe
    mov eax, dword ptr [ebp - local_10]          # 0048f305
    mov cl, byte ptr [eax + field_4]             # 0048f308
    mov byte ptr [ebp - local_4], cl             # 0048f30b
    mov byte ptr [ebp - local_3], 0x0            # 0048f30e
    mov dword ptr [ebp - local_8], 0x0           # 0048f312
    jmp.d8 L_0048f324                            # 0048f319
L_0048f31b:
    # block 0x0048f31b: entered by jmp at 0x0048f3d2, 3 instruction(s), falls into the block at 0x0048f324
    mov edx, dword ptr [ebp - local_8]           # 0048f31b
    add edx, 0x1                                 # 0048f31e
    mov dword ptr [ebp - local_8], edx           # 0048f321
L_0048f324:
    # block 0x0048f324: entered by jmp at 0x0048f319, 4 instruction(s), ends with jge to 0x0048f3d7 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0048f324
    movsx ecx, word ptr [eax + field_b0]         # 0048f327
    cmp dword ptr [ebp - local_8], ecx           # 0048f32e
    jge.d32 L_0048f3d7                           # 0048f331
    # block 0x0048f337: entered by fall-through of jge at 0x0048f331, 9 instruction(s), ends with je to 0x0048f3d2 (forward)
    mov edi, 0x63a8b8                            # 0048f337
    mov edx, dword ptr [ebp - local_8]           # 0048f33c
    imul edx, edx, 0x11                          # 0048f33f
    mov eax, dword ptr [ebp - local_24]          # 0048f342
    lea esi, [eax + edx + field_200]             # 0048f345
    mov ecx, 0x1                                 # 0048f34c
    {load} xor edx, edx                          # 0048f351
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048f353
    je.d8 L_0048f3d2                             # 0048f355
    # block 0x0048f357: entered by fall-through of je at 0x0048f355, 7 instruction(s), falls into the block at 0x0048f370
    lea eax, [ebp - local_4]                     # 0048f357
    mov dword ptr [ebp - local_2c], eax          # 0048f35a
    mov ecx, dword ptr [ebp - local_8]           # 0048f35d
    imul ecx, ecx, 0x11                          # 0048f360
    mov edx, dword ptr [ebp - local_24]          # 0048f363
    lea eax, [edx + ecx + field_200]             # 0048f366
    mov dword ptr [ebp - local_30], eax          # 0048f36d
L_0048f370:
    # block 0x0048f370: entered by jne at 0x0048f3a2, 6 instruction(s), ends with jne to 0x0048f3ad (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0048f370
    mov dl, byte ptr [ecx]                       # 0048f373
    mov byte ptr [ebp - local_31], dl            # 0048f375
    mov eax, dword ptr [ebp - local_2c]          # 0048f378
    cmp dl, byte ptr [eax]                       # 0048f37b
    jne.d8 L_0048f3ad                            # 0048f37d
    # block 0x0048f37f: entered by fall-through of jne at 0x0048f37d, 2 instruction(s), ends with je to 0x0048f3a4 (forward)
    cmp byte ptr [ebp - local_31], 0x0           # 0048f37f
    je.d8 L_0048f3a4                             # 0048f383
    # block 0x0048f385: entered by fall-through of je at 0x0048f383, 6 instruction(s), ends with jne to 0x0048f3ad (forward)
    mov ecx, dword ptr [ebp - local_30]          # 0048f385
    mov dl, byte ptr [ecx + field_1]             # 0048f388
    mov byte ptr [ebp - local_32], dl            # 0048f38b
    mov eax, dword ptr [ebp - local_2c]          # 0048f38e
    cmp dl, byte ptr [eax + field_1]             # 0048f391
    jne.d8 L_0048f3ad                            # 0048f394
    # block 0x0048f396: entered by fall-through of jne at 0x0048f394, 4 instruction(s), ends with jne to 0x0048f370 (backward)
    add dword ptr [ebp - local_30], 0x2          # 0048f396
    add dword ptr [ebp - local_2c], 0x2          # 0048f39a
    cmp byte ptr [ebp - local_32], 0x0           # 0048f39e
    jne.d8 L_0048f370                            # 0048f3a2
L_0048f3a4:
    # block 0x0048f3a4: entered by je at 0x0048f383; fall-through of jne at 0x0048f3a2, 2 instruction(s), ends with forward jump to 0x0048f3b5
    mov dword ptr [ebp - local_38], 0x0          # 0048f3a4
    jmp.d8 L_0048f3b5                            # 0048f3ab
L_0048f3ad:
    # block 0x0048f3ad: entered by jne at 0x0048f37d; jne at 0x0048f394, 3 instruction(s), falls into the block at 0x0048f3b5
    {load} sbb ecx, ecx                          # 0048f3ad
    sbb ecx, -0x1                                # 0048f3af
    mov dword ptr [ebp - local_38], ecx          # 0048f3b2
L_0048f3b5:
    # block 0x0048f3b5: entered by jmp at 0x0048f3ab, 4 instruction(s), ends with je to 0x0048f3d2 (forward)
    mov edx, dword ptr [ebp - local_38]          # 0048f3b5
    mov dword ptr [ebp - local_3c], edx          # 0048f3b8
    cmp dword ptr [ebp - local_3c], 0x0          # 0048f3bb
    je.d8 L_0048f3d2                             # 0048f3bf
    # block 0x0048f3c1: entered by fall-through of je at 0x0048f3bf, 3 instruction(s), falls into the block at 0x0048f3d2
    mov eax, dword ptr [ebp - local_8]           # 0048f3c1
    mov ecx, dword ptr [ebp - local_24]          # 0048f3c4
    mov dword ptr [ecx + 4*eax + field_46a], 0x1 # 0048f3c7
L_0048f3d2:
    # block 0x0048f3d2: entered by je at 0x0048f355; je at 0x0048f3bf, 1 instruction(s), ends with backward jump to 0x0048f31b
    jmp.d32 L_0048f31b                           # 0048f3d2
L_0048f3d7:
    # block 0x0048f3d7: entered by jmp at 0x0048f283; je at 0x0048f29a; jne at 0x0048f2b6; jge at 0x0048f331, 1 instruction(s), ends with backward jump to 0x0048f238
    jmp.d32 L_0048f238                           # 0048f3d7
L_0048f3dc:
    # block 0x0048f3dc: entered by jge at 0x0048f245; jne at 0x0048f258, 4 instruction(s), ends with jne to 0x0048f449 (forward)
    mov edx, dword ptr [ebp - local_24]          # 0048f3dc
    movsx eax, word ptr [edx + field_4e2]        # 0048f3df
    cmp eax, -0x1                                # 0048f3e6
    jne.d8 L_0048f449                            # 0048f3e9
    # block 0x0048f3eb: entered by fall-through of jne at 0x0048f3e9, 16 instruction(s), ends with je to 0x0048f449 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048f3eb
    mov word ptr [ecx + field_4e2], 0x0          # 0048f3ee
    mov ecx, 0x7f                                # 0048f3f7
    {load} xor eax, eax                          # 0048f3fc
    mov edi, dword ptr [ebp - local_24]          # 0048f3fe
    add edi, 0x200                               # 0048f401
    rep stosd dword ptr es:[edi], eax            # 0048f407
    stosw word ptr es:[edi], ax                  # 0048f409
    mov ecx, 0x1e                                # 0048f40b
    {load} xor eax, eax                          # 0048f410
    mov edi, dword ptr [ebp - local_24]          # 0048f412
    add edi, 0x46a                               # 0048f415
    rep stosd dword ptr es:[edi], eax            # 0048f41b
    movsx edx, word ptr [0x63a4cd]               # 0048f41d
    test edx, edx                                # 0048f424
    je.d8 L_0048f449                             # 0048f426
    # block 0x0048f428: entered by fall-through of je at 0x0048f426, 7 instruction(s), calls FUN_0050ca3e, FUN_004264e8, falls into the block at 0x0048f449
    push 0x54e9a4                                # 0048f428
    push 0x63888b                                # 0048f42d
    call FUN_0050ca3e                            # 0048f432
    add esp, 0x8                                 # 0048f437
    push 0x63888b                                # 0048f43a
    mov ecx, 0x583979                            # 0048f43f
    call FUN_004264e8                            # 0048f444
L_0048f449:
    # block 0x0048f449: entered by jne at 0x0048f3e9; je at 0x0048f426, 2 instruction(s), ends with forward jump to 0x0048f45b
    mov dword ptr [ebp - local_c], 0x0           # 0048f449
    jmp.d8 L_0048f45b                            # 0048f450
L_0048f452:
    # block 0x0048f452: entered by jmp at 0x0048f57e, 3 instruction(s), falls into the block at 0x0048f45b
    mov eax, dword ptr [ebp - local_c]           # 0048f452
    add eax, 0x1                                 # 0048f455
    mov dword ptr [ebp - local_c], eax           # 0048f458
L_0048f45b:
    # block 0x0048f45b: entered by jmp at 0x0048f450, 4 instruction(s), ends with jge to 0x0048f583 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0048f45b
    movsx edx, word ptr [ecx + field_b0]         # 0048f45e
    cmp dword ptr [ebp - local_c], edx           # 0048f465
    jge.d32 L_0048f583                           # 0048f468
    # block 0x0048f46e: entered by fall-through of jge at 0x0048f468, 41 instruction(s), ends with forward jump to 0x0048f525
    mov eax, dword ptr [ebp - local_c]           # 0048f46e
    imul eax, eax, 0xd0                          # 0048f471
    mov ecx, dword ptr [ebp - local_10]          # 0048f477
    mov edx, dword ptr [ecx + eax + field_b6]    # 0048f47a
    add edx, dword ptr [0x58318a]                # 0048f481
    mov eax, dword ptr [ebp - local_c]           # 0048f487
    shl eax, 0x4                                 # 0048f48a
    mov ecx, dword ptr [ebp - local_24]          # 0048f48d
    mov dword ptr [ecx + eax + field_24], edx    # 0048f490
    mov edx, dword ptr [ebp - local_c]           # 0048f494
    imul edx, edx, 0xd0                          # 0048f497
    mov eax, dword ptr [ebp - local_10]          # 0048f49d
    mov ecx, dword ptr [eax + edx + field_be]    # 0048f4a0
    add ecx, dword ptr [0x58318a]                # 0048f4a7
    mov edx, dword ptr [ebp - local_c]           # 0048f4ad
    shl edx, 0x4                                 # 0048f4b0
    mov eax, dword ptr [ebp - local_24]          # 0048f4b3
    mov dword ptr [eax + edx + field_2c], ecx    # 0048f4b6
    mov ecx, dword ptr [ebp - local_c]           # 0048f4ba
    imul ecx, ecx, 0xd0                          # 0048f4bd
    mov edx, dword ptr [ebp - local_10]          # 0048f4c3
    mov eax, dword ptr [edx + ecx + field_b2]    # 0048f4c6
    add eax, dword ptr [0x583186]                # 0048f4cd
    mov ecx, dword ptr [ebp - local_c]           # 0048f4d3
    shl ecx, 0x4                                 # 0048f4d6
    mov edx, dword ptr [ebp - local_24]          # 0048f4d9
    mov dword ptr [edx + ecx + field_20], eax    # 0048f4dc
    mov eax, dword ptr [ebp - local_c]           # 0048f4e0
    imul eax, eax, 0xd0                          # 0048f4e3
    mov ecx, dword ptr [ebp - local_10]          # 0048f4e9
    mov edx, dword ptr [ecx + eax + field_ba]    # 0048f4ec
    add edx, dword ptr [0x583186]                # 0048f4f3
    mov eax, dword ptr [ebp - local_c]           # 0048f4f9
    shl eax, 0x4                                 # 0048f4fc
    mov ecx, dword ptr [ebp - local_24]          # 0048f4ff
    mov dword ptr [ecx + eax + field_28], edx    # 0048f502
    mov edx, dword ptr [ebp - local_24]          # 0048f506
    add edx, dword ptr [ebp - local_c]           # 0048f509
    mov byte ptr [edx + field_433], 0x0          # 0048f50c
    mov dword ptr [ebp - local_8], 0x0           # 0048f513
    jmp.d8 L_0048f525                            # 0048f51a
L_0048f51c:
    # block 0x0048f51c: entered by jmp at 0x0048f57c, 3 instruction(s), falls into the block at 0x0048f525
    mov eax, dword ptr [ebp - local_8]           # 0048f51c
    add eax, 0x1                                 # 0048f51f
    mov dword ptr [ebp - local_8], eax           # 0048f522
L_0048f525:
    # block 0x0048f525: entered by jmp at 0x0048f51a, 2 instruction(s), ends with jge to 0x0048f57e (forward)
    cmp dword ptr [ebp - local_8], 0x3           # 0048f525
    jge.d8 L_0048f57e                            # 0048f529
    # block 0x0048f52b: entered by fall-through of jge at 0x0048f529, 19 instruction(s), ends with jle to 0x0048f57c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0048f52b
    imul ecx, ecx, 0xd0                          # 0048f52e
    mov edx, dword ptr [ebp - local_10]          # 0048f534
    lea eax, [edx + ecx + field_b2]              # 0048f537
    mov ecx, dword ptr [ebp - local_8]           # 0048f53e
    imul ecx, ecx, 0x14                          # 0048f541
    lea edi, [eax + ecx + field_10]              # 0048f544
    or ecx, -0x1                                 # 0048f548
    {load} xor eax, eax                          # 0048f54b
    repne scasb al, byte ptr es:[edi]            # 0048f54d
    not ecx                                      # 0048f54f
    add ecx, -0x1                                # 0048f551
    mov word ptr [ebp - local_14], cx            # 0048f554
    movsx edx, word ptr [ebp - local_14]         # 0048f558
    mov eax, dword ptr [ebp - local_24]          # 0048f55c
    add eax, dword ptr [ebp - local_c]           # 0048f55f
    movsx ecx, byte ptr [eax + field_433]        # 0048f562
    {load} cmp edx, ecx                          # 0048f569
    jle.d8 L_0048f57c                            # 0048f56b
    # block 0x0048f56d: entered by fall-through of jle at 0x0048f56b, 4 instruction(s), falls into the block at 0x0048f57c
    mov edx, dword ptr [ebp - local_24]          # 0048f56d
    add edx, dword ptr [ebp - local_c]           # 0048f570
    mov al, byte ptr [ebp - local_14]            # 0048f573
    mov byte ptr [edx + field_433], al           # 0048f576
L_0048f57c:
    # block 0x0048f57c: entered by jle at 0x0048f56b, 1 instruction(s), ends with backward jump to 0x0048f51c
    jmp.d8 L_0048f51c                            # 0048f57c
L_0048f57e:
    # block 0x0048f57e: entered by jge at 0x0048f529, 1 instruction(s), ends with backward jump to 0x0048f452
    jmp.d32 L_0048f452                           # 0048f57e
L_0048f583:
    # block 0x0048f583: entered by jge at 0x0048f468, 61 instruction(s), calls FUN_004d39f9, ends with je to 0x0048f689 (forward)
    call FUN_004d39f9                            # 0048f583
    mov ecx, dword ptr [ebp - local_24]          # 0048f588
    mov word ptr [ecx + field_1c], ax            # 0048f58b
    mov edx, dword ptr [ebp - local_24]          # 0048f58f
    movsx eax, word ptr [edx + field_1c]         # 0048f592
    imul eax, eax, 0x4a                          # 0048f596
    mov dword ptr [eax + 0x5d1591], 0xa          # 0048f599
    mov ecx, dword ptr [ebp - local_24]          # 0048f5a3
    movsx edx, word ptr [ecx + field_1c]         # 0048f5a6
    imul edx, edx, 0x4a                          # 0048f5aa
    mov dword ptr [edx + 0x5d1595], 0x49027c     # 0048f5ad
    mov eax, dword ptr [ebp - local_24]          # 0048f5b7
    movsx ecx, word ptr [eax + field_1c]         # 0048f5ba
    imul ecx, ecx, 0x4a                          # 0048f5be
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0048f5c1
    mov edx, dword ptr [ebp - local_24]          # 0048f5cb
    movsx eax, word ptr [edx + field_1c]         # 0048f5ce
    imul eax, eax, 0x4a                          # 0048f5d2
    mov dword ptr [eax + 0x5d159d], 0x0          # 0048f5d5
    mov ecx, dword ptr [ebp - local_24]          # 0048f5df
    movsx edx, word ptr [ecx + field_1c]         # 0048f5e2
    imul edx, edx, 0x4a                          # 0048f5e6
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0048f5e9
    mov eax, dword ptr [ebp - local_24]          # 0048f5f3
    movsx ecx, word ptr [eax + field_1c]         # 0048f5f6
    imul ecx, ecx, 0x4a                          # 0048f5fa
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048f5fd
    mov edx, dword ptr [ebp - local_24]          # 0048f607
    movsx eax, word ptr [edx + field_1c]         # 0048f60a
    imul eax, eax, 0x4a                          # 0048f60e
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0048f611
    mov ecx, dword ptr [ebp - local_24]          # 0048f61b
    movsx edx, word ptr [ecx + field_1c]         # 0048f61e
    imul edx, edx, 0x4a                          # 0048f622
    mov word ptr [edx + 0x5d15ad], 0x0           # 0048f625
    mov edi, 0x54e9c8                            # 0048f62e
    mov eax, dword ptr [ebp - local_24]          # 0048f633
    movsx ecx, word ptr [eax + field_1c]         # 0048f636
    imul ecx, ecx, 0x4a                          # 0048f63a
    add ecx, 0x5d15b3                            # 0048f63d
    {load} mov edx, ecx                          # 0048f643
    or ecx, -0x1                                 # 0048f645
    {load} xor eax, eax                          # 0048f648
    repne scasb al, byte ptr es:[edi]            # 0048f64a
    not ecx                                      # 0048f64c
    {load} sub edi, ecx                          # 0048f64e
    {load} mov esi, edi                          # 0048f650
    {load} mov eax, ecx                          # 0048f652
    {load} mov edi, edx                          # 0048f654
    shr ecx, 0x2                                 # 0048f656
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0048f659
    {load} mov ecx, eax                          # 0048f65b
    and ecx, 0x3                                 # 0048f65d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0048f660
    mov edi, 0x54e9dc                            # 0048f662
    mov esi, dword ptr [ebp - local_10]          # 0048f667
    add esi, 0x32                                # 0048f66a
    mov ecx, 0x9                                 # 0048f66d
    {load} xor edx, edx                          # 0048f672
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048f674
    je.d8 L_0048f689                             # 0048f676
    # block 0x0048f678: entered by fall-through of je at 0x0048f676, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0048f689
    mov eax, dword ptr [ebp - local_10]          # 0048f678
    add eax, 0x32                                # 0048f67b
    push eax                                     # 0048f67e
    mov ecx, 0x5c3a67                            # 0048f67f
    call FUN_004fb77a                            # 0048f684
L_0048f689:
    # block 0x0048f689: entered by je at 0x0048f676, 30 instruction(s), calls FUN_004c924d, KERNEL32.dll!GetTickCount, ends with forward jump to 0x00490240
    mov ecx, dword ptr [ebp - local_10]          # 0048f689
    mov dx, word ptr [ecx]                       # 0048f68c
    push edx                                     # 0048f68f
    mov ecx, 0x5cf659                            # 0048f690
    call FUN_004c924d                            # 0048f695
    call dword ptr [0x52a23c]                    # 0048f69a
    mov ecx, dword ptr [ebp - local_10]          # 0048f6a0
    movsx edx, word ptr [ecx + field_2]          # 0048f6a3
    {load} add eax, edx                          # 0048f6a7
    mov ecx, dword ptr [ebp - local_24]          # 0048f6a9
    mov dword ptr [ecx + field_466], eax         # 0048f6ac
    mov edx, dword ptr [ebp - local_24]          # 0048f6b2
    mov byte ptr [edx + field_45a], 0x0          # 0048f6b5
    mov eax, dword ptr [ebp - local_24]          # 0048f6bc
    mov byte ptr [eax + field_45b], 0x0          # 0048f6bf
    mov ecx, dword ptr [ebp - local_24]          # 0048f6c6
    mov byte ptr [ecx + field_45c], 0x0          # 0048f6c9
    mov edx, dword ptr [ebp - local_24]          # 0048f6d0
    mov dword ptr [edx + field_45d], 0x0         # 0048f6d3
    mov eax, dword ptr [ebp - local_24]          # 0048f6dd
    mov byte ptr [eax + field_451], 0x0          # 0048f6e0
    mov ecx, dword ptr [ebp - local_24]          # 0048f6e7
    mov dword ptr [ecx + field_452], 0x0         # 0048f6ea
    mov edx, dword ptr [ebp - local_24]          # 0048f6f4
    mov dword ptr [edx + field_456], 0x0         # 0048f6f7
    mov eax, dword ptr [ebp - local_24]          # 0048f701
    movsx ecx, word ptr [eax + field_1e]         # 0048f704
    imul ecx, ecx, 0x8d                          # 0048f708
    mov dword ptr [ecx + 0x5bb632], 0x1          # 0048f70e
    jmp.d32 L_00490240                           # 0048f718
L_0048f71d:
    # block 0x0048f71d: entered by je at 0x0048f1bc, 20 instruction(s), ends with ja to 0x0049003b (forward)
    mov edx, dword ptr [ebp - local_24]          # 0048f71d
    movsx eax, word ptr [edx + field_4e2]        # 0048f720
    imul eax, eax, 0x204                         # 0048f727
    mov word ptr [eax + 0x591b1c], 0x1           # 0048f72d
    mov ecx, dword ptr [ebp - local_24]          # 0048f736
    movsx edx, word ptr [ecx + field_4e2]        # 0048f739
    imul edx, edx, 0x204                         # 0048f740
    mov ax, word ptr [0x5bb57b]                  # 0048f746
    mov word ptr [edx + 0x591b1e], ax            # 0048f74c
    mov ecx, dword ptr [ebp - local_24]          # 0048f753
    movsx edx, word ptr [ecx + field_4e2]        # 0048f756
    imul edx, edx, 0x204                         # 0048f75d
    mov eax, dword ptr [ebp - local_24]          # 0048f763
    mov cx, word ptr [eax + field_3fe]           # 0048f766
    mov word ptr [edx + 0x591b20], cx            # 0048f76d
    mov edx, dword ptr [ebp - local_24]          # 0048f774
    mov eax, dword ptr [edx + field_452]         # 0048f777
    mov dword ptr [ebp - local_40], eax          # 0048f77d
    cmp dword ptr [ebp - local_40], 0x8          # 0048f780
    ja.d32 L_0049003b                            # 0048f784
    # block 0x0048f78a: entered by fall-through of ja at 0x0048f784, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x490248]
    mov ecx, dword ptr [ebp - local_40]          # 0048f78a
    jmp dword ptr [4*ecx + SWTAB_00490248_VA]    # 0048f78d
L_0048f794:
    # block 0x0048f794: entered by switch case, 3 instruction(s), ends with je to 0x0048fb9a (forward)
    mov edx, dword ptr [ebp - local_24]          # 0048f794
    cmp dword ptr [edx + field_45d], 0x0         # 0048f797
    je.d32 L_0048fb9a                            # 0048f79e
    # block 0x0048f7a4: entered by fall-through of je at 0x0048f79e, 12 instruction(s), ends with jbe to 0x0048f858 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048f7a4
    movsx ecx, word ptr [eax + field_3fe]        # 0048f7a7
    imul ecx, ecx, 0x11                          # 0048f7ae
    mov edx, dword ptr [ebp - local_24]          # 0048f7b1
    lea edi, [edx + ecx + field_200]             # 0048f7b4
    or ecx, -0x1                                 # 0048f7bb
    {load} xor eax, eax                          # 0048f7be
    repne scasb al, byte ptr es:[edi]            # 0048f7c0
    not ecx                                      # 0048f7c2
    add ecx, -0x1                                # 0048f7c4
    test ecx, ecx                                # 0048f7c7
    jbe.d32 L_0048f858                           # 0048f7c9
    # block 0x0048f7cf: entered by fall-through of jbe at 0x0048f7c9, 20 instruction(s), ends with jne to 0x0048f858 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048f7cf
    movsx ecx, word ptr [eax + field_3fe]        # 0048f7d2
    imul ecx, ecx, 0x11                          # 0048f7d9
    mov edx, dword ptr [ebp - local_24]          # 0048f7dc
    lea edx, [edx + ecx + field_200]             # 0048f7df
    mov eax, dword ptr [ebp - local_24]          # 0048f7e6
    movsx ecx, word ptr [eax + field_3fe]        # 0048f7e9
    imul ecx, ecx, 0x11                          # 0048f7f0
    mov eax, dword ptr [ebp - local_24]          # 0048f7f3
    lea edi, [eax + ecx + field_200]             # 0048f7f6
    or ecx, -0x1                                 # 0048f7fd
    {load} xor eax, eax                          # 0048f800
    repne scasb al, byte ptr es:[edi]            # 0048f802
    not ecx                                      # 0048f804
    add ecx, -0x1                                # 0048f806
    movsx ecx, byte ptr [edx + ecx - field_minus_1] # 0048f809
    mov edx, dword ptr [ebp - local_10]          # 0048f80e
    movsx eax, byte ptr [edx + field_4]          # 0048f811
    {load} cmp ecx, eax                          # 0048f815
    jne.d8 L_0048f858                            # 0048f817
    # block 0x0048f819: entered by fall-through of jne at 0x0048f817, 16 instruction(s), falls into the block at 0x0048f858
    mov ecx, dword ptr [ebp - local_24]          # 0048f819
    movsx edx, word ptr [ecx + field_3fe]        # 0048f81c
    imul edx, edx, 0x11                          # 0048f823
    mov eax, dword ptr [ebp - local_24]          # 0048f826
    lea edx, [eax + edx + field_200]             # 0048f829
    mov eax, dword ptr [ebp - local_24]          # 0048f830
    movsx ecx, word ptr [eax + field_3fe]        # 0048f833
    imul ecx, ecx, 0x11                          # 0048f83a
    mov eax, dword ptr [ebp - local_24]          # 0048f83d
    lea edi, [eax + ecx + field_200]             # 0048f840
    or ecx, -0x1                                 # 0048f847
    {load} xor eax, eax                          # 0048f84a
    repne scasb al, byte ptr es:[edi]            # 0048f84c
    not ecx                                      # 0048f84e
    add ecx, -0x1                                # 0048f850
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 0048f853
L_0048f858:
    # block 0x0048f858: entered by jbe at 0x0048f7c9; jne at 0x0048f817, 5 instruction(s), ends with je to 0x0048f875 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048f858
    mov dl, byte ptr [ecx + field_461]           # 0048f85b
    mov byte ptr [ebp - local_44], dl            # 0048f861
    cmp byte ptr [ebp - local_44], 0x8           # 0048f864
    je.d8 L_0048f875                             # 0048f868
    # block 0x0048f86a: entered by fall-through of je at 0x0048f868, 2 instruction(s), ends with je to 0x0048f8e0 (forward)
    cmp byte ptr [ebp - local_44], 0xd           # 0048f86a
    je.d8 L_0048f8e0                             # 0048f86e
    # block 0x0048f870: entered by fall-through of je at 0x0048f86e, 1 instruction(s), ends with forward jump to 0x0048f932
    jmp.d32 L_0048f932                           # 0048f870
L_0048f875:
    # block 0x0048f875: entered by je at 0x0048f868, 12 instruction(s), ends with jbe to 0x0048f8db (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048f875
    movsx ecx, word ptr [eax + field_3fe]        # 0048f878
    imul ecx, ecx, 0x11                          # 0048f87f
    mov edx, dword ptr [ebp - local_24]          # 0048f882
    lea edi, [edx + ecx + field_200]             # 0048f885
    or ecx, -0x1                                 # 0048f88c
    {load} xor eax, eax                          # 0048f88f
    repne scasb al, byte ptr es:[edi]            # 0048f891
    not ecx                                      # 0048f893
    add ecx, -0x1                                # 0048f895
    test ecx, ecx                                # 0048f898
    jbe.d8 L_0048f8db                            # 0048f89a
    # block 0x0048f89c: entered by fall-through of jbe at 0x0048f89a, 16 instruction(s), falls into the block at 0x0048f8db
    mov eax, dword ptr [ebp - local_24]          # 0048f89c
    movsx ecx, word ptr [eax + field_3fe]        # 0048f89f
    imul ecx, ecx, 0x11                          # 0048f8a6
    mov edx, dword ptr [ebp - local_24]          # 0048f8a9
    lea edx, [edx + ecx + field_200]             # 0048f8ac
    mov eax, dword ptr [ebp - local_24]          # 0048f8b3
    movsx ecx, word ptr [eax + field_3fe]        # 0048f8b6
    imul ecx, ecx, 0x11                          # 0048f8bd
    mov eax, dword ptr [ebp - local_24]          # 0048f8c0
    lea edi, [eax + ecx + field_200]             # 0048f8c3
    or ecx, -0x1                                 # 0048f8ca
    {load} xor eax, eax                          # 0048f8cd
    repne scasb al, byte ptr es:[edi]            # 0048f8cf
    not ecx                                      # 0048f8d1
    add ecx, -0x1                                # 0048f8d3
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 0048f8d6
L_0048f8db:
    # block 0x0048f8db: entered by jbe at 0x0048f89a, 1 instruction(s), ends with forward jump to 0x0048fb8d
    jmp.d32 L_0048fb8d                           # 0048f8db
L_0048f8e0:
    # block 0x0048f8e0: entered by je at 0x0048f86e, 12 instruction(s), ends with jbe to 0x0048f916 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048f8e0
    movsx edx, word ptr [ecx + field_3fe]        # 0048f8e3
    imul edx, edx, 0x11                          # 0048f8ea
    mov eax, dword ptr [ebp - local_24]          # 0048f8ed
    lea edi, [eax + edx + field_200]             # 0048f8f0
    or ecx, -0x1                                 # 0048f8f7
    {load} xor eax, eax                          # 0048f8fa
    repne scasb al, byte ptr es:[edi]            # 0048f8fc
    not ecx                                      # 0048f8fe
    add ecx, -0x1                                # 0048f900
    test ecx, ecx                                # 0048f903
    jbe.d8 L_0048f916                            # 0048f905
    # block 0x0048f907: entered by fall-through of jbe at 0x0048f905, 3 instruction(s), ends with forward jump to 0x0048f92d
    mov ecx, dword ptr [ebp - local_24]          # 0048f907
    mov dword ptr [ecx + field_452], 0x1         # 0048f90a
    jmp.d8 L_0048f92d                            # 0048f914
L_0048f916:
    # block 0x0048f916: entered by jbe at 0x0048f905, 5 instruction(s), ends with jne to 0x0048f92d (forward)
    mov edx, dword ptr [ebp - local_10]          # 0048f916
    {load} xor eax, eax                          # 0048f919
    mov al, byte ptr [edx + field_ae]            # 0048f91b
    test eax, eax                                # 0048f921
    jne.d8 L_0048f92d                            # 0048f923
    # block 0x0048f925: entered by fall-through of jne at 0x0048f923, 2 instruction(s), calls FUN_0048ef40, falls into the block at 0x0048f92d
    mov ecx, dword ptr [ebp - local_24]          # 0048f925
    call FUN_0048ef40                            # 0048f928
L_0048f92d:
    # block 0x0048f92d: entered by jmp at 0x0048f914; jne at 0x0048f923, 1 instruction(s), ends with forward jump to 0x0048fb8d
    jmp.d32 L_0048fb8d                           # 0048f92d
L_0048f932:
    # block 0x0048f932: entered by jmp at 0x0048f870, 12 instruction(s), ends with jae to 0x0048fb8d (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048f932
    movsx edx, word ptr [ecx + field_3fe]        # 0048f935
    imul edx, edx, 0x11                          # 0048f93c
    mov eax, dword ptr [ebp - local_24]          # 0048f93f
    lea edi, [eax + edx + field_200]             # 0048f942
    or ecx, -0x1                                 # 0048f949
    {load} xor eax, eax                          # 0048f94c
    repne scasb al, byte ptr es:[edi]            # 0048f94e
    not ecx                                      # 0048f950
    inc ecx                                      # 0048f952
    cmp ecx, 0x11                                # 0048f953
    jae.d32 L_0048fb8d                           # 0048f956
    # block 0x0048f95c: entered by fall-through of jae at 0x0048f956, 32 instruction(s), calls FUN_004d3836, ends with jge to 0x0048fb8d (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0048f95c
    movsx edx, word ptr [ecx]                    # 0048f95f
    imul edx, edx, 0x1d0                         # 0048f962
    add edx, 0x5adb3a                            # 0048f968
    push edx                                     # 0048f96e
    mov eax, dword ptr [ebp - local_10]          # 0048f96f
    movsx ecx, word ptr [eax]                    # 0048f972
    imul ecx, ecx, 0x7f3                         # 0048f975
    add ecx, 0x5a4c24                            # 0048f97b
    push ecx                                     # 0048f981
    mov edx, dword ptr [ebp - local_24]          # 0048f982
    movsx eax, word ptr [edx + field_3fe]        # 0048f985
    imul eax, eax, 0x11                          # 0048f98c
    mov ecx, dword ptr [ebp - local_24]          # 0048f98f
    lea edx, [ecx + eax + field_200]             # 0048f992
    push edx                                     # 0048f999
    call FUN_004d3836                            # 0048f99a
    add esp, 0xc                                 # 0048f99f
    movsx eax, ax                                # 0048f9a2
    mov ecx, dword ptr [ebp - local_24]          # 0048f9a5
    movsx edx, word ptr [ecx + field_3fe]        # 0048f9a8
    shl edx, 0x4                                 # 0048f9af
    mov ecx, dword ptr [ebp - local_24]          # 0048f9b2
    movsx ecx, word ptr [ecx + field_3fe]        # 0048f9b5
    shl ecx, 0x4                                 # 0048f9bc
    mov esi, dword ptr [ebp - local_24]          # 0048f9bf
    mov edi, dword ptr [ebp - local_24]          # 0048f9c2
    mov edx, dword ptr [esi + edx + field_28]    # 0048f9c5
    sub edx, dword ptr [edi + ecx + field_20]    # 0048f9c9
    sub edx, 0x14                                # 0048f9cd
    {load} cmp eax, edx                          # 0048f9d0
    jge.d32 L_0048fb8d                           # 0048f9d2
    # block 0x0048f9d8: entered by fall-through of jge at 0x0048f9d2, 13 instruction(s), ends with je to 0x0048fa19 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048f9d8
    mov cl, byte ptr [eax + field_461]           # 0048f9db
    mov byte ptr [ebp - local_4], cl             # 0048f9e1
    mov byte ptr [ebp - local_3], 0x0            # 0048f9e4
    mov edi, dword ptr [ebp - local_10]          # 0048f9e8
    add edi, 0x5                                 # 0048f9eb
    or ecx, -0x1                                 # 0048f9ee
    {load} xor eax, eax                          # 0048f9f1
    repne scasb al, byte ptr es:[edi]            # 0048f9f3
    not ecx                                      # 0048f9f5
    add ecx, -0x1                                # 0048f9f7
    test ecx, ecx                                # 0048f9fa
    je.d8 L_0048fa19                             # 0048f9fc
    # block 0x0048f9fe: entered by fall-through of je at 0x0048f9fc, 9 instruction(s), calls FUN_0050d8e0, ends with je to 0x0048fb8d (forward)
    lea edx, [ebp - local_4]                     # 0048f9fe
    push edx                                     # 0048fa01
    mov eax, dword ptr [ebp - local_10]          # 0048fa02
    add eax, 0x5                                 # 0048fa05
    push eax                                     # 0048fa08
    call FUN_0050d8e0                            # 0048fa09
    add esp, 0x8                                 # 0048fa0e
    test eax, eax                                # 0048fa11
    je.d32 L_0048fb8d                            # 0048fa13
L_0048fa19:
    # block 0x0048fa19: entered by je at 0x0048f9fc; fall-through of je at 0x0048fa13, 23 instruction(s), ends with jne to 0x0048fb8d (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048fa19
    movsx edx, word ptr [ecx + field_3fe]        # 0048fa1c
    imul edx, edx, 0x11                          # 0048fa23
    mov eax, dword ptr [ebp - local_24]          # 0048fa26
    lea edx, [eax + edx + field_200]             # 0048fa29
    mov eax, dword ptr [ebp - local_24]          # 0048fa30
    movsx ecx, word ptr [eax + field_3fe]        # 0048fa33
    imul ecx, ecx, 0x11                          # 0048fa3a
    mov eax, dword ptr [ebp - local_24]          # 0048fa3d
    lea edi, [eax + ecx + field_200]             # 0048fa40
    or ecx, -0x1                                 # 0048fa47
    {load} xor eax, eax                          # 0048fa4a
    repne scasb al, byte ptr es:[edi]            # 0048fa4c
    not ecx                                      # 0048fa4e
    add ecx, -0x1                                # 0048fa50
    mov eax, dword ptr [ebp - local_24]          # 0048fa53
    mov al, byte ptr [eax + field_461]           # 0048fa56
    mov byte ptr [edx + ecx], al                 # 0048fa5c
    mov ecx, dword ptr [ebp - local_10]          # 0048fa5f
    {load} xor edx, edx                          # 0048fa62
    mov dl, byte ptr [ecx + field_af]            # 0048fa64
    test edx, edx                                # 0048fa6a
    jne.d32 L_0048fb8d                           # 0048fa6c
    # block 0x0048fa72: entered by fall-through of jne at 0x0048fa6c, 4 instruction(s), calls FUN_0048ec4a, ends with je to 0x0048fb44 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048fa72
    call FUN_0048ec4a                            # 0048fa75
    test eax, eax                                # 0048fa7a
    je.d32 L_0048fb44                            # 0048fa7c
    # block 0x0048fa82: entered by fall-through of je at 0x0048fa7c, 11 instruction(s), falls into the block at 0x0048fab2
    mov eax, dword ptr [ebp - local_24]          # 0048fa82
    mov dword ptr [eax + field_452], 0x2         # 0048fa85
    mov ecx, dword ptr [ebp - local_10]          # 0048fa8f
    add ecx, 0x4                                 # 0048fa92
    mov dword ptr [ebp - local_48], ecx          # 0048fa95
    mov edx, dword ptr [ebp - local_24]          # 0048fa98
    movsx eax, word ptr [edx + field_3fe]        # 0048fa9b
    imul eax, eax, 0x11                          # 0048faa2
    mov ecx, dword ptr [ebp - local_24]          # 0048faa5
    lea edx, [ecx + eax + field_200]             # 0048faa8
    mov dword ptr [ebp - local_4c], edx          # 0048faaf
L_0048fab2:
    # block 0x0048fab2: entered by jne at 0x0048fae4, 6 instruction(s), ends with jne to 0x0048faef (forward)
    mov eax, dword ptr [ebp - local_4c]          # 0048fab2
    mov cl, byte ptr [eax]                       # 0048fab5
    mov byte ptr [ebp - local_4d], cl            # 0048fab7
    mov edx, dword ptr [ebp - local_48]          # 0048faba
    cmp cl, byte ptr [edx]                       # 0048fabd
    jne.d8 L_0048faef                            # 0048fabf
    # block 0x0048fac1: entered by fall-through of jne at 0x0048fabf, 2 instruction(s), ends with je to 0x0048fae6 (forward)
    cmp byte ptr [ebp - local_4d], 0x0           # 0048fac1
    je.d8 L_0048fae6                             # 0048fac5
    # block 0x0048fac7: entered by fall-through of je at 0x0048fac5, 6 instruction(s), ends with jne to 0x0048faef (forward)
    mov eax, dword ptr [ebp - local_4c]          # 0048fac7
    mov cl, byte ptr [eax + field_1]             # 0048faca
    mov byte ptr [ebp - local_4e], cl            # 0048facd
    mov edx, dword ptr [ebp - local_48]          # 0048fad0
    cmp cl, byte ptr [edx + field_1]             # 0048fad3
    jne.d8 L_0048faef                            # 0048fad6
    # block 0x0048fad8: entered by fall-through of jne at 0x0048fad6, 4 instruction(s), ends with jne to 0x0048fab2 (backward)
    add dword ptr [ebp - local_4c], 0x2          # 0048fad8
    add dword ptr [ebp - local_48], 0x2          # 0048fadc
    cmp byte ptr [ebp - local_4e], 0x0           # 0048fae0
    jne.d8 L_0048fab2                            # 0048fae4
L_0048fae6:
    # block 0x0048fae6: entered by je at 0x0048fac5; fall-through of jne at 0x0048fae4, 2 instruction(s), ends with forward jump to 0x0048faf7
    mov dword ptr [ebp - local_54], 0x0          # 0048fae6
    jmp.d8 L_0048faf7                            # 0048faed
L_0048faef:
    # block 0x0048faef: entered by jne at 0x0048fabf; jne at 0x0048fad6, 3 instruction(s), falls into the block at 0x0048faf7
    {load} sbb eax, eax                          # 0048faef
    sbb eax, -0x1                                # 0048faf1
    mov dword ptr [ebp - local_54], eax          # 0048faf4
L_0048faf7:
    # block 0x0048faf7: entered by jmp at 0x0048faed, 4 instruction(s), ends with jne to 0x0048fb42 (forward)
    mov ecx, dword ptr [ebp - local_54]          # 0048faf7
    mov dword ptr [ebp - local_58], ecx          # 0048fafa
    cmp dword ptr [ebp - local_58], 0x0          # 0048fafd
    jne.d8 L_0048fb42                            # 0048fb01
    # block 0x0048fb03: entered by fall-through of jne at 0x0048fb01, 16 instruction(s), falls into the block at 0x0048fb42
    mov edx, dword ptr [ebp - local_24]          # 0048fb03
    movsx eax, word ptr [edx + field_3fe]        # 0048fb06
    imul eax, eax, 0x11                          # 0048fb0d
    mov ecx, dword ptr [ebp - local_24]          # 0048fb10
    lea edx, [ecx + eax + field_200]             # 0048fb13
    mov eax, dword ptr [ebp - local_24]          # 0048fb1a
    movsx ecx, word ptr [eax + field_3fe]        # 0048fb1d
    imul ecx, ecx, 0x11                          # 0048fb24
    mov eax, dword ptr [ebp - local_24]          # 0048fb27
    lea edi, [eax + ecx + field_200]             # 0048fb2a
    or ecx, -0x1                                 # 0048fb31
    {load} xor eax, eax                          # 0048fb34
    repne scasb al, byte ptr es:[edi]            # 0048fb36
    not ecx                                      # 0048fb38
    add ecx, -0x1                                # 0048fb3a
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 0048fb3d
L_0048fb42:
    # block 0x0048fb42: entered by jne at 0x0048fb01, 1 instruction(s), ends with forward jump to 0x0048fb8d
    jmp.d8 L_0048fb8d                            # 0048fb42
L_0048fb44:
    # block 0x0048fb44: entered by je at 0x0048fa7c, 16 instruction(s), ends with jb to 0x0048fb8d (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048fb44
    movsx edx, word ptr [ecx + field_3fe]        # 0048fb47
    imul edx, edx, 0x11                          # 0048fb4e
    mov eax, dword ptr [ebp - local_24]          # 0048fb51
    lea edi, [eax + edx + field_200]             # 0048fb54
    or ecx, -0x1                                 # 0048fb5b
    {load} xor eax, eax                          # 0048fb5e
    repne scasb al, byte ptr es:[edi]            # 0048fb60
    not ecx                                      # 0048fb62
    add ecx, -0x1                                # 0048fb64
    mov edx, dword ptr [ebp - local_24]          # 0048fb67
    movsx eax, word ptr [edx + field_3fe]        # 0048fb6a
    mov edx, dword ptr [ebp - local_24]          # 0048fb71
    movsx eax, byte ptr [edx + eax + field_433]  # 0048fb74
    {load} cmp ecx, eax                          # 0048fb7c
    jb.d8 L_0048fb8d                             # 0048fb7e
    # block 0x0048fb80: entered by fall-through of jb at 0x0048fb7e, 2 instruction(s), falls into the block at 0x0048fb8d
    mov ecx, dword ptr [ebp - local_24]          # 0048fb80
    mov dword ptr [ecx + field_452], 0x4         # 0048fb83
L_0048fb8d:
    # block 0x0048fb8d: entered by jmp at 0x0048f8db; jmp at 0x0048f92d; jae at 0x0048f956; jge at 0x0048f9d2; more, 2 instruction(s), falls into the block at 0x0048fb9a
    mov edx, dword ptr [ebp - local_24]          # 0048fb8d
    mov dword ptr [edx + field_45d], 0x0         # 0048fb90
L_0048fb9a:
    # block 0x0048fb9a: entered by je at 0x0048f79e, 3 instruction(s), ends with je to 0x0048fbba (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048fb9a
    cmp dword ptr [eax + field_452], 0x2         # 0048fb9d
    je.d8 L_0048fbba                             # 0048fba4
    # block 0x0048fba6: entered by fall-through of je at 0x0048fba4, 4 instruction(s), calls FUN_0048e9bf, ends with jne to 0x0048fbba (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048fba6
    call FUN_0048e9bf                            # 0048fba9
    test eax, eax                                # 0048fbae
    jne.d8 L_0048fbba                            # 0048fbb0
    # block 0x0048fbb2: entered by fall-through of jne at 0x0048fbb0, 2 instruction(s), calls FUN_0048ea24, falls into the block at 0x0048fbba
    mov ecx, dword ptr [ebp - local_24]          # 0048fbb2
    call FUN_0048ea24                            # 0048fbb5
L_0048fbba:
    # block 0x0048fbba: entered by je at 0x0048fba4; jne at 0x0048fbb0, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d32 L_0049003b                           # 0048fbba
L_0048fbbf:
    # block 0x0048fbbf: entered by switch case, 4 instruction(s), calls FUN_0048ec4a, ends with je to 0x0048fc91 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048fbbf
    call FUN_0048ec4a                            # 0048fbc2
    test eax, eax                                # 0048fbc7
    je.d32 L_0048fc91                            # 0048fbc9
    # block 0x0048fbcf: entered by fall-through of je at 0x0048fbc9, 11 instruction(s), falls into the block at 0x0048fbff
    mov ecx, dword ptr [ebp - local_24]          # 0048fbcf
    mov dword ptr [ecx + field_452], 0x2         # 0048fbd2
    mov edx, dword ptr [ebp - local_10]          # 0048fbdc
    add edx, 0x4                                 # 0048fbdf
    mov dword ptr [ebp - local_5c], edx          # 0048fbe2
    mov eax, dword ptr [ebp - local_24]          # 0048fbe5
    movsx ecx, word ptr [eax + field_3fe]        # 0048fbe8
    imul ecx, ecx, 0x11                          # 0048fbef
    mov edx, dword ptr [ebp - local_24]          # 0048fbf2
    lea eax, [edx + ecx + field_200]             # 0048fbf5
    mov dword ptr [ebp - local_60], eax          # 0048fbfc
L_0048fbff:
    # block 0x0048fbff: entered by jne at 0x0048fc31, 6 instruction(s), ends with jne to 0x0048fc3c (forward)
    mov ecx, dword ptr [ebp - local_60]          # 0048fbff
    mov dl, byte ptr [ecx]                       # 0048fc02
    mov byte ptr [ebp - local_61], dl            # 0048fc04
    mov eax, dword ptr [ebp - local_5c]          # 0048fc07
    cmp dl, byte ptr [eax]                       # 0048fc0a
    jne.d8 L_0048fc3c                            # 0048fc0c
    # block 0x0048fc0e: entered by fall-through of jne at 0x0048fc0c, 2 instruction(s), ends with je to 0x0048fc33 (forward)
    cmp byte ptr [ebp - local_61], 0x0           # 0048fc0e
    je.d8 L_0048fc33                             # 0048fc12
    # block 0x0048fc14: entered by fall-through of je at 0x0048fc12, 6 instruction(s), ends with jne to 0x0048fc3c (forward)
    mov ecx, dword ptr [ebp - local_60]          # 0048fc14
    mov dl, byte ptr [ecx + field_1]             # 0048fc17
    mov byte ptr [ebp - local_62], dl            # 0048fc1a
    mov eax, dword ptr [ebp - local_5c]          # 0048fc1d
    cmp dl, byte ptr [eax + field_1]             # 0048fc20
    jne.d8 L_0048fc3c                            # 0048fc23
    # block 0x0048fc25: entered by fall-through of jne at 0x0048fc23, 4 instruction(s), ends with jne to 0x0048fbff (backward)
    add dword ptr [ebp - local_60], 0x2          # 0048fc25
    add dword ptr [ebp - local_5c], 0x2          # 0048fc29
    cmp byte ptr [ebp - local_62], 0x0           # 0048fc2d
    jne.d8 L_0048fbff                            # 0048fc31
L_0048fc33:
    # block 0x0048fc33: entered by je at 0x0048fc12; fall-through of jne at 0x0048fc31, 2 instruction(s), ends with forward jump to 0x0048fc44
    mov dword ptr [ebp - local_68], 0x0          # 0048fc33
    jmp.d8 L_0048fc44                            # 0048fc3a
L_0048fc3c:
    # block 0x0048fc3c: entered by jne at 0x0048fc0c; jne at 0x0048fc23, 3 instruction(s), falls into the block at 0x0048fc44
    {load} sbb ecx, ecx                          # 0048fc3c
    sbb ecx, -0x1                                # 0048fc3e
    mov dword ptr [ebp - local_68], ecx          # 0048fc41
L_0048fc44:
    # block 0x0048fc44: entered by jmp at 0x0048fc3a, 4 instruction(s), ends with jne to 0x0048fc8f (forward)
    mov edx, dword ptr [ebp - local_68]          # 0048fc44
    mov dword ptr [ebp - local_6c], edx          # 0048fc47
    cmp dword ptr [ebp - local_6c], 0x0          # 0048fc4a
    jne.d8 L_0048fc8f                            # 0048fc4e
    # block 0x0048fc50: entered by fall-through of jne at 0x0048fc4e, 16 instruction(s), falls into the block at 0x0048fc8f
    mov eax, dword ptr [ebp - local_24]          # 0048fc50
    movsx ecx, word ptr [eax + field_3fe]        # 0048fc53
    imul ecx, ecx, 0x11                          # 0048fc5a
    mov edx, dword ptr [ebp - local_24]          # 0048fc5d
    lea edx, [edx + ecx + field_200]             # 0048fc60
    mov eax, dword ptr [ebp - local_24]          # 0048fc67
    movsx ecx, word ptr [eax + field_3fe]        # 0048fc6a
    imul ecx, ecx, 0x11                          # 0048fc71
    mov eax, dword ptr [ebp - local_24]          # 0048fc74
    lea edi, [eax + ecx + field_200]             # 0048fc77
    or ecx, -0x1                                 # 0048fc7e
    {load} xor eax, eax                          # 0048fc81
    repne scasb al, byte ptr es:[edi]            # 0048fc83
    not ecx                                      # 0048fc85
    add ecx, -0x1                                # 0048fc87
    mov byte ptr [edx + ecx - field_minus_1], 0x0 # 0048fc8a
L_0048fc8f:
    # block 0x0048fc8f: entered by jne at 0x0048fc4e, 1 instruction(s), ends with forward jump to 0x0048fc9e
    jmp.d8 L_0048fc9e                            # 0048fc8f
L_0048fc91:
    # block 0x0048fc91: entered by je at 0x0048fbc9, 2 instruction(s), falls into the block at 0x0048fc9e
    mov ecx, dword ptr [ebp - local_24]          # 0048fc91
    mov dword ptr [ecx + field_452], 0x4         # 0048fc94
L_0048fc9e:
    # block 0x0048fc9e: entered by jmp at 0x0048fc8f, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d32 L_0049003b                           # 0048fc9e
L_0048fca3:
    # block 0x0048fca3: entered by switch case, 2 instruction(s), ends with je to 0x0048fcdb (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0048fca3
    je.d8 L_0048fcdb                             # 0048fcaa
    # block 0x0048fcac: entered by fall-through of je at 0x0048fcaa, 12 instruction(s), calls FUN_00448d11, falls into the block at 0x0048fcdb
    push 0x0                                     # 0048fcac
    push -0x1                                    # 0048fcae
    mov edx, dword ptr [ebp - local_24]          # 0048fcb0
    movsx eax, word ptr [edx + field_3fe]        # 0048fcb3
    imul eax, eax, 0xd0                          # 0048fcba
    mov ecx, dword ptr [ebp - local_10]          # 0048fcc0
    lea edx, [ecx + eax + field_123]             # 0048fcc3
    push edx                                     # 0048fcca
    mov eax, dword ptr [0x5d03b3]                # 0048fccb
    push eax                                     # 0048fcd0
    mov ecx, 0x619a05                            # 0048fcd1
    call FUN_00448d11                            # 0048fcd6
L_0048fcdb:
    # block 0x0048fcdb: entered by je at 0x0048fcaa, 10 instruction(s), ends with je to 0x0048fd26 (forward)
    mov edi, 0x54e9e8                            # 0048fcdb
    mov ecx, dword ptr [ebp - local_24]          # 0048fce0
    movsx edx, word ptr [ecx + field_3fe]        # 0048fce3
    imul edx, edx, 0xd0                          # 0048fcea
    mov eax, dword ptr [ebp - local_10]          # 0048fcf0
    lea esi, [eax + edx + field_100]             # 0048fcf3
    mov ecx, 0x9                                 # 0048fcfa
    {load} xor edx, edx                          # 0048fcff
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048fd01
    je.d8 L_0048fd26                             # 0048fd03
    # block 0x0048fd05: entered by fall-through of je at 0x0048fd03, 8 instruction(s), calls FUN_0048efe8, FUN_0048ef40, ends with forward jump to 0x0048fd6a
    push 0x1                                     # 0048fd05
    mov ecx, dword ptr [ebp - local_24]          # 0048fd07
    call FUN_0048efe8                            # 0048fd0a
    mov eax, dword ptr [ebp - local_24]          # 0048fd0f
    mov dword ptr [eax + field_452], 0x3         # 0048fd12
    mov ecx, dword ptr [ebp - local_24]          # 0048fd1c
    call FUN_0048ef40                            # 0048fd1f
    jmp.d8 L_0048fd6a                            # 0048fd24
L_0048fd26:
    # block 0x0048fd26: entered by je at 0x0048fd03, 11 instruction(s), calls FUN_0048ef40, FUN_0048e9bf, ends with je to 0x0048fd5d (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0048fd26
    call FUN_0048ef40                            # 0048fd29
    mov ecx, dword ptr [ebp - local_24]          # 0048fd2e
    call FUN_0048e9bf                            # 0048fd31
    mov ecx, dword ptr [ebp - local_24]          # 0048fd36
    mov byte ptr [ecx + field_45a], al           # 0048fd39
    mov edx, dword ptr [ebp - local_24]          # 0048fd3f
    {load} xor eax, eax                          # 0048fd42
    mov al, byte ptr [edx + field_45a]           # 0048fd44
    test eax, eax                                # 0048fd4a
    je.d8 L_0048fd5d                             # 0048fd4c
    # block 0x0048fd4e: entered by fall-through of je at 0x0048fd4c, 3 instruction(s), ends with forward jump to 0x0048fd6a
    mov ecx, dword ptr [ebp - local_24]          # 0048fd4e
    mov dword ptr [ecx + field_452], 0x6         # 0048fd51
    jmp.d8 L_0048fd6a                            # 0048fd5b
L_0048fd5d:
    # block 0x0048fd5d: entered by je at 0x0048fd4c, 2 instruction(s), falls into the block at 0x0048fd6a
    mov edx, dword ptr [ebp - local_24]          # 0048fd5d
    mov dword ptr [edx + field_452], 0x0         # 0048fd60
L_0048fd6a:
    # block 0x0048fd6a: entered by jmp at 0x0048fd24; jmp at 0x0048fd5b, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d32 L_0049003b                           # 0048fd6a
L_0048fd6f:
    # block 0x0048fd6f: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048fdff (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048fd6f
    movsx ecx, word ptr [eax + field_421]        # 0048fd72
    mov dword ptr [ebp - local_18], ecx          # 0048fd79
    mov edx, dword ptr [ebp - local_18]          # 0048fd7c
    push edx                                     # 0048fd7f
    mov ecx, 0x5cf1eb                            # 0048fd80
    call FUN_004f6334                            # 0048fd85
    test eax, eax                                # 0048fd8a
    jne.d8 L_0048fdff                            # 0048fd8c
    # block 0x0048fd8e: entered by fall-through of jne at 0x0048fd8c, 14 instruction(s), calls FUN_004fba69, FUN_0048e9bf, ends with je to 0x0048fdd0 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048fd8e
    add eax, 0x400                               # 0048fd91
    push eax                                     # 0048fd96
    mov ecx, 0x5c3a67                            # 0048fd97
    call FUN_004fba69                            # 0048fd9c
    mov ecx, dword ptr [ebp - local_24]          # 0048fda1
    call FUN_0048e9bf                            # 0048fda4
    mov ecx, dword ptr [ebp - local_24]          # 0048fda9
    mov byte ptr [ecx + field_45a], al           # 0048fdac
    mov edx, dword ptr [ebp - local_24]          # 0048fdb2
    {load} xor eax, eax                          # 0048fdb5
    mov al, byte ptr [edx + field_45a]           # 0048fdb7
    test eax, eax                                # 0048fdbd
    je.d8 L_0048fdd0                             # 0048fdbf
    # block 0x0048fdc1: entered by fall-through of je at 0x0048fdbf, 3 instruction(s), ends with forward jump to 0x0048fddd
    mov ecx, dword ptr [ebp - local_24]          # 0048fdc1
    mov dword ptr [ecx + field_452], 0x6         # 0048fdc4
    jmp.d8 L_0048fddd                            # 0048fdce
L_0048fdd0:
    # block 0x0048fdd0: entered by je at 0x0048fdbf, 2 instruction(s), falls into the block at 0x0048fddd
    mov edx, dword ptr [ebp - local_24]          # 0048fdd0
    mov dword ptr [edx + field_452], 0x0         # 0048fdd3
L_0048fddd:
    # block 0x0048fddd: entered by jmp at 0x0048fdce, 2 instruction(s), ends with je to 0x0048fdff (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0048fddd
    je.d8 L_0048fdff                             # 0048fde4
    # block 0x0048fde6: entered by fall-through of je at 0x0048fde4, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x0048fdff
    push 0x0                                     # 0048fde6
    push -0x1                                    # 0048fde8
    push 0x54e9f4                                # 0048fdea
    mov eax, dword ptr [0x5d03b3]                # 0048fdef
    push eax                                     # 0048fdf4
    mov ecx, 0x619a05                            # 0048fdf5
    call FUN_00448d11                            # 0048fdfa
L_0048fdff:
    # block 0x0048fdff: entered by jne at 0x0048fd8c; je at 0x0048fde4, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d32 L_0049003b                           # 0048fdff
L_0048fe04:
    # block 0x0048fe04: entered by switch case, 2 instruction(s), ends with je to 0x0048fe3d (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0048fe04
    je.d8 L_0048fe3d                             # 0048fe0b
    # block 0x0048fe0d: entered by fall-through of je at 0x0048fe0b, 12 instruction(s), calls FUN_00448d11, falls into the block at 0x0048fe3d
    push 0x0                                     # 0048fe0d
    push -0x1                                    # 0048fe0f
    mov ecx, dword ptr [ebp - local_24]          # 0048fe11
    movsx edx, word ptr [ecx + field_3fe]        # 0048fe14
    imul edx, edx, 0xd0                          # 0048fe1b
    mov eax, dword ptr [ebp - local_10]          # 0048fe21
    lea ecx, [eax + edx + field_164]             # 0048fe24
    push ecx                                     # 0048fe2b
    mov edx, dword ptr [0x5d03b3]                # 0048fe2c
    push edx                                     # 0048fe32
    mov ecx, 0x619a05                            # 0048fe33
    call FUN_00448d11                            # 0048fe38
L_0048fe3d:
    # block 0x0048fe3d: entered by je at 0x0048fe0b, 10 instruction(s), ends with je to 0x0048fe80 (forward)
    mov edi, 0x54e9fc                            # 0048fe3d
    mov eax, dword ptr [ebp - local_24]          # 0048fe42
    movsx ecx, word ptr [eax + field_3fe]        # 0048fe45
    imul ecx, ecx, 0xd0                          # 0048fe4c
    mov edx, dword ptr [ebp - local_10]          # 0048fe52
    lea esi, [edx + ecx + field_141]             # 0048fe55
    mov ecx, 0x9                                 # 0048fe5c
    {load} xor eax, eax                          # 0048fe61
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048fe63
    je.d8 L_0048fe80                             # 0048fe65
    # block 0x0048fe67: entered by fall-through of je at 0x0048fe65, 6 instruction(s), calls FUN_0048efe8, ends with forward jump to 0x0048feb4
    push 0x0                                     # 0048fe67
    mov ecx, dword ptr [ebp - local_24]          # 0048fe69
    call FUN_0048efe8                            # 0048fe6c
    mov ecx, dword ptr [ebp - local_24]          # 0048fe71
    mov dword ptr [ecx + field_452], 0x5         # 0048fe74
    jmp.d8 L_0048feb4                            # 0048fe7e
L_0048fe80:
    # block 0x0048fe80: entered by je at 0x0048fe65, 13 instruction(s), falls into the block at 0x0048feb4
    {load} xor edx, edx                          # 0048fe80
    mov eax, dword ptr [ebp - local_24]          # 0048fe82
    movsx ecx, word ptr [eax + field_3fe]        # 0048fe85
    imul ecx, ecx, 0x11                          # 0048fe8c
    mov eax, dword ptr [ebp - local_24]          # 0048fe8f
    lea ecx, [eax + ecx + field_200]             # 0048fe92
    mov dword ptr [ecx], edx                     # 0048fe99
    mov dword ptr [ecx + field_4], edx           # 0048fe9b
    mov dword ptr [ecx + field_8], edx           # 0048fe9e
    mov dword ptr [ecx + field_c], edx           # 0048fea1
    mov byte ptr [ecx + field_10], dl            # 0048fea4
    mov edx, dword ptr [ebp - local_24]          # 0048fea7
    mov dword ptr [edx + field_452], 0x0         # 0048feaa
L_0048feb4:
    # block 0x0048feb4: entered by jmp at 0x0048fe7e, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d32 L_0049003b                           # 0048feb4
L_0048feb9:
    # block 0x0048feb9: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x0048ff42 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048feb9
    movsx ecx, word ptr [eax + field_421]        # 0048febc
    mov dword ptr [ebp - local_1c], ecx          # 0048fec3
    mov edx, dword ptr [ebp - local_1c]          # 0048fec6
    push edx                                     # 0048fec9
    mov ecx, 0x5cf1eb                            # 0048feca
    call FUN_004f6334                            # 0048fecf
    test eax, eax                                # 0048fed4
    jne.d8 L_0048ff42                            # 0048fed6
    # block 0x0048fed8: entered by fall-through of jne at 0x0048fed6, 20 instruction(s), calls FUN_004fba69, ends with je to 0x0048ff42 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0048fed8
    add eax, 0x400                               # 0048fedb
    push eax                                     # 0048fee0
    mov ecx, 0x5c3a67                            # 0048fee1
    call FUN_004fba69                            # 0048fee6
    {load} xor ecx, ecx                          # 0048feeb
    mov edx, dword ptr [ebp - local_24]          # 0048feed
    movsx eax, word ptr [edx + field_3fe]        # 0048fef0
    imul eax, eax, 0x11                          # 0048fef7
    mov edx, dword ptr [ebp - local_24]          # 0048fefa
    lea eax, [edx + eax + field_200]             # 0048fefd
    mov dword ptr [eax], ecx                     # 0048ff04
    mov dword ptr [eax + field_4], ecx           # 0048ff06
    mov dword ptr [eax + field_8], ecx           # 0048ff09
    mov dword ptr [eax + field_c], ecx           # 0048ff0c
    mov byte ptr [eax + field_10], cl            # 0048ff0f
    mov ecx, dword ptr [ebp - local_24]          # 0048ff12
    mov dword ptr [ecx + field_452], 0x0         # 0048ff15
    cmp dword ptr [0x5bb202], 0x0                # 0048ff1f
    je.d8 L_0048ff42                             # 0048ff26
    # block 0x0048ff28: entered by fall-through of je at 0x0048ff26, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x0048ff42
    push 0x0                                     # 0048ff28
    push -0x1                                    # 0048ff2a
    push 0x54ea08                                # 0048ff2c
    mov edx, dword ptr [0x5d03b3]                # 0048ff31
    push edx                                     # 0048ff37
    mov ecx, 0x619a05                            # 0048ff38
    call FUN_00448d11                            # 0048ff3d
L_0048ff42:
    # block 0x0048ff42: entered by jne at 0x0048fed6; je at 0x0048ff26, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d32 L_0049003b                           # 0048ff42
L_0048ff47:
    # block 0x0048ff47: entered by switch case, 2 instruction(s), ends with je to 0x0048ff6c (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0048ff47
    je.d8 L_0048ff6c                             # 0048ff4e
    # block 0x0048ff50: entered by fall-through of je at 0x0048ff4e, 9 instruction(s), calls FUN_00448d11, falls into the block at 0x0048ff6c
    push 0x0                                     # 0048ff50
    push -0x1                                    # 0048ff52
    mov eax, dword ptr [ebp - local_10]          # 0048ff54
    add eax, 0x63                                # 0048ff57
    push eax                                     # 0048ff5a
    mov ecx, dword ptr [0x5d03b3]                # 0048ff5b
    push ecx                                     # 0048ff61
    mov ecx, 0x619a05                            # 0048ff62
    call FUN_00448d11                            # 0048ff67
L_0048ff6c:
    # block 0x0048ff6c: entered by je at 0x0048ff4e, 7 instruction(s), ends with je to 0x0048ffa3 (forward)
    mov edi, 0x54ea10                            # 0048ff6c
    mov esi, dword ptr [ebp - local_10]          # 0048ff71
    add esi, 0x32                                # 0048ff74
    mov ecx, 0x9                                 # 0048ff77
    {load} xor edx, edx                          # 0048ff7c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0048ff7e
    je.d8 L_0048ffa3                             # 0048ff80
    # block 0x0048ff82: entered by fall-through of je at 0x0048ff80, 8 instruction(s), calls FUN_004fb2e3, ends with forward jump to 0x0048ffba
    mov eax, dword ptr [ebp - local_10]          # 0048ff82
    mov cx, word ptr [eax + field_53]            # 0048ff85
    push ecx                                     # 0048ff89
    mov ecx, 0x5c3a67                            # 0048ff8a
    call FUN_004fb2e3                            # 0048ff8f
    mov edx, dword ptr [ebp - local_24]          # 0048ff94
    mov dword ptr [edx + field_452], 0x7         # 0048ff97
    jmp.d8 L_0048ffba                            # 0048ffa1
L_0048ffa3:
    # block 0x0048ffa3: entered by je at 0x0048ff80, 4 instruction(s), falls into the block at 0x0048ffba
    mov eax, dword ptr [ebp - local_24]          # 0048ffa3
    movsx ecx, word ptr [eax + field_1e]         # 0048ffa6
    imul ecx, ecx, 0x8d                          # 0048ffaa
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0048ffb0
L_0048ffba:
    # block 0x0048ffba: entered by jmp at 0x0048ffa1, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d8 L_0049003b                            # 0048ffba
L_0048ffbc:
    # block 0x0048ffbc: entered by switch case, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x00490022 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0048ffbc
    movsx eax, word ptr [edx + field_53]         # 0048ffbf
    mov dword ptr [ebp - local_20], eax          # 0048ffc3
    mov ecx, dword ptr [ebp - local_20]          # 0048ffc6
    push ecx                                     # 0048ffc9
    mov ecx, 0x5cf1eb                            # 0048ffca
    call FUN_004f6334                            # 0048ffcf
    test eax, eax                                # 0048ffd4
    jne.d8 L_00490022                            # 0048ffd6
    # block 0x0048ffd8: entered by fall-through of jne at 0x0048ffd6, 7 instruction(s), calls FUN_004fba69, ends with je to 0x0049000b (forward)
    mov edx, dword ptr [ebp - local_10]          # 0048ffd8
    add edx, 0x32                                # 0048ffdb
    push edx                                     # 0048ffde
    mov ecx, 0x5c3a67                            # 0048ffdf
    call FUN_004fba69                            # 0048ffe4
    cmp dword ptr [0x5bb202], 0x0                # 0048ffe9
    je.d8 L_0049000b                             # 0048fff0
    # block 0x0048fff2: entered by fall-through of je at 0x0048fff0, 7 instruction(s), calls FUN_00448d11, falls into the block at 0x0049000b
    push 0x0                                     # 0048fff2
    push -0x1                                    # 0048fff4
    push 0x54ea1c                                # 0048fff6
    mov eax, dword ptr [0x5d03b3]                # 0048fffb
    push eax                                     # 00490000
    mov ecx, 0x619a05                            # 00490001
    call FUN_00448d11                            # 00490006
L_0049000b:
    # block 0x0049000b: entered by je at 0x0048fff0, 4 instruction(s), falls into the block at 0x00490022
    mov ecx, dword ptr [ebp - local_24]          # 0049000b
    movsx edx, word ptr [ecx + field_1e]         # 0049000e
    imul edx, edx, 0x8d                          # 00490012
    mov dword ptr [edx + 0x5bb632], 0x2          # 00490018
L_00490022:
    # block 0x00490022: entered by jne at 0x0048ffd6, 1 instruction(s), ends with forward jump to 0x0049003b
    jmp.d8 L_0049003b                            # 00490022
L_00490024:
    # block 0x00490024: entered by switch case, 4 instruction(s), falls into the block at 0x0049003b
    mov eax, dword ptr [ebp - local_24]          # 00490024
    movsx ecx, word ptr [eax + field_1e]         # 00490027
    imul ecx, ecx, 0x8d                          # 0049002b
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00490031
L_0049003b:
    # block 0x0049003b: entered by ja at 0x0048f784; jmp at 0x0048fbba; jmp at 0x0048fc9e; jmp at 0x0048fd6a; more, 1 instruction(s), ends with forward jump to 0x00490240
    jmp.d32 L_00490240                           # 0049003b
L_00490040:
    # block 0x00490040: entered by je at 0x0048f1c6, 11 instruction(s), calls FUN_004c92c5, ends with je to 0x0049015c (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 00490040
    mov edx, dword ptr [ebp - local_10]          # 0049004a
    mov ax, word ptr [edx]                       # 0049004d
    push eax                                     # 00490050
    mov ecx, 0x5cf659                            # 00490051
    call FUN_004c92c5                            # 00490056
    mov ecx, dword ptr [ebp - local_24]          # 0049005b
    {load} xor edx, edx                          # 0049005e
    mov dl, byte ptr [ecx + field_451]           # 00490060
    test edx, edx                                # 00490066
    je.d32 L_0049015c                            # 00490068
    # block 0x0049006e: entered by fall-through of je at 0x00490068, 4 instruction(s), ends with je to 0x00490120 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0049006e
    movsx ecx, word ptr [eax + field_81]         # 00490071
    cmp ecx, 0x270f                              # 00490078
    je.d32 L_00490120                            # 0049007e
    # block 0x00490084: entered by fall-through of je at 0x0049007e, 25 instruction(s), ends with jne to 0x0049010c (forward)
    mov edx, dword ptr [ebp - local_10]          # 00490084
    movsx eax, word ptr [edx + field_81]         # 00490087
    mov dword ptr [0x5bb57b], eax                # 0049008e
    mov ecx, dword ptr [ebp - local_10]          # 00490093
    mov dx, word ptr [ecx + field_83]            # 00490096
    mov word ptr [0x5bb599], dx                  # 0049009d
    mov eax, dword ptr [ebp - local_10]          # 004900a4
    mov cx, word ptr [eax + field_85]            # 004900a7
    mov word ptr [0x5bb595], cx                  # 004900ae
    mov edx, dword ptr [ebp - local_10]          # 004900b5
    mov ax, word ptr [edx + field_87]            # 004900b8
    mov word ptr [0x5c39ff], ax                  # 004900bf
    mov ecx, dword ptr [ebp - local_10]          # 004900c5
    mov edx, dword ptr [ecx + field_89]          # 004900c8
    mov dword ptr [0x5bb59b], edx                # 004900ce
    mov eax, dword ptr [ebp - local_10]          # 004900d4
    mov ecx, dword ptr [eax + field_8d]          # 004900d7
    mov dword ptr [0x5bb59f], ecx                # 004900dd
    mov edx, dword ptr [ebp - local_10]          # 004900e3
    mov eax, dword ptr [edx + field_91]          # 004900e6
    mov dword ptr [0x5bb5a3], eax                # 004900ec
    mov ecx, dword ptr [ebp - local_10]          # 004900f1
    movsx edx, word ptr [ecx + field_95]         # 004900f4
    cmp edx, 0x1                                 # 004900fb
    jne.d8 L_0049010c                            # 004900fe
    # block 0x00490100: entered by fall-through of jne at 0x004900fe, 2 instruction(s), ends with forward jump to 0x00490116
    mov dword ptr [0x5bb1ca], 0x0                # 00490100
    jmp.d8 L_00490116                            # 0049010a
L_0049010c:
    # block 0x0049010c: entered by jne at 0x004900fe, 1 instruction(s), falls into the block at 0x00490116
    mov dword ptr [0x5bb1ca], 0x1                # 0049010c
L_00490116:
    # block 0x00490116: entered by jmp at 0x0049010a, 1 instruction(s), falls into the block at 0x00490120
    mov dword ptr [0x583999], 0x4                # 00490116
L_00490120:
    # block 0x00490120: entered by je at 0x0049007e, 4 instruction(s), ends with je to 0x00490157 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00490120
    movsx ecx, word ptr [eax + field_97]         # 00490123
    cmp ecx, -0x1                                # 0049012a
    je.d8 L_00490157                             # 0049012d
    # block 0x0049012f: entered by fall-through of je at 0x0049012d, 4 instruction(s), calls FUN_0048e9bf, ends with jne to 0x00490157 (forward)
    mov ecx, dword ptr [ebp - local_24]          # 0049012f
    call FUN_0048e9bf                            # 00490132
    test eax, eax                                # 00490137
    jne.d8 L_00490157                            # 00490139
    # block 0x0049013b: entered by fall-through of jne at 0x00490139, 6 instruction(s), falls into the block at 0x00490157
    mov edx, dword ptr [ebp - local_10]          # 0049013b
    {load} xor eax, eax                          # 0049013e
    mov al, byte ptr [edx + field_99]            # 00490140
    mov ecx, dword ptr [ebp - local_10]          # 00490146
    movsx edx, word ptr [ecx + field_97]         # 00490149
    mov dword ptr [4*edx + 0x585801], eax        # 00490150
L_00490157:
    # block 0x00490157: entered by je at 0x0049012d; jne at 0x00490139, 1 instruction(s), ends with forward jump to 0x00490228
    jmp.d32 L_00490228                           # 00490157
L_0049015c:
    # block 0x0049015c: entered by je at 0x00490068, 5 instruction(s), ends with je to 0x00490228 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0049015c
    {load} xor ecx, ecx                          # 0049015f
    mov cl, byte ptr [eax + field_45a]           # 00490161
    test ecx, ecx                                # 00490167
    je.d32 L_00490228                            # 00490169
    # block 0x0049016f: entered by fall-through of je at 0x00490169, 4 instruction(s), ends with je to 0x00490206 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0049016f
    movsx eax, word ptr [edx + field_19]         # 00490172
    cmp eax, 0x270f                              # 00490176
    je.d32 L_00490206                            # 0049017b
    # block 0x00490181: entered by fall-through of je at 0x0049017b, 25 instruction(s), ends with jne to 0x004901f2 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00490181
    movsx edx, word ptr [ecx + field_19]         # 00490184
    mov dword ptr [0x5bb57b], edx                # 00490188
    mov eax, dword ptr [ebp - local_10]          # 0049018e
    mov cx, word ptr [eax + field_1b]            # 00490191
    mov word ptr [0x5bb599], cx                  # 00490195
    mov edx, dword ptr [ebp - local_10]          # 0049019c
    mov ax, word ptr [edx + field_1d]            # 0049019f
    mov word ptr [0x5bb595], ax                  # 004901a3
    mov ecx, dword ptr [ebp - local_10]          # 004901a9
    mov dx, word ptr [ecx + field_1f]            # 004901ac
    mov word ptr [0x5c39ff], dx                  # 004901b0
    mov eax, dword ptr [ebp - local_10]          # 004901b7
    mov ecx, dword ptr [eax + field_21]          # 004901ba
    mov dword ptr [0x5bb59b], ecx                # 004901bd
    mov edx, dword ptr [ebp - local_10]          # 004901c3
    mov eax, dword ptr [edx + field_25]          # 004901c6
    mov dword ptr [0x5bb59f], eax                # 004901c9
    mov ecx, dword ptr [ebp - local_10]          # 004901ce
    mov edx, dword ptr [ecx + field_29]          # 004901d1
    mov dword ptr [0x5bb5a3], edx                # 004901d4
    mov eax, dword ptr [ebp - local_10]          # 004901da
    movsx ecx, word ptr [eax + field_2d]         # 004901dd
    cmp ecx, 0x1                                 # 004901e1
    jne.d8 L_004901f2                            # 004901e4
    # block 0x004901e6: entered by fall-through of jne at 0x004901e4, 2 instruction(s), ends with forward jump to 0x004901fc
    mov dword ptr [0x5bb1ca], 0x0                # 004901e6
    jmp.d8 L_004901fc                            # 004901f0
L_004901f2:
    # block 0x004901f2: entered by jne at 0x004901e4, 1 instruction(s), falls into the block at 0x004901fc
    mov dword ptr [0x5bb1ca], 0x1                # 004901f2
L_004901fc:
    # block 0x004901fc: entered by jmp at 0x004901f0, 1 instruction(s), falls into the block at 0x00490206
    mov dword ptr [0x583999], 0x4                # 004901fc
L_00490206:
    # block 0x00490206: entered by je at 0x0049017b, 4 instruction(s), ends with je to 0x00490228 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00490206
    movsx eax, word ptr [edx + field_2f]         # 00490209
    cmp eax, -0x1                                # 0049020d
    je.d8 L_00490228                             # 00490210
    # block 0x00490212: entered by fall-through of je at 0x00490210, 6 instruction(s), falls into the block at 0x00490228
    mov ecx, dword ptr [ebp - local_10]          # 00490212
    {load} xor edx, edx                          # 00490215
    mov dl, byte ptr [ecx + field_31]            # 00490217
    mov eax, dword ptr [ebp - local_10]          # 0049021a
    movsx ecx, word ptr [eax + field_2f]         # 0049021d
    mov dword ptr [4*ecx + 0x585801], edx        # 00490221
L_00490228:
    # block 0x00490228: entered by jmp at 0x00490157; je at 0x00490169; je at 0x00490210, 7 instruction(s), calls FUN_0042ba3a, FUN_0048e2f5, falls into the block at 0x00490240
    mov edx, dword ptr [ebp - local_24]          # 00490228
    mov ax, word ptr [edx + field_1e]            # 0049022b
    push eax                                     # 0049022f
    call FUN_0042ba3a                            # 00490230
    add esp, 0x4                                 # 00490235
    mov ecx, dword ptr [ebp - local_24]          # 00490238
    call FUN_0048e2f5                            # 0049023b
L_00490240:
    # block 0x00490240: entered by jmp at 0x0048f1cc; jmp at 0x0048f718; jmp at 0x0049003b, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00490240
    pop esi                                      # 00490241
    {load} mov esp, ebp                          # 00490242
    pop ebp                                      # 00490244
    ret 0x4                                      # 00490245

# --- data items (not part of the function) -------------------------
.org 0x00490248 - 0x401000
SWTAB_00490248:  # 9 case address(es)
    .long L_0048f794 - .text + 0x401000
    .long L_0048fbbf - .text + 0x401000
    .long L_0048fca3 - .text + 0x401000
    .long L_0048fd6f - .text + 0x401000
    .long L_0048fe04 - .text + 0x401000
    .long L_0048feb9 - .text + 0x401000
    .long L_0048ff47 - .text + 0x401000
    .long L_0048ffbc - .text + 0x401000
    .long L_00490024 - .text + 0x401000
.set SWTAB_00490248_VA, SWTAB_00490248 - .text + 0x401000

