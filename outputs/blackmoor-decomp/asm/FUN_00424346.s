# FUN_00424346
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00424346
# extent:       0x00424346-0x00424a3c (1782 code bytes)
# span:         0x00424346-0x00424aa8 (code 1782, tables 108, padding 0)
# sha256:       6ef61d36effbd2005a44bc6657536230683d1b1e885449958c0f0a434f627704
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m424346_node_condition
# naming:       native port src/original_methods_fl26c.c:m424346_node_condition (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m424346_node_condition: every kind arm and both jump tables, 451/451 instructions, 116/116 jump directions, 2292 scenarios. Native rejections listed in tasks/fl26c-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       15 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30 and 3 more
# fields:       [eax + n] field_2, field_4, field_10, field_14, field_16, field_20, field_24, field_30; [ecx + n] field_2, field_4, field_14, field_24, field_28, field_30; [edx + n] field_2, field_4, field_6, field_12, field_24, field_2c, field_48, field_614
# callees:      calls FUN_004f6334, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_0050cd50, FUN_0044a2b7, FUN_0042639d
# track-n:      outputs/blackmoor-decomp/src/condition_extra.c:evaluate_random (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 451 instruction(s), 58 conditional branch(es) and 2 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_48, 0x48  # offset +0x48
.equ field_614, 0x614  # offset +0x614

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00424346 - 0x401000
.globl FUN_00424346
FUN_00424346:
    # block 0x00424346: entry, 32 instruction(s), ends with ja to 0x00424a02 (forward)
    push ebp                                     # 00424346
    {load} mov ebp, esp                          # 00424347
    sub esp, 0x3c                                # 00424349
    mov dword ptr [ebp - local_30], ecx          # 0042434c
    mov eax, dword ptr [ebp + arg_8]             # 0042434f
    movsx ecx, word ptr [eax + field_10]         # 00424352
    mov dword ptr [ebp - local_14], ecx          # 00424356
    mov edx, dword ptr [ebp + arg_8]             # 00424359
    movsx eax, word ptr [edx + field_12]         # 0042435c
    mov dword ptr [ebp - local_8], eax           # 00424360
    mov ecx, dword ptr [ebp + arg_8]             # 00424363
    movsx edx, word ptr [ecx + field_14]         # 00424366
    mov dword ptr [ebp - local_20], edx          # 0042436a
    mov eax, dword ptr [ebp + arg_8]             # 0042436d
    movsx ecx, word ptr [eax + field_16]         # 00424370
    mov dword ptr [ebp - local_2c], ecx          # 00424374
    mov edx, dword ptr [ebp + arg_8]             # 00424377
    add edx, 0x18                                # 0042437a
    mov dword ptr [ebp - local_1c], edx          # 0042437d
    mov eax, dword ptr [ebp + arg_8]             # 00424380
    mov ecx, dword ptr [eax + field_20]          # 00424383
    mov dword ptr [ebp - local_28], ecx          # 00424386
    mov edx, dword ptr [ebp + arg_8]             # 00424389
    mov eax, dword ptr [edx + field_24]          # 0042438c
    mov dword ptr [ebp - local_24], eax          # 0042438f
    mov ecx, dword ptr [ebp + arg_8]             # 00424392
    mov edx, dword ptr [ecx + field_28]          # 00424395
    mov dword ptr [ebp - local_18], edx          # 00424398
    mov eax, dword ptr [ebp - local_14]          # 0042439b
    mov dword ptr [ebp - local_34], eax          # 0042439e
    cmp dword ptr [ebp - local_34], 0x16         # 004243a1
    ja.d32 L_00424a02                            # 004243a5
    # block 0x004243ab: entered by fall-through of ja at 0x004243a5, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x424a3c]
    mov ecx, dword ptr [ebp - local_34]          # 004243ab
    jmp dword ptr [4*ecx + SWTAB_00424a3c_VA]    # 004243ae
L_004243b5:
    # block 0x004243b5: entered by switch case, 2 instruction(s), ends with jne to 0x004243d4 (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 004243b5
    jne.d8 L_004243d4                            # 004243b9
    # block 0x004243bb: entered by fall-through of jne at 0x004243b9, 3 instruction(s), ends with je to 0x004243f3 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004243bb
    cmp dword ptr [4*edx + 0x583bd5], 0x1        # 004243be
    je.d8 L_004243f3                             # 004243c6
    # block 0x004243c8: entered by fall-through of je at 0x004243c6, 3 instruction(s), ends with je to 0x004243f3 (forward)
    movsx eax, word ptr [0x583a29]               # 004243c8
    cmp eax, dword ptr [ebp - local_8]           # 004243cf
    je.d8 L_004243f3                             # 004243d2
L_004243d4:
    # block 0x004243d4: entered by jne at 0x004243b9; fall-through of je at 0x004243d2, 2 instruction(s), ends with jne to 0x004243ff (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004243d4
    jne.d8 L_004243ff                            # 004243d8
    # block 0x004243da: entered by fall-through of jne at 0x004243d8, 3 instruction(s), ends with jne to 0x004243ff (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004243da
    cmp dword ptr [4*ecx + 0x583bd5], 0x0        # 004243dd
    jne.d8 L_004243ff                            # 004243e5
    # block 0x004243e7: entered by fall-through of jne at 0x004243e5, 3 instruction(s), ends with je to 0x004243ff (forward)
    movsx edx, word ptr [0x583a29]               # 004243e7
    cmp edx, dword ptr [ebp - local_8]           # 004243ee
    je.d8 L_004243ff                             # 004243f1
L_004243f3:
    # block 0x004243f3: entered by je at 0x004243c6; je at 0x004243d2; fall-through of je at 0x004243f1, 3 instruction(s), ends with forward jump to 0x00424409
    mov eax, dword ptr [ebp + arg_8]             # 004243f3
    mov dword ptr [eax + field_4], 0x1           # 004243f6
    jmp.d8 L_00424409                            # 004243fd
