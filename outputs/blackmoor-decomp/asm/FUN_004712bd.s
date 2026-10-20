# FUN_004712bd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004712bd
# extent:       0x004712bd-0x00471722 (1125 code bytes)
# span:         0x004712bd-0x00471722 (code 1125, tables 0, padding 0)
# sha256:       09bf39ecb2c78135648244ac83acea373a9deafd2e28de4fcc99c1a87f1973b7
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4712bd_click_27a6_27ad
# naming:       native port src/original_methods_fl25d.c:m4712bd_click_27a6_27ad (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4712bd_click_27a6_27ad. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25d-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_87, field_c9c, field_d28, field_d2a, field_d30, field_d32, field_d3a, field_d3e, field_d4a, field_e06; [ecx + n] field_21, field_23, field_c9c, field_d01, field_d2a, field_d30, field_d32, field_d48, field_e00; [edx + n] field_21, field_23, field_24, field_c9c, field_d01, field_d2a, field_d2c, field_d30, field_d32, field_d3b, field_d3f, field_dc2; [esi + n] field_d4c
# callees:      calls KERNEL32.dll!GetTickCount, FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/action_family_e0_runtime.h:e0_click (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 267 instruction(s), 28 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_87, 0x87  # offset +0x87
.equ field_c9c, 0xc9c  # offset +0xc9c
.equ field_d01, 0xd01  # offset +0xd01
.equ field_d28, 0xd28  # offset +0xd28
.equ field_d2a, 0xd2a  # offset +0xd2a
.equ field_d2c, 0xd2c  # offset +0xd2c
.equ field_d30, 0xd30  # offset +0xd30
.equ field_d32, 0xd32  # offset +0xd32
.equ field_d3a, 0xd3a  # offset +0xd3a
.equ field_d3b, 0xd3b  # offset +0xd3b
.equ field_d3e, 0xd3e  # offset +0xd3e
.equ field_d3f, 0xd3f  # offset +0xd3f
.equ field_d48, 0xd48  # offset +0xd48
.equ field_d4a, 0xd4a  # offset +0xd4a
.equ field_d4c, 0xd4c  # offset +0xd4c
.equ field_dc2, 0xdc2  # offset +0xdc2
.equ field_e00, 0xe00  # offset +0xe00
.equ field_e06, 0xe06  # offset +0xe06

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004712bd - 0x401000
.globl FUN_004712bd
FUN_004712bd:
    # block 0x004712bd: entry, 16 instruction(s), ends with je to 0x0047171c (forward)
    push ebp                                     # 004712bd
    {load} mov ebp, esp                          # 004712be
    sub esp, 0x10                                # 004712c0
    push esi                                     # 004712c3
    push edi                                     # 004712c4
    mov dword ptr [ebp - local_10], ecx          # 004712c5
    mov eax, dword ptr [ebp - local_10]          # 004712c8
    movsx ecx, word ptr [eax + field_d28]        # 004712cb
    imul ecx, ecx, 0x8d                          # 004712d2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004712d8
    mov dword ptr [ebp - local_4], edx           # 004712de
    mov eax, dword ptr [ebp - local_10]          # 004712e1
    {load} xor ecx, ecx                          # 004712e4
    mov cl, byte ptr [eax + field_d3e]           # 004712e6
    test ecx, ecx                                # 004712ec
    je.d32 L_0047171c                            # 004712ee
    # block 0x004712f4: entered by fall-through of je at 0x004712ee, 3 instruction(s), ends with jne to 0x0047171c (forward)
    mov edx, dword ptr [ebp - local_10]          # 004712f4
    cmp dword ptr [edx + field_d2c], 0x0         # 004712f7
    jne.d32 L_0047171c                           # 004712fe
    # block 0x00471304: entered by fall-through of jne at 0x004712fe, 5 instruction(s), ends with jne to 0x0047171c (forward)
    mov eax, dword ptr [ebp - local_10]          # 00471304
    movsx ecx, word ptr [eax + field_d28]        # 00471307
    imul ecx, ecx, 0x8d                          # 0047130e
    cmp dword ptr [ecx + 0x5bb632], 0x1          # 00471314
    jne.d32 L_0047171c                           # 0047131b
    # block 0x00471321: entered by fall-through of jne at 0x0047131b, 4 instruction(s), ends with je to 0x0047167f (forward)
    mov edx, dword ptr [ebp - local_10]          # 00471321
    movsx eax, word ptr [edx + field_d2a]        # 00471324
    cmp eax, 0x28                                # 0047132b
    je.d32 L_0047167f                            # 0047132e
    # block 0x00471334: entered by fall-through of je at 0x0047132e, 2 instruction(s), ends with jne to 0x0047167f (forward)
    cmp dword ptr [0x5c39e5], 0x27a6             # 00471334
    jne.d32 L_0047167f                           # 0047133e
    # block 0x00471344: entered by fall-through of jne at 0x0047133e, 7 instruction(s), ends with je to 0x0047141a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00471344
    movsx edx, word ptr [ecx + field_d2a]        # 00471347
    mov eax, dword ptr [ebp - local_10]          # 0047134e
    {load} xor ecx, ecx                          # 00471351
    mov cl, byte ptr [eax + edx + field_c9c]     # 00471353
    test ecx, ecx                                # 0047135a
    je.d32 L_0047141a                            # 0047135c
    # block 0x00471362: entered by fall-through of je at 0x0047135c, 5 instruction(s), ends with je to 0x0047141a (forward)
    mov edx, dword ptr [ebp - local_4]           # 00471362
    {load} xor eax, eax                          # 00471365
    mov al, byte ptr [edx + field_23]            # 00471367
    test eax, eax                                # 0047136a
    je.d32 L_0047141a                            # 0047136c
    # block 0x00471372: entered by fall-through of je at 0x0047136c, 13 instruction(s), ends with jge to 0x004713af (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00471372
    movsx edx, word ptr [ecx + field_d2a]        # 00471375
    mov eax, dword ptr [ebp - local_10]          # 0047137c
    mov byte ptr [eax + edx + field_c9c], 0x0    # 0047137f
    mov ecx, dword ptr [ebp - local_10]          # 00471387
    mov dx, word ptr [ecx + field_d32]           # 0047138a
    mov word ptr [ebp - local_c], dx             # 00471391
    mov ax, word ptr [ebp - local_c]             # 00471395
    .insn 0x66, 0x2d, 0x0001{:u16}               # 00471399
    mov word ptr [ebp - local_c], ax             # 0047139d
    movsx ecx, word ptr [ebp - local_c]          # 004713a1
    test ecx, ecx                                # 004713a5
    jge.d8 L_004713af                            # 004713a7
    # block 0x004713a9: entered by fall-through of jge at 0x004713a7, 1 instruction(s), falls into the block at 0x004713af
    mov word ptr [ebp - local_c], 0x0            # 004713a9
