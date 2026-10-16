# FUN_0040236a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040236a
# extent:       0x0040236a-0x00402945 (1499 code bytes)
# span:         0x0040236a-0x00402945 (code 1499, tables 0, padding 0)
# sha256:       05b84834bb6d5e0cf2bce1901f8ba2818139ed82d011273b281bfc7aa7bda301
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040236a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_5c; [ecx + n] field_5c; [edx + n] field_5c
# callees:      calls FUN_0051d48c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 415 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0051d48c, .text + (0x0051d48c - 0x401000)

.org 0x0040236a - 0x401000
.globl FUN_0040236a
FUN_0040236a:
    # block 0x0040236a: entry, 8 instruction(s), ends with jne to 0x00402399 (forward)
    push ebp                                     # 0040236a
    {load} mov ebp, esp                          # 0040236b
    push ecx                                     # 0040236d
    mov dword ptr [ebp - local_4], ecx           # 0040236e
    mov eax, dword ptr [ebp - local_4]           # 00402371
    mov ecx, dword ptr [eax + field_5c]          # 00402374
    cmp dword ptr [4*ecx + 0x5e60d6], 0x1        # 00402377
    jne.d8 L_00402399                            # 0040237f
    # block 0x00402381: entered by fall-through of jne at 0x0040237f, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004023af
    push 0x0                                     # 00402381
    push 0x1                                     # 00402383
    push 0xf1                                    # 00402385
    push 0x3fc                                   # 0040238a
    mov ecx, dword ptr [ebp - local_4]           # 0040238f
    call FUN_0051d48c                            # 00402392
    jmp.d8 L_004023af                            # 00402397
L_00402399:
    # block 0x00402399: entered by jne at 0x0040237f, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004023af
    push 0x0                                     # 00402399
    push 0x0                                     # 0040239b
    push 0xf1                                    # 0040239d
    push 0x3fc                                   # 004023a2
    mov ecx, dword ptr [ebp - local_4]           # 004023a7
    call FUN_0051d48c                            # 004023aa
L_004023af:
    # block 0x004023af: entered by jmp at 0x00402397, 4 instruction(s), ends with jne to 0x004023d7 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004023af
    mov eax, dword ptr [edx + field_5c]          # 004023b2
    cmp dword ptr [4*eax + 0x5e60da], 0x1        # 004023b5
    jne.d8 L_004023d7                            # 004023bd
    # block 0x004023bf: entered by fall-through of jne at 0x004023bd, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004023ed
    push 0x0                                     # 004023bf
    push 0x1                                     # 004023c1
    push 0xf1                                    # 004023c3
    push 0x3fd                                   # 004023c8
    mov ecx, dword ptr [ebp - local_4]           # 004023cd
    call FUN_0051d48c                            # 004023d0
    jmp.d8 L_004023ed                            # 004023d5
L_004023d7:
    # block 0x004023d7: entered by jne at 0x004023bd, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004023ed
    push 0x0                                     # 004023d7
    push 0x0                                     # 004023d9
    push 0xf1                                    # 004023db
    push 0x3fd                                   # 004023e0
    mov ecx, dword ptr [ebp - local_4]           # 004023e5
    call FUN_0051d48c                            # 004023e8
L_004023ed:
    # block 0x004023ed: entered by jmp at 0x004023d5, 4 instruction(s), ends with jne to 0x00402415 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004023ed
    mov edx, dword ptr [ecx + field_5c]          # 004023f0
    cmp dword ptr [4*edx + 0x5e60de], 0x1        # 004023f3
    jne.d8 L_00402415                            # 004023fb
    # block 0x004023fd: entered by fall-through of jne at 0x004023fb, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x0040242b
    push 0x0                                     # 004023fd
    push 0x1                                     # 004023ff
    push 0xf1                                    # 00402401
    push 0x3fe                                   # 00402406
    mov ecx, dword ptr [ebp - local_4]           # 0040240b
    call FUN_0051d48c                            # 0040240e
    jmp.d8 L_0040242b                            # 00402413
L_00402415:
    # block 0x00402415: entered by jne at 0x004023fb, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x0040242b
    push 0x0                                     # 00402415
    push 0x0                                     # 00402417
    push 0xf1                                    # 00402419
    push 0x3fe                                   # 0040241e
    mov ecx, dword ptr [ebp - local_4]           # 00402423
    call FUN_0051d48c                            # 00402426