L_004243ff:
    # block 0x004243ff: entered by jne at 0x004243d8; jne at 0x004243e5; je at 0x004243f1, 2 instruction(s), falls into the block at 0x00424409
    mov ecx, dword ptr [ebp + arg_8]             # 004243ff
    mov dword ptr [ecx + field_4], 0x0           # 00424402
L_00424409:
    # block 0x00424409: entered by jmp at 0x004243fd, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424409
L_0042440e:
    # block 0x0042440e: entered by switch case, 7 instruction(s), ends with je to 0x0042443c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0042440e
    mov eax, dword ptr [edx + field_48]          # 00424411
    mov ecx, dword ptr [eax + field_14]          # 00424414
    mov dword ptr [ebp - local_10], ecx          # 00424417
    mov edx, dword ptr [ebp - local_30]          # 0042441a
    cmp dword ptr [edx + field_614], 0x0         # 0042441d
    je.d8 L_0042443c                             # 00424424
    # block 0x00424426: entered by fall-through of je at 0x00424424, 5 instruction(s), ends with forward jump to 0x0042447c
    mov eax, dword ptr [ebp + arg_8]             # 00424426
    mov dword ptr [eax + field_4], 0x1           # 00424429
    mov ecx, dword ptr [ebp - local_10]          # 00424430
    mov dword ptr [ecx + field_24], 0x0          # 00424433
    jmp.d8 L_0042447c                            # 0042443a
L_0042443c:
    # block 0x0042443c: entered by je at 0x00424424, 3 instruction(s), ends with jne to 0x0042445d (forward)
    movsx edx, word ptr [0x583a29]               # 0042443c
    cmp edx, dword ptr [ebp - local_8]           # 00424443
    jne.d8 L_0042445d                            # 00424446
    # block 0x00424448: entered by fall-through of jne at 0x00424446, 6 instruction(s), ends with forward jump to 0x0042447c
    mov eax, dword ptr [ebp + arg_8]             # 00424448
    mov dword ptr [eax + field_4], 0x1           # 0042444b
    mov ecx, dword ptr [ebp - local_10]          # 00424452
    mov edx, dword ptr [ebp + arg_8]             # 00424455
    mov dword ptr [ecx + field_24], edx          # 00424458
    jmp.d8 L_0042447c                            # 0042445b
L_0042445d:
    # block 0x0042445d: entered by jne at 0x00424446, 6 instruction(s), ends with jne to 0x0042447c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 0042445d
    mov dword ptr [eax + field_4], 0x0           # 00424460
    mov ecx, dword ptr [ebp - local_10]          # 00424467
    mov edx, dword ptr [ecx + field_24]          # 0042446a
    cmp edx, dword ptr [ebp + arg_8]             # 0042446d
    jne.d8 L_0042447c                            # 00424470
    # block 0x00424472: entered by fall-through of jne at 0x00424470, 2 instruction(s), falls into the block at 0x0042447c
    mov eax, dword ptr [ebp - local_10]          # 00424472
    mov dword ptr [eax + field_24], 0x0          # 00424475
L_0042447c:
    # block 0x0042447c: entered by jmp at 0x0042443a; jmp at 0x0042445b; jne at 0x00424470, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 0042447c
L_00424481:
    # block 0x00424481: entered by switch case, 4 instruction(s), ends with jne to 0x0042449c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00424481
    mov edx, dword ptr [4*ecx + 0x585801]        # 00424484
    cmp edx, dword ptr [ebp - local_20]          # 0042448b
    jne.d8 L_0042449c                            # 0042448e
    # block 0x00424490: entered by fall-through of jne at 0x0042448e, 3 instruction(s), ends with forward jump to 0x004244a6
    mov eax, dword ptr [ebp + arg_8]             # 00424490
    mov dword ptr [eax + field_4], 0x1           # 00424493
    jmp.d8 L_004244a6                            # 0042449a
L_0042449c:
    # block 0x0042449c: entered by jne at 0x0042448e, 2 instruction(s), falls into the block at 0x004244a6
    mov ecx, dword ptr [ebp + arg_8]             # 0042449c
    mov dword ptr [ecx + field_4], 0x0           # 0042449f
L_004244a6:
    # block 0x004244a6: entered by jmp at 0x0042449a, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 004244a6
L_004244ab:
    # block 0x004244ab: entered by switch case, 7 instruction(s), calls FUN_004f6334, ends with jne to 0x004244c8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004244ab
    push edx                                     # 004244ae
    mov ecx, 0x5cf1eb                            # 004244af
    call FUN_004f6334                            # 004244b4
    mov dword ptr [ebp - local_4], eax           # 004244b9
    cmp dword ptr [ebp - local_20], 0x1          # 004244bc
    jne.d8 L_004244c8                            # 004244c0
    # block 0x004244c2: entered by fall-through of jne at 0x004244c0, 2 instruction(s), ends with jne to 0x004244d4 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004244c2
    jne.d8 L_004244d4                            # 004244c6
L_004244c8:
    # block 0x004244c8: entered by jne at 0x004244c0; fall-through of jne at 0x004244c6, 2 instruction(s), ends with jne to 0x004244e0 (forward)
    cmp dword ptr [ebp - local_20], 0x0          # 004244c8
    jne.d8 L_004244e0                            # 004244cc
    # block 0x004244ce: entered by fall-through of jne at 0x004244cc, 2 instruction(s), ends with jne to 0x004244e0 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004244ce
    jne.d8 L_004244e0                            # 004244d2
L_004244d4:
    # block 0x004244d4: entered by jne at 0x004244c6; fall-through of jne at 0x004244d2, 3 instruction(s), ends with forward jump to 0x004244ea
    mov eax, dword ptr [ebp + arg_8]             # 004244d4
    mov dword ptr [eax + field_4], 0x1           # 004244d7
    jmp.d8 L_004244ea                            # 004244de
L_004244e0:
    # block 0x004244e0: entered by jne at 0x004244cc; jne at 0x004244d2, 2 instruction(s), falls into the block at 0x004244ea
    mov ecx, dword ptr [ebp + arg_8]             # 004244e0
    mov dword ptr [ecx + field_4], 0x0           # 004244e3
