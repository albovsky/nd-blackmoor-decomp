# FUN_004b10e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b10e3
# extent:       0x004b10e3-0x004b2026 (3907 code bytes)
# span:         0x004b10e3-0x004b203e (code 3907, tables 24, padding 0)
# sha256:       b3afafd0220f676114ba7c19a71881cc338e2ea768b514115c2af96138f9b7bc
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b10e3
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4, field_8, field_c, field_14, field_18, field_1c, field_1e, field_20, field_24, field_28, field_43, field_1529 and 1 more; [ecx + n] field_4, field_8, field_c, field_14, field_18, field_1a, field_1c, field_20, field_24, field_28, field_43, field_1529 and 1 more; [edx + n] field_4, field_8, field_c, field_14, field_18, field_1a, field_1c, field_20, field_24, field_28, field_43, field_1529 and 1 more; [esi + n] field_43
# callees:      calls FUN_004b203e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 995 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_43, 0x43  # offset +0x43
.equ field_1529, 0x1529  # offset +0x1529
.equ field_152d, 0x152d  # offset +0x152d

# --- external targets -----------------------------------------------
.set FUN_004b203e, .text + (0x004b203e - 0x401000)

.org 0x004b10e3 - 0x401000
.globl FUN_004b10e3
FUN_004b10e3:
    # block 0x004b10e3: entry, 59 instruction(s), calls FUN_004b203e, ends with ja to 0x004b201f (forward)
    push ebp                                     # 004b10e3
    {load} mov ebp, esp                          # 004b10e4
    sub esp, 0xc                                 # 004b10e6
    push esi                                     # 004b10e9
    mov dword ptr [ebp - local_8], ecx           # 004b10ea
    mov eax, dword ptr [ebp - local_8]           # 004b10ed
    movsx ecx, word ptr [eax + field_1e]         # 004b10f0
    imul ecx, ecx, 0x8d                          # 004b10f4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b10fa
    mov dword ptr [ebp - local_4], edx           # 004b1100
    movsx eax, word ptr [ebp + arg_8]            # 004b1103
    imul eax, eax, 0x1e4                         # 004b1107
    mov ecx, dword ptr [ebp - local_8]           # 004b110d
    lea edx, [ecx + eax + field_43]              # 004b1110
    movsx eax, word ptr [ebp + arg_c]            # 004b1114
    imul eax, eax, 0x2c                          # 004b1118
    lea ecx, [edx + eax + field_4]               # 004b111b
    push ecx                                     # 004b111f
    movsx edx, word ptr [ebp + arg_8]            # 004b1120
    imul edx, edx, 0x1e4                         # 004b1124
    mov eax, dword ptr [ebp - local_8]           # 004b112a
    lea ecx, [eax + edx + field_43]              # 004b112d
    movsx edx, word ptr [ebp + arg_c]            # 004b1131
    imul edx, edx, 0x2c                          # 004b1135
    mov ax, word ptr [ecx + edx + field_18]      # 004b1138
    push eax                                     # 004b113d
    mov cx, word ptr [ebp + arg_c]               # 004b113e
    push ecx                                     # 004b1142
    mov dx, word ptr [ebp + arg_8]               # 004b1143
    push edx                                     # 004b1147
    mov ecx, dword ptr [ebp - local_8]           # 004b1148
    call FUN_004b203e                            # 004b114b
    movsx eax, word ptr [ebp + arg_8]            # 004b1150
    imul eax, eax, 0x1e4                         # 004b1154
    mov ecx, dword ptr [ebp - local_8]           # 004b115a
    lea edx, [ecx + eax + field_43]              # 004b115d
    movsx eax, word ptr [ebp + arg_c]            # 004b1161
    imul eax, eax, 0x2c                          # 004b1165
    mov dword ptr [edx + eax + field_14], 0x1    # 004b1168
    movsx ecx, word ptr [ebp + arg_8]            # 004b1170
    imul ecx, ecx, 0x1e4                         # 004b1174
    mov edx, dword ptr [ebp - local_8]           # 004b117a
    lea eax, [edx + ecx + field_43]              # 004b117d
    movsx ecx, word ptr [ebp + arg_c]            # 004b1181
    imul ecx, ecx, 0x2c                          # 004b1185
    mov dword ptr [eax + ecx], 0x1               # 004b1188
    movsx edx, word ptr [ebp + arg_8]            # 004b118f
    imul edx, edx, 0x1e4                         # 004b1193
    mov eax, dword ptr [ebp - local_8]           # 004b1199
    lea ecx, [eax + edx + field_43]              # 004b119c
    movsx edx, word ptr [ebp + arg_c]            # 004b11a0
    imul edx, edx, 0x2c                          # 004b11a4
    movsx eax, word ptr [ecx + edx + field_18]   # 004b11a7
    mov dword ptr [ebp - local_c], eax           # 004b11ac
    mov ecx, dword ptr [ebp - local_c]           # 004b11af
    sub ecx, 0x1                                 # 004b11b2
    mov dword ptr [ebp - local_c], ecx           # 004b11b5
    cmp dword ptr [ebp - local_c], 0x5           # 004b11b8
    ja.d32 L_004b201f                            # 004b11bc
    # block 0x004b11c2: entered by fall-through of ja at 0x004b11bc, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4b2026]
    mov edx, dword ptr [ebp - local_c]           # 004b11c2
    jmp dword ptr [4*edx + SWTAB_004b2026_VA]    # 004b11c5