L_004713af:
    # block 0x004713af: entered by jge at 0x004713a7, 7 instruction(s), ends with jne to 0x00471415 (forward)
    movsx edx, word ptr [ebp - local_c]          # 004713af
    mov eax, dword ptr [ebp - local_10]          # 004713b3
    movsx ecx, word ptr [eax + 2*edx + field_d4a] # 004713b6
    mov edx, dword ptr [ebp - local_10]          # 004713be
    movsx eax, word ptr [edx + field_d2a]        # 004713c1
    {load} cmp ecx, eax                          # 004713c8
    jne.d8 L_00471415                            # 004713ca
    # block 0x004713cc: entered by fall-through of jne at 0x004713ca, 9 instruction(s), ends with jge to 0x004713fe (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004713cc
    mov dx, word ptr [ecx + field_d32]           # 004713cf
    sub dx, 0x1                                  # 004713d6
    mov eax, dword ptr [ebp - local_10]          # 004713da
    mov word ptr [eax + field_d32], dx           # 004713dd
    mov ecx, dword ptr [ebp - local_10]          # 004713e4
    movsx edx, word ptr [ecx + field_d32]        # 004713e7
    test edx, edx                                # 004713ee
    jge.d8 L_004713fe                            # 004713f0
    # block 0x004713f2: entered by fall-through of jge at 0x004713f0, 2 instruction(s), falls into the block at 0x004713fe
    mov eax, dword ptr [ebp - local_10]          # 004713f2
    mov word ptr [eax + field_d32], 0x0          # 004713f5
