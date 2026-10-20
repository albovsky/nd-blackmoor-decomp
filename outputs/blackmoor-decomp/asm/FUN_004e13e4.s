# FUN_004e13e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e13e4
# extent:       0x004e13e4-0x004e18e5 (1281 code bytes)
# span:         0x004e13e4-0x004e18e5 (code 1281, tables 0, padding 0)
# sha256:       b2e63b99940ec84592abfdfa53fc306482e6ed099a5fce257409f55f0e8c13b3
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_scene_action_lock_table_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_button_runtime.h:56 says "the lock table producers (the scene action handler 0x4e13e4 and 0x4e1305)"
# name-note:    Scene action handler that is a producer of the task bar lock table.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_3, field_4, field_6, field_753; [ecx + n] field_3, field_4, field_6, field_753; [edx + n] field_2, field_3, field_6, field_753; [esi + n] field_753
# callees:      calls FUN_004e1305, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 313 instruction(s), 33 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_2, 0x2  # offset +0x2
.equ field_3, 0x3  # offset +0x3
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_753, 0x753  # offset +0x753

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004e1305, .text + (0x004e1305 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e13e4 - 0x401000
.globl FUN_004e13e4
FUN_004e13e4:
    # block 0x004e13e4: entry, 14 instruction(s), ends with jne to 0x004e14b5 (forward)
    push ebp                                     # 004e13e4
    {load} mov ebp, esp                          # 004e13e5
    sub esp, 0x18                                # 004e13e7
    push esi                                     # 004e13ea
    mov dword ptr [ebp - local_14], ecx          # 004e13eb
    movsx eax, word ptr [ebp + arg_8]            # 004e13ee
    imul eax, eax, 0x8d                          # 004e13f2
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004e13f8
    mov dword ptr [ebp - local_4], ecx           # 004e13fe
    mov edx, dword ptr [ebp - local_4]           # 004e1401
    {load} xor eax, eax                          # 004e1404
    mov al, byte ptr [edx + field_2]             # 004e1406
    cmp eax, 0x1                                 # 004e1409
    jne.d32 L_004e14b5                           # 004e140c
    # block 0x004e1412: entered by fall-through of jne at 0x004e140c, 11 instruction(s), calls FUN_004e1305, ends with je to 0x004e14b0 (forward)
    lea ecx, [ebp - local_10]                    # 004e1412
    push ecx                                     # 004e1415
    mov edx, dword ptr [ebp - local_4]           # 004e1416
    mov ax, word ptr [edx]                       # 004e1419
    push eax                                     # 004e141c
    mov cx, word ptr [0x583204]                  # 004e141d
    push ecx                                     # 004e1424
    mov ecx, dword ptr [ebp - local_14]          # 004e1425
    call FUN_004e1305                            # 004e1428
    cmp dword ptr [ebp - local_10], 0x0          # 004e142d
    je.d8 L_004e14b0                             # 004e1431
    # block 0x004e1433: entered by fall-through of je at 0x004e1431, 5 instruction(s), ends with je to 0x004e1450 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1433
    movsx eax, word ptr [edx]                    # 004e1436
    mov dword ptr [ebp - local_18], eax          # 004e1439
    cmp dword ptr [ebp - local_18], 0x1          # 004e143c
    je.d8 L_004e1450                             # 004e1440
    # block 0x004e1442: entered by fall-through of je at 0x004e1440, 2 instruction(s), ends with je to 0x004e1463 (forward)
    cmp dword ptr [ebp - local_18], 0x2          # 004e1442
    je.d8 L_004e1463                             # 004e1446
    # block 0x004e1448: entered by fall-through of je at 0x004e1446, 2 instruction(s), ends with je to 0x004e1476 (forward)
    cmp dword ptr [ebp - local_18], 0x3          # 004e1448
    je.d8 L_004e1476                             # 004e144c
    # block 0x004e144e: entered by fall-through of je at 0x004e144c, 1 instruction(s), ends with forward jump to 0x004e14b0
    jmp.d8 L_004e14b0                            # 004e144e
L_004e1450:
    # block 0x004e1450: entered by je at 0x004e1440, 3 instruction(s), ends with forward jump to 0x004e14b0
    mov byte ptr [0x583232], 0x1                 # 004e1450
    mov dword ptr [0x583204], 0x1                # 004e1457
    jmp.d8 L_004e14b0                            # 004e1461
L_004e1463:
    # block 0x004e1463: entered by je at 0x004e1446, 3 instruction(s), ends with forward jump to 0x004e14b0
    mov byte ptr [0x583233], 0x1                 # 004e1463
    mov dword ptr [0x583204], 0x1                # 004e146a
    jmp.d8 L_004e14b0                            # 004e1474
L_004e1476:
    # block 0x004e1476: entered by je at 0x004e144c, 6 instruction(s), ends with je to 0x004e14b0 (forward)
    mov byte ptr [0x583234], 0x1                 # 004e1476
    mov dword ptr [0x583204], 0x1                # 004e147d
    mov ecx, dword ptr [ebp - local_4]           # 004e1487
    movsx edx, word ptr [ecx + field_4]          # 004e148a
    cmp edx, 0x270f                              # 004e148e
    je.d8 L_004e14b0                             # 004e1494
    # block 0x004e1496: entered by fall-through of je at 0x004e1494, 6 instruction(s), falls into the block at 0x004e14b0
    mov eax, dword ptr [ebp - local_4]           # 004e1496
    mov cx, word ptr [eax + field_4]             # 004e1499
    mov word ptr [0x579e0e], cx                  # 004e149d
    mov edx, dword ptr [ebp - local_4]           # 004e14a4
    movsx eax, word ptr [edx + field_6]          # 004e14a7
    mov dword ptr [0x579e10], eax                # 004e14ab
L_004e14b0:
    # block 0x004e14b0: entered by je at 0x004e1431; jmp at 0x004e144e; jmp at 0x004e1461; jmp at 0x004e1474; more, 1 instruction(s), ends with forward jump to 0x004e18de
    jmp.d32 L_004e18de                           # 004e14b0
L_004e14b5:
    # block 0x004e14b5: entered by jne at 0x004e140c, 5 instruction(s), ends with je to 0x004e14f9 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e14b5
    {load} xor edx, edx                          # 004e14b8
    mov dl, byte ptr [ecx + field_3]             # 004e14ba
    test edx, edx                                # 004e14bd
    je.d8 L_004e14f9                             # 004e14bf
    # block 0x004e14c1: entered by fall-through of je at 0x004e14bf, 4 instruction(s), ends with je to 0x004e14de (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e14c1
    movsx ecx, word ptr [eax + field_4]          # 004e14c4
    cmp ecx, 0x270b                              # 004e14c8
    je.d8 L_004e14de                             # 004e14ce
    # block 0x004e14d0: entered by fall-through of je at 0x004e14ce, 4 instruction(s), ends with jne to 0x004e14f9 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e14d0
    movsx eax, word ptr [edx + field_6]          # 004e14d3
    cmp eax, 0x270b                              # 004e14d7
    jne.d8 L_004e14f9                            # 004e14dc
L_004e14de:
    # block 0x004e14de: entered by je at 0x004e14ce; fall-through of jne at 0x004e14dc, 5 instruction(s), ends with forward jump to 0x004e18de
    mov ecx, dword ptr [ebp - local_4]           # 004e14de
    movsx edx, word ptr [ecx]                    # 004e14e1
    imul edx, edx, 0x1a4                         # 004e14e4
    mov dword ptr [edx + 0x5a1620], 0x1          # 004e14ea
    jmp.d32 L_004e18de                           # 004e14f4
L_004e14f9:
    # block 0x004e14f9: entered by je at 0x004e14bf; jne at 0x004e14dc, 5 instruction(s), ends with je to 0x004e1553 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e14f9
    {load} xor ecx, ecx                          # 004e14fc
    mov cl, byte ptr [eax + field_3]             # 004e14fe
    test ecx, ecx                                # 004e1501
    je.d8 L_004e1553                             # 004e1503
    # block 0x004e1505: entered by fall-through of je at 0x004e1503, 5 instruction(s), ends with jne to 0x004e1553 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1505
    movsx eax, word ptr [edx]                    # 004e1508
    imul eax, eax, 0x1a4                         # 004e150b
    cmp dword ptr [eax + 0x5a1620], 0x1          # 004e1511
    jne.d8 L_004e1553                            # 004e1518
    # block 0x004e151a: entered by fall-through of jne at 0x004e1518, 4 instruction(s), ends with je to 0x004e1538 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e151a
    movsx edx, word ptr [ecx + field_4]          # 004e151d
    cmp edx, 0x270c                              # 004e1521
    je.d8 L_004e1538                             # 004e1527
    # block 0x004e1529: entered by fall-through of je at 0x004e1527, 4 instruction(s), ends with jne to 0x004e1553 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e1529
    movsx ecx, word ptr [eax + field_6]          # 004e152c
    cmp ecx, 0x270c                              # 004e1530
    jne.d8 L_004e1553                            # 004e1536
L_004e1538:
    # block 0x004e1538: entered by je at 0x004e1527; fall-through of jne at 0x004e1536, 5 instruction(s), ends with forward jump to 0x004e18de
    mov edx, dword ptr [ebp - local_4]           # 004e1538
    movsx eax, word ptr [edx]                    # 004e153b
    imul eax, eax, 0x1a4                         # 004e153e
    mov dword ptr [eax + 0x5a1620], 0x0          # 004e1544
    jmp.d32 L_004e18de                           # 004e154e
L_004e1553:
    # block 0x004e1553: entered by je at 0x004e1503; jne at 0x004e1518; jne at 0x004e1536, 5 instruction(s), ends with jne to 0x004e1597 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e1553
    {load} xor edx, edx                          # 004e1556
    mov dl, byte ptr [ecx + field_3]             # 004e1558
    test edx, edx                                # 004e155b
    jne.d8 L_004e1597                            # 004e155d
    # block 0x004e155f: entered by fall-through of jne at 0x004e155d, 4 instruction(s), ends with je to 0x004e157c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e155f
    movsx ecx, word ptr [eax + field_4]          # 004e1562
    cmp ecx, 0x270d                              # 004e1566
    je.d8 L_004e157c                             # 004e156c
    # block 0x004e156e: entered by fall-through of je at 0x004e156c, 4 instruction(s), ends with jne to 0x004e1597 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e156e
    movsx eax, word ptr [edx + field_6]          # 004e1571
    cmp eax, 0x270d                              # 004e1575
    jne.d8 L_004e1597                            # 004e157a
L_004e157c:
    # block 0x004e157c: entered by je at 0x004e156c; fall-through of jne at 0x004e157a, 5 instruction(s), ends with forward jump to 0x004e18de
    mov ecx, dword ptr [ebp - local_4]           # 004e157c
    movsx edx, word ptr [ecx]                    # 004e157f
    imul edx, edx, 0x1a4                         # 004e1582
    mov dword ptr [edx + 0x5a1620], 0x2          # 004e1588
    jmp.d32 L_004e18de                           # 004e1592
L_004e1597:
    # block 0x004e1597: entered by jne at 0x004e155d; jne at 0x004e157a, 5 instruction(s), ends with jne to 0x004e15f1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e1597
    {load} xor ecx, ecx                          # 004e159a
    mov cl, byte ptr [eax + field_3]             # 004e159c
    test ecx, ecx                                # 004e159f
    jne.d8 L_004e15f1                            # 004e15a1
    # block 0x004e15a3: entered by fall-through of jne at 0x004e15a1, 5 instruction(s), ends with jne to 0x004e15f1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e15a3
    movsx eax, word ptr [edx]                    # 004e15a6
    imul eax, eax, 0x1a4                         # 004e15a9
    cmp dword ptr [eax + 0x5a1620], 0x2          # 004e15af
    jne.d8 L_004e15f1                            # 004e15b6
    # block 0x004e15b8: entered by fall-through of jne at 0x004e15b6, 4 instruction(s), ends with je to 0x004e15d6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e15b8
    movsx edx, word ptr [ecx + field_4]          # 004e15bb
    cmp edx, 0x270e                              # 004e15bf
    je.d8 L_004e15d6                             # 004e15c5
    # block 0x004e15c7: entered by fall-through of je at 0x004e15c5, 4 instruction(s), ends with jne to 0x004e15f1 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e15c7
    movsx ecx, word ptr [eax + field_6]          # 004e15ca
    cmp ecx, 0x270e                              # 004e15ce
    jne.d8 L_004e15f1                            # 004e15d4
L_004e15d6:
    # block 0x004e15d6: entered by je at 0x004e15c5; fall-through of jne at 0x004e15d4, 5 instruction(s), ends with forward jump to 0x004e18de
    mov edx, dword ptr [ebp - local_4]           # 004e15d6
    movsx eax, word ptr [edx]                    # 004e15d9
    imul eax, eax, 0x1a4                         # 004e15dc
    mov dword ptr [eax + 0x5a1620], 0x0          # 004e15e2
    jmp.d32 L_004e18de                           # 004e15ec
L_004e15f1:
    # block 0x004e15f1: entered by jne at 0x004e15a1; jne at 0x004e15b6; jne at 0x004e15d4, 5 instruction(s), ends with forward jump to 0x004e1621
    mov word ptr [ebp - local_c], 0xffff         # 004e15f1
    mov word ptr [ebp - local_8], 0xffff         # 004e15f7
    mov ecx, dword ptr [ebp - local_14]          # 004e15fd
    mov dword ptr [ecx + field_753], 0x0         # 004e1600
    jmp.d8 L_004e1621                            # 004e160a
L_004e160c:
    # block 0x004e160c: entered by jmp at 0x004e16ef, 5 instruction(s), falls into the block at 0x004e1621
    mov edx, dword ptr [ebp - local_14]          # 004e160c
    mov eax, dword ptr [edx + field_753]         # 004e160f
    add eax, 0x1                                 # 004e1615
    mov ecx, dword ptr [ebp - local_14]          # 004e1618
    mov dword ptr [ecx + field_753], eax         # 004e161b
L_004e1621:
    # block 0x004e1621: entered by jmp at 0x004e160a, 3 instruction(s), ends with jge to 0x004e16f4 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004e1621
    cmp dword ptr [edx + field_753], 0x32        # 004e1624
    jge.d32 L_004e16f4                           # 004e162b
    # block 0x004e1631: entered by fall-through of jge at 0x004e162b, 8 instruction(s), ends with jne to 0x004e1691 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e1631
    movsx ecx, word ptr [eax]                    # 004e1634
    imul ecx, ecx, 0x1a4                         # 004e1637
    mov edx, dword ptr [ebp - local_14]          # 004e163d
    mov eax, dword ptr [edx + field_753]         # 004e1640
    movsx ecx, word ptr [ecx + 2*eax + 0x5a1624] # 004e1646
    cmp ecx, 0x270f                              # 004e164e
    jne.d8 L_004e1691                            # 004e1654
    # block 0x004e1656: entered by fall-through of jne at 0x004e1654, 8 instruction(s), ends with jne to 0x004e1691 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e1656
    movsx eax, word ptr [edx]                    # 004e1659
    imul eax, eax, 0x1a4                         # 004e165c
    mov ecx, dword ptr [ebp - local_14]          # 004e1662
    mov edx, dword ptr [ecx + field_753]         # 004e1665
    movsx eax, word ptr [eax + 2*edx + 0x5a1688] # 004e166b
    cmp eax, 0x270f                              # 004e1673
    jne.d8 L_004e1691                            # 004e1678
    # block 0x004e167a: entered by fall-through of jne at 0x004e1678, 3 instruction(s), ends with jne to 0x004e1691 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004e167a
    cmp ecx, -0x1                                # 004e167e
    jne.d8 L_004e1691                            # 004e1681
    # block 0x004e1683: entered by fall-through of jne at 0x004e1681, 3 instruction(s), falls into the block at 0x004e1691
    mov edx, dword ptr [ebp - local_14]          # 004e1683
    mov ax, word ptr [edx + field_753]           # 004e1686
    mov word ptr [ebp - local_c], ax             # 004e168d
L_004e1691:
    # block 0x004e1691: entered by jne at 0x004e1654; jne at 0x004e1678; jne at 0x004e1681, 10 instruction(s), ends with jne to 0x004e16ef (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004e1691
    movsx edx, word ptr [ecx]                    # 004e1694
    imul edx, edx, 0x1a4                         # 004e1697
    mov eax, dword ptr [ebp - local_14]          # 004e169d
    mov ecx, dword ptr [eax + field_753]         # 004e16a0
    movsx edx, word ptr [edx + 2*ecx + 0x5a1624] # 004e16a6
    mov eax, dword ptr [ebp - local_4]           # 004e16ae
    movsx ecx, word ptr [eax + field_4]          # 004e16b1
    {load} cmp edx, ecx                          # 004e16b5
    jne.d8 L_004e16ef                            # 004e16b7
    # block 0x004e16b9: entered by fall-through of jne at 0x004e16b7, 10 instruction(s), ends with jne to 0x004e16ef (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e16b9
    movsx eax, word ptr [edx]                    # 004e16bc
    imul eax, eax, 0x1a4                         # 004e16bf
    mov ecx, dword ptr [ebp - local_14]          # 004e16c5
    mov edx, dword ptr [ecx + field_753]         # 004e16c8
    movsx eax, word ptr [eax + 2*edx + 0x5a1688] # 004e16ce
    mov ecx, dword ptr [ebp - local_4]           # 004e16d6
    movsx edx, word ptr [ecx + field_6]          # 004e16d9
    {load} cmp eax, edx                          # 004e16dd
    jne.d8 L_004e16ef                            # 004e16df
    # block 0x004e16e1: entered by fall-through of jne at 0x004e16df, 3 instruction(s), falls into the block at 0x004e16ef
    mov eax, dword ptr [ebp - local_14]          # 004e16e1
    mov cx, word ptr [eax + field_753]           # 004e16e4
    mov word ptr [ebp - local_8], cx             # 004e16eb
L_004e16ef:
    # block 0x004e16ef: entered by jne at 0x004e16b7; jne at 0x004e16df, 1 instruction(s), ends with backward jump to 0x004e160c
    jmp.d32 L_004e160c                           # 004e16ef
L_004e16f4:
    # block 0x004e16f4: entered by jge at 0x004e162b, 5 instruction(s), ends with je to 0x004e1824 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004e16f4
    {load} xor eax, eax                          # 004e16f7
    mov al, byte ptr [edx + field_3]             # 004e16f9
    test eax, eax                                # 004e16fc
    je.d32 L_004e1824                            # 004e16fe
    # block 0x004e1704: entered by fall-through of je at 0x004e16fe, 3 instruction(s), ends with je to 0x004e1712 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004e1704
    cmp ecx, -0x1                                # 004e1708
    je.d8 L_004e1712                             # 004e170b
    # block 0x004e170d: entered by fall-through of je at 0x004e170b, 1 instruction(s), ends with forward jump to 0x004e18de
    jmp.d32 L_004e18de                           # 004e170d
L_004e1712:
    # block 0x004e1712: entered by je at 0x004e170b, 3 instruction(s), ends with jne to 0x004e17c2 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004e1712
    cmp edx, -0x1                                # 004e1716
    jne.d32 L_004e17c2                           # 004e1719
    # block 0x004e171f: entered by fall-through of jne at 0x004e1719, 3 instruction(s), ends with forward jump to 0x004e1743
    mov eax, dword ptr [ebp - local_14]          # 004e171f
    mov dword ptr [eax + field_753], 0x0         # 004e1722
    jmp.d8 L_004e1743                            # 004e172c
L_004e172e:
    # block 0x004e172e: entered by jmp at 0x004e1789, 5 instruction(s), falls into the block at 0x004e1743
    mov ecx, dword ptr [ebp - local_14]          # 004e172e
    mov edx, dword ptr [ecx + field_753]         # 004e1731
    add edx, 0x1                                 # 004e1737
    mov eax, dword ptr [ebp - local_14]          # 004e173a
    mov dword ptr [eax + field_753], edx         # 004e173d
L_004e1743:
    # block 0x004e1743: entered by jmp at 0x004e172c, 3 instruction(s), ends with jge to 0x004e178b (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004e1743
    cmp dword ptr [ecx + field_753], 0x31        # 004e1746
    jge.d8 L_004e178b                            # 004e174d
    # block 0x004e174f: entered by fall-through of jge at 0x004e174d, 13 instruction(s), ends with backward jump to 0x004e172e
    mov edx, dword ptr [ebp - local_4]           # 004e174f
    movsx eax, word ptr [edx]                    # 004e1752
    imul eax, eax, 0x1a4                         # 004e1755
    mov ecx, dword ptr [ebp - local_14]          # 004e175b
    mov edx, dword ptr [ecx + field_753]         # 004e175e
    mov ecx, dword ptr [ebp - local_4]           # 004e1764
    movsx ecx, word ptr [ecx]                    # 004e1767
    imul ecx, ecx, 0x1a4                         # 004e176a
    mov esi, dword ptr [ebp - local_14]          # 004e1770
    mov esi, dword ptr [esi + field_753]         # 004e1773
    mov dx, word ptr [eax + 2*edx + 0x5a1626]    # 004e1779
    mov word ptr [ecx + 2*esi + 0x5a1624], dx    # 004e1781
    jmp.d8 L_004e172e                            # 004e1789
L_004e178b:
    # block 0x004e178b: entered by jge at 0x004e174d, 4 instruction(s), ends with je to 0x004e17c2 (forward)
    mov word ptr [ebp - local_c], 0x31           # 004e178b
    movsx eax, word ptr [0x63a4cd]               # 004e1791
    test eax, eax                                # 004e1798
    je.d8 L_004e17c2                             # 004e179a
    # block 0x004e179c: entered by fall-through of je at 0x004e179a, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004e17c2
    mov ecx, dword ptr [ebp - local_4]           # 004e179c
    movsx edx, word ptr [ecx]                    # 004e179f
    push edx                                     # 004e17a2
    push 0x55be9c                                # 004e17a3
    push 0x63888b                                # 004e17a8
    call FUN_0050ca3e                            # 004e17ad
    add esp, 0xc                                 # 004e17b2
    push 0x63888b                                # 004e17b5
    call FUN_0044a2b7                            # 004e17ba
    add esp, 0x4                                 # 004e17bf
L_004e17c2:
    # block 0x004e17c2: entered by jne at 0x004e1719; je at 0x004e179a, 23 instruction(s), ends with forward jump to 0x004e18de
    mov eax, dword ptr [ebp - local_4]           # 004e17c2
    movsx ecx, word ptr [eax]                    # 004e17c5
    imul ecx, ecx, 0x1a4                         # 004e17c8
    movsx edx, word ptr [ebp - local_c]          # 004e17ce
    mov eax, dword ptr [ebp - local_4]           # 004e17d2
    mov ax, word ptr [eax + field_4]             # 004e17d5
    mov word ptr [ecx + 2*edx + 0x5a1624], ax    # 004e17d9
    mov ecx, dword ptr [ebp - local_4]           # 004e17e1
    movsx edx, word ptr [ecx]                    # 004e17e4
    imul edx, edx, 0x1a4                         # 004e17e7
    movsx eax, word ptr [ebp - local_c]          # 004e17ed
    mov ecx, dword ptr [ebp - local_4]           # 004e17f1
    mov cx, word ptr [ecx + field_6]             # 004e17f4
    mov word ptr [edx + 2*eax + 0x5a1688], cx    # 004e17f8
    mov edx, dword ptr [ebp - local_4]           # 004e1800
    {load} xor eax, eax                          # 004e1803
    mov al, byte ptr [edx + field_2]             # 004e1805
    mov ecx, dword ptr [ebp - local_4]           # 004e1808
    movsx edx, word ptr [ecx]                    # 004e180b
    imul edx, edx, 0x1a4                         # 004e180e
    movsx ecx, word ptr [ebp - local_c]          # 004e1814
    mov dword ptr [edx + 4*ecx + 0x5a16ec], eax  # 004e1818
    jmp.d32 L_004e18de                           # 004e181f
L_004e1824:
    # block 0x004e1824: entered by je at 0x004e16fe, 3 instruction(s), ends with jne to 0x004e1832 (forward)
    movsx edx, word ptr [ebp - local_8]          # 004e1824
    cmp edx, -0x1                                # 004e1828
    jne.d8 L_004e1832                            # 004e182b
    # block 0x004e182d: entered by fall-through of jne at 0x004e182b, 1 instruction(s), ends with forward jump to 0x004e18de
    jmp.d32 L_004e18de                           # 004e182d
L_004e1832:
    # block 0x004e1832: entered by jne at 0x004e182b, 4 instruction(s), ends with forward jump to 0x004e1856
    movsx eax, word ptr [ebp - local_8]          # 004e1832
    mov ecx, dword ptr [ebp - local_14]          # 004e1836
    mov dword ptr [ecx + field_753], eax         # 004e1839
    jmp.d8 L_004e1856                            # 004e183f
L_004e1841:
    # block 0x004e1841: entered by jmp at 0x004e189c, 5 instruction(s), falls into the block at 0x004e1856
    mov edx, dword ptr [ebp - local_14]          # 004e1841
    mov eax, dword ptr [edx + field_753]         # 004e1844
    add eax, 0x1                                 # 004e184a
    mov ecx, dword ptr [ebp - local_14]          # 004e184d
    mov dword ptr [ecx + field_753], eax         # 004e1850
L_004e1856:
    # block 0x004e1856: entered by jmp at 0x004e183f, 3 instruction(s), ends with jge to 0x004e189e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004e1856
    cmp dword ptr [edx + field_753], 0x31        # 004e1859
    jge.d8 L_004e189e                            # 004e1860
    # block 0x004e1862: entered by fall-through of jge at 0x004e1860, 13 instruction(s), ends with backward jump to 0x004e1841
    mov eax, dword ptr [ebp - local_4]           # 004e1862
    movsx ecx, word ptr [eax]                    # 004e1865
    imul ecx, ecx, 0x1a4                         # 004e1868
    mov edx, dword ptr [ebp - local_14]          # 004e186e
    mov eax, dword ptr [edx + field_753]         # 004e1871
    mov edx, dword ptr [ebp - local_4]           # 004e1877
    movsx edx, word ptr [edx]                    # 004e187a
    imul edx, edx, 0x1a4                         # 004e187d
    mov esi, dword ptr [ebp - local_14]          # 004e1883
    mov esi, dword ptr [esi + field_753]         # 004e1886
    mov ax, word ptr [ecx + 2*eax + 0x5a1626]    # 004e188c
    mov word ptr [edx + 2*esi + 0x5a1624], ax    # 004e1894
    jmp.d8 L_004e1841                            # 004e189c
L_004e189e:
    # block 0x004e189e: entered by jge at 0x004e1860, 12 instruction(s), falls into the block at 0x004e18de
    mov ecx, dword ptr [ebp - local_4]           # 004e189e
    movsx edx, word ptr [ecx]                    # 004e18a1
    imul edx, edx, 0x1a4                         # 004e18a4
    mov word ptr [edx + 0x5a1686], 0x270f        # 004e18aa
    mov eax, dword ptr [ebp - local_4]           # 004e18b3
    movsx ecx, word ptr [eax]                    # 004e18b6
    imul ecx, ecx, 0x1a4                         # 004e18b9
    mov word ptr [ecx + 0x5a16ea], 0x270f        # 004e18bf
    mov edx, dword ptr [ebp - local_4]           # 004e18c8
    movsx eax, word ptr [edx]                    # 004e18cb
    imul eax, eax, 0x1a4                         # 004e18ce
    mov dword ptr [eax + 0x5a17b0], 0xd          # 004e18d4
L_004e18de:
    # block 0x004e18de: entered by jmp at 0x004e14b0; jmp at 0x004e14f4; jmp at 0x004e154e; jmp at 0x004e1592; more, 4 instruction(s), ends with ret 0x4
    pop esi                                      # 004e18de
    {load} mov esp, ebp                          # 004e18df
    pop ebp                                      # 004e18e1
    ret 0x4                                      # 004e18e2