L_004b11cc:
    # block 0x004b11cc: entered by switch case, 126 instruction(s), ends with forward jump to 0x004b201f
    movsx eax, word ptr [ebp + arg_8]            # 004b11cc
    imul eax, eax, 0x1e4                         # 004b11d0
    mov ecx, dword ptr [ebp - local_8]           # 004b11d6
    lea edx, [ecx + eax + field_43]              # 004b11d9
    movsx eax, word ptr [ebp + arg_c]            # 004b11dd
    add eax, 0x1                                 # 004b11e1
    imul eax, eax, 0x2c                          # 004b11e4
    mov dword ptr [edx + eax + field_14], 0x0    # 004b11e7
    movsx ecx, word ptr [ebp + arg_8]            # 004b11ef
    imul ecx, ecx, 0x1e4                         # 004b11f3
    mov edx, dword ptr [ebp - local_8]           # 004b11f9
    lea eax, [edx + ecx + field_43]              # 004b11fc
    movsx ecx, word ptr [ebp + arg_c]            # 004b1200
    add ecx, 0x1                                 # 004b1204
    imul ecx, ecx, 0x2c                          # 004b1207
    mov dword ptr [eax + ecx], 0x1               # 004b120a
    movsx edx, word ptr [ebp + arg_8]            # 004b1211
    imul edx, edx, 0x1e4                         # 004b1215
    mov eax, dword ptr [ebp - local_8]           # 004b121b
    lea ecx, [eax + edx + field_43]              # 004b121e
    movsx edx, word ptr [ebp + arg_c]            # 004b1222
    imul edx, edx, 0x2c                          # 004b1226
    movsx eax, word ptr [ebp + arg_8]            # 004b1229
    imul eax, eax, 0x1e4                         # 004b122d
    mov esi, dword ptr [ebp - local_8]           # 004b1233
    lea eax, [esi + eax + field_43]              # 004b1236
    movsx esi, word ptr [ebp + arg_c]            # 004b123a
    add esi, 0x1                                 # 004b123e
    imul esi, esi, 0x2c                          # 004b1241
    mov cx, word ptr [ecx + edx + field_18]      # 004b1244
    mov word ptr [eax + esi + field_18], cx      # 004b1249
    movsx edx, word ptr [ebp + arg_8]            # 004b124e
    imul edx, edx, 0x1e4                         # 004b1252
    mov eax, dword ptr [ebp - local_8]           # 004b1258
    lea ecx, [eax + edx + field_43]              # 004b125b
    movsx edx, word ptr [ebp + arg_c]            # 004b125f
    imul edx, edx, 0x2c                          # 004b1263
    mov word ptr [ecx + edx + field_1a], 0x2794  # 004b1266
    movsx eax, word ptr [ebp + arg_8]            # 004b126d
    imul eax, eax, 0x1e4                         # 004b1271
    mov ecx, dword ptr [ebp - local_8]           # 004b1277
    lea edx, [ecx + eax + field_43]              # 004b127a
    movsx eax, word ptr [ebp + arg_c]            # 004b127e
    imul eax, eax, 0x2c                          # 004b1282
    lea ecx, [edx + eax + field_4]               # 004b1285
    movsx edx, word ptr [ebp + arg_8]            # 004b1289
    imul edx, edx, 0x1e4                         # 004b128d
    mov eax, dword ptr [ebp - local_8]           # 004b1293
    lea edx, [eax + edx + field_43]              # 004b1296
    movsx eax, word ptr [ebp + arg_c]            # 004b129a
    imul eax, eax, 0x2c                          # 004b129e
    lea edx, [edx + eax + field_1c]              # 004b12a1
    mov eax, dword ptr [ecx]                     # 004b12a5
    mov dword ptr [edx], eax                     # 004b12a7
    mov eax, dword ptr [ecx + field_4]           # 004b12a9
    mov dword ptr [edx + field_4], eax           # 004b12ac
    mov eax, dword ptr [ecx + field_8]           # 004b12af
    mov dword ptr [edx + field_8], eax           # 004b12b2
    mov ecx, dword ptr [ecx + field_c]           # 004b12b5
    mov dword ptr [edx + field_c], ecx           # 004b12b8
    movsx edx, word ptr [ebp + arg_8]            # 004b12bb
    imul edx, edx, 0x1e4                         # 004b12bf
    mov eax, dword ptr [ebp - local_8]           # 004b12c5
    lea ecx, [eax + edx + field_43]              # 004b12c8
    movsx edx, word ptr [ebp + arg_c]            # 004b12cc
    imul edx, edx, 0x2c                          # 004b12d0
    mov eax, dword ptr [ecx + edx + field_1c]    # 004b12d3
    mov ecx, dword ptr [ebp - local_8]           # 004b12d7
    add eax, dword ptr [ecx + field_1529]        # 004b12da
    movsx edx, word ptr [ebp + arg_8]            # 004b12e0
    imul edx, edx, 0x1e4                         # 004b12e4
    mov ecx, dword ptr [ebp - local_8]           # 004b12ea
    lea edx, [ecx + edx + field_43]              # 004b12ed
    movsx ecx, word ptr [ebp + arg_c]            # 004b12f1
    imul ecx, ecx, 0x2c                          # 004b12f5
    mov dword ptr [edx + ecx + field_24], eax    # 004b12f8
    movsx edx, word ptr [ebp + arg_8]            # 004b12fc
    imul edx, edx, 0x1e4                         # 004b1300
    mov eax, dword ptr [ebp - local_8]           # 004b1306
    lea ecx, [eax + edx + field_43]              # 004b1309
    movsx edx, word ptr [ebp + arg_c]            # 004b130d
    add edx, 0x1                                 # 004b1311
    imul edx, edx, 0x2c                          # 004b1314
    mov word ptr [ecx + edx + field_1a], 0x2797  # 004b1317
    movsx eax, word ptr [ebp + arg_8]            # 004b131e
    imul eax, eax, 0x1e4                         # 004b1322
    mov ecx, dword ptr [ebp - local_8]           # 004b1328
    lea edx, [ecx + eax + field_43]              # 004b132b
    movsx eax, word ptr [ebp + arg_c]            # 004b132f
    imul eax, eax, 0x2c                          # 004b1333
    lea ecx, [edx + eax + field_4]               # 004b1336
    movsx edx, word ptr [ebp + arg_8]            # 004b133a
    imul edx, edx, 0x1e4                         # 004b133e
    mov eax, dword ptr [ebp - local_8]           # 004b1344
    lea edx, [eax + edx + field_43]              # 004b1347
    movsx eax, word ptr [ebp + arg_c]            # 004b134b
    add eax, 0x1                                 # 004b134f
    imul eax, eax, 0x2c                          # 004b1352
    lea edx, [edx + eax + field_1c]              # 004b1355
    mov eax, dword ptr [ecx]                     # 004b1359
    mov dword ptr [edx], eax                     # 004b135b
    mov eax, dword ptr [ecx + field_4]           # 004b135d
    mov dword ptr [edx + field_4], eax           # 004b1360
    mov eax, dword ptr [ecx + field_8]           # 004b1363
    mov dword ptr [edx + field_8], eax           # 004b1366
    mov ecx, dword ptr [ecx + field_c]           # 004b1369
    mov dword ptr [edx + field_c], ecx           # 004b136c
    movsx edx, word ptr [ebp + arg_8]            # 004b136f
    imul edx, edx, 0x1e4                         # 004b1373
    mov eax, dword ptr [ebp - local_8]           # 004b1379
    lea ecx, [eax + edx + field_43]              # 004b137c
    movsx edx, word ptr [ebp + arg_c]            # 004b1380
    add edx, 0x1                                 # 004b1384
    imul edx, edx, 0x2c                          # 004b1387
    mov eax, dword ptr [ebp - local_8]           # 004b138a
    mov ecx, dword ptr [ecx + edx + field_24]    # 004b138d
    sub ecx, dword ptr [eax + field_1529]        # 004b1391
    movsx edx, word ptr [ebp + arg_8]            # 004b1397
    imul edx, edx, 0x1e4                         # 004b139b
    mov eax, dword ptr [ebp - local_8]           # 004b13a1
    lea edx, [eax + edx + field_43]              # 004b13a4
    movsx eax, word ptr [ebp + arg_c]            # 004b13a8
    add eax, 0x1                                 # 004b13ac
    imul eax, eax, 0x2c                          # 004b13af
    mov dword ptr [edx + eax + field_1c], ecx    # 004b13b2
    jmp.d32 L_004b201f                           # 004b13b6