L_0040242b:
    # block 0x0040242b: entered by jmp at 0x00402413, 4 instruction(s), ends with jne to 0x00402453 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0040242b
    mov ecx, dword ptr [eax + field_5c]          # 0040242e
    cmp dword ptr [4*ecx + 0x5e60e2], 0x1        # 00402431
    jne.d8 L_00402453                            # 00402439
    # block 0x0040243b: entered by fall-through of jne at 0x00402439, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402469
    push 0x0                                     # 0040243b
    push 0x1                                     # 0040243d
    push 0xf1                                    # 0040243f
    push 0x3ff                                   # 00402444
    mov ecx, dword ptr [ebp - local_4]           # 00402449
    call FUN_0051d48c                            # 0040244c
    jmp.d8 L_00402469                            # 00402451
L_00402453:
    # block 0x00402453: entered by jne at 0x00402439, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402469
    push 0x0                                     # 00402453
    push 0x0                                     # 00402455
    push 0xf1                                    # 00402457
    push 0x3ff                                   # 0040245c
    mov ecx, dword ptr [ebp - local_4]           # 00402461
    call FUN_0051d48c                            # 00402464
L_00402469:
    # block 0x00402469: entered by jmp at 0x00402451, 4 instruction(s), ends with jne to 0x00402491 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00402469
    mov eax, dword ptr [edx + field_5c]          # 0040246c
    cmp dword ptr [4*eax + 0x5e60e6], 0x1        # 0040246f
    jne.d8 L_00402491                            # 00402477
    # block 0x00402479: entered by fall-through of jne at 0x00402477, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004024a7
    push 0x0                                     # 00402479
    push 0x1                                     # 0040247b
    push 0xf1                                    # 0040247d
    push 0x400                                   # 00402482
    mov ecx, dword ptr [ebp - local_4]           # 00402487
    call FUN_0051d48c                            # 0040248a
    jmp.d8 L_004024a7                            # 0040248f
L_00402491:
    # block 0x00402491: entered by jne at 0x00402477, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004024a7
    push 0x0                                     # 00402491
    push 0x0                                     # 00402493
    push 0xf1                                    # 00402495
    push 0x400                                   # 0040249a
    mov ecx, dword ptr [ebp - local_4]           # 0040249f
    call FUN_0051d48c                            # 004024a2
L_004024a7:
    # block 0x004024a7: entered by jmp at 0x0040248f, 4 instruction(s), ends with jne to 0x004024cf (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004024a7
    mov edx, dword ptr [ecx + field_5c]          # 004024aa
    cmp dword ptr [4*edx + 0x5e60ea], 0x1        # 004024ad
    jne.d8 L_004024cf                            # 004024b5
    # block 0x004024b7: entered by fall-through of jne at 0x004024b5, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004024e5
    push 0x0                                     # 004024b7
    push 0x1                                     # 004024b9
    push 0xf1                                    # 004024bb
    push 0x401                                   # 004024c0
    mov ecx, dword ptr [ebp - local_4]           # 004024c5
    call FUN_0051d48c                            # 004024c8
    jmp.d8 L_004024e5                            # 004024cd
L_004024cf:
    # block 0x004024cf: entered by jne at 0x004024b5, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004024e5
    push 0x0                                     # 004024cf
    push 0x0                                     # 004024d1
    push 0xf1                                    # 004024d3
    push 0x401                                   # 004024d8
    mov ecx, dword ptr [ebp - local_4]           # 004024dd
    call FUN_0051d48c                            # 004024e0
L_004024e5:
    # block 0x004024e5: entered by jmp at 0x004024cd, 4 instruction(s), ends with jne to 0x0040250d (forward)
    mov eax, dword ptr [ebp - local_4]           # 004024e5
    mov ecx, dword ptr [eax + field_5c]          # 004024e8
    cmp dword ptr [4*ecx + 0x5e60ee], 0x1        # 004024eb
    jne.d8 L_0040250d                            # 004024f3
    # block 0x004024f5: entered by fall-through of jne at 0x004024f3, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402523
    push 0x0                                     # 004024f5
    push 0x1                                     # 004024f7
    push 0xf1                                    # 004024f9
    push 0x402                                   # 004024fe
    mov ecx, dword ptr [ebp - local_4]           # 00402503
    call FUN_0051d48c                            # 00402506
    jmp.d8 L_00402523                            # 0040250b
