# FUN_004c0f70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0f70
# extent:       0x004c0f70-0x004c139a (1066 code bytes)
# span:         0x004c0f70-0x004c139a (code 1066, tables 0, padding 0)
# sha256:       b5b277de1c258e3159144f0e70b9c5c9e298d67c2a0f3d1503bbd8b549dc7564
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0f70
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_c, field_c52, field_c5e, field_c6a, field_c72, field_cd6, field_d2e, field_d36, field_d5a, field_d62, field_d6a, field_d6e and 5 more; [ecx + n] field_4, field_46, field_c4a, field_c56, field_c62, field_c6e, field_cd2, field_d22, field_d26, field_d32, field_d3a, field_d72 and 6 more; [edx + n] field_4, field_8, field_c, field_14, field_c4e, field_c5a, field_c66, field_d1e, field_d2a, field_d56, field_d5e, field_d66 and 6 more
# callees:      calls FUN_0043ef10, FUN_004c94ec, FUN_0051dc43, FUN_004264e8, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m426520_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 218 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_46, 0x46  # offset +0x46
.equ field_c4a, 0xc4a  # offset +0xc4a
.equ field_c4e, 0xc4e  # offset +0xc4e
.equ field_c52, 0xc52  # offset +0xc52
.equ field_c56, 0xc56  # offset +0xc56
.equ field_c5a, 0xc5a  # offset +0xc5a
.equ field_c5e, 0xc5e  # offset +0xc5e
.equ field_c62, 0xc62  # offset +0xc62
.equ field_c66, 0xc66  # offset +0xc66
.equ field_c6a, 0xc6a  # offset +0xc6a
.equ field_c6e, 0xc6e  # offset +0xc6e
.equ field_c72, 0xc72  # offset +0xc72
.equ field_cd2, 0xcd2  # offset +0xcd2
.equ field_cd6, 0xcd6  # offset +0xcd6
.equ field_d1e, 0xd1e  # offset +0xd1e
.equ field_d22, 0xd22  # offset +0xd22
.equ field_d26, 0xd26  # offset +0xd26
.equ field_d2a, 0xd2a  # offset +0xd2a
.equ field_d2e, 0xd2e  # offset +0xd2e
.equ field_d32, 0xd32  # offset +0xd32
.equ field_d36, 0xd36  # offset +0xd36
.equ field_d3a, 0xd3a  # offset +0xd3a
.equ field_d56, 0xd56  # offset +0xd56
.equ field_d5a, 0xd5a  # offset +0xd5a
.equ field_d5e, 0xd5e  # offset +0xd5e
.equ field_d62, 0xd62  # offset +0xd62
.equ field_d66, 0xd66  # offset +0xd66
.equ field_d6a, 0xd6a  # offset +0xd6a
.equ field_d6e, 0xd6e  # offset +0xd6e
.equ field_d72, 0xd72  # offset +0xd72
.equ field_d76, 0xd76  # offset +0xd76
.equ field_d7a, 0xd7a  # offset +0xd7a
.equ field_d7e, 0xd7e  # offset +0xd7e
.equ field_d82, 0xd82  # offset +0xd82
.equ field_d86, 0xd86  # offset +0xd86
.equ field_e86, 0xe86  # offset +0xe86
.equ field_175c, 0x175c  # offset +0x175c
.equ field_1f24, 0x1f24  # offset +0x1f24
.equ field_1f28, 0x1f28  # offset +0x1f28
.equ field_1f2c, 0x1f2c  # offset +0x1f2c
.equ field_1f30, 0x1f30  # offset +0x1f30
.equ field_1f34, 0x1f34  # offset +0x1f34
.equ field_38a8, 0x38a8  # offset +0x38a8
.equ field_38b0, 0x38b0  # offset +0x38b0

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0043ef10, .text + (0x0043ef10 - 0x401000)
.set FUN_004c94ec, .text + (0x004c94ec - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004c0f70 - 0x401000
.globl FUN_004c0f70
FUN_004c0f70:
    # block 0x004c0f70: entry, 29 instruction(s), calls FUN_0043ef10, ends with forward jump to 0x004c0ff7
    push ebp                                     # 004c0f70
    {load} mov ebp, esp                          # 004c0f71
    push -0x1                                    # 004c0f73
    push 0x5287c8                                # 004c0f75
    mov eax, dword ptr fs:[0x0]                  # 004c0f7a
    push eax                                     # 004c0f80
    mov dword ptr fs:[0x0], esp                  # 004c0f81
    sub esp, 0x10                                # 004c0f88
    push edi                                     # 004c0f8b
    mov dword ptr [ebp - local_1c], ecx          # 004c0f8c
    mov dword ptr [ebp - local_4], 0x0           # 004c0f8f
    mov ecx, dword ptr [ebp - local_1c]          # 004c0f96
    add ecx, 0x38cc                              # 004c0f99
    call FUN_0043ef10                            # 004c0f9f
    mov byte ptr [ebp - local_4], 0x1            # 004c0fa4
    mov eax, dword ptr [ebp - local_1c]          # 004c0fa8
    mov dword ptr [eax], 0x52e230                # 004c0fab
    mov ecx, dword ptr [ebp - local_1c]          # 004c0fb1
    mov dword ptr [ecx + field_4], 0x0           # 004c0fb4
    mov edx, dword ptr [ebp - local_1c]          # 004c0fbb
    mov dword ptr [edx + field_8], 0x0           # 004c0fbe
    mov eax, dword ptr [ebp - local_1c]          # 004c0fc5
    mov dword ptr [eax + field_c], 0x0           # 004c0fc8
    mov ecx, dword ptr [ebp - local_1c]          # 004c0fcf
    mov dword ptr [ecx + field_46], 0x0          # 004c0fd2
    mov edx, dword ptr [ebp - local_1c]          # 004c0fd9
    mov dword ptr [edx + field_14], 0x0          # 004c0fdc
    mov word ptr [ebp - local_10], 0x0           # 004c0fe3
    jmp.d8 L_004c0ff7                            # 004c0fe9
L_004c0feb:
    # block 0x004c0feb: entered by jmp at 0x004c1012, 3 instruction(s), falls into the block at 0x004c0ff7
    mov ax, word ptr [ebp - local_10]            # 004c0feb
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c0fef
    mov word ptr [ebp - local_10], ax            # 004c0ff3
L_004c0ff7:
    # block 0x004c0ff7: entered by jmp at 0x004c0fe9, 3 instruction(s), ends with jge to 0x004c1014 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004c0ff7
    cmp ecx, 0x18                                # 004c0ffb
    jge.d8 L_004c1014                            # 004c0ffe
    # block 0x004c1000: entered by fall-through of jge at 0x004c0ffe, 4 instruction(s), ends with backward jump to 0x004c0feb
    movsx edx, word ptr [ebp - local_10]         # 004c1000
    mov eax, dword ptr [ebp - local_1c]          # 004c1004
    mov dword ptr [eax + 4*edx + field_c72], 0x0 # 004c1007
    jmp.d8 L_004c0feb                            # 004c1012
L_004c1014:
    # block 0x004c1014: entered by jge at 0x004c0ffe, 48 instruction(s), ends with forward jump to 0x004c1153
    mov ecx, dword ptr [ebp - local_1c]          # 004c1014
    mov dword ptr [ecx + field_cd2], 0x0         # 004c1017
    mov edx, dword ptr [ebp - local_1c]          # 004c1021
    mov dword ptr [edx + field_d1e], 0x0         # 004c1024
    mov eax, dword ptr [ebp - local_1c]          # 004c102e
    mov dword ptr [eax + field_d62], 0x0         # 004c1031
    mov ecx, dword ptr [ebp - local_1c]          # 004c103b
    mov dword ptr [ecx + field_d76], 0x0         # 004c103e
    mov edx, dword ptr [ebp - local_1c]          # 004c1048
    mov dword ptr [edx + field_d7a], 0x0         # 004c104b
    mov eax, dword ptr [ebp - local_1c]          # 004c1055
    mov dword ptr [eax + field_d7e], 0x0         # 004c1058
    mov ecx, dword ptr [ebp - local_1c]          # 004c1062
    mov dword ptr [ecx + field_d82], 0x0         # 004c1065
    mov edx, dword ptr [ebp - local_1c]          # 004c106f
    mov dword ptr [edx + field_d86], 0x0         # 004c1072
    mov eax, dword ptr [ebp - local_1c]          # 004c107c
    mov dword ptr [eax + field_d6e], 0x0         # 004c107f
    mov ecx, dword ptr [ebp - local_1c]          # 004c1089
    mov dword ptr [ecx + field_d72], 0x0         # 004c108c
    mov edx, dword ptr [ebp - local_1c]          # 004c1096
    mov dword ptr [edx + field_d66], 0x0         # 004c1099
    mov eax, dword ptr [ebp - local_1c]          # 004c10a3
    mov dword ptr [eax + field_d6a], 0x0         # 004c10a6
    mov ecx, dword ptr [ebp - local_1c]          # 004c10b0
    mov dword ptr [ecx + field_d22], 0x0         # 004c10b3
    mov edx, dword ptr [ebp - local_1c]          # 004c10bd
    mov dword ptr [edx + field_d5e], 0x0         # 004c10c0
    mov eax, dword ptr [ebp - local_1c]          # 004c10ca
    mov dword ptr [eax + field_d36], 0x0         # 004c10cd
    mov ecx, dword ptr [ebp - local_1c]          # 004c10d7
    mov dword ptr [ecx + field_d3a], 0x0         # 004c10da
    mov edx, dword ptr [ebp - local_1c]          # 004c10e4
    mov dword ptr [edx + field_d56], 0x0         # 004c10e7
    mov eax, dword ptr [ebp - local_1c]          # 004c10f1
    mov dword ptr [eax + field_d5a], 0x0         # 004c10f4
    mov ecx, dword ptr [ebp - local_1c]          # 004c10fe
    mov dword ptr [ecx + field_d26], 0x0         # 004c1101
    mov edx, dword ptr [ebp - local_1c]          # 004c110b
    mov dword ptr [edx + field_d2a], 0x0         # 004c110e
    mov eax, dword ptr [ebp - local_1c]          # 004c1118
    mov dword ptr [eax + field_d2e], 0x0         # 004c111b
    mov ecx, dword ptr [ebp - local_1c]          # 004c1125
    mov dword ptr [ecx + field_d32], 0x0         # 004c1128
    mov edx, dword ptr [ebp - local_1c]          # 004c1132
    mov dword ptr [edx + field_38a8], 0x0        # 004c1135
    mov word ptr [ebp - local_10], 0x0           # 004c113f
    jmp.d8 L_004c1153                            # 004c1145
L_004c1147:
    # block 0x004c1147: entered by jmp at 0x004c116e, 3 instruction(s), falls into the block at 0x004c1153
    mov ax, word ptr [ebp - local_10]            # 004c1147
    .insn 0x66, 0x05, 0x0001{:u16}               # 004c114b
    mov word ptr [ebp - local_10], ax            # 004c114f
L_004c1153:
    # block 0x004c1153: entered by jmp at 0x004c1145, 3 instruction(s), ends with jge to 0x004c1170 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004c1153
    cmp ecx, 0x12                                # 004c1157
    jge.d8 L_004c1170                            # 004c115a
    # block 0x004c115c: entered by fall-through of jge at 0x004c115a, 4 instruction(s), ends with backward jump to 0x004c1147
    movsx edx, word ptr [ebp - local_10]         # 004c115c
    mov eax, dword ptr [ebp - local_1c]          # 004c1160
    mov dword ptr [eax + 4*edx + field_cd6], 0x0 # 004c1163
    jmp.d8 L_004c1147                            # 004c116e
L_004c1170:
    # block 0x004c1170: entered by jge at 0x004c115a, 27 instruction(s), calls FUN_004c94ec, FUN_0051dc43, ends with jne to 0x004c11f2 (forward)
    mov ecx, 0x1b                                # 004c1170
    {load} xor eax, eax                          # 004c1175
    mov edi, dword ptr [ebp - local_1c]          # 004c1177
    add edi, 0xd8a                               # 004c117a
    rep stosd dword ptr es:[edi], eax            # 004c1180
    {load} xor ecx, ecx                          # 004c1182
    mov edx, dword ptr [ebp - local_1c]          # 004c1184
    add edx, 0xe72                               # 004c1187
    mov dword ptr [edx], ecx                     # 004c118d
    mov dword ptr [edx + field_4], ecx           # 004c118f
    mov dword ptr [edx + field_8], ecx           # 004c1192
    mov dword ptr [edx + field_c], ecx           # 004c1195
    mov eax, dword ptr [ebp - local_1c]          # 004c1198
    mov word ptr [eax + field_e86], 0x0          # 004c119b
    mov ecx, dword ptr [ebp - local_1c]          # 004c11a4
    call FUN_004c94ec                            # 004c11a7
    mov ecx, dword ptr [ebp - local_1c]          # 004c11ac
    mov dword ptr [ecx + field_38b0], 0x1        # 004c11af
    push 0x1764                                  # 004c11b9
    call FUN_0051dc43                            # 004c11be
    add esp, 0x4                                 # 004c11c3
    mov dword ptr [ebp - local_14], eax          # 004c11c6
    mov edx, dword ptr [ebp - local_1c]          # 004c11c9
    mov eax, dword ptr [ebp - local_14]          # 004c11cc
    mov dword ptr [edx + field_1f24], eax        # 004c11cf
    cmp dword ptr [ebp - local_14], 0x0          # 004c11d5
    jne.d8 L_004c11f2                            # 004c11d9
    # block 0x004c11db: entered by fall-through of jne at 0x004c11d9, 5 instruction(s), calls FUN_004264e8, FUN_004c97b4, falls into the block at 0x004c11f2
    push 0x552c04                                # 004c11db
    mov ecx, 0x583979                            # 004c11e0
    call FUN_004264e8                            # 004c11e5
    mov ecx, dword ptr [ebp - local_1c]          # 004c11ea
    call FUN_004c97b4                            # 004c11ed
L_004c11f2:
    # block 0x004c11f2: entered by jne at 0x004c11d9, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c122b (forward)
    push 0x1764                                  # 004c11f2
    call FUN_0051dc43                            # 004c11f7
    add esp, 0x4                                 # 004c11fc
    mov dword ptr [ebp - local_18], eax          # 004c11ff
    mov ecx, dword ptr [ebp - local_1c]          # 004c1202
    mov edx, dword ptr [ebp - local_18]          # 004c1205
    mov dword ptr [ecx + field_1f28], edx        # 004c1208
    cmp dword ptr [ebp - local_18], 0x0          # 004c120e
    jne.d8 L_004c122b                            # 004c1212
    # block 0x004c1214: entered by fall-through of jne at 0x004c1212, 5 instruction(s), calls FUN_004264e8, FUN_004c97b4, falls into the block at 0x004c122b
    push 0x552c6c                                # 004c1214
    mov ecx, 0x583979                            # 004c1219
    call FUN_004264e8                            # 004c121e
    mov ecx, dword ptr [ebp - local_1c]          # 004c1223
    call FUN_004c97b4                            # 004c1226
L_004c122b:
    # block 0x004c122b: entered by jne at 0x004c1212, 55 instruction(s), ends with forward jump to 0x004c135d
    mov ecx, 0x5d9                               # 004c122b
    {load} xor eax, eax                          # 004c1230
    mov edx, dword ptr [ebp - local_1c]          # 004c1232
    mov edi, dword ptr [edx + field_1f24]        # 004c1235
    rep stosd dword ptr es:[edi], eax            # 004c123b
    mov ecx, 0x5d9                               # 004c123d
    {load} xor eax, eax                          # 004c1242
    mov edx, dword ptr [ebp - local_1c]          # 004c1244
    mov edi, dword ptr [edx + field_1f28]        # 004c1247
    rep stosd dword ptr es:[edi], eax            # 004c124d
    mov eax, dword ptr [ebp - local_1c]          # 004c124f
    mov ecx, dword ptr [eax + field_1f24]        # 004c1252
    mov dword ptr [ecx + field_175c], 0xffffffff # 004c1258
    mov edx, dword ptr [ebp - local_1c]          # 004c1262
    mov eax, dword ptr [edx + field_1f28]        # 004c1265
    mov dword ptr [eax + field_175c], 0xffffffff # 004c126b
    mov ecx, dword ptr [ebp - local_1c]          # 004c1275
    mov dword ptr [ecx + field_1f2c], 0x0        # 004c1278
    mov edx, dword ptr [ebp - local_1c]          # 004c1282
    mov dword ptr [edx + field_1f34], 0x0        # 004c1285
    mov eax, dword ptr [ebp - local_1c]          # 004c128f
    mov dword ptr [eax + field_1f30], 0x0        # 004c1292
    mov ecx, dword ptr [ebp - local_1c]          # 004c129c
    mov dword ptr [ecx + field_c4a], 0x0         # 004c129f
    mov edx, dword ptr [ebp - local_1c]          # 004c12a9
    mov dword ptr [edx + field_c4e], 0x0         # 004c12ac
    mov eax, dword ptr [ebp - local_1c]          # 004c12b6
    mov dword ptr [eax + field_c52], 0x0         # 004c12b9
    mov ecx, 0x180                               # 004c12c3
    {load} xor eax, eax                          # 004c12c8
    mov edi, dword ptr [ebp - local_1c]          # 004c12ca
    add edi, 0x4a                                # 004c12cd
    rep stosd dword ptr es:[edi], eax            # 004c12d0
    mov ecx, 0x180                               # 004c12d2
    {load} xor eax, eax                          # 004c12d7
    mov edi, dword ptr [ebp - local_1c]          # 004c12d9
    add edi, 0x64a                               # 004c12dc
    rep stosd dword ptr es:[edi], eax            # 004c12e2
    mov ecx, dword ptr [ebp - local_1c]          # 004c12e4
    mov dword ptr [ecx + field_c56], 0x32        # 004c12e7
    mov edx, dword ptr [ebp - local_1c]          # 004c12f1
    mov dword ptr [edx + field_c5a], 0x96        # 004c12f4
    mov eax, dword ptr [ebp - local_1c]          # 004c12fe
    mov dword ptr [eax + field_c5e], 0x64        # 004c1301
    mov ecx, dword ptr [ebp - local_1c]          # 004c130b
    mov dword ptr [ecx + field_c62], 0x64        # 004c130e
    mov edx, dword ptr [ebp - local_1c]          # 004c1318
    mov dword ptr [edx + field_c66], 0x0         # 004c131b
    mov eax, dword ptr [ebp - local_1c]          # 004c1325
    mov dword ptr [eax + field_c6a], 0x0         # 004c1328
    mov ecx, dword ptr [ebp - local_1c]          # 004c1332
    mov dword ptr [ecx + field_c6e], 0x0         # 004c1335
    mov dword ptr [0x63a8d4], 0x0                # 004c133f
    mov word ptr [ebp - local_10], 0x0           # 004c1349
    jmp.d8 L_004c135d                            # 004c134f
L_004c1351:
    # block 0x004c1351: entered by jmp at 0x004c137f, 3 instruction(s), falls into the block at 0x004c135d
    mov dx, word ptr [ebp - local_10]            # 004c1351
    add dx, 0x1                                  # 004c1355
    mov word ptr [ebp - local_10], dx            # 004c1359
L_004c135d:
    # block 0x004c135d: entered by jmp at 0x004c134f, 3 instruction(s), ends with jge to 0x004c1381 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004c135d
    cmp eax, 0x1                                 # 004c1361
    jge.d8 L_004c1381                            # 004c1364
    # block 0x004c1366: entered by fall-through of jge at 0x004c1364, 6 instruction(s), ends with backward jump to 0x004c1351
    movsx ecx, word ptr [ebp - local_10]         # 004c1366
    shl ecx, 0x6                                 # 004c136a
    mov edx, dword ptr [0x63a8d4]                # 004c136d
    or edx, dword ptr [ecx + 0x552be8]           # 004c1373
    mov dword ptr [0x63a8d4], edx                # 004c1379
    jmp.d8 L_004c1351                            # 004c137f
L_004c1381:
    # block 0x004c1381: entered by jge at 0x004c1364, 8 instruction(s), ends with ret
    mov dword ptr [ebp - local_4], 0xffffffff    # 004c1381
    mov eax, dword ptr [ebp - local_1c]          # 004c1388
    mov ecx, dword ptr [ebp - local_c]           # 004c138b
    mov dword ptr fs:[0x0], ecx                  # 004c138e
    pop edi                                      # 004c1395
    {load} mov esp, ebp                          # 004c1396
    pop ebp                                      # 004c1398
    ret                                          # 004c1399