L_004713fe:
    # block 0x004713fe: entered by jge at 0x004713f0, 4 instruction(s), falls into the block at 0x00471415
    mov ecx, dword ptr [ebp - local_10]          # 004713fe
    movsx edx, word ptr [ecx + field_d32]        # 00471401
    mov eax, dword ptr [ebp - local_10]          # 00471408
    mov word ptr [eax + 2*edx + field_d4a], 0xffff # 0047140b
L_00471415:
    # block 0x00471415: entered by jne at 0x004713ca, 1 instruction(s), ends with forward jump to 0x004715ee
    jmp.d32 L_004715ee                           # 00471415
L_0047141a:
    # block 0x0047141a: entered by je at 0x0047135c; je at 0x0047136c, 5 instruction(s), ends with je to 0x004714d3 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047141a
    {load} xor edx, edx                          # 0047141d
    mov dl, byte ptr [ecx + field_23]            # 0047141f
    test edx, edx                                # 00471422
    je.d32 L_004714d3                            # 00471424
    # block 0x0047142a: entered by fall-through of je at 0x00471424, 7 instruction(s), ends with jg to 0x00471461 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047142a
    movsx ecx, word ptr [eax + field_d32]        # 0047142d
    mov edx, dword ptr [ebp - local_4]           # 00471434
    movsx eax, word ptr [edx + field_21]         # 00471437
    sub eax, 0x1                                 # 0047143b
    {load} cmp ecx, eax                          # 0047143e
    jg.d8 L_00471461                             # 00471440
    # block 0x00471442: entered by fall-through of jg at 0x00471440, 6 instruction(s), falls into the block at 0x00471461
    mov ecx, dword ptr [ebp - local_10]          # 00471442
    movsx edx, word ptr [ecx + field_d32]        # 00471445
    mov eax, dword ptr [ebp - local_10]          # 0047144c
    mov ecx, dword ptr [ebp - local_10]          # 0047144f
    mov cx, word ptr [ecx + field_d2a]           # 00471452
    mov word ptr [eax + 2*edx + field_d4a], cx   # 00471459
L_00471461:
    # block 0x00471461: entered by jg at 0x00471440, 7 instruction(s), ends with jne to 0x004714a8 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00471461
    movsx eax, word ptr [edx + field_d2a]        # 00471464
    mov ecx, dword ptr [ebp - local_10]          # 0047146b
    {load} xor edx, edx                          # 0047146e
    mov dl, byte ptr [ecx + eax + field_c9c]     # 00471470
    test edx, edx                                # 00471477
    jne.d8 L_004714a8                            # 00471479
    # block 0x0047147b: entered by fall-through of jne at 0x00471479, 9 instruction(s), falls into the block at 0x004714a8
    mov eax, dword ptr [ebp - local_10]          # 0047147b
    mov cx, word ptr [eax + field_d32]           # 0047147e
    add cx, 0x1                                  # 00471485
    mov edx, dword ptr [ebp - local_10]          # 00471489
    mov word ptr [edx + field_d32], cx           # 0047148c
    mov eax, dword ptr [ebp - local_10]          # 00471493
    movsx ecx, word ptr [eax + field_d2a]        # 00471496
    mov edx, dword ptr [ebp - local_10]          # 0047149d
    mov byte ptr [edx + ecx + field_c9c], 0x1    # 004714a0
L_004714a8:
    # block 0x004714a8: entered by jne at 0x00471479, 6 instruction(s), ends with jle to 0x004714ce (forward)
    mov eax, dword ptr [ebp - local_10]          # 004714a8
    movsx ecx, word ptr [eax + field_d32]        # 004714ab
    mov edx, dword ptr [ebp - local_4]           # 004714b2
    movsx eax, word ptr [edx + field_21]         # 004714b5
    {load} cmp ecx, eax                          # 004714b9
    jle.d8 L_004714ce                            # 004714bb
    # block 0x004714bd: entered by fall-through of jle at 0x004714bb, 4 instruction(s), falls into the block at 0x004714ce
    mov ecx, dword ptr [ebp - local_10]          # 004714bd
    mov edx, dword ptr [ebp - local_4]           # 004714c0
    mov ax, word ptr [edx + field_21]            # 004714c3
    mov word ptr [ecx + field_d32], ax           # 004714c7