L_0040250d:
    # block 0x0040250d: entered by jne at 0x004024f3, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402523
    push 0x0                                     # 0040250d
    push 0x0                                     # 0040250f
    push 0xf1                                    # 00402511
    push 0x402                                   # 00402516
    mov ecx, dword ptr [ebp - local_4]           # 0040251b
    call FUN_0051d48c                            # 0040251e
L_00402523:
    # block 0x00402523: entered by jmp at 0x0040250b, 4 instruction(s), ends with jne to 0x0040254b (forward)
    mov edx, dword ptr [ebp - local_4]           # 00402523
    mov eax, dword ptr [edx + field_5c]          # 00402526
    cmp dword ptr [4*eax + 0x5e60f2], 0x1        # 00402529
    jne.d8 L_0040254b                            # 00402531
    # block 0x00402533: entered by fall-through of jne at 0x00402531, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402561
    push 0x0                                     # 00402533
    push 0x1                                     # 00402535
    push 0xf1                                    # 00402537
    push 0x403                                   # 0040253c
    mov ecx, dword ptr [ebp - local_4]           # 00402541
    call FUN_0051d48c                            # 00402544
    jmp.d8 L_00402561                            # 00402549
L_0040254b:
    # block 0x0040254b: entered by jne at 0x00402531, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402561
    push 0x0                                     # 0040254b
    push 0x0                                     # 0040254d
    push 0xf1                                    # 0040254f
    push 0x403                                   # 00402554
    mov ecx, dword ptr [ebp - local_4]           # 00402559
    call FUN_0051d48c                            # 0040255c
L_00402561:
    # block 0x00402561: entered by jmp at 0x00402549, 4 instruction(s), ends with jne to 0x00402589 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00402561
    mov edx, dword ptr [ecx + field_5c]          # 00402564
    cmp dword ptr [4*edx + 0x5e60f6], 0x1        # 00402567
    jne.d8 L_00402589                            # 0040256f
    # block 0x00402571: entered by fall-through of jne at 0x0040256f, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x0040259f
    push 0x0                                     # 00402571
    push 0x1                                     # 00402573
    push 0xf1                                    # 00402575
    push 0x40e                                   # 0040257a
    mov ecx, dword ptr [ebp - local_4]           # 0040257f
    call FUN_0051d48c                            # 00402582
    jmp.d8 L_0040259f                            # 00402587
L_00402589:
    # block 0x00402589: entered by jne at 0x0040256f, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x0040259f
    push 0x0                                     # 00402589
    push 0x0                                     # 0040258b
    push 0xf1                                    # 0040258d
    push 0x40e                                   # 00402592
    mov ecx, dword ptr [ebp - local_4]           # 00402597
    call FUN_0051d48c                            # 0040259a
L_0040259f:
    # block 0x0040259f: entered by jmp at 0x00402587, 4 instruction(s), ends with jne to 0x004025c7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0040259f
    mov ecx, dword ptr [eax + field_5c]          # 004025a2
    cmp dword ptr [4*ecx + 0x5e60fa], 0x1        # 004025a5
    jne.d8 L_004025c7                            # 004025ad
    # block 0x004025af: entered by fall-through of jne at 0x004025ad, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004025dd
    push 0x0                                     # 004025af
    push 0x1                                     # 004025b1
    push 0xf1                                    # 004025b3
    push 0x40d                                   # 004025b8
    mov ecx, dword ptr [ebp - local_4]           # 004025bd
    call FUN_0051d48c                            # 004025c0
    jmp.d8 L_004025dd                            # 004025c5
L_004025c7:
    # block 0x004025c7: entered by jne at 0x004025ad, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004025dd
    push 0x0                                     # 004025c7
    push 0x0                                     # 004025c9
    push 0xf1                                    # 004025cb
    push 0x40d                                   # 004025d0
    mov ecx, dword ptr [ebp - local_4]           # 004025d5
    call FUN_0051d48c                            # 004025d8