L_004b13bb:
    # block 0x004b13bb: entered by switch case, 126 instruction(s), ends with forward jump to 0x004b201f
    movsx ecx, word ptr [ebp + arg_8]            # 004b13bb
    add ecx, 0x1                                 # 004b13bf
    imul ecx, ecx, 0x1e4                         # 004b13c2
    mov edx, dword ptr [ebp - local_8]           # 004b13c8
    lea eax, [edx + ecx + field_43]              # 004b13cb
    movsx ecx, word ptr [ebp + arg_c]            # 004b13cf
    imul ecx, ecx, 0x2c                          # 004b13d3
    mov dword ptr [eax + ecx + field_14], 0x0    # 004b13d6
    movsx edx, word ptr [ebp + arg_8]            # 004b13de
    add edx, 0x1                                 # 004b13e2
    imul edx, edx, 0x1e4                         # 004b13e5
    mov eax, dword ptr [ebp - local_8]           # 004b13eb
    lea ecx, [eax + edx + field_43]              # 004b13ee
    movsx edx, word ptr [ebp + arg_c]            # 004b13f2
    imul edx, edx, 0x2c                          # 004b13f6
    mov dword ptr [ecx + edx], 0x1               # 004b13f9
    movsx eax, word ptr [ebp + arg_8]            # 004b1400
    imul eax, eax, 0x1e4                         # 004b1404
    mov ecx, dword ptr [ebp - local_8]           # 004b140a
    lea edx, [ecx + eax + field_43]              # 004b140d
    movsx eax, word ptr [ebp + arg_c]            # 004b1411
    imul eax, eax, 0x2c                          # 004b1415
    movsx ecx, word ptr [ebp + arg_8]            # 004b1418
    add ecx, 0x1                                 # 004b141c
    imul ecx, ecx, 0x1e4                         # 004b141f
    mov esi, dword ptr [ebp - local_8]           # 004b1425
    lea ecx, [esi + ecx + field_43]              # 004b1428
    movsx esi, word ptr [ebp + arg_c]            # 004b142c
    imul esi, esi, 0x2c                          # 004b1430
    mov dx, word ptr [edx + eax + field_18]      # 004b1433
    mov word ptr [ecx + esi + field_18], dx      # 004b1438
    movsx eax, word ptr [ebp + arg_8]            # 004b143d
    imul eax, eax, 0x1e4                         # 004b1441
    mov ecx, dword ptr [ebp - local_8]           # 004b1447
    lea edx, [ecx + eax + field_43]              # 004b144a
    movsx eax, word ptr [ebp + arg_c]            # 004b144e
    imul eax, eax, 0x2c                          # 004b1452
    mov word ptr [edx + eax + field_1a], 0x2795  # 004b1455
    movsx ecx, word ptr [ebp + arg_8]            # 004b145c
    imul ecx, ecx, 0x1e4                         # 004b1460
    mov edx, dword ptr [ebp - local_8]           # 004b1466
    lea eax, [edx + ecx + field_43]              # 004b1469
    movsx ecx, word ptr [ebp + arg_c]            # 004b146d
    imul ecx, ecx, 0x2c                          # 004b1471
    lea edx, [eax + ecx + field_4]               # 004b1474
    movsx eax, word ptr [ebp + arg_8]            # 004b1478
    imul eax, eax, 0x1e4                         # 004b147c
    mov ecx, dword ptr [ebp - local_8]           # 004b1482
    lea eax, [ecx + eax + field_43]              # 004b1485
    movsx ecx, word ptr [ebp + arg_c]            # 004b1489
    imul ecx, ecx, 0x2c                          # 004b148d
    lea eax, [eax + ecx + field_1c]              # 004b1490
    mov ecx, dword ptr [edx]                     # 004b1494
    mov dword ptr [eax], ecx                     # 004b1496
    mov ecx, dword ptr [edx + field_4]           # 004b1498
    mov dword ptr [eax + field_4], ecx           # 004b149b
    mov ecx, dword ptr [edx + field_8]           # 004b149e
    mov dword ptr [eax + field_8], ecx           # 004b14a1
    mov edx, dword ptr [edx + field_c]           # 004b14a4
    mov dword ptr [eax + field_c], edx           # 004b14a7
    movsx eax, word ptr [ebp + arg_8]            # 004b14aa
    imul eax, eax, 0x1e4                         # 004b14ae
    mov ecx, dword ptr [ebp - local_8]           # 004b14b4
    lea edx, [ecx + eax + field_43]              # 004b14b7
    movsx eax, word ptr [ebp + arg_c]            # 004b14bb
    imul eax, eax, 0x2c                          # 004b14bf
    mov ecx, dword ptr [edx + eax + field_20]    # 004b14c2
    mov edx, dword ptr [ebp - local_8]           # 004b14c6
    add ecx, dword ptr [edx + field_152d]        # 004b14c9
    movsx eax, word ptr [ebp + arg_8]            # 004b14cf
    imul eax, eax, 0x1e4                         # 004b14d3
    mov edx, dword ptr [ebp - local_8]           # 004b14d9
    lea eax, [edx + eax + field_43]              # 004b14dc
    movsx edx, word ptr [ebp + arg_c]            # 004b14e0
    imul edx, edx, 0x2c                          # 004b14e4
    mov dword ptr [eax + edx + field_28], ecx    # 004b14e7
    movsx eax, word ptr [ebp + arg_8]            # 004b14eb
    add eax, 0x1                                 # 004b14ef
    imul eax, eax, 0x1e4                         # 004b14f2
    mov ecx, dword ptr [ebp - local_8]           # 004b14f8
    lea edx, [ecx + eax + field_43]              # 004b14fb
    movsx eax, word ptr [ebp + arg_c]            # 004b14ff
    imul eax, eax, 0x2c                          # 004b1503
    mov word ptr [edx + eax + field_1a], 0x2796  # 004b1506
    movsx ecx, word ptr [ebp + arg_8]            # 004b150d
    imul ecx, ecx, 0x1e4                         # 004b1511
    mov edx, dword ptr [ebp - local_8]           # 004b1517
    lea eax, [edx + ecx + field_43]              # 004b151a
    movsx ecx, word ptr [ebp + arg_c]            # 004b151e
    imul ecx, ecx, 0x2c                          # 004b1522
    lea edx, [eax + ecx + field_4]               # 004b1525
    movsx eax, word ptr [ebp + arg_8]            # 004b1529
    add eax, 0x1                                 # 004b152d
    imul eax, eax, 0x1e4                         # 004b1530
    mov ecx, dword ptr [ebp - local_8]           # 004b1536
    lea eax, [ecx + eax + field_43]              # 004b1539
    movsx ecx, word ptr [ebp + arg_c]            # 004b153d
    imul ecx, ecx, 0x2c                          # 004b1541
    lea eax, [eax + ecx + field_1c]              # 004b1544
    mov ecx, dword ptr [edx]                     # 004b1548
    mov dword ptr [eax], ecx                     # 004b154a
    mov ecx, dword ptr [edx + field_4]           # 004b154c
    mov dword ptr [eax + field_4], ecx           # 004b154f
    mov ecx, dword ptr [edx + field_8]           # 004b1552
    mov dword ptr [eax + field_8], ecx           # 004b1555
    mov edx, dword ptr [edx + field_c]           # 004b1558
    mov dword ptr [eax + field_c], edx           # 004b155b
    movsx eax, word ptr [ebp + arg_8]            # 004b155e
    add eax, 0x1                                 # 004b1562
    imul eax, eax, 0x1e4                         # 004b1565
    mov ecx, dword ptr [ebp - local_8]           # 004b156b
    lea edx, [ecx + eax + field_43]              # 004b156e
    movsx eax, word ptr [ebp + arg_c]            # 004b1572
    imul eax, eax, 0x2c                          # 004b1576
    mov ecx, dword ptr [ebp - local_8]           # 004b1579
    mov edx, dword ptr [edx + eax + field_28]    # 004b157c
    sub edx, dword ptr [ecx + field_152d]        # 004b1580
    movsx eax, word ptr [ebp + arg_8]            # 004b1586
    add eax, 0x1                                 # 004b158a
    imul eax, eax, 0x1e4                         # 004b158d
    mov ecx, dword ptr [ebp - local_8]           # 004b1593
    lea eax, [ecx + eax + field_43]              # 004b1596
    movsx ecx, word ptr [ebp + arg_c]            # 004b159a
    imul ecx, ecx, 0x2c                          # 004b159e
    mov dword ptr [eax + ecx + field_20], edx    # 004b15a1
    jmp.d32 L_004b201f                           # 004b15a5