L_004714ce:
    # block 0x004714ce: entered by jle at 0x004714bb, 1 instruction(s), ends with forward jump to 0x004715ee
    jmp.d32 L_004715ee                           # 004714ce
L_004714d3:
    # block 0x004714d3: entered by je at 0x00471424, 5 instruction(s), ends with jne to 0x004715ee (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004714d3
    {load} xor edx, edx                          # 004714d6
    mov dl, byte ptr [ecx + field_23]            # 004714d8
    test edx, edx                                # 004714db
    jne.d32 L_004715ee                           # 004714dd
    # block 0x004714e3: entered by fall-through of jne at 0x004714dd, 7 instruction(s), ends with jne to 0x004715ee (forward)
    mov eax, dword ptr [ebp - local_10]          # 004714e3
    movsx ecx, word ptr [eax + field_d2a]        # 004714e6
    mov edx, dword ptr [ebp - local_10]          # 004714ed
    {load} xor eax, eax                          # 004714f0
    mov al, byte ptr [edx + ecx + field_c9c]     # 004714f2
    test eax, eax                                # 004714f9
    jne.d32 L_004715ee                           # 004714fb
    # block 0x00471501: entered by fall-through of jne at 0x004714fb, 9 instruction(s), ends with jle to 0x00471553 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00471501
    mov dx, word ptr [ecx + field_d32]           # 00471504
    add dx, 0x1                                  # 0047150b
    mov eax, dword ptr [ebp - local_10]          # 0047150f
    mov word ptr [eax + field_d32], dx           # 00471512
    mov ecx, dword ptr [ebp - local_10]          # 00471519
    movsx edx, word ptr [ecx + field_d01]        # 0047151c
    test edx, edx                                # 00471523
    jle.d8 L_00471553                            # 00471525
    # block 0x00471527: entered by fall-through of jle at 0x00471525, 6 instruction(s), ends with jle to 0x00471553 (forward)
    mov eax, dword ptr [ebp - local_10]          # 00471527
    movsx ecx, word ptr [eax + field_d32]        # 0047152a
    mov edx, dword ptr [ebp - local_10]          # 00471531
    movsx eax, word ptr [edx + field_d01]        # 00471534
    {load} cmp ecx, eax                          # 0047153b
    jle.d8 L_00471553                            # 0047153d
    # block 0x0047153f: entered by fall-through of jle at 0x0047153d, 4 instruction(s), falls into the block at 0x00471553
    mov ecx, dword ptr [ebp - local_10]          # 0047153f
    mov edx, dword ptr [ebp - local_10]          # 00471542
    mov ax, word ptr [edx + field_d01]           # 00471545
    mov word ptr [ecx + field_d32], ax           # 0047154c
L_00471553:
    # block 0x00471553: entered by jle at 0x00471525; jle at 0x0047153d, 12 instruction(s), calls KERNEL32.dll!GetTickCount, ends with forward jump to 0x0047159a
    mov ecx, dword ptr [ebp - local_10]          # 00471553
    movsx edx, word ptr [ecx + field_d2a]        # 00471556
    mov eax, dword ptr [ebp - local_10]          # 0047155d
    mov byte ptr [eax + edx + field_c9c], 0x1    # 00471560
    call dword ptr [0x52a23c]                    # 00471568
    add eax, 0x12c                               # 0047156e
    mov ecx, dword ptr [ebp - local_10]          # 00471573
    mov dword ptr [ecx + field_e00], eax         # 00471576
    mov edx, dword ptr [ebp - local_10]          # 0047157c
    mov byte ptr [edx + field_d3b], 0x1          # 0047157f
    mov word ptr [ebp - local_8], 0x0            # 00471586
    jmp.d8 L_0047159a                            # 0047158c
L_0047158e:
    # block 0x0047158e: entered by jmp at 0x004715cd, 3 instruction(s), falls into the block at 0x0047159a
    mov ax, word ptr [ebp - local_8]             # 0047158e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00471592
    mov word ptr [ebp - local_8], ax             # 00471596