L_004025dd:
    # block 0x004025dd: entered by jmp at 0x004025c5, 4 instruction(s), ends with jne to 0x00402605 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004025dd
    mov eax, dword ptr [edx + field_5c]          # 004025e0
    cmp dword ptr [4*eax + 0x5e60fe], 0x1        # 004025e3
    jne.d8 L_00402605                            # 004025eb
    # block 0x004025ed: entered by fall-through of jne at 0x004025eb, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x0040261b
    push 0x0                                     # 004025ed
    push 0x1                                     # 004025ef
    push 0xf1                                    # 004025f1
    push 0x40c                                   # 004025f6
    mov ecx, dword ptr [ebp - local_4]           # 004025fb
    call FUN_0051d48c                            # 004025fe
    jmp.d8 L_0040261b                            # 00402603
L_00402605:
    # block 0x00402605: entered by jne at 0x004025eb, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x0040261b
    push 0x0                                     # 00402605
    push 0x0                                     # 00402607
    push 0xf1                                    # 00402609
    push 0x40c                                   # 0040260e
    mov ecx, dword ptr [ebp - local_4]           # 00402613
    call FUN_0051d48c                            # 00402616
L_0040261b:
    # block 0x0040261b: entered by jmp at 0x00402603, 4 instruction(s), ends with jne to 0x00402643 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0040261b
    mov edx, dword ptr [ecx + field_5c]          # 0040261e
    cmp dword ptr [4*edx + 0x5e6102], 0x1        # 00402621
    jne.d8 L_00402643                            # 00402629
    # block 0x0040262b: entered by fall-through of jne at 0x00402629, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402659
    push 0x0                                     # 0040262b
    push 0x1                                     # 0040262d
    push 0xf1                                    # 0040262f
    push 0x40b                                   # 00402634
    mov ecx, dword ptr [ebp - local_4]           # 00402639
    call FUN_0051d48c                            # 0040263c
    jmp.d8 L_00402659                            # 00402641
L_00402643:
    # block 0x00402643: entered by jne at 0x00402629, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402659
    push 0x0                                     # 00402643
    push 0x0                                     # 00402645
    push 0xf1                                    # 00402647
    push 0x40b                                   # 0040264c
    mov ecx, dword ptr [ebp - local_4]           # 00402651
    call FUN_0051d48c                            # 00402654
L_00402659:
    # block 0x00402659: entered by jmp at 0x00402641, 4 instruction(s), ends with jne to 0x00402681 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00402659
    mov ecx, dword ptr [eax + field_5c]          # 0040265c
    cmp dword ptr [4*ecx + 0x5e6106], 0x1        # 0040265f
    jne.d8 L_00402681                            # 00402667
    # block 0x00402669: entered by fall-through of jne at 0x00402667, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402697
    push 0x0                                     # 00402669
    push 0x1                                     # 0040266b
    push 0xf1                                    # 0040266d
    push 0x404                                   # 00402672
    mov ecx, dword ptr [ebp - local_4]           # 00402677
    call FUN_0051d48c                            # 0040267a
    jmp.d8 L_00402697                            # 0040267f
L_00402681:
    # block 0x00402681: entered by jne at 0x00402667, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402697
    push 0x0                                     # 00402681
    push 0x0                                     # 00402683
    push 0xf1                                    # 00402685
    push 0x404                                   # 0040268a
    mov ecx, dword ptr [ebp - local_4]           # 0040268f
    call FUN_0051d48c                            # 00402692
L_00402697:
    # block 0x00402697: entered by jmp at 0x0040267f, 4 instruction(s), ends with jne to 0x004026bf (forward)
    mov edx, dword ptr [ebp - local_4]           # 00402697
    mov eax, dword ptr [edx + field_5c]          # 0040269a
    cmp dword ptr [4*eax + 0x5e610a], 0x1        # 0040269d
    jne.d8 L_004026bf                            # 004026a5
    # block 0x004026a7: entered by fall-through of jne at 0x004026a5, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004026d5
    push 0x0                                     # 004026a7
    push 0x1                                     # 004026a9
    push 0xf1                                    # 004026ab
    push 0x405                                   # 004026b0
    mov ecx, dword ptr [ebp - local_4]           # 004026b5
    call FUN_0051d48c                            # 004026b8
    jmp.d8 L_004026d5                            # 004026bd