L_004244ea:
    # block 0x004244ea: entered by jmp at 0x004244de, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 004244ea
L_004244ef:
    # block 0x004244ef: entered by switch case, 4 instruction(s), ends with jne to 0x0042450a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004244ef
    mov eax, dword ptr [4*edx + 0x581a71]        # 004244f2
    cmp eax, dword ptr [ebp - local_20]          # 004244f9
    jne.d8 L_0042450a                            # 004244fc
    # block 0x004244fe: entered by fall-through of jne at 0x004244fc, 3 instruction(s), ends with forward jump to 0x00424514
    mov ecx, dword ptr [ebp + arg_8]             # 004244fe
    mov dword ptr [ecx + field_4], 0x1           # 00424501
    jmp.d8 L_00424514                            # 00424508
L_0042450a:
    # block 0x0042450a: entered by jne at 0x004244fc, 2 instruction(s), falls into the block at 0x00424514
    mov edx, dword ptr [ebp + arg_8]             # 0042450a
    mov dword ptr [edx + field_4], 0x0           # 0042450d
L_00424514:
    # block 0x00424514: entered by jmp at 0x00424508, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424514
L_00424519:
    # block 0x00424519: entered by switch case, 3 instruction(s), ends with jne to 0x00424531 (forward)
    movsx eax, word ptr [0x58c94f]               # 00424519
    cmp eax, dword ptr [ebp - local_20]          # 00424520
    jne.d8 L_00424531                            # 00424523
    # block 0x00424525: entered by fall-through of jne at 0x00424523, 3 instruction(s), ends with forward jump to 0x0042453b
    mov ecx, dword ptr [ebp + arg_8]             # 00424525
    mov dword ptr [ecx + field_4], 0x1           # 00424528
    jmp.d8 L_0042453b                            # 0042452f
L_00424531:
    # block 0x00424531: entered by jne at 0x00424523, 2 instruction(s), falls into the block at 0x0042453b
    mov edx, dword ptr [ebp + arg_8]             # 00424531
    mov dword ptr [edx + field_4], 0x0           # 00424534
L_0042453b:
    # block 0x0042453b: entered by jmp at 0x0042452f, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 0042453b
L_00424540:
    # block 0x00424540: entered by switch case, 2 instruction(s), ends with jne to 0x0042454f (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 00424540
    jne.d8 L_0042454f                            # 00424544
    # block 0x00424546: entered by fall-through of jne at 0x00424544, 2 instruction(s), ends with je to 0x0042455e (forward)
    cmp dword ptr [0x5bb202], 0x0                # 00424546
    je.d8 L_0042455e                             # 0042454d
L_0042454f:
    # block 0x0042454f: entered by jne at 0x00424544; fall-through of je at 0x0042454d, 2 instruction(s), ends with jne to 0x0042456a (forward)
    cmp dword ptr [ebp - local_20], 0x2          # 0042454f
    jne.d8 L_0042456a                            # 00424553
    # block 0x00424555: entered by fall-through of jne at 0x00424553, 2 instruction(s), ends with je to 0x0042456a (forward)
    cmp dword ptr [0x5bb202], 0x0                # 00424555
    je.d8 L_0042456a                             # 0042455c
L_0042455e:
    # block 0x0042455e: entered by je at 0x0042454d; fall-through of je at 0x0042455c, 3 instruction(s), ends with forward jump to 0x00424574
    mov eax, dword ptr [ebp + arg_8]             # 0042455e
    mov dword ptr [eax + field_4], 0x1           # 00424561
    jmp.d8 L_00424574                            # 00424568
L_0042456a:
    # block 0x0042456a: entered by jne at 0x00424553; je at 0x0042455c, 2 instruction(s), falls into the block at 0x00424574
    mov ecx, dword ptr [ebp + arg_8]             # 0042456a
    mov dword ptr [ecx + field_4], 0x0           # 0042456d
L_00424574:
    # block 0x00424574: entered by jmp at 0x00424568, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424574
L_00424579:
    # block 0x00424579: entered by switch case, 5 instruction(s), ends with je to 0x0042459a (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00424579
    movsx eax, word ptr [edx + field_6]          # 0042457c
    mov dword ptr [ebp - local_38], eax          # 00424580
    cmp dword ptr [ebp - local_38], 0x1          # 00424583
    je.d8 L_0042459a                             # 00424587
    # block 0x00424589: entered by fall-through of je at 0x00424587, 2 instruction(s), ends with je to 0x004245ce (forward)
    cmp dword ptr [ebp - local_38], 0x2          # 00424589
    je.d8 L_004245ce                             # 0042458d
    # block 0x0042458f: entered by fall-through of je at 0x0042458d, 2 instruction(s), ends with je to 0x004245ff (forward)
    cmp dword ptr [ebp - local_38], 0x3          # 0042458f
    je.d8 L_004245ff                             # 00424593
    # block 0x00424595: entered by fall-through of je at 0x00424593, 1 instruction(s), ends with forward jump to 0x00424630
    jmp.d32 L_00424630                           # 00424595
L_0042459a:
    # block 0x0042459a: entered by je at 0x00424587, 7 instruction(s), ends with jge to 0x004245bf (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 0042459a
    movsx edx, word ptr [ecx]                    # 0042459d
    movsx eax, word ptr [2*edx + 0x587b2d]       # 004245a0
    mov ecx, dword ptr [ebp - local_1c]          # 004245a8
    movsx edx, word ptr [ecx + field_2]          # 004245ab
    {load} cmp eax, edx                          # 004245af
    jge.d8 L_004245bf                            # 004245b1
    # block 0x004245b3: entered by fall-through of jge at 0x004245b1, 3 instruction(s), ends with forward jump to 0x004245c9
    mov eax, dword ptr [ebp + arg_8]             # 004245b3
    mov dword ptr [eax + field_4], 0x1           # 004245b6
    jmp.d8 L_004245c9                            # 004245bd