L_004b15aa:
    # block 0x004b15aa: entered by switch case, 157 instruction(s), ends with forward jump to 0x004b201f
    movsx edx, word ptr [ebp + arg_8]            # 004b15aa
    imul edx, edx, 0x1e4                         # 004b15ae
    mov eax, dword ptr [ebp - local_8]           # 004b15b4
    lea ecx, [eax + edx + field_43]              # 004b15b7
    movsx edx, word ptr [ebp + arg_c]            # 004b15bb
    add edx, 0x1                                 # 004b15bf
    imul edx, edx, 0x2c                          # 004b15c2
    mov dword ptr [ecx + edx], 0x1               # 004b15c5
    movsx eax, word ptr [ebp + arg_8]            # 004b15cc
    imul eax, eax, 0x1e4                         # 004b15d0
    mov ecx, dword ptr [ebp - local_8]           # 004b15d6
    lea edx, [ecx + eax + field_43]              # 004b15d9
    movsx eax, word ptr [ebp + arg_c]            # 004b15dd
    imul eax, eax, 0x2c                          # 004b15e1
    movsx ecx, word ptr [ebp + arg_8]            # 004b15e4
    imul ecx, ecx, 0x1e4                         # 004b15e8
    mov esi, dword ptr [ebp - local_8]           # 004b15ee
    lea ecx, [esi + ecx + field_43]              # 004b15f1
    movsx esi, word ptr [ebp + arg_c]            # 004b15f5
    add esi, 0x1                                 # 004b15f9
    imul esi, esi, 0x2c                          # 004b15fc
    mov dx, word ptr [edx + eax + field_18]      # 004b15ff
    mov word ptr [ecx + esi + field_18], dx      # 004b1604
    movsx eax, word ptr [ebp + arg_8]            # 004b1609
    imul eax, eax, 0x1e4                         # 004b160d
    mov ecx, dword ptr [ebp - local_8]           # 004b1613
    lea edx, [ecx + eax + field_43]              # 004b1616
    movsx eax, word ptr [ebp + arg_c]            # 004b161a
    add eax, 0x1                                 # 004b161e
    imul eax, eax, 0x2c                          # 004b1621
    mov dword ptr [edx + eax + field_14], 0x0    # 004b1624
    movsx ecx, word ptr [ebp + arg_8]            # 004b162c
    imul ecx, ecx, 0x1e4                         # 004b1630
    mov edx, dword ptr [ebp - local_8]           # 004b1636
    lea eax, [edx + ecx + field_43]              # 004b1639
    movsx ecx, word ptr [ebp + arg_c]            # 004b163d
    add ecx, 0x2                                 # 004b1641
    imul ecx, ecx, 0x2c                          # 004b1644
    mov dword ptr [eax + ecx], 0x1               # 004b1647
    movsx edx, word ptr [ebp + arg_8]            # 004b164e
    imul edx, edx, 0x1e4                         # 004b1652
    mov eax, dword ptr [ebp - local_8]           # 004b1658
    lea ecx, [eax + edx + field_43]              # 004b165b
    movsx edx, word ptr [ebp + arg_c]            # 004b165f
    imul edx, edx, 0x2c                          # 004b1663
    movsx eax, word ptr [ebp + arg_8]            # 004b1666
    imul eax, eax, 0x1e4                         # 004b166a
    mov esi, dword ptr [ebp - local_8]           # 004b1670
    lea eax, [esi + eax + field_43]              # 004b1673
    movsx esi, word ptr [ebp + arg_c]            # 004b1677
    add esi, 0x2                                 # 004b167b
    imul esi, esi, 0x2c                          # 004b167e
    mov cx, word ptr [ecx + edx + field_18]      # 004b1681
    mov word ptr [eax + esi + field_18], cx      # 004b1686
    movsx edx, word ptr [ebp + arg_8]            # 004b168b
    imul edx, edx, 0x1e4                         # 004b168f
    mov eax, dword ptr [ebp - local_8]           # 004b1695
    lea ecx, [eax + edx + field_43]              # 004b1698
    movsx edx, word ptr [ebp + arg_c]            # 004b169c
    add edx, 0x2                                 # 004b16a0
    imul edx, edx, 0x2c                          # 004b16a3
    mov dword ptr [ecx + edx + field_14], 0x0    # 004b16a6
    movsx eax, word ptr [ebp + arg_8]            # 004b16ae
    imul eax, eax, 0x1e4                         # 004b16b2
    mov ecx, dword ptr [ebp - local_8]           # 004b16b8
    lea edx, [ecx + eax + field_43]              # 004b16bb
    movsx eax, word ptr [ebp + arg_c]            # 004b16bf
    imul eax, eax, 0x2c                          # 004b16c3
    mov word ptr [edx + eax + field_1a], 0x2794  # 004b16c6
    movsx ecx, word ptr [ebp + arg_8]            # 004b16cd
    imul ecx, ecx, 0x1e4                         # 004b16d1
    mov edx, dword ptr [ebp - local_8]           # 004b16d7
    lea eax, [edx + ecx + field_43]              # 004b16da
    movsx ecx, word ptr [ebp + arg_c]            # 004b16de
    imul ecx, ecx, 0x2c                          # 004b16e2
    lea edx, [eax + ecx + field_4]               # 004b16e5
    movsx eax, word ptr [ebp + arg_8]            # 004b16e9
    imul eax, eax, 0x1e4                         # 004b16ed
    mov ecx, dword ptr [ebp - local_8]           # 004b16f3
    lea eax, [ecx + eax + field_43]              # 004b16f6
    movsx ecx, word ptr [ebp + arg_c]            # 004b16fa
    imul ecx, ecx, 0x2c                          # 004b16fe
    lea eax, [eax + ecx + field_1c]              # 004b1701
    mov ecx, dword ptr [edx]                     # 004b1705
    mov dword ptr [eax], ecx                     # 004b1707
    mov ecx, dword ptr [edx + field_4]           # 004b1709
    mov dword ptr [eax + field_4], ecx           # 004b170c
    mov ecx, dword ptr [edx + field_8]           # 004b170f
    mov dword ptr [eax + field_8], ecx           # 004b1712
    mov edx, dword ptr [edx + field_c]           # 004b1715
    mov dword ptr [eax + field_c], edx           # 004b1718
    movsx eax, word ptr [ebp + arg_8]            # 004b171b
    imul eax, eax, 0x1e4                         # 004b171f
    mov ecx, dword ptr [ebp - local_8]           # 004b1725
    lea edx, [ecx + eax + field_43]              # 004b1728
    movsx eax, word ptr [ebp + arg_c]            # 004b172c
    imul eax, eax, 0x2c                          # 004b1730
    mov ecx, dword ptr [edx + eax + field_1c]    # 004b1733
    mov edx, dword ptr [ebp - local_8]           # 004b1737
    add ecx, dword ptr [edx + field_1529]        # 004b173a
    movsx eax, word ptr [ebp + arg_8]            # 004b1740
    imul eax, eax, 0x1e4                         # 004b1744
    mov edx, dword ptr [ebp - local_8]           # 004b174a
    lea eax, [edx + eax + field_43]              # 004b174d
    movsx edx, word ptr [ebp + arg_c]            # 004b1751
    imul edx, edx, 0x2c                          # 004b1755
    mov dword ptr [eax + edx + field_24], ecx    # 004b1758
    movsx eax, word ptr [ebp + arg_8]            # 004b175c
    imul eax, eax, 0x1e4                         # 004b1760
    mov ecx, dword ptr [ebp - local_8]           # 004b1766
    lea edx, [ecx + eax + field_43]              # 004b1769
    movsx eax, word ptr [ebp + arg_c]            # 004b176d
    add eax, 0x2                                 # 004b1771
    imul eax, eax, 0x2c                          # 004b1774
    mov word ptr [edx + eax + field_1a], 0x2797  # 004b1777
    movsx ecx, word ptr [ebp + arg_8]            # 004b177e
    imul ecx, ecx, 0x1e4                         # 004b1782
    mov edx, dword ptr [ebp - local_8]           # 004b1788
    lea eax, [edx + ecx + field_43]              # 004b178b
    movsx ecx, word ptr [ebp + arg_c]            # 004b178f
    imul ecx, ecx, 0x2c                          # 004b1793
    lea edx, [eax + ecx + field_4]               # 004b1796
    movsx eax, word ptr [ebp + arg_8]            # 004b179a
    imul eax, eax, 0x1e4                         # 004b179e
    mov ecx, dword ptr [ebp - local_8]           # 004b17a4
    lea eax, [ecx + eax + field_43]              # 004b17a7
    movsx ecx, word ptr [ebp + arg_c]            # 004b17ab
    add ecx, 0x2                                 # 004b17af
    imul ecx, ecx, 0x2c                          # 004b17b2
    lea eax, [eax + ecx + field_1c]              # 004b17b5
    mov ecx, dword ptr [edx]                     # 004b17b9
    mov dword ptr [eax], ecx                     # 004b17bb
    mov ecx, dword ptr [edx + field_4]           # 004b17bd
    mov dword ptr [eax + field_4], ecx           # 004b17c0
    mov ecx, dword ptr [edx + field_8]           # 004b17c3
    mov dword ptr [eax + field_8], ecx           # 004b17c6
    mov edx, dword ptr [edx + field_c]           # 004b17c9
    mov dword ptr [eax + field_c], edx           # 004b17cc
    movsx eax, word ptr [ebp + arg_8]            # 004b17cf
    imul eax, eax, 0x1e4                         # 004b17d3
    mov ecx, dword ptr [ebp - local_8]           # 004b17d9
    lea edx, [ecx + eax + field_43]              # 004b17dc
    movsx eax, word ptr [ebp + arg_c]            # 004b17e0
    add eax, 0x2                                 # 004b17e4
    imul eax, eax, 0x2c                          # 004b17e7
    mov ecx, dword ptr [ebp - local_8]           # 004b17ea
    mov edx, dword ptr [edx + eax + field_24]    # 004b17ed
    sub edx, dword ptr [ecx + field_1529]        # 004b17f1
    movsx eax, word ptr [ebp + arg_8]            # 004b17f7
    imul eax, eax, 0x1e4                         # 004b17fb
    mov ecx, dword ptr [ebp - local_8]           # 004b1801
    lea eax, [ecx + eax + field_43]              # 004b1804
    movsx ecx, word ptr [ebp + arg_c]            # 004b1808
    add ecx, 0x2                                 # 004b180c
    imul ecx, ecx, 0x2c                          # 004b180f
    mov dword ptr [eax + ecx + field_1c], edx    # 004b1812
    jmp.d32 L_004b201f                           # 004b1816