L_004026bf:
    # block 0x004026bf: entered by jne at 0x004026a5, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004026d5
    push 0x0                                     # 004026bf
    push 0x0                                     # 004026c1
    push 0xf1                                    # 004026c3
    push 0x405                                   # 004026c8
    mov ecx, dword ptr [ebp - local_4]           # 004026cd
    call FUN_0051d48c                            # 004026d0
L_004026d5:
    # block 0x004026d5: entered by jmp at 0x004026bd, 4 instruction(s), ends with jne to 0x004026fd (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004026d5
    mov edx, dword ptr [ecx + field_5c]          # 004026d8
    cmp dword ptr [4*edx + 0x5e610e], 0x1        # 004026db
    jne.d8 L_004026fd                            # 004026e3
    # block 0x004026e5: entered by fall-through of jne at 0x004026e3, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402713
    push 0x0                                     # 004026e5
    push 0x1                                     # 004026e7
    push 0xf1                                    # 004026e9
    push 0x406                                   # 004026ee
    mov ecx, dword ptr [ebp - local_4]           # 004026f3
    call FUN_0051d48c                            # 004026f6
    jmp.d8 L_00402713                            # 004026fb
L_004026fd:
    # block 0x004026fd: entered by jne at 0x004026e3, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402713
    push 0x0                                     # 004026fd
    push 0x0                                     # 004026ff
    push 0xf1                                    # 00402701
    push 0x406                                   # 00402706
    mov ecx, dword ptr [ebp - local_4]           # 0040270b
    call FUN_0051d48c                            # 0040270e
L_00402713:
    # block 0x00402713: entered by jmp at 0x004026fb, 4 instruction(s), ends with jne to 0x0040273b (forward)
    mov eax, dword ptr [ebp - local_4]           # 00402713
    mov ecx, dword ptr [eax + field_5c]          # 00402716
    cmp dword ptr [4*ecx + 0x5e6112], 0x1        # 00402719
    jne.d8 L_0040273b                            # 00402721
    # block 0x00402723: entered by fall-through of jne at 0x00402721, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402751
    push 0x0                                     # 00402723
    push 0x1                                     # 00402725
    push 0xf1                                    # 00402727
    push 0x407                                   # 0040272c
    mov ecx, dword ptr [ebp - local_4]           # 00402731
    call FUN_0051d48c                            # 00402734
    jmp.d8 L_00402751                            # 00402739
L_0040273b:
    # block 0x0040273b: entered by jne at 0x00402721, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402751
    push 0x0                                     # 0040273b
    push 0x0                                     # 0040273d
    push 0xf1                                    # 0040273f
    push 0x407                                   # 00402744
    mov ecx, dword ptr [ebp - local_4]           # 00402749
    call FUN_0051d48c                            # 0040274c
L_00402751:
    # block 0x00402751: entered by jmp at 0x00402739, 4 instruction(s), ends with jne to 0x00402779 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00402751
    mov eax, dword ptr [edx + field_5c]          # 00402754
    cmp dword ptr [4*eax + 0x5e6116], 0x1        # 00402757
    jne.d8 L_00402779                            # 0040275f
    # block 0x00402761: entered by fall-through of jne at 0x0040275f, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x0040278f
    push 0x0                                     # 00402761
    push 0x1                                     # 00402763
    push 0xf1                                    # 00402765
    push 0x408                                   # 0040276a
    mov ecx, dword ptr [ebp - local_4]           # 0040276f
    call FUN_0051d48c                            # 00402772
    jmp.d8 L_0040278f                            # 00402777
L_00402779:
    # block 0x00402779: entered by jne at 0x0040275f, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x0040278f
    push 0x0                                     # 00402779
    push 0x0                                     # 0040277b
    push 0xf1                                    # 0040277d
    push 0x408                                   # 00402782
    mov ecx, dword ptr [ebp - local_4]           # 00402787
    call FUN_0051d48c                            # 0040278a