L_004245bf:
    # block 0x004245bf: entered by jge at 0x004245b1, 2 instruction(s), falls into the block at 0x004245c9
    mov ecx, dword ptr [ebp + arg_8]             # 004245bf
    mov dword ptr [ecx + field_4], 0x0           # 004245c2
L_004245c9:
    # block 0x004245c9: entered by jmp at 0x004245bd, 1 instruction(s), ends with forward jump to 0x00424661
    jmp.d32 L_00424661                           # 004245c9
L_004245ce:
    # block 0x004245ce: entered by je at 0x0042458d, 7 instruction(s), ends with jle to 0x004245f3 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004245ce
    movsx eax, word ptr [edx]                    # 004245d1
    movsx ecx, word ptr [2*eax + 0x587b2d]       # 004245d4
    mov edx, dword ptr [ebp - local_1c]          # 004245dc
    movsx eax, word ptr [edx + field_2]          # 004245df
    {load} cmp ecx, eax                          # 004245e3
    jle.d8 L_004245f3                            # 004245e5
    # block 0x004245e7: entered by fall-through of jle at 0x004245e5, 3 instruction(s), ends with forward jump to 0x004245fd
    mov ecx, dword ptr [ebp + arg_8]             # 004245e7
    mov dword ptr [ecx + field_4], 0x1           # 004245ea
    jmp.d8 L_004245fd                            # 004245f1
L_004245f3:
    # block 0x004245f3: entered by jle at 0x004245e5, 2 instruction(s), falls into the block at 0x004245fd
    mov edx, dword ptr [ebp + arg_8]             # 004245f3
    mov dword ptr [edx + field_4], 0x0           # 004245f6
L_004245fd:
    # block 0x004245fd: entered by jmp at 0x004245f1, 1 instruction(s), ends with forward jump to 0x00424661
    jmp.d8 L_00424661                            # 004245fd
L_004245ff:
    # block 0x004245ff: entered by je at 0x00424593, 7 instruction(s), ends with jne to 0x00424624 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004245ff
    movsx ecx, word ptr [eax + field_2]          # 00424602
    mov edx, dword ptr [ebp - local_1c]          # 00424606
    movsx eax, word ptr [edx]                    # 00424609
    movsx edx, word ptr [2*eax + 0x587b2d]       # 0042460c
    {load} cmp ecx, edx                          # 00424614
    jne.d8 L_00424624                            # 00424616
    # block 0x00424618: entered by fall-through of jne at 0x00424616, 3 instruction(s), ends with forward jump to 0x0042462e
    mov eax, dword ptr [ebp + arg_8]             # 00424618
    mov dword ptr [eax + field_4], 0x1           # 0042461b
    jmp.d8 L_0042462e                            # 00424622
L_00424624:
    # block 0x00424624: entered by jne at 0x00424616, 2 instruction(s), falls into the block at 0x0042462e
    mov ecx, dword ptr [ebp + arg_8]             # 00424624
    mov dword ptr [ecx + field_4], 0x0           # 00424627
L_0042462e:
    # block 0x0042462e: entered by jmp at 0x00424622, 1 instruction(s), ends with forward jump to 0x00424661
    jmp.d8 L_00424661                            # 0042462e
L_00424630:
    # block 0x00424630: entered by jmp at 0x00424595, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00424661
    mov edx, dword ptr [0x5bb57b]                # 00424630
    push edx                                     # 00424636
    push 0x5449a8                                # 00424637
    push 0x63888b                                # 0042463c
    call FUN_0050ca3e                            # 00424641
    add esp, 0xc                                 # 00424646
    push 0x0                                     # 00424649
    push 0x0                                     # 0042464b
    push 0x63888b                                # 0042464d
    call FUN_0052139c                            # 00424652
    mov ecx, 0x5cf659                            # 00424657
    call FUN_004c97b4                            # 0042465c
L_00424661:
    # block 0x00424661: entered by jmp at 0x004245c9; jmp at 0x004245fd; jmp at 0x0042462e, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424661
L_00424666:
    # block 0x00424666: entered by switch case, 3 instruction(s), ends with jne to 0x0042467e (forward)
    movsx eax, word ptr [0x5bb20a]               # 00424666
    cmp dword ptr [ebp - local_8], eax           # 0042466d
    jne.d8 L_0042467e                            # 00424670
    # block 0x00424672: entered by fall-through of jne at 0x00424670, 3 instruction(s), ends with forward jump to 0x00424688
    mov ecx, dword ptr [ebp + arg_8]             # 00424672
    mov dword ptr [ecx + field_4], 0x1           # 00424675
    jmp.d8 L_00424688                            # 0042467c
L_0042467e:
    # block 0x0042467e: entered by jne at 0x00424670, 2 instruction(s), falls into the block at 0x00424688
    mov edx, dword ptr [ebp + arg_8]             # 0042467e
    mov dword ptr [edx + field_4], 0x0           # 00424681
L_00424688:
    # block 0x00424688: entered by jmp at 0x0042467c, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424688
L_0042468d:
    # block 0x0042468d: entered by switch case, 3 instruction(s), ends with jl to 0x004246a3 (forward)
    mov eax, dword ptr [0x585d37]                # 0042468d
    cmp eax, dword ptr [ebp - local_28]          # 00424692
    jl.d8 L_004246a3                             # 00424695
    # block 0x00424697: entered by fall-through of jl at 0x00424695, 3 instruction(s), ends with forward jump to 0x004246ad
    mov ecx, dword ptr [ebp + arg_8]             # 00424697
    mov dword ptr [ecx + field_4], 0x1           # 0042469a
    jmp.d8 L_004246ad                            # 004246a1
L_004246a3:
    # block 0x004246a3: entered by jl at 0x00424695, 2 instruction(s), falls into the block at 0x004246ad
    mov edx, dword ptr [ebp + arg_8]             # 004246a3
    mov dword ptr [edx + field_4], 0x0           # 004246a6
L_004246ad:
    # block 0x004246ad: entered by jmp at 0x004246a1, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 004246ad