L_004b181b:
    # block 0x004b181b: entered by switch case, 157 instruction(s), ends with forward jump to 0x004b201f
    movsx edx, word ptr [ebp + arg_8]            # 004b181b
    add edx, 0x1                                 # 004b181f
    imul edx, edx, 0x1e4                         # 004b1822
    mov eax, dword ptr [ebp - local_8]           # 004b1828
    lea ecx, [eax + edx + field_43]              # 004b182b
    movsx edx, word ptr [ebp + arg_c]            # 004b182f
    imul edx, edx, 0x2c                          # 004b1833
    mov dword ptr [ecx + edx + field_14], 0x0    # 004b1836
    movsx eax, word ptr [ebp + arg_8]            # 004b183e
    add eax, 0x2                                 # 004b1842
    imul eax, eax, 0x1e4                         # 004b1845
    mov ecx, dword ptr [ebp - local_8]           # 004b184b
    lea edx, [ecx + eax + field_43]              # 004b184e
    movsx eax, word ptr [ebp + arg_c]            # 004b1852
    imul eax, eax, 0x2c                          # 004b1856
    mov dword ptr [edx + eax + field_14], 0x0    # 004b1859
    movsx ecx, word ptr [ebp + arg_8]            # 004b1861
    add ecx, 0x1                                 # 004b1865
    imul ecx, ecx, 0x1e4                         # 004b1868
    mov edx, dword ptr [ebp - local_8]           # 004b186e
    lea eax, [edx + ecx + field_43]              # 004b1871
    movsx ecx, word ptr [ebp + arg_c]            # 004b1875
    imul ecx, ecx, 0x2c                          # 004b1879
    mov dword ptr [eax + ecx], 0x1               # 004b187c
    movsx edx, word ptr [ebp + arg_8]            # 004b1883
    add edx, 0x2                                 # 004b1887
    imul edx, edx, 0x1e4                         # 004b188a
    mov eax, dword ptr [ebp - local_8]           # 004b1890
    lea ecx, [eax + edx + field_43]              # 004b1893
    movsx edx, word ptr [ebp + arg_c]            # 004b1897
    imul edx, edx, 0x2c                          # 004b189b
    mov dword ptr [ecx + edx], 0x1               # 004b189e
    movsx eax, word ptr [ebp + arg_8]            # 004b18a5
    imul eax, eax, 0x1e4                         # 004b18a9
    mov ecx, dword ptr [ebp - local_8]           # 004b18af
    lea edx, [ecx + eax + field_43]              # 004b18b2
    movsx eax, word ptr [ebp + arg_c]            # 004b18b6
    imul eax, eax, 0x2c                          # 004b18ba
    movsx ecx, word ptr [ebp + arg_8]            # 004b18bd
    add ecx, 0x1                                 # 004b18c1
    imul ecx, ecx, 0x1e4                         # 004b18c4
    mov esi, dword ptr [ebp - local_8]           # 004b18ca
    lea ecx, [esi + ecx + field_43]              # 004b18cd
    movsx esi, word ptr [ebp + arg_c]            # 004b18d1
    imul esi, esi, 0x2c                          # 004b18d5
    mov dx, word ptr [edx + eax + field_18]      # 004b18d8
    mov word ptr [ecx + esi + field_18], dx      # 004b18dd
    movsx eax, word ptr [ebp + arg_8]            # 004b18e2
    imul eax, eax, 0x1e4                         # 004b18e6
    mov ecx, dword ptr [ebp - local_8]           # 004b18ec
    lea edx, [ecx + eax + field_43]              # 004b18ef
    movsx eax, word ptr [ebp + arg_c]            # 004b18f3
    imul eax, eax, 0x2c                          # 004b18f7
    movsx ecx, word ptr [ebp + arg_8]            # 004b18fa
    add ecx, 0x2                                 # 004b18fe
    imul ecx, ecx, 0x1e4                         # 004b1901
    mov esi, dword ptr [ebp - local_8]           # 004b1907
    lea ecx, [esi + ecx + field_43]              # 004b190a
    movsx esi, word ptr [ebp + arg_c]            # 004b190e
    imul esi, esi, 0x2c                          # 004b1912
    mov dx, word ptr [edx + eax + field_18]      # 004b1915
    mov word ptr [ecx + esi + field_18], dx      # 004b191a
    movsx eax, word ptr [ebp + arg_8]            # 004b191f
    imul eax, eax, 0x1e4                         # 004b1923
    mov ecx, dword ptr [ebp - local_8]           # 004b1929
    lea edx, [ecx + eax + field_43]              # 004b192c
    movsx eax, word ptr [ebp + arg_c]            # 004b1930
    imul eax, eax, 0x2c                          # 004b1934
    mov word ptr [edx + eax + field_1a], 0x2795  # 004b1937
    movsx ecx, word ptr [ebp + arg_8]            # 004b193e
    imul ecx, ecx, 0x1e4                         # 004b1942
    mov edx, dword ptr [ebp - local_8]           # 004b1948
    lea eax, [edx + ecx + field_43]              # 004b194b
    movsx ecx, word ptr [ebp + arg_c]            # 004b194f
    imul ecx, ecx, 0x2c                          # 004b1953
    lea edx, [eax + ecx + field_4]               # 004b1956
    movsx eax, word ptr [ebp + arg_8]            # 004b195a
    imul eax, eax, 0x1e4                         # 004b195e
    mov ecx, dword ptr [ebp - local_8]           # 004b1964
    lea eax, [ecx + eax + field_43]              # 004b1967
    movsx ecx, word ptr [ebp + arg_c]            # 004b196b
    imul ecx, ecx, 0x2c                          # 004b196f
    lea eax, [eax + ecx + field_1c]              # 004b1972
    mov ecx, dword ptr [edx]                     # 004b1976
    mov dword ptr [eax], ecx                     # 004b1978
    mov ecx, dword ptr [edx + field_4]           # 004b197a
    mov dword ptr [eax + field_4], ecx           # 004b197d
    mov ecx, dword ptr [edx + field_8]           # 004b1980
    mov dword ptr [eax + field_8], ecx           # 004b1983
    mov edx, dword ptr [edx + field_c]           # 004b1986
    mov dword ptr [eax + field_c], edx           # 004b1989
    movsx eax, word ptr [ebp + arg_8]            # 004b198c
    imul eax, eax, 0x1e4                         # 004b1990
    mov ecx, dword ptr [ebp - local_8]           # 004b1996
    lea edx, [ecx + eax + field_43]              # 004b1999
    movsx eax, word ptr [ebp + arg_c]            # 004b199d
    imul eax, eax, 0x2c                          # 004b19a1
    mov ecx, dword ptr [edx + eax + field_20]    # 004b19a4
    mov edx, dword ptr [ebp - local_8]           # 004b19a8
    add ecx, dword ptr [edx + field_152d]        # 004b19ab
    movsx eax, word ptr [ebp + arg_8]            # 004b19b1
    imul eax, eax, 0x1e4                         # 004b19b5
    mov edx, dword ptr [ebp - local_8]           # 004b19bb
    lea eax, [edx + eax + field_43]              # 004b19be
    movsx edx, word ptr [ebp + arg_c]            # 004b19c2
    imul edx, edx, 0x2c                          # 004b19c6
    mov dword ptr [eax + edx + field_28], ecx    # 004b19c9
    movsx eax, word ptr [ebp + arg_8]            # 004b19cd
    add eax, 0x2                                 # 004b19d1
    imul eax, eax, 0x1e4                         # 004b19d4
    mov ecx, dword ptr [ebp - local_8]           # 004b19da
    lea edx, [ecx + eax + field_43]              # 004b19dd
    movsx eax, word ptr [ebp + arg_c]            # 004b19e1
    imul eax, eax, 0x2c                          # 004b19e5
    mov word ptr [edx + eax + field_1a], 0x2796  # 004b19e8
    movsx ecx, word ptr [ebp + arg_8]            # 004b19ef
    imul ecx, ecx, 0x1e4                         # 004b19f3
    mov edx, dword ptr [ebp - local_8]           # 004b19f9
    lea eax, [edx + ecx + field_43]              # 004b19fc
    movsx ecx, word ptr [ebp + arg_c]            # 004b1a00
    imul ecx, ecx, 0x2c                          # 004b1a04
    lea edx, [eax + ecx + field_4]               # 004b1a07
    movsx eax, word ptr [ebp + arg_8]            # 004b1a0b
    add eax, 0x2                                 # 004b1a0f
    imul eax, eax, 0x1e4                         # 004b1a12
    mov ecx, dword ptr [ebp - local_8]           # 004b1a18
    lea eax, [ecx + eax + field_43]              # 004b1a1b
    movsx ecx, word ptr [ebp + arg_c]            # 004b1a1f
    imul ecx, ecx, 0x2c                          # 004b1a23
    lea eax, [eax + ecx + field_1c]              # 004b1a26
    mov ecx, dword ptr [edx]                     # 004b1a2a
    mov dword ptr [eax], ecx                     # 004b1a2c
    mov ecx, dword ptr [edx + field_4]           # 004b1a2e
    mov dword ptr [eax + field_4], ecx           # 004b1a31
    mov ecx, dword ptr [edx + field_8]           # 004b1a34
    mov dword ptr [eax + field_8], ecx           # 004b1a37
    mov edx, dword ptr [edx + field_c]           # 004b1a3a
    mov dword ptr [eax + field_c], edx           # 004b1a3d
    movsx eax, word ptr [ebp + arg_8]            # 004b1a40
    add eax, 0x2                                 # 004b1a44
    imul eax, eax, 0x1e4                         # 004b1a47
    mov ecx, dword ptr [ebp - local_8]           # 004b1a4d
    lea edx, [ecx + eax + field_43]              # 004b1a50
    movsx eax, word ptr [ebp + arg_c]            # 004b1a54
    imul eax, eax, 0x2c                          # 004b1a58
    mov ecx, dword ptr [ebp - local_8]           # 004b1a5b
    mov edx, dword ptr [edx + eax + field_28]    # 004b1a5e
    sub edx, dword ptr [ecx + field_152d]        # 004b1a62
    movsx eax, word ptr [ebp + arg_8]            # 004b1a68
    add eax, 0x2                                 # 004b1a6c
    imul eax, eax, 0x1e4                         # 004b1a6f
    mov ecx, dword ptr [ebp - local_8]           # 004b1a75
    lea eax, [ecx + eax + field_43]              # 004b1a78
    movsx ecx, word ptr [ebp + arg_c]            # 004b1a7c
    imul ecx, ecx, 0x2c                          # 004b1a80
    mov dword ptr [eax + ecx + field_20], edx    # 004b1a83
    jmp.d32 L_004b201f                           # 004b1a87