L_0040278f:
    # block 0x0040278f: entered by jmp at 0x00402777, 4 instruction(s), ends with jne to 0x004027b7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0040278f
    mov edx, dword ptr [ecx + field_5c]          # 00402792
    cmp dword ptr [4*edx + 0x5e611a], 0x1        # 00402795
    jne.d8 L_004027b7                            # 0040279d
    # block 0x0040279f: entered by fall-through of jne at 0x0040279d, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004027cd
    push 0x0                                     # 0040279f
    push 0x1                                     # 004027a1
    push 0xf1                                    # 004027a3
    push 0x409                                   # 004027a8
    mov ecx, dword ptr [ebp - local_4]           # 004027ad
    call FUN_0051d48c                            # 004027b0
    jmp.d8 L_004027cd                            # 004027b5
L_004027b7:
    # block 0x004027b7: entered by jne at 0x0040279d, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004027cd
    push 0x0                                     # 004027b7
    push 0x0                                     # 004027b9
    push 0xf1                                    # 004027bb
    push 0x409                                   # 004027c0
    mov ecx, dword ptr [ebp - local_4]           # 004027c5
    call FUN_0051d48c                            # 004027c8
L_004027cd:
    # block 0x004027cd: entered by jmp at 0x004027b5, 4 instruction(s), ends with jne to 0x004027f5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004027cd
    mov ecx, dword ptr [eax + field_5c]          # 004027d0
    cmp dword ptr [4*ecx + 0x5e611e], 0x1        # 004027d3
    jne.d8 L_004027f5                            # 004027db
    # block 0x004027dd: entered by fall-through of jne at 0x004027db, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x0040280b
    push 0x0                                     # 004027dd
    push 0x1                                     # 004027df
    push 0xf1                                    # 004027e1
    push 0x40a                                   # 004027e6
    mov ecx, dword ptr [ebp - local_4]           # 004027eb
    call FUN_0051d48c                            # 004027ee
    jmp.d8 L_0040280b                            # 004027f3
L_004027f5:
    # block 0x004027f5: entered by jne at 0x004027db, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x0040280b
    push 0x0                                     # 004027f5
    push 0x0                                     # 004027f7
    push 0xf1                                    # 004027f9
    push 0x40a                                   # 004027fe
    mov ecx, dword ptr [ebp - local_4]           # 00402803
    call FUN_0051d48c                            # 00402806
L_0040280b:
    # block 0x0040280b: entered by jmp at 0x004027f3, 4 instruction(s), ends with jne to 0x00402833 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0040280b
    mov eax, dword ptr [edx + field_5c]          # 0040280e
    cmp dword ptr [4*eax + 0x5e6122], 0x1        # 00402811
    jne.d8 L_00402833                            # 00402819
    # block 0x0040281b: entered by fall-through of jne at 0x00402819, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402849
    push 0x0                                     # 0040281b
    push 0x1                                     # 0040281d
    push 0xf1                                    # 0040281f
    push 0x40f                                   # 00402824
    mov ecx, dword ptr [ebp - local_4]           # 00402829
    call FUN_0051d48c                            # 0040282c
    jmp.d8 L_00402849                            # 00402831
L_00402833:
    # block 0x00402833: entered by jne at 0x00402819, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402849
    push 0x0                                     # 00402833
    push 0x0                                     # 00402835
    push 0xf1                                    # 00402837
    push 0x40f                                   # 0040283c
    mov ecx, dword ptr [ebp - local_4]           # 00402841
    call FUN_0051d48c                            # 00402844
L_00402849:
    # block 0x00402849: entered by jmp at 0x00402831, 4 instruction(s), ends with jne to 0x00402871 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00402849
    mov edx, dword ptr [ecx + field_5c]          # 0040284c
    cmp dword ptr [4*edx + 0x5e6126], 0x1        # 0040284f
    jne.d8 L_00402871                            # 00402857
    # block 0x00402859: entered by fall-through of jne at 0x00402857, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402887
    push 0x0                                     # 00402859
    push 0x1                                     # 0040285b
    push 0xf1                                    # 0040285d
    push 0x410                                   # 00402862
    mov ecx, dword ptr [ebp - local_4]           # 00402867
    call FUN_0051d48c                            # 0040286a
    jmp.d8 L_00402887                            # 0040286f