L_004246b2:
    # block 0x004246b2: entered by switch case, 4 instruction(s), ends with je to 0x004246e8 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004246b2
    imul eax, eax, 0x106                         # 004246b5
    cmp dword ptr [eax + 0x585d65], 0x1          # 004246bb
    je.d8 L_004246e8                             # 004246c2
    # block 0x004246c4: entered by fall-through of je at 0x004246c2, 4 instruction(s), ends with je to 0x004246e8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004246c4
    imul ecx, ecx, 0x106                         # 004246c7
    cmp dword ptr [ecx + 0x585d65], 0x5          # 004246cd
    je.d8 L_004246e8                             # 004246d4
    # block 0x004246d6: entered by fall-through of je at 0x004246d4, 4 instruction(s), ends with jne to 0x00424708 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004246d6
    imul edx, edx, 0x106                         # 004246d9
    cmp dword ptr [edx + 0x585d65], 0x6          # 004246df
    jne.d8 L_00424708                            # 004246e6
L_004246e8:
    # block 0x004246e8: entered by je at 0x004246c2; je at 0x004246d4; fall-through of jne at 0x004246e6, 5 instruction(s), ends with jg to 0x00424708 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004246e8
    imul eax, eax, 0x106                         # 004246eb
    mov ecx, dword ptr [eax + 0x585d69]          # 004246f1
    cmp ecx, dword ptr [ebp - local_28]          # 004246f7
    jg.d8 L_00424708                             # 004246fa
    # block 0x004246fc: entered by fall-through of jg at 0x004246fa, 3 instruction(s), ends with forward jump to 0x00424712
    mov edx, dword ptr [ebp + arg_8]             # 004246fc
    mov dword ptr [edx + field_4], 0x1           # 004246ff
    jmp.d8 L_00424712                            # 00424706
L_00424708:
    # block 0x00424708: entered by jne at 0x004246e6; jg at 0x004246fa, 2 instruction(s), falls into the block at 0x00424712
    mov eax, dword ptr [ebp + arg_8]             # 00424708
    mov dword ptr [eax + field_4], 0x0           # 0042470b
L_00424712:
    # block 0x00424712: entered by jmp at 0x00424706, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424712
L_00424717:
    # block 0x00424717: entered by switch case, 4 instruction(s), ends with je to 0x0042474d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00424717
    imul ecx, ecx, 0x106                         # 0042471a
    cmp dword ptr [ecx + 0x585d65], 0x1          # 00424720
    je.d8 L_0042474d                             # 00424727
    # block 0x00424729: entered by fall-through of je at 0x00424727, 4 instruction(s), ends with je to 0x0042474d (forward)
    mov edx, dword ptr [ebp - local_8]           # 00424729
    imul edx, edx, 0x106                         # 0042472c
    cmp dword ptr [edx + 0x585d65], 0x5          # 00424732
    je.d8 L_0042474d                             # 00424739
    # block 0x0042473b: entered by fall-through of je at 0x00424739, 4 instruction(s), ends with jne to 0x0042476d (forward)
    mov eax, dword ptr [ebp - local_8]           # 0042473b
    imul eax, eax, 0x106                         # 0042473e
    cmp dword ptr [eax + 0x585d65], 0x6          # 00424744
    jne.d8 L_0042476d                            # 0042474b
L_0042474d:
    # block 0x0042474d: entered by je at 0x00424727; je at 0x00424739; fall-through of jne at 0x0042474b, 5 instruction(s), ends with jle to 0x0042476d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0042474d
    imul ecx, ecx, 0x106                         # 00424750
    mov edx, dword ptr [ecx + 0x585d69]          # 00424756
    cmp edx, dword ptr [ebp - local_28]          # 0042475c
    jle.d8 L_0042476d                            # 0042475f
    # block 0x00424761: entered by fall-through of jle at 0x0042475f, 3 instruction(s), ends with forward jump to 0x00424777
    mov eax, dword ptr [ebp + arg_8]             # 00424761
    mov dword ptr [eax + field_4], 0x1           # 00424764
    jmp.d8 L_00424777                            # 0042476b
L_0042476d:
    # block 0x0042476d: entered by jne at 0x0042474b; jle at 0x0042475f, 2 instruction(s), falls into the block at 0x00424777
    mov ecx, dword ptr [ebp + arg_8]             # 0042476d
    mov dword ptr [ecx + field_4], 0x0           # 00424770
L_00424777:
    # block 0x00424777: entered by jmp at 0x0042476b, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 00424777
L_0042477c:
    # block 0x0042477c: entered by switch case, 4 instruction(s), ends with je to 0x004247b2 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0042477c
    imul edx, edx, 0x106                         # 0042477f
    cmp dword ptr [edx + 0x585d65], 0x1          # 00424785
    je.d8 L_004247b2                             # 0042478c
    # block 0x0042478e: entered by fall-through of je at 0x0042478c, 4 instruction(s), ends with je to 0x004247b2 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0042478e
    imul eax, eax, 0x106                         # 00424791
    cmp dword ptr [eax + 0x585d65], 0x5          # 00424797
    je.d8 L_004247b2                             # 0042479e
    # block 0x004247a0: entered by fall-through of je at 0x0042479e, 4 instruction(s), ends with jne to 0x004247be (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004247a0
    imul ecx, ecx, 0x106                         # 004247a3
    cmp dword ptr [ecx + 0x585d65], 0x6          # 004247a9
    jne.d8 L_004247be                            # 004247b0
L_004247b2:
    # block 0x004247b2: entered by je at 0x0042478c; je at 0x0042479e; fall-through of jne at 0x004247b0, 3 instruction(s), ends with forward jump to 0x004247c8
    mov edx, dword ptr [ebp + arg_8]             # 004247b2
    mov dword ptr [edx + field_4], 0x1           # 004247b5
    jmp.d8 L_004247c8                            # 004247bc
L_004247be:
    # block 0x004247be: entered by jne at 0x004247b0, 2 instruction(s), falls into the block at 0x004247c8
    mov eax, dword ptr [ebp + arg_8]             # 004247be
    mov dword ptr [eax + field_4], 0x0           # 004247c1