L_0047159a:
    # block 0x0047159a: entered by jmp at 0x0047158c, 6 instruction(s), ends with jge to 0x004715cf (forward)
    movsx ecx, word ptr [ebp - local_8]          # 0047159a
    mov edx, dword ptr [ebp - local_10]          # 0047159e
    movsx eax, word ptr [edx + field_d01]        # 004715a1
    sub eax, 0x1                                 # 004715a8
    {load} cmp ecx, eax                          # 004715ab
    jge.d8 L_004715cf                            # 004715ad
    # block 0x004715af: entered by fall-through of jge at 0x004715ad, 7 instruction(s), ends with backward jump to 0x0047158e
    movsx ecx, word ptr [ebp - local_8]          # 004715af
    movsx edx, word ptr [ebp - local_8]          # 004715b3
    mov eax, dword ptr [ebp - local_10]          # 004715b7
    mov esi, dword ptr [ebp - local_10]          # 004715ba
    mov cx, word ptr [esi + 2*ecx + field_d4c]   # 004715bd
    mov word ptr [eax + 2*edx + field_d4a], cx   # 004715c5
    jmp.d8 L_0047158e                            # 004715cd
L_004715cf:
    # block 0x004715cf: entered by jge at 0x004715ad, 6 instruction(s), falls into the block at 0x004715ee
    mov edx, dword ptr [ebp - local_10]          # 004715cf
    movsx eax, word ptr [edx + field_d01]        # 004715d2
    mov ecx, dword ptr [ebp - local_10]          # 004715d9
    mov edx, dword ptr [ebp - local_10]          # 004715dc
    mov dx, word ptr [edx + field_d2a]           # 004715df
    mov word ptr [ecx + 2*eax + field_d48], dx   # 004715e6
L_004715ee:
    # block 0x004715ee: entered by jmp at 0x00471415; jmp at 0x004714ce; jne at 0x004714dd; jne at 0x004714fb, 4 instruction(s), ends with jle to 0x0047164b (forward)
    mov eax, dword ptr [ebp - local_10]          # 004715ee
    movsx ecx, word ptr [eax + field_e06]        # 004715f1
    test ecx, ecx                                # 004715f8
    jle.d8 L_0047164b                            # 004715fa
    # block 0x004715fc: entered by fall-through of jle at 0x004715fa, 7 instruction(s), ends with jg to 0x0047164b (forward)
    mov edx, dword ptr [ebp - local_10]          # 004715fc
    movsx eax, word ptr [edx + field_d30]        # 004715ff
    mov ecx, dword ptr [ebp - local_4]           # 00471606
    movsx edx, word ptr [ecx + field_21]         # 00471609
    sub edx, 0x1                                 # 0047160d
    {load} cmp eax, edx                          # 00471610
    jg.d8 L_0047164b                             # 00471612
    # block 0x00471614: entered by fall-through of jg at 0x00471612, 11 instruction(s), falls into the block at 0x0047164b
    mov eax, dword ptr [ebp - local_10]          # 00471614
    movsx ecx, word ptr [eax + field_d30]        # 00471617
    mov edx, dword ptr [ebp - local_10]          # 0047161e
    mov eax, dword ptr [ebp - local_10]          # 00471621
    mov ax, word ptr [eax + field_d2a]           # 00471624
    mov word ptr [edx + 2*ecx + field_dc2], ax   # 0047162b
    mov ecx, dword ptr [ebp - local_10]          # 00471633
    mov dx, word ptr [ecx + field_d30]           # 00471636
    add dx, 0x1                                  # 0047163d
    mov eax, dword ptr [ebp - local_10]          # 00471641
    mov word ptr [eax + field_d30], dx           # 00471644