L_00402871:
    # block 0x00402871: entered by jne at 0x00402857, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402887
    push 0x0                                     # 00402871
    push 0x0                                     # 00402873
    push 0xf1                                    # 00402875
    push 0x410                                   # 0040287a
    mov ecx, dword ptr [ebp - local_4]           # 0040287f
    call FUN_0051d48c                            # 00402882
L_00402887:
    # block 0x00402887: entered by jmp at 0x0040286f, 4 instruction(s), ends with jne to 0x004028af (forward)
    mov eax, dword ptr [ebp - local_4]           # 00402887
    mov ecx, dword ptr [eax + field_5c]          # 0040288a
    cmp dword ptr [4*ecx + 0x5e612a], 0x1        # 0040288d
    jne.d8 L_004028af                            # 00402895
    # block 0x00402897: entered by fall-through of jne at 0x00402895, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x004028c5
    push 0x0                                     # 00402897
    push 0x1                                     # 00402899
    push 0xf1                                    # 0040289b
    push 0x411                                   # 004028a0
    mov ecx, dword ptr [ebp - local_4]           # 004028a5
    call FUN_0051d48c                            # 004028a8
    jmp.d8 L_004028c5                            # 004028ad
L_004028af:
    # block 0x004028af: entered by jne at 0x00402895, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x004028c5
    push 0x0                                     # 004028af
    push 0x0                                     # 004028b1
    push 0xf1                                    # 004028b3
    push 0x411                                   # 004028b8
    mov ecx, dword ptr [ebp - local_4]           # 004028bd
    call FUN_0051d48c                            # 004028c0
L_004028c5:
    # block 0x004028c5: entered by jmp at 0x004028ad, 4 instruction(s), ends with jne to 0x004028ed (forward)
    mov edx, dword ptr [ebp - local_4]           # 004028c5
    mov eax, dword ptr [edx + field_5c]          # 004028c8
    cmp dword ptr [4*eax + 0x5e612e], 0x1        # 004028cb
    jne.d8 L_004028ed                            # 004028d3
    # block 0x004028d5: entered by fall-through of jne at 0x004028d3, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402903
    push 0x0                                     # 004028d5
    push 0x1                                     # 004028d7
    push 0xf1                                    # 004028d9
    push 0x412                                   # 004028de
    mov ecx, dword ptr [ebp - local_4]           # 004028e3
    call FUN_0051d48c                            # 004028e6
    jmp.d8 L_00402903                            # 004028eb
L_004028ed:
    # block 0x004028ed: entered by jne at 0x004028d3, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402903
    push 0x0                                     # 004028ed
    push 0x0                                     # 004028ef
    push 0xf1                                    # 004028f1
    push 0x412                                   # 004028f6
    mov ecx, dword ptr [ebp - local_4]           # 004028fb
    call FUN_0051d48c                            # 004028fe
L_00402903:
    # block 0x00402903: entered by jmp at 0x004028eb, 4 instruction(s), ends with jne to 0x0040292b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00402903
    mov edx, dword ptr [ecx + field_5c]          # 00402906
    cmp dword ptr [4*edx + 0x5e6132], 0x1        # 00402909
    jne.d8 L_0040292b                            # 00402911
    # block 0x00402913: entered by fall-through of jne at 0x00402911, 7 instruction(s), calls FUN_0051d48c, ends with forward jump to 0x00402941
    push 0x0                                     # 00402913
    push 0x1                                     # 00402915
    push 0xf1                                    # 00402917
    push 0x413                                   # 0040291c
    mov ecx, dword ptr [ebp - local_4]           # 00402921
    call FUN_0051d48c                            # 00402924
    jmp.d8 L_00402941                            # 00402929
L_0040292b:
    # block 0x0040292b: entered by jne at 0x00402911, 6 instruction(s), calls FUN_0051d48c, falls into the block at 0x00402941
    push 0x0                                     # 0040292b
    push 0x0                                     # 0040292d
    push 0xf1                                    # 0040292f
    push 0x413                                   # 00402934
    mov ecx, dword ptr [ebp - local_4]           # 00402939
    call FUN_0051d48c                            # 0040293c
L_00402941:
    # block 0x00402941: entered by jmp at 0x00402929, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00402941
    pop ebp                                      # 00402943
    ret                                          # 00402944