L_004247c8:
    # block 0x004247c8: entered by jmp at 0x004247bc, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 004247c8
L_004247cd:
    # block 0x004247cd: entered by switch case, 3 instruction(s), ends with jl to 0x004247e4 (forward)
    mov ecx, dword ptr [0x585d41]                # 004247cd
    cmp ecx, dword ptr [ebp - local_28]          # 004247d3
    jl.d8 L_004247e4                             # 004247d6
    # block 0x004247d8: entered by fall-through of jl at 0x004247d6, 3 instruction(s), ends with forward jump to 0x004247ee
    mov edx, dword ptr [ebp + arg_8]             # 004247d8
    mov dword ptr [edx + field_4], 0x1           # 004247db
    jmp.d8 L_004247ee                            # 004247e2
L_004247e4:
    # block 0x004247e4: entered by jl at 0x004247d6, 2 instruction(s), falls into the block at 0x004247ee
    mov eax, dword ptr [ebp + arg_8]             # 004247e4
    mov dword ptr [eax + field_4], 0x0           # 004247e7
L_004247ee:
    # block 0x004247ee: entered by jmp at 0x004247e2, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 004247ee
L_004247f3:
    # block 0x004247f3: entered by switch case, 4 instruction(s), ends with ja to 0x004248fa (forward)
    mov ecx, dword ptr [ebp - local_20]          # 004247f3
    mov dword ptr [ebp - local_3c], ecx          # 004247f6
    cmp dword ptr [ebp - local_3c], 0x3          # 004247f9
    ja.d32 L_004248fa                            # 004247fd
    # block 0x00424803: entered by fall-through of ja at 0x004247fd, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x424a98]
    mov edx, dword ptr [ebp - local_3c]          # 00424803
    jmp dword ptr [4*edx + SWTAB_00424a98_VA]    # 00424806
L_0042480d:
    # block 0x0042480d: entered by switch case, 3 instruction(s), ends with jl to 0x00424823 (forward)
    mov eax, dword ptr [0x585d4b]                # 0042480d
    cmp eax, dword ptr [ebp - local_28]          # 00424812
    jl.d8 L_00424823                             # 00424815
    # block 0x00424817: entered by fall-through of jl at 0x00424815, 3 instruction(s), ends with forward jump to 0x0042482d
    mov ecx, dword ptr [ebp + arg_8]             # 00424817
    mov dword ptr [ecx + field_4], 0x1           # 0042481a
    jmp.d8 L_0042482d                            # 00424821
L_00424823:
    # block 0x00424823: entered by jl at 0x00424815, 2 instruction(s), falls into the block at 0x0042482d
    mov edx, dword ptr [ebp + arg_8]             # 00424823
    mov dword ptr [edx + field_4], 0x0           # 00424826
L_0042482d:
    # block 0x0042482d: entered by jmp at 0x00424821, 1 instruction(s), ends with forward jump to 0x0042492b
    jmp.d32 L_0042492b                           # 0042482d
L_00424832:
    # block 0x00424832: entered by switch case, 3 instruction(s), ends with jg to 0x00424848 (forward)
    mov eax, dword ptr [0x585d4b]                # 00424832
    cmp eax, dword ptr [ebp - local_28]          # 00424837
    jg.d8 L_00424848                             # 0042483a
    # block 0x0042483c: entered by fall-through of jg at 0x0042483a, 3 instruction(s), ends with forward jump to 0x00424852
    mov ecx, dword ptr [ebp + arg_8]             # 0042483c
    mov dword ptr [ecx + field_4], 0x1           # 0042483f
    jmp.d8 L_00424852                            # 00424846
L_00424848:
    # block 0x00424848: entered by jg at 0x0042483a, 2 instruction(s), falls into the block at 0x00424852
    mov edx, dword ptr [ebp + arg_8]             # 00424848
    mov dword ptr [edx + field_4], 0x0           # 0042484b
L_00424852:
    # block 0x00424852: entered by jmp at 0x00424846, 1 instruction(s), ends with forward jump to 0x0042492b
    jmp.d32 L_0042492b                           # 00424852
L_00424857:
    # block 0x00424857: entered by switch case, 3 instruction(s), ends with jne to 0x0042486d (forward)
    mov eax, dword ptr [0x585d4b]                # 00424857
    cmp eax, dword ptr [ebp - local_28]          # 0042485c
    jne.d8 L_0042486d                            # 0042485f
    # block 0x00424861: entered by fall-through of jne at 0x0042485f, 3 instruction(s), ends with forward jump to 0x00424877
    mov ecx, dword ptr [ebp + arg_8]             # 00424861
    mov dword ptr [ecx + field_4], 0x1           # 00424864
    jmp.d8 L_00424877                            # 0042486b
L_0042486d:
    # block 0x0042486d: entered by jne at 0x0042485f, 2 instruction(s), falls into the block at 0x00424877
    mov edx, dword ptr [ebp + arg_8]             # 0042486d
    mov dword ptr [edx + field_4], 0x0           # 00424870
L_00424877:
    # block 0x00424877: entered by jmp at 0x0042486b, 1 instruction(s), ends with forward jump to 0x0042492b
    jmp.d32 L_0042492b                           # 00424877
L_0042487c:
    # block 0x0042487c: entered by switch case, 3 instruction(s), ends with jg to 0x004248b2 (forward)
    mov eax, dword ptr [ebp - local_24]          # 0042487c
    cmp eax, dword ptr [ebp - local_18]          # 0042487f
    jg.d8 L_004248b2                             # 00424882
    # block 0x00424884: entered by fall-through of jg at 0x00424882, 3 instruction(s), ends with jl to 0x004248a6 (forward)
    mov ecx, dword ptr [0x585d4b]                # 00424884
    cmp ecx, dword ptr [ebp - local_24]          # 0042488a
    jl.d8 L_004248a6                             # 0042488d
    # block 0x0042488f: entered by fall-through of jl at 0x0042488d, 3 instruction(s), ends with jg to 0x004248a6 (forward)
    mov edx, dword ptr [0x585d4b]                # 0042488f
    cmp edx, dword ptr [ebp - local_18]          # 00424895
    jg.d8 L_004248a6                             # 00424898
    # block 0x0042489a: entered by fall-through of jg at 0x00424898, 3 instruction(s), ends with forward jump to 0x004248b0
    mov eax, dword ptr [ebp + arg_8]             # 0042489a
    mov dword ptr [eax + field_4], 0x1           # 0042489d
    jmp.d8 L_004248b0                            # 004248a4