L_0047164b:
    # block 0x0047164b: entered by jle at 0x004715fa; jg at 0x00471612, 2 instruction(s), ends with je to 0x0047167f (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 0047164b
    je.d8 L_0047167f                             # 00471652
    # block 0x00471654: entered by fall-through of je at 0x00471652, 7 instruction(s), ends with je to 0x0047167f (forward)
    mov edi, 0x54c480                            # 00471654
    mov esi, dword ptr [ebp - local_4]           # 00471659
    add esi, 0x66                                # 0047165c
    mov ecx, 0x9                                 # 0047165f
    {load} xor edx, edx                          # 00471664
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00471666
    je.d8 L_0047167f                             # 00471668
    # block 0x0047166a: entered by fall-through of je at 0x00471668, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0047167f
    mov eax, dword ptr [ebp - local_4]           # 0047166a
    mov cx, word ptr [eax + field_87]            # 0047166d
    push ecx                                     # 00471674
    mov ecx, 0x5c3a67                            # 00471675
    call FUN_004fb2e3                            # 0047167a
L_0047167f:
    # block 0x0047167f: entered by je at 0x0047132e; jne at 0x0047133e; je at 0x00471652; je at 0x00471668, 5 instruction(s), ends with je to 0x004716ec (forward)
    mov edx, dword ptr [ebp - local_4]           # 0047167f
    {load} xor eax, eax                          # 00471682
    mov al, byte ptr [edx + field_24]            # 00471684
    test eax, eax                                # 00471687
    je.d8 L_004716ec                             # 00471689
    # block 0x0047168b: entered by fall-through of je at 0x00471689, 4 instruction(s), ends with jne to 0x004716ec (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047168b
    movsx edx, word ptr [ecx + field_d2a]        # 0047168e
    cmp edx, 0x28                                # 00471695
    jne.d8 L_004716ec                            # 00471698
    # block 0x0047169a: entered by fall-through of jne at 0x00471698, 8 instruction(s), calls KERNEL32.dll!GetTickCount, ends with je to 0x004716ec (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047169a
    mov byte ptr [eax + field_d3a], 0x1          # 0047169d
    call dword ptr [0x52a23c]                    # 004716a4
    add eax, 0x12c                               # 004716aa
    mov ecx, dword ptr [ebp - local_10]          # 004716af
    mov dword ptr [ecx + field_e00], eax         # 004716b2
    cmp dword ptr [0x5bb1ca], 0x0                # 004716b8
    je.d8 L_004716ec                             # 004716bf
    # block 0x004716c1: entered by fall-through of je at 0x004716bf, 7 instruction(s), ends with je to 0x004716ec (forward)
    mov edi, 0x54c48c                            # 004716c1
    mov esi, dword ptr [ebp - local_4]           # 004716c6
    add esi, 0x66                                # 004716c9
    mov ecx, 0x9                                 # 004716cc
    {load} xor edx, edx                          # 004716d1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004716d3
    je.d8 L_004716ec                             # 004716d5
    # block 0x004716d7: entered by fall-through of je at 0x004716d5, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004716ec
    mov eax, dword ptr [ebp - local_4]           # 004716d7
    mov cx, word ptr [eax + field_87]            # 004716da
    push ecx                                     # 004716e1
    mov ecx, 0x5c3a67                            # 004716e2
    call FUN_004fb2e3                            # 004716e7
L_004716ec:
    # block 0x004716ec: entered by je at 0x00471689; jne at 0x00471698; je at 0x004716bf; je at 0x004716d5, 2 instruction(s), ends with jne to 0x0047171c (forward)
    cmp dword ptr [0x5c39e5], 0x27ad             # 004716ec
    jne.d8 L_0047171c                            # 004716f6
    # block 0x004716f8: entered by fall-through of jne at 0x004716f6, 6 instruction(s), falls into the block at 0x0047171c
    mov edx, dword ptr [ebp - local_10]          # 004716f8
    mov byte ptr [edx + field_d3f], 0x1          # 004716fb
    mov eax, dword ptr [ebp - local_10]          # 00471702
    movsx ecx, word ptr [eax + field_d28]        # 00471705
    imul ecx, ecx, 0x8d                          # 0047170c
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00471712
L_0047171c:
    # block 0x0047171c: entered by je at 0x004712ee; jne at 0x004712fe; jne at 0x0047131b; jne at 0x004716f6, 5 instruction(s), ends with ret
    pop edi                                      # 0047171c
    pop esi                                      # 0047171d
    {load} mov esp, ebp                          # 0047171e
    pop ebp                                      # 00471720
    ret                                          # 00471721