L_004b1a8c:
    # block 0x004b1a8c: entered by switch case, 364 instruction(s), falls into the block at 0x004b201f
    movsx edx, word ptr [ebp + arg_8]            # 004b1a8c
    add edx, 0x1                                 # 004b1a90
    imul edx, edx, 0x1e4                         # 004b1a93
    mov eax, dword ptr [ebp - local_8]           # 004b1a99
    lea ecx, [eax + edx + field_43]              # 004b1a9c
    movsx edx, word ptr [ebp + arg_c]            # 004b1aa0
    imul edx, edx, 0x2c                          # 004b1aa4
    mov dword ptr [ecx + edx + field_14], 0x0    # 004b1aa7
    movsx eax, word ptr [ebp + arg_8]            # 004b1aaf
    add eax, 0x1                                 # 004b1ab3
    imul eax, eax, 0x1e4                         # 004b1ab6
    mov ecx, dword ptr [ebp - local_8]           # 004b1abc
    lea edx, [ecx + eax + field_43]              # 004b1abf
    movsx eax, word ptr [ebp + arg_c]            # 004b1ac3
    add eax, 0x1                                 # 004b1ac7
    imul eax, eax, 0x2c                          # 004b1aca
    mov dword ptr [edx + eax + field_14], 0x0    # 004b1acd
    movsx ecx, word ptr [ebp + arg_8]            # 004b1ad5
    imul ecx, ecx, 0x1e4                         # 004b1ad9
    mov edx, dword ptr [ebp - local_8]           # 004b1adf
    lea eax, [edx + ecx + field_43]              # 004b1ae2
    movsx ecx, word ptr [ebp + arg_c]            # 004b1ae6
    add ecx, 0x1                                 # 004b1aea
    imul ecx, ecx, 0x2c                          # 004b1aed
    mov dword ptr [eax + ecx + field_14], 0x0    # 004b1af0
    movsx edx, word ptr [ebp + arg_8]            # 004b1af8
    add edx, 0x1                                 # 004b1afc
    imul edx, edx, 0x1e4                         # 004b1aff
    mov eax, dword ptr [ebp - local_8]           # 004b1b05
    lea ecx, [eax + edx + field_43]              # 004b1b08
    movsx edx, word ptr [ebp + arg_c]            # 004b1b0c
    imul edx, edx, 0x2c                          # 004b1b10
    mov dword ptr [ecx + edx], 0x1               # 004b1b13
    movsx eax, word ptr [ebp + arg_8]            # 004b1b1a
    imul eax, eax, 0x1e4                         # 004b1b1e
    mov ecx, dword ptr [ebp - local_8]           # 004b1b24
    lea edx, [ecx + eax + field_43]              # 004b1b27
    movsx eax, word ptr [ebp + arg_c]            # 004b1b2b
    imul eax, eax, 0x2c                          # 004b1b2f
    movsx ecx, word ptr [ebp + arg_8]            # 004b1b32
    add ecx, 0x1                                 # 004b1b36
    imul ecx, ecx, 0x1e4                         # 004b1b39
    mov esi, dword ptr [ebp - local_8]           # 004b1b3f
    lea ecx, [esi + ecx + field_43]              # 004b1b42
    movsx esi, word ptr [ebp + arg_c]            # 004b1b46
    imul esi, esi, 0x2c                          # 004b1b4a
    mov dx, word ptr [edx + eax + field_18]      # 004b1b4d
    mov word ptr [ecx + esi + field_18], dx      # 004b1b52
    movsx eax, word ptr [ebp + arg_8]            # 004b1b57
    imul eax, eax, 0x1e4                         # 004b1b5b
    mov ecx, dword ptr [ebp - local_8]           # 004b1b61
    lea edx, [ecx + eax + field_43]              # 004b1b64
    movsx eax, word ptr [ebp + arg_c]            # 004b1b68
    add eax, 0x1                                 # 004b1b6c
    imul eax, eax, 0x2c                          # 004b1b6f
    mov dword ptr [edx + eax], 0x1               # 004b1b72
    movsx ecx, word ptr [ebp + arg_8]            # 004b1b79
    imul ecx, ecx, 0x1e4                         # 004b1b7d
    mov edx, dword ptr [ebp - local_8]           # 004b1b83
    lea eax, [edx + ecx + field_43]              # 004b1b86
    movsx ecx, word ptr [ebp + arg_c]            # 004b1b8a
    imul ecx, ecx, 0x2c                          # 004b1b8e
    movsx edx, word ptr [ebp + arg_8]            # 004b1b91
    imul edx, edx, 0x1e4                         # 004b1b95
    mov esi, dword ptr [ebp - local_8]           # 004b1b9b
    lea edx, [esi + edx + field_43]              # 004b1b9e
    movsx esi, word ptr [ebp + arg_c]            # 004b1ba2
    add esi, 0x1                                 # 004b1ba6
    imul esi, esi, 0x2c                          # 004b1ba9
    mov ax, word ptr [eax + ecx + field_18]      # 004b1bac
    mov word ptr [edx + esi + field_18], ax      # 004b1bb1
    movsx ecx, word ptr [ebp + arg_8]            # 004b1bb6
    add ecx, 0x1                                 # 004b1bba
    imul ecx, ecx, 0x1e4                         # 004b1bbd
    mov edx, dword ptr [ebp - local_8]           # 004b1bc3
    lea eax, [edx + ecx + field_43]              # 004b1bc6
    movsx ecx, word ptr [ebp + arg_c]            # 004b1bca
    add ecx, 0x1                                 # 004b1bce
    imul ecx, ecx, 0x2c                          # 004b1bd1
    mov dword ptr [eax + ecx], 0x1               # 004b1bd4
    movsx edx, word ptr [ebp + arg_8]            # 004b1bdb
    imul edx, edx, 0x1e4                         # 004b1bdf
    mov eax, dword ptr [ebp - local_8]           # 004b1be5
    lea ecx, [eax + edx + field_43]              # 004b1be8
    movsx edx, word ptr [ebp + arg_c]            # 004b1bec
    imul edx, edx, 0x2c                          # 004b1bf0
    movsx eax, word ptr [ebp + arg_8]            # 004b1bf3
    add eax, 0x1                                 # 004b1bf7
    imul eax, eax, 0x1e4                         # 004b1bfa
    mov esi, dword ptr [ebp - local_8]           # 004b1c00
    lea eax, [esi + eax + field_43]              # 004b1c03
    movsx esi, word ptr [ebp + arg_c]            # 004b1c07
    add esi, 0x1                                 # 004b1c0b
    imul esi, esi, 0x2c                          # 004b1c0e
    mov cx, word ptr [ecx + edx + field_18]      # 004b1c11
    mov word ptr [eax + esi + field_18], cx      # 004b1c16
    movsx edx, word ptr [ebp + arg_8]            # 004b1c1b
    imul edx, edx, 0x1e4                         # 004b1c1f
    mov eax, dword ptr [ebp - local_8]           # 004b1c25
    lea ecx, [eax + edx + field_43]              # 004b1c28
    movsx edx, word ptr [ebp + arg_c]            # 004b1c2c
    imul edx, edx, 0x2c                          # 004b1c30
    mov word ptr [ecx + edx + field_1a], 0x2794  # 004b1c33
    movsx eax, word ptr [ebp + arg_8]            # 004b1c3a
    imul eax, eax, 0x1e4                         # 004b1c3e
    mov ecx, dword ptr [ebp - local_8]           # 004b1c44
    lea edx, [ecx + eax + field_43]              # 004b1c47
    movsx eax, word ptr [ebp + arg_c]            # 004b1c4b
    imul eax, eax, 0x2c                          # 004b1c4f
    lea ecx, [edx + eax + field_4]               # 004b1c52
    movsx edx, word ptr [ebp + arg_8]            # 004b1c56
    imul edx, edx, 0x1e4                         # 004b1c5a
    mov eax, dword ptr [ebp - local_8]           # 004b1c60
    lea edx, [eax + edx + field_43]              # 004b1c63
    movsx eax, word ptr [ebp + arg_c]            # 004b1c67
    imul eax, eax, 0x2c                          # 004b1c6b
    lea edx, [edx + eax + field_1c]              # 004b1c6e
    mov eax, dword ptr [ecx]                     # 004b1c72
    mov dword ptr [edx], eax                     # 004b1c74
    mov eax, dword ptr [ecx + field_4]           # 004b1c76
    mov dword ptr [edx + field_4], eax           # 004b1c79
    mov eax, dword ptr [ecx + field_8]           # 004b1c7c
    mov dword ptr [edx + field_8], eax           # 004b1c7f
    mov ecx, dword ptr [ecx + field_c]           # 004b1c82
    mov dword ptr [edx + field_c], ecx           # 004b1c85
    movsx edx, word ptr [ebp + arg_8]            # 004b1c88
    imul edx, edx, 0x1e4                         # 004b1c8c
    mov eax, dword ptr [ebp - local_8]           # 004b1c92
    lea ecx, [eax + edx + field_43]              # 004b1c95
    movsx edx, word ptr [ebp + arg_c]            # 004b1c99
    imul edx, edx, 0x2c                          # 004b1c9d
    mov eax, dword ptr [ecx + edx + field_1c]    # 004b1ca0
    mov ecx, dword ptr [ebp - local_8]           # 004b1ca4
    add eax, dword ptr [ecx + field_1529]        # 004b1ca7
    movsx edx, word ptr [ebp + arg_8]            # 004b1cad
    imul edx, edx, 0x1e4                         # 004b1cb1
    mov ecx, dword ptr [ebp - local_8]           # 004b1cb7
    lea edx, [ecx + edx + field_43]              # 004b1cba
    movsx ecx, word ptr [ebp + arg_c]            # 004b1cbe
    imul ecx, ecx, 0x2c                          # 004b1cc2
    mov dword ptr [edx + ecx + field_24], eax    # 004b1cc5
    movsx edx, word ptr [ebp + arg_8]            # 004b1cc9
    imul edx, edx, 0x1e4                         # 004b1ccd
    mov eax, dword ptr [ebp - local_8]           # 004b1cd3
    lea ecx, [eax + edx + field_43]              # 004b1cd6
    movsx edx, word ptr [ebp + arg_c]            # 004b1cda
    imul edx, edx, 0x2c                          # 004b1cde
    mov eax, dword ptr [ecx + edx + field_20]    # 004b1ce1
    mov ecx, dword ptr [ebp - local_8]           # 004b1ce5
    add eax, dword ptr [ecx + field_152d]        # 004b1ce8
    movsx edx, word ptr [ebp + arg_8]            # 004b1cee
    imul edx, edx, 0x1e4                         # 004b1cf2
    mov ecx, dword ptr [ebp - local_8]           # 004b1cf8
    lea edx, [ecx + edx + field_43]              # 004b1cfb
    movsx ecx, word ptr [ebp + arg_c]            # 004b1cff
    imul ecx, ecx, 0x2c                          # 004b1d03
    mov dword ptr [edx + ecx + field_28], eax    # 004b1d06
    movsx edx, word ptr [ebp + arg_8]            # 004b1d0a
    add edx, 0x1                                 # 004b1d0e
    imul edx, edx, 0x1e4                         # 004b1d11
    mov eax, dword ptr [ebp - local_8]           # 004b1d17
    lea ecx, [eax + edx + field_43]              # 004b1d1a
    movsx edx, word ptr [ebp + arg_c]            # 004b1d1e
    add edx, 0x1                                 # 004b1d22
    imul edx, edx, 0x2c                          # 004b1d25
    mov word ptr [ecx + edx + field_1a], 0x0     # 004b1d28
    movsx eax, word ptr [ebp + arg_8]            # 004b1d2f
    imul eax, eax, 0x1e4                         # 004b1d33
    mov ecx, dword ptr [ebp - local_8]           # 004b1d39
    lea edx, [ecx + eax + field_43]              # 004b1d3c
    movsx eax, word ptr [ebp + arg_c]            # 004b1d40
    imul eax, eax, 0x2c                          # 004b1d44
    lea ecx, [edx + eax + field_4]               # 004b1d47
    movsx edx, word ptr [ebp + arg_8]            # 004b1d4b
    add edx, 0x1                                 # 004b1d4f
    imul edx, edx, 0x1e4                         # 004b1d52
    mov eax, dword ptr [ebp - local_8]           # 004b1d58
    lea edx, [eax + edx + field_43]              # 004b1d5b
    movsx eax, word ptr [ebp + arg_c]            # 004b1d5f
    add eax, 0x1                                 # 004b1d63
    imul eax, eax, 0x2c                          # 004b1d66
    lea edx, [edx + eax + field_1c]              # 004b1d69
    mov eax, dword ptr [ecx]                     # 004b1d6d
    mov dword ptr [edx], eax                     # 004b1d6f
    mov eax, dword ptr [ecx + field_4]           # 004b1d71
    mov dword ptr [edx + field_4], eax           # 004b1d74
    mov eax, dword ptr [ecx + field_8]           # 004b1d77
    mov dword ptr [edx + field_8], eax           # 004b1d7a
    mov ecx, dword ptr [ecx + field_c]           # 004b1d7d
    mov dword ptr [edx + field_c], ecx           # 004b1d80
    movsx edx, word ptr [ebp + arg_8]            # 004b1d83
    add edx, 0x1                                 # 004b1d87
    imul edx, edx, 0x1e4                         # 004b1d8a
    mov eax, dword ptr [ebp - local_8]           # 004b1d90
    lea ecx, [eax + edx + field_43]              # 004b1d93
    movsx edx, word ptr [ebp + arg_c]            # 004b1d97
    add edx, 0x1                                 # 004b1d9b
    imul edx, edx, 0x2c                          # 004b1d9e
    mov eax, dword ptr [ebp - local_8]           # 004b1da1
    mov ecx, dword ptr [ecx + edx + field_24]    # 004b1da4
    sub ecx, dword ptr [eax + field_1529]        # 004b1da8
    movsx edx, word ptr [ebp + arg_8]            # 004b1dae
    add edx, 0x1                                 # 004b1db2
    imul edx, edx, 0x1e4                         # 004b1db5
    mov eax, dword ptr [ebp - local_8]           # 004b1dbb
    lea edx, [eax + edx + field_43]              # 004b1dbe
    movsx eax, word ptr [ebp + arg_c]            # 004b1dc2
    add eax, 0x1                                 # 004b1dc6
    imul eax, eax, 0x2c                          # 004b1dc9
    mov dword ptr [edx + eax + field_1c], ecx    # 004b1dcc
    movsx ecx, word ptr [ebp + arg_8]            # 004b1dd0
    add ecx, 0x1                                 # 004b1dd4
    imul ecx, ecx, 0x1e4                         # 004b1dd7
    mov edx, dword ptr [ebp - local_8]           # 004b1ddd
    lea eax, [edx + ecx + field_43]              # 004b1de0
    movsx ecx, word ptr [ebp + arg_c]            # 004b1de4
    add ecx, 0x1                                 # 004b1de8
    imul ecx, ecx, 0x2c                          # 004b1deb
    mov edx, dword ptr [ebp - local_8]           # 004b1dee
    mov eax, dword ptr [eax + ecx + field_28]    # 004b1df1
    sub eax, dword ptr [edx + field_152d]        # 004b1df5
    movsx ecx, word ptr [ebp + arg_8]            # 004b1dfb
    add ecx, 0x1                                 # 004b1dff
    imul ecx, ecx, 0x1e4                         # 004b1e02
    mov edx, dword ptr [ebp - local_8]           # 004b1e08
    lea ecx, [edx + ecx + field_43]              # 004b1e0b
    movsx edx, word ptr [ebp + arg_c]            # 004b1e0f
    add edx, 0x1                                 # 004b1e13
    imul edx, edx, 0x2c                          # 004b1e16
    mov dword ptr [ecx + edx + field_20], eax    # 004b1e19
    movsx eax, word ptr [ebp + arg_8]            # 004b1e1d
    imul eax, eax, 0x1e4                         # 004b1e21
    mov ecx, dword ptr [ebp - local_8]           # 004b1e27
    lea edx, [ecx + eax + field_43]              # 004b1e2a
    movsx eax, word ptr [ebp + arg_c]            # 004b1e2e
    add eax, 0x1                                 # 004b1e32
    imul eax, eax, 0x2c                          # 004b1e35
    mov word ptr [edx + eax + field_1a], 0x0     # 004b1e38
    movsx ecx, word ptr [ebp + arg_8]            # 004b1e3f
    imul ecx, ecx, 0x1e4                         # 004b1e43
    mov edx, dword ptr [ebp - local_8]           # 004b1e49
    lea eax, [edx + ecx + field_43]              # 004b1e4c
    movsx ecx, word ptr [ebp + arg_c]            # 004b1e50
    imul ecx, ecx, 0x2c                          # 004b1e54
    lea edx, [eax + ecx + field_4]               # 004b1e57
    movsx eax, word ptr [ebp + arg_8]            # 004b1e5b
    imul eax, eax, 0x1e4                         # 004b1e5f
    mov ecx, dword ptr [ebp - local_8]           # 004b1e65
    lea eax, [ecx + eax + field_43]              # 004b1e68
    movsx ecx, word ptr [ebp + arg_c]            # 004b1e6c
    add ecx, 0x1                                 # 004b1e70
    imul ecx, ecx, 0x2c                          # 004b1e73
    lea eax, [eax + ecx + field_1c]              # 004b1e76
    mov ecx, dword ptr [edx]                     # 004b1e7a
    mov dword ptr [eax], ecx                     # 004b1e7c
    mov ecx, dword ptr [edx + field_4]           # 004b1e7e
    mov dword ptr [eax + field_4], ecx           # 004b1e81
    mov ecx, dword ptr [edx + field_8]           # 004b1e84
    mov dword ptr [eax + field_8], ecx           # 004b1e87
    mov edx, dword ptr [edx + field_c]           # 004b1e8a
    mov dword ptr [eax + field_c], edx           # 004b1e8d
    movsx eax, word ptr [ebp + arg_8]            # 004b1e90
    imul eax, eax, 0x1e4                         # 004b1e94
    mov ecx, dword ptr [ebp - local_8]           # 004b1e9a
    lea edx, [ecx + eax + field_43]              # 004b1e9d
    movsx eax, word ptr [ebp + arg_c]            # 004b1ea1
    add eax, 0x1                                 # 004b1ea5
    imul eax, eax, 0x2c                          # 004b1ea8
    mov ecx, dword ptr [ebp - local_8]           # 004b1eab
    mov edx, dword ptr [edx + eax + field_24]    # 004b1eae
    sub edx, dword ptr [ecx + field_1529]        # 004b1eb2
    movsx eax, word ptr [ebp + arg_8]            # 004b1eb8
    imul eax, eax, 0x1e4                         # 004b1ebc
    mov ecx, dword ptr [ebp - local_8]           # 004b1ec2
    lea eax, [ecx + eax + field_43]              # 004b1ec5
    movsx ecx, word ptr [ebp + arg_c]            # 004b1ec9
    add ecx, 0x1                                 # 004b1ecd
    imul ecx, ecx, 0x2c                          # 004b1ed0
    mov dword ptr [eax + ecx + field_1c], edx    # 004b1ed3
    movsx edx, word ptr [ebp + arg_8]            # 004b1ed7
    imul edx, edx, 0x1e4                         # 004b1edb
    mov eax, dword ptr [ebp - local_8]           # 004b1ee1
    lea ecx, [eax + edx + field_43]              # 004b1ee4
    movsx edx, word ptr [ebp + arg_c]            # 004b1ee8
    add edx, 0x1                                 # 004b1eec
    imul edx, edx, 0x2c                          # 004b1eef
    mov eax, dword ptr [ecx + edx + field_20]    # 004b1ef2
    mov ecx, dword ptr [ebp - local_8]           # 004b1ef6
    add eax, dword ptr [ecx + field_152d]        # 004b1ef9
    movsx edx, word ptr [ebp + arg_8]            # 004b1eff
    imul edx, edx, 0x1e4                         # 004b1f03
    mov ecx, dword ptr [ebp - local_8]           # 004b1f09
    lea edx, [ecx + edx + field_43]              # 004b1f0c
    movsx ecx, word ptr [ebp + arg_c]            # 004b1f10
    add ecx, 0x1                                 # 004b1f14
    imul ecx, ecx, 0x2c                          # 004b1f17
    mov dword ptr [edx + ecx + field_28], eax    # 004b1f1a
    movsx edx, word ptr [ebp + arg_8]            # 004b1f1e
    add edx, 0x1                                 # 004b1f22
    imul edx, edx, 0x1e4                         # 004b1f25
    mov eax, dword ptr [ebp - local_8]           # 004b1f2b
    lea ecx, [eax + edx + field_43]              # 004b1f2e
    movsx edx, word ptr [ebp + arg_c]            # 004b1f32
    imul edx, edx, 0x2c                          # 004b1f36
    mov word ptr [ecx + edx + field_1a], 0x0     # 004b1f39
    movsx eax, word ptr [ebp + arg_8]            # 004b1f40
    imul eax, eax, 0x1e4                         # 004b1f44
    mov ecx, dword ptr [ebp - local_8]           # 004b1f4a
    lea edx, [ecx + eax + field_43]              # 004b1f4d
    movsx eax, word ptr [ebp + arg_c]            # 004b1f51
    imul eax, eax, 0x2c                          # 004b1f55
    lea ecx, [edx + eax + field_4]               # 004b1f58
    movsx edx, word ptr [ebp + arg_8]            # 004b1f5c
    add edx, 0x1                                 # 004b1f60
    imul edx, edx, 0x1e4                         # 004b1f63
    mov eax, dword ptr [ebp - local_8]           # 004b1f69
    lea edx, [eax + edx + field_43]              # 004b1f6c
    movsx eax, word ptr [ebp + arg_c]            # 004b1f70
    imul eax, eax, 0x2c                          # 004b1f74
    lea edx, [edx + eax + field_1c]              # 004b1f77
    mov eax, dword ptr [ecx]                     # 004b1f7b
    mov dword ptr [edx], eax                     # 004b1f7d
    mov eax, dword ptr [ecx + field_4]           # 004b1f7f
    mov dword ptr [edx + field_4], eax           # 004b1f82
    mov eax, dword ptr [ecx + field_8]           # 004b1f85
    mov dword ptr [edx + field_8], eax           # 004b1f88
    mov ecx, dword ptr [ecx + field_c]           # 004b1f8b
    mov dword ptr [edx + field_c], ecx           # 004b1f8e
    movsx edx, word ptr [ebp + arg_8]            # 004b1f91
    add edx, 0x1                                 # 004b1f95
    imul edx, edx, 0x1e4                         # 004b1f98
    mov eax, dword ptr [ebp - local_8]           # 004b1f9e
    lea ecx, [eax + edx + field_43]              # 004b1fa1
    movsx edx, word ptr [ebp + arg_c]            # 004b1fa5
    imul edx, edx, 0x2c                          # 004b1fa9
    mov eax, dword ptr [ecx + edx + field_1c]    # 004b1fac
    mov ecx, dword ptr [ebp - local_8]           # 004b1fb0
    add eax, dword ptr [ecx + field_1529]        # 004b1fb3
    movsx edx, word ptr [ebp + arg_8]            # 004b1fb9
    add edx, 0x1                                 # 004b1fbd
    imul edx, edx, 0x1e4                         # 004b1fc0
    mov ecx, dword ptr [ebp - local_8]           # 004b1fc6
    lea edx, [ecx + edx + field_43]              # 004b1fc9
    movsx ecx, word ptr [ebp + arg_c]            # 004b1fcd
    imul ecx, ecx, 0x2c                          # 004b1fd1
    mov dword ptr [edx + ecx + field_24], eax    # 004b1fd4
    movsx edx, word ptr [ebp + arg_8]            # 004b1fd8
    add edx, 0x1                                 # 004b1fdc
    imul edx, edx, 0x1e4                         # 004b1fdf
    mov eax, dword ptr [ebp - local_8]           # 004b1fe5
    lea ecx, [eax + edx + field_43]              # 004b1fe8
    movsx edx, word ptr [ebp + arg_c]            # 004b1fec
    imul edx, edx, 0x2c                          # 004b1ff0
    mov eax, dword ptr [ebp - local_8]           # 004b1ff3
    mov ecx, dword ptr [ecx + edx + field_28]    # 004b1ff6
    sub ecx, dword ptr [eax + field_152d]        # 004b1ffa
    movsx edx, word ptr [ebp + arg_8]            # 004b2000
    add edx, 0x1                                 # 004b2004
    imul edx, edx, 0x1e4                         # 004b2007
    mov eax, dword ptr [ebp - local_8]           # 004b200d
    lea edx, [eax + edx + field_43]              # 004b2010
    movsx eax, word ptr [ebp + arg_c]            # 004b2014
    imul eax, eax, 0x2c                          # 004b2018
    mov dword ptr [edx + eax + field_20], ecx    # 004b201b
L_004b201f:
    # block 0x004b201f: entered by ja at 0x004b11bc; jmp at 0x004b13b6; jmp at 0x004b15a5; jmp at 0x004b1816; more, 4 instruction(s), ends with ret 0x8
    pop esi                                      # 004b201f
    {load} mov esp, ebp                          # 004b2020
    pop ebp                                      # 004b2022
    ret 0x8                                      # 004b2023

# --- data items (not part of the function) -------------------------
.org 0x004b2026 - 0x401000
SWTAB_004b2026:  # 6 case address(es)
    .long L_004b11cc - .text + 0x401000
    .long L_004b13bb - .text + 0x401000
    .long L_004b15aa - .text + 0x401000
    .long L_004b181b - .text + 0x401000
    .long L_004b1a8c - .text + 0x401000
    .long L_004b11cc - .text + 0x401000
.set SWTAB_004b2026_VA, SWTAB_004b2026 - .text + 0x401000