L_004248a6:
    # block 0x004248a6: entered by jl at 0x0042488d; jg at 0x00424898, 2 instruction(s), falls into the block at 0x004248b0
    mov ecx, dword ptr [ebp + arg_8]             # 004248a6
    mov dword ptr [ecx + field_4], 0x0           # 004248a9
L_004248b0:
    # block 0x004248b0: entered by jmp at 0x004248a4, 1 instruction(s), ends with forward jump to 0x004248f8
    jmp.d8 L_004248f8                            # 004248b0
L_004248b2:
    # block 0x004248b2: entered by jg at 0x00424882, 4 instruction(s), ends with jl to 0x004248ce (forward)
    mov dword ptr [ebp - local_c], 0x59f         # 004248b2
    mov edx, dword ptr [0x585d4b]                # 004248b9
    cmp edx, dword ptr [ebp - local_24]          # 004248bf
    jl.d8 L_004248ce                             # 004248c2
    # block 0x004248c4: entered by fall-through of jl at 0x004248c2, 3 instruction(s), ends with jle to 0x004248e2 (forward)
    mov eax, dword ptr [0x585d4b]                # 004248c4
    cmp eax, dword ptr [ebp - local_c]           # 004248c9
    jle.d8 L_004248e2                            # 004248cc
L_004248ce:
    # block 0x004248ce: entered by jl at 0x004248c2; fall-through of jle at 0x004248cc, 2 instruction(s), ends with jl to 0x004248ee (forward)
    cmp dword ptr [0x585d4b], 0x0                # 004248ce
    jl.d8 L_004248ee                             # 004248d5
    # block 0x004248d7: entered by fall-through of jl at 0x004248d5, 3 instruction(s), ends with jg to 0x004248ee (forward)
    mov ecx, dword ptr [0x585d4b]                # 004248d7
    cmp ecx, dword ptr [ebp - local_18]          # 004248dd
    jg.d8 L_004248ee                             # 004248e0
L_004248e2:
    # block 0x004248e2: entered by jle at 0x004248cc; fall-through of jg at 0x004248e0, 3 instruction(s), ends with forward jump to 0x004248f8
    mov edx, dword ptr [ebp + arg_8]             # 004248e2
    mov dword ptr [edx + field_4], 0x1           # 004248e5
    jmp.d8 L_004248f8                            # 004248ec
L_004248ee:
    # block 0x004248ee: entered by jl at 0x004248d5; jg at 0x004248e0, 2 instruction(s), falls into the block at 0x004248f8
    mov eax, dword ptr [ebp + arg_8]             # 004248ee
    mov dword ptr [eax + field_4], 0x0           # 004248f1
L_004248f8:
    # block 0x004248f8: entered by jmp at 0x004248b0; jmp at 0x004248ec, 1 instruction(s), ends with forward jump to 0x0042492b
    jmp.d8 L_0042492b                            # 004248f8
L_004248fa:
    # block 0x004248fa: entered by ja at 0x004247fd, 12 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x0042492b
    mov ecx, dword ptr [0x5bb57b]                # 004248fa
    push ecx                                     # 00424900
    push 0x5449e8                                # 00424901
    push 0x63888b                                # 00424906
    call FUN_0050ca3e                            # 0042490b
    add esp, 0xc                                 # 00424910
    push 0x0                                     # 00424913
    push 0x0                                     # 00424915
    push 0x63888b                                # 00424917
    call FUN_0052139c                            # 0042491c
    mov ecx, 0x5cf659                            # 00424921
    call FUN_004c97b4                            # 00424926
L_0042492b:
    # block 0x0042492b: entered by jmp at 0x0042482d; jmp at 0x00424852; jmp at 0x00424877; jmp at 0x004248f8, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d32 L_00424a36                           # 0042492b
L_00424930:
    # block 0x00424930: entered by switch case, 3 instruction(s), ends with jne to 0x004249d3 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00424930
    cmp dword ptr [edx + field_2c], 0x0          # 00424933
    jne.d32 L_004249d3                           # 00424937
    # block 0x0042493d: entered by fall-through of jne at 0x00424937, 9 instruction(s), calls FUN_0050cd50, ends with je to 0x004249a8 (forward)
    call FUN_0050cd50                            # 0042493d
    cdq                                          # 00424942
    mov ecx, 0x64                                # 00424943
    idiv ecx                                     # 00424948
    mov eax, dword ptr [ebp + arg_8]             # 0042494a
    mov dword ptr [eax + field_30], edx          # 0042494d
    movsx ecx, word ptr [0x63a4cd]               # 00424950
    test ecx, ecx                                # 00424957
    je.d8 L_004249a8                             # 00424959
    # block 0x0042495b: entered by fall-through of je at 0x00424959, 2 instruction(s), ends with jl to 0x00424967 (forward)
    cmp dword ptr [ebp - local_20], 0x1          # 0042495b
    jl.d8 L_00424967                             # 0042495f
    # block 0x00424961: entered by fall-through of jl at 0x0042495f, 2 instruction(s), ends with jle to 0x004249a8 (forward)
    cmp dword ptr [ebp - local_20], 0x64         # 00424961
    jle.d8 L_004249a8                            # 00424965
L_00424967:
    # block 0x00424967: entered by jl at 0x0042495f; fall-through of jle at 0x00424965, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4, falls into the block at 0x004249a8
    mov edx, dword ptr [ebp - local_20]          # 00424967
    push edx                                     # 0042496a
    mov eax, dword ptr [0x5bb57b]                # 0042496b
    push eax                                     # 00424970
    push 0x544a34                                # 00424971
    push 0x63888b                                # 00424976
    call FUN_0050ca3e                            # 0042497b
    add esp, 0x10                                # 00424980
    push 0x0                                     # 00424983
    push 0x0                                     # 00424985
    push 0x63888b                                # 00424987
    call FUN_0052139c                            # 0042498c
    push 0x63888b                                # 00424991
    call FUN_0044a2b7                            # 00424996
    add esp, 0x4                                 # 0042499b
    mov ecx, 0x5cf659                            # 0042499e
    call FUN_004c97b4                            # 004249a3
L_004249a8:
    # block 0x004249a8: entered by je at 0x00424959; jle at 0x00424965, 4 instruction(s), ends with jge to 0x004249bf (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004249a8
    mov edx, dword ptr [ecx + field_30]          # 004249ab
    cmp edx, dword ptr [ebp - local_20]          # 004249ae
    jge.d8 L_004249bf                            # 004249b1
    # block 0x004249b3: entered by fall-through of jge at 0x004249b1, 3 instruction(s), ends with forward jump to 0x004249c9
    mov eax, dword ptr [ebp + arg_8]             # 004249b3
    mov dword ptr [eax + field_4], 0x1           # 004249b6
    jmp.d8 L_004249c9                            # 004249bd
L_004249bf:
    # block 0x004249bf: entered by jge at 0x004249b1, 2 instruction(s), falls into the block at 0x004249c9
    mov ecx, dword ptr [ebp + arg_8]             # 004249bf
    mov dword ptr [ecx + field_4], 0x0           # 004249c2
L_004249c9:
    # block 0x004249c9: entered by jmp at 0x004249bd, 2 instruction(s), falls into the block at 0x004249d3
    mov edx, dword ptr [ebp + arg_8]             # 004249c9
    mov dword ptr [edx + field_2c], 0x1          # 004249cc
L_004249d3:
    # block 0x004249d3: entered by jne at 0x00424937, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d8 L_00424a36                            # 004249d3
L_004249d5:
    # block 0x004249d5: entered by switch case, 2 instruction(s), ends with je to 0x004249ea (forward)
    cmp dword ptr [0x5c3a47], 0x0                # 004249d5
    je.d8 L_004249ea                             # 004249dc
    # block 0x004249de: entered by fall-through of je at 0x004249dc, 3 instruction(s), ends with forward jump to 0x004249f4
    mov eax, dword ptr [ebp + arg_8]             # 004249de
    mov dword ptr [eax + field_4], 0x1           # 004249e1
    jmp.d8 L_004249f4                            # 004249e8
L_004249ea:
    # block 0x004249ea: entered by je at 0x004249dc, 2 instruction(s), falls into the block at 0x004249f4
    mov ecx, dword ptr [ebp + arg_8]             # 004249ea
    mov dword ptr [ecx + field_4], 0x0           # 004249ed
L_004249f4:
    # block 0x004249f4: entered by jmp at 0x004249e8, 1 instruction(s), ends with forward jump to 0x00424a36
    jmp.d8 L_00424a36                            # 004249f4
L_004249f6:
    # block 0x004249f6: entered by switch case, 3 instruction(s), ends with forward jump to 0x00424a36
    mov edx, dword ptr [ebp + arg_8]             # 004249f6
    mov dword ptr [edx + field_4], 0x1           # 004249f9
    jmp.d8 L_00424a36                            # 00424a00
L_00424a02:
    # block 0x00424a02: entered by ja at 0x004243a5; switch case, 12 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00424a36
    mov eax, dword ptr [ebp - local_14]          # 00424a02
    push eax                                     # 00424a05
    push 0x544a80                                # 00424a06
    push 0x63888b                                # 00424a0b
    call FUN_0050ca3e                            # 00424a10
    add esp, 0xc                                 # 00424a15
    push 0x63888b                                # 00424a18
    push 0x544a88                                # 00424a1d
    mov ecx, 0x583979                            # 00424a22
    call FUN_0042639d                            # 00424a27
    mov ecx, 0x5cf659                            # 00424a2c
    call FUN_004c97b4                            # 00424a31
L_00424a36:
    # block 0x00424a36: entered by jmp at 0x00424409; jmp at 0x0042447c; jmp at 0x004244a6; jmp at 0x004244ea; more, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00424a36
    pop ebp                                      # 00424a38
    ret 0x4                                      # 00424a39

# --- data items (not part of the function) -------------------------
.org 0x00424a3c - 0x401000
SWTAB_00424a3c:  # 23 case address(es)
    .long L_004249f6 - .text + 0x401000
    .long L_004243b5 - .text + 0x401000
    .long L_00424481 - .text + 0x401000
    .long L_004244ef - .text + 0x401000
    .long L_0042468d - .text + 0x401000
    .long L_004247cd - .text + 0x401000
    .long L_004247f3 - .text + 0x401000
    .long L_00424a02 - .text + 0x401000
    .long L_00424a02 - .text + 0x401000
    .long L_00424579 - .text + 0x401000
    .long L_00424a02 - .text + 0x401000
    .long L_0042440e - .text + 0x401000
    .long L_00424666 - .text + 0x401000
    .long L_004246b2 - .text + 0x401000
    .long L_00424717 - .text + 0x401000
    .long L_00424519 - .text + 0x401000
    .long L_00424540 - .text + 0x401000
    .long L_004244ab - .text + 0x401000
    .long L_00424a02 - .text + 0x401000
    .long L_00424a02 - .text + 0x401000
    .long L_00424930 - .text + 0x401000
    .long L_004249d5 - .text + 0x401000
    .long L_0042477c - .text + 0x401000
.org 0x00424a98 - 0x401000
SWTAB_00424a98:  # 4 case address(es)
    .long L_0042480d - .text + 0x401000
    .long L_00424832 - .text + 0x401000
    .long L_00424857 - .text + 0x401000
    .long L_0042487c - .text + 0x401000
.set SWTAB_00424a3c_VA, SWTAB_00424a3c - .text + 0x401000
.set SWTAB_00424a98_VA, SWTAB_00424a98 - .text + 0x401000

