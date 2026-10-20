# FUN_0045841e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045841e
# extent:       0x0045841e-0x0045879e (896 code bytes)
# span:         0x0045841e-0x0045879e (code 896, tables 0, padding 0)
# sha256:       e6452ddecf37331d81e7f6c62fd506fca689130eb9a9c98c223288ff7bb2d2ac
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45841e_hit_test
# naming:       native port src/original_methods_fl25a.c:m45841e_hit_test (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m45841e_hit_test. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25a-handoff.md.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_26, field_98, field_b4, field_e5, field_f9, field_fd, field_653; [ecx + n] field_20, field_21, field_23, field_3a, field_9e, field_a2, field_a6, field_aa, field_ae, field_f1, field_f5, field_65f; [edx + n] field_4, field_8, field_c, field_23, field_3a, field_b4, field_e9, field_ed, field_101, field_105, field_109, field_10d and 3 more
# callees:      calls FUN_00458262, FUN_0045839e, FUN_0045879e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m45841e_hit_test (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 234 instruction(s), 27 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_20, 0x20  # offset +0x20
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_26, 0x26  # offset +0x26
.equ field_3a, 0x3a  # offset +0x3a
.equ field_98, 0x98  # offset +0x98
.equ field_9e, 0x9e  # offset +0x9e
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a6, 0xa6  # offset +0xa6
.equ field_aa, 0xaa  # offset +0xaa
.equ field_ae, 0xae  # offset +0xae
.equ field_b4, 0xb4  # offset +0xb4
.equ field_e5, 0xe5  # offset +0xe5
.equ field_e9, 0xe9  # offset +0xe9
.equ field_ed, 0xed  # offset +0xed
.equ field_f1, 0xf1  # offset +0xf1
.equ field_f5, 0xf5  # offset +0xf5
.equ field_f9, 0xf9  # offset +0xf9
.equ field_fd, 0xfd  # offset +0xfd
.equ field_101, 0x101  # offset +0x101
.equ field_105, 0x105  # offset +0x105
.equ field_109, 0x109  # offset +0x109
.equ field_10d, 0x10d  # offset +0x10d
.equ field_111, 0x111  # offset +0x111
.equ field_653, 0x653  # offset +0x653
.equ field_657, 0x657  # offset +0x657
.equ field_65b, 0x65b  # offset +0x65b
.equ field_65f, 0x65f  # offset +0x65f

# --- external targets -----------------------------------------------
.set FUN_00458262, .text + (0x00458262 - 0x401000)
.set FUN_0045839e, .text + (0x0045839e - 0x401000)
.set FUN_0045879e, .text + (0x0045879e - 0x401000)

.org 0x0045841e - 0x401000
.globl FUN_0045841e
FUN_0045841e:
    # block 0x0045841e: entry, 12 instruction(s), ends with je to 0x00458796 (forward)
    push ebp                                     # 0045841e
    {load} mov ebp, esp                          # 0045841f
    sub esp, 0x1c                                # 00458421
    mov dword ptr [ebp - local_1c], ecx          # 00458424
    mov eax, dword ptr [ebp - local_1c]          # 00458427
    movsx ecx, word ptr [eax + field_26]         # 0045842a
    imul ecx, ecx, 0x8d                          # 0045842e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00458434
    mov dword ptr [ebp - local_18], edx          # 0045843a
    mov eax, dword ptr [ebp - local_1c]          # 0045843d
    cmp dword ptr [eax + field_98], 0x0          # 00458440
    je.d32 L_00458796                            # 00458447
    # block 0x0045844d: entered by fall-through of je at 0x00458447, 19 instruction(s), ends with je to 0x004586ed (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 0045844d
    mov edx, dword ptr [ebp + arg_10]            # 00458450
    mov eax, dword ptr [edx + field_4]           # 00458453
    mov dword ptr [ecx + field_a2], eax          # 00458456
    mov ecx, dword ptr [ebp - local_1c]          # 0045845c
    mov edx, dword ptr [ebp + arg_10]            # 0045845f
    mov eax, dword ptr [edx + field_c]           # 00458462
    mov dword ptr [ecx + field_aa], eax          # 00458465
    mov ecx, dword ptr [ebp - local_1c]          # 0045846b
    mov edx, dword ptr [ebp + arg_10]            # 0045846e
    mov eax, dword ptr [edx]                     # 00458471
    mov dword ptr [ecx + field_9e], eax          # 00458473
    mov ecx, dword ptr [ebp - local_1c]          # 00458479
    mov edx, dword ptr [ebp + arg_10]            # 0045847c
    mov eax, dword ptr [edx + field_8]           # 0045847f
    mov dword ptr [ecx + field_a6], eax          # 00458482
    mov ecx, dword ptr [ebp - local_1c]          # 00458488
    cmp dword ptr [ecx + field_20], 0x5          # 0045848b
    je.d32 L_004586ed                            # 0045848f
    # block 0x00458495: entered by fall-through of je at 0x0045848f, 4 instruction(s), ends with je to 0x004585b9 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 00458495
    movsx eax, word ptr [edx + field_3a]         # 00458498
    cmp eax, -0x1                                # 0045849c
    je.d32 L_004585b9                            # 0045849f
    # block 0x004584a5: entered by fall-through of je at 0x0045849f, 12 instruction(s), calls FUN_00458262, FUN_0045839e, ends with je to 0x004584ee (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004584a5
    call FUN_00458262                            # 004584a8
    mov ecx, dword ptr [ebp - local_18]          # 004584ad
    add ecx, 0xe5                                # 004584b0
    push ecx                                     # 004584b6
    mov edx, dword ptr [ebp - local_1c]          # 004584b7
    add edx, 0x3e                                # 004584ba
    push edx                                     # 004584bd
    mov ecx, dword ptr [ebp - local_1c]          # 004584be
    call FUN_0045839e                            # 004584c1
    test eax, eax                                # 004584c6
    je.d8 L_004584ee                             # 004584c8
    # block 0x004584ca: entered by fall-through of je at 0x004584c8, 7 instruction(s), calls FUN_0045879e, ends with forward jump to 0x00458798
    push 0x27a5                                  # 004584ca
    mov ecx, dword ptr [ebp - local_1c]          # 004584cf
    call FUN_0045879e                            # 004584d2
    mov eax, dword ptr [ebp - local_1c]          # 004584d7
    mov dword ptr [eax + field_b4], 0x0          # 004584da
    mov eax, 0x1                                 # 004584e4
    jmp.d32 L_00458798                           # 004584e9
L_004584ee:
    # block 0x004584ee: entered by je at 0x004584c8, 2 instruction(s), ends with forward jump to 0x00458500
    mov dword ptr [ebp - local_14], 0x0          # 004584ee
    jmp.d8 L_00458500                            # 004584f5
L_004584f7:
    # block 0x004584f7: entered by jmp at 0x004585af, 3 instruction(s), falls into the block at 0x00458500
    mov ecx, dword ptr [ebp - local_14]          # 004584f7
    add ecx, 0x1                                 # 004584fa
    mov dword ptr [ebp - local_14], ecx          # 004584fd
L_00458500:
    # block 0x00458500: entered by jmp at 0x004584f5, 4 instruction(s), ends with jge to 0x004585b4 (forward)
    mov edx, dword ptr [ebp - local_18]          # 00458500
    movsx eax, word ptr [edx + field_23]         # 00458503
    cmp dword ptr [ebp - local_14], eax          # 00458507
    jge.d32 L_004585b4                           # 0045850a
    # block 0x00458510: entered by fall-through of jge at 0x0045850a, 28 instruction(s), ends with jne to 0x004585af (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00458510
    shl ecx, 0x4                                 # 00458513
    mov edx, dword ptr [ebp - local_18]          # 00458516
    mov eax, dword ptr [edx + ecx + field_109]   # 00458519
    add eax, 0xa                                 # 00458520
    mov dword ptr [ebp - local_c], eax           # 00458523
    mov ecx, dword ptr [ebp - local_14]          # 00458526
    shl ecx, 0x4                                 # 00458529
    mov edx, dword ptr [ebp - local_18]          # 0045852c
    mov eax, dword ptr [edx + ecx + field_111]   # 0045852f
    sub eax, 0xa                                 # 00458536
    mov dword ptr [ebp - local_4], eax           # 00458539
    mov ecx, dword ptr [ebp - local_14]          # 0045853c
    shl ecx, 0x4                                 # 0045853f
    mov edx, dword ptr [ebp - local_18]          # 00458542
    mov eax, dword ptr [edx + ecx + field_105]   # 00458545
    add eax, 0xa                                 # 0045854c
    mov dword ptr [ebp - local_10], eax          # 0045854f
    mov ecx, dword ptr [ebp - local_14]          # 00458552
    shl ecx, 0x4                                 # 00458555
    mov edx, dword ptr [ebp - local_18]          # 00458558
    mov eax, dword ptr [edx + ecx + field_10d]   # 0045855b
    sub eax, 0xa                                 # 00458562
    mov dword ptr [ebp - local_8], eax           # 00458565
    mov ecx, dword ptr [ebp - local_1c]          # 00458568
    movsx edx, word ptr [ecx + field_3a]         # 0045856b
    cmp edx, dword ptr [ebp - local_14]          # 0045856f
    jne.d8 L_004585af                            # 00458572
    # block 0x00458574: entered by fall-through of jne at 0x00458572, 9 instruction(s), calls FUN_0045839e, ends with je to 0x004585af (forward)
    lea eax, [ebp - local_10]                    # 00458574
    push eax                                     # 00458577
    mov ecx, dword ptr [ebp - local_1c]          # 00458578
    add ecx, 0x3e                                # 0045857b
    push ecx                                     # 0045857e
    mov ecx, dword ptr [ebp - local_1c]          # 0045857f
    call FUN_0045839e                            # 00458582
    test eax, eax                                # 00458587
    je.d8 L_004585af                             # 00458589
    # block 0x0045858b: entered by fall-through of je at 0x00458589, 7 instruction(s), calls FUN_0045879e, ends with forward jump to 0x00458798
    push 0x27a5                                  # 0045858b
    mov ecx, dword ptr [ebp - local_1c]          # 00458590
    call FUN_0045879e                            # 00458593
    mov edx, dword ptr [ebp - local_1c]          # 00458598
    mov dword ptr [edx + field_b4], 0x1          # 0045859b
    mov eax, 0x1                                 # 004585a5
    jmp.d32 L_00458798                           # 004585aa
L_004585af:
    # block 0x004585af: entered by jne at 0x00458572; je at 0x00458589, 1 instruction(s), ends with backward jump to 0x004584f7
    jmp.d32 L_004584f7                           # 004585af
L_004585b4:
    # block 0x004585b4: entered by jge at 0x0045850a, 1 instruction(s), ends with forward jump to 0x004586eb
    jmp.d32 L_004586eb                           # 004585b4
L_004585b9:
    # block 0x004585b9: entered by je at 0x0045849f, 5 instruction(s), ends with jge to 0x004586eb (forward)
    movsx eax, word ptr [0x5a4c08]               # 004585b9
    mov ecx, dword ptr [ebp - local_18]          # 004585c0
    movsx edx, word ptr [ecx + field_21]         # 004585c3
    {load} cmp eax, edx                          # 004585c7
    jge.d32 L_004586eb                           # 004585c9
    # block 0x004585cf: entered by fall-through of jge at 0x004585c9, 2 instruction(s), ends with forward jump to 0x004585e1
    mov dword ptr [ebp - local_14], 0x0          # 004585cf
    jmp.d8 L_004585e1                            # 004585d6
L_004585d8:
    # block 0x004585d8: entered by jmp at 0x0045867b, 3 instruction(s), falls into the block at 0x004585e1
    mov eax, dword ptr [ebp - local_14]          # 004585d8
    add eax, 0x1                                 # 004585db
    mov dword ptr [ebp - local_14], eax          # 004585de
L_004585e1:
    # block 0x004585e1: entered by jmp at 0x004585d6, 4 instruction(s), ends with jge to 0x00458680 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004585e1
    movsx edx, word ptr [ecx + field_23]         # 004585e4
    cmp dword ptr [ebp - local_14], edx          # 004585e8
    jge.d32 L_00458680                           # 004585eb
    # block 0x004585f1: entered by fall-through of jge at 0x004585eb, 6 instruction(s), ends with jl to 0x0045867b (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004585f1
    mov ecx, dword ptr [ebp - local_14]          # 004585f5
    shl ecx, 0x4                                 # 004585f8
    mov edx, dword ptr [ebp - local_18]          # 004585fb
    cmp eax, dword ptr [edx + ecx + field_109]   # 004585fe
    jl.d8 L_0045867b                             # 00458605
    # block 0x00458607: entered by fall-through of jl at 0x00458605, 6 instruction(s), ends with jg to 0x0045867b (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00458607
    mov ecx, dword ptr [ebp - local_14]          # 0045860b
    shl ecx, 0x4                                 # 0045860e
    mov edx, dword ptr [ebp - local_18]          # 00458611
    cmp eax, dword ptr [edx + ecx + field_111]   # 00458614
    jg.d8 L_0045867b                             # 0045861b
    # block 0x0045861d: entered by fall-through of jg at 0x0045861b, 6 instruction(s), ends with jl to 0x0045867b (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0045861d
    mov ecx, dword ptr [ebp - local_14]          # 00458621
    shl ecx, 0x4                                 # 00458624
    mov edx, dword ptr [ebp - local_18]          # 00458627
    cmp eax, dword ptr [edx + ecx + field_105]   # 0045862a
    jl.d8 L_0045867b                             # 00458631
    # block 0x00458633: entered by fall-through of jl at 0x00458631, 6 instruction(s), ends with jg to 0x0045867b (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00458633
    mov ecx, dword ptr [ebp - local_14]          # 00458637
    shl ecx, 0x4                                 # 0045863a
    mov edx, dword ptr [ebp - local_18]          # 0045863d
    cmp eax, dword ptr [edx + ecx + field_10d]   # 00458640
    jg.d8 L_0045867b                             # 00458647
    # block 0x00458649: entered by fall-through of jg at 0x00458647, 10 instruction(s), calls FUN_0045879e, ends with forward jump to 0x00458798
    push 0x27a4                                  # 00458649
    mov ecx, dword ptr [ebp - local_1c]          # 0045864e
    call FUN_0045879e                            # 00458651
    mov eax, dword ptr [ebp - local_1c]          # 00458656
    mov dword ptr [eax + field_b4], 0x1          # 00458659
    mov ecx, dword ptr [ebp - local_1c]          # 00458663
    mov dx, word ptr [ebp - local_14]            # 00458666
    mov word ptr [ecx + field_ae], dx            # 0045866a
    mov eax, 0x1                                 # 00458671
    jmp.d32 L_00458798                           # 00458676
L_0045867b:
    # block 0x0045867b: entered by jl at 0x00458605; jg at 0x0045861b; jl at 0x00458631; jg at 0x00458647, 1 instruction(s), ends with backward jump to 0x004585d8
    jmp.d32 L_004585d8                           # 0045867b
L_00458680:
    # block 0x00458680: entered by jge at 0x004585eb, 3 instruction(s), ends with jle to 0x004586eb (forward)
    movsx eax, word ptr [0x5a4c08]               # 00458680
    test eax, eax                                # 00458687
    jle.d8 L_004586eb                            # 00458689
    # block 0x0045868b: entered by fall-through of jle at 0x00458689, 4 instruction(s), ends with jl to 0x004586eb (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 0045868b
    mov edx, dword ptr [ebp - local_18]          # 0045868f
    cmp ecx, dword ptr [edx + field_e9]          # 00458692
    jl.d8 L_004586eb                             # 00458698
    # block 0x0045869a: entered by fall-through of jl at 0x00458698, 4 instruction(s), ends with jg to 0x004586eb (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045869a
    mov ecx, dword ptr [ebp - local_18]          # 0045869e
    cmp eax, dword ptr [ecx + field_f1]          # 004586a1
    jg.d8 L_004586eb                             # 004586a7
    # block 0x004586a9: entered by fall-through of jg at 0x004586a7, 4 instruction(s), ends with jl to 0x004586eb (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004586a9
    mov eax, dword ptr [ebp - local_18]          # 004586ad
    cmp edx, dword ptr [eax + field_e5]          # 004586b0
    jl.d8 L_004586eb                             # 004586b6
    # block 0x004586b8: entered by fall-through of jl at 0x004586b6, 4 instruction(s), ends with jg to 0x004586eb (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004586b8
    mov edx, dword ptr [ebp - local_18]          # 004586bc
    cmp ecx, dword ptr [edx + field_ed]          # 004586bf
    jg.d8 L_004586eb                             # 004586c5
    # block 0x004586c7: entered by fall-through of jg at 0x004586c5, 7 instruction(s), calls FUN_0045879e, ends with forward jump to 0x00458798
    push 0x27a4                                  # 004586c7
    mov ecx, dword ptr [ebp - local_1c]          # 004586cc
    call FUN_0045879e                            # 004586cf
    mov eax, dword ptr [ebp - local_1c]          # 004586d4
    mov dword ptr [eax + field_b4], 0x0          # 004586d7
    mov eax, 0x1                                 # 004586e1
    jmp.d32 L_00458798                           # 004586e6
L_004586eb:
    # block 0x004586eb: entered by jmp at 0x004585b4; jge at 0x004585c9; jle at 0x00458689; jl at 0x00458698; more, 1 instruction(s), ends with forward jump to 0x00458746
    jmp.d8 L_00458746                            # 004586eb
L_004586ed:
    # block 0x004586ed: entered by je at 0x0045848f, 3 instruction(s), ends with jne to 0x00458746 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004586ed
    cmp dword ptr [ecx + field_20], 0x5          # 004586f0
    jne.d8 L_00458746                            # 004586f4
    # block 0x004586f6: entered by fall-through of jne at 0x004586f4, 4 instruction(s), ends with jl to 0x00458746 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004586f6
    mov eax, dword ptr [ebp - local_18]          # 004586fa
    cmp edx, dword ptr [eax + field_f9]          # 004586fd
    jl.d8 L_00458746                             # 00458703
    # block 0x00458705: entered by fall-through of jl at 0x00458703, 4 instruction(s), ends with jg to 0x00458746 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00458705
    mov edx, dword ptr [ebp - local_18]          # 00458709
    cmp ecx, dword ptr [edx + field_101]         # 0045870c
    jg.d8 L_00458746                             # 00458712
    # block 0x00458714: entered by fall-through of jg at 0x00458712, 4 instruction(s), ends with jl to 0x00458746 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00458714
    mov ecx, dword ptr [ebp - local_18]          # 00458718
    cmp eax, dword ptr [ecx + field_f5]          # 0045871b
    jl.d8 L_00458746                             # 00458721
    # block 0x00458723: entered by fall-through of jl at 0x00458721, 4 instruction(s), ends with jg to 0x00458746 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00458723
    mov eax, dword ptr [ebp - local_18]          # 00458727
    cmp edx, dword ptr [eax + field_fd]          # 0045872a
    jg.d8 L_00458746                             # 00458730
    # block 0x00458732: entered by fall-through of jg at 0x00458730, 5 instruction(s), calls FUN_0045879e, ends with forward jump to 0x00458798
    push 0x27a4                                  # 00458732
    mov ecx, dword ptr [ebp - local_1c]          # 00458737
    call FUN_0045879e                            # 0045873a
    mov eax, 0x1                                 # 0045873f
    jmp.d8 L_00458798                            # 00458744
L_00458746:
    # block 0x00458746: entered by jmp at 0x004586eb; jne at 0x004586f4; jl at 0x00458703; jg at 0x00458712; more, 4 instruction(s), ends with jl to 0x00458796 (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 00458746
    mov edx, dword ptr [ebp - local_18]          # 0045874a
    cmp ecx, dword ptr [edx + field_657]         # 0045874d
    jl.d8 L_00458796                             # 00458753
    # block 0x00458755: entered by fall-through of jl at 0x00458753, 4 instruction(s), ends with jg to 0x00458796 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 00458755
    mov ecx, dword ptr [ebp - local_18]          # 00458759
    cmp eax, dword ptr [ecx + field_65f]         # 0045875c
    jg.d8 L_00458796                             # 00458762
    # block 0x00458764: entered by fall-through of jg at 0x00458762, 4 instruction(s), ends with jl to 0x00458796 (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00458764
    mov eax, dword ptr [ebp - local_18]          # 00458768
    cmp edx, dword ptr [eax + field_653]         # 0045876b
    jl.d8 L_00458796                             # 00458771
    # block 0x00458773: entered by fall-through of jl at 0x00458771, 4 instruction(s), ends with jg to 0x00458796 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 00458773
    mov edx, dword ptr [ebp - local_18]          # 00458777
    cmp ecx, dword ptr [edx + field_65b]         # 0045877a
    jg.d8 L_00458796                             # 00458780
    # block 0x00458782: entered by fall-through of jg at 0x00458780, 5 instruction(s), calls FUN_0045879e, ends with forward jump to 0x00458798
    push 0x279f                                  # 00458782
    mov ecx, dword ptr [ebp - local_1c]          # 00458787
    call FUN_0045879e                            # 0045878a
    mov eax, 0x1                                 # 0045878f
    jmp.d8 L_00458798                            # 00458794
L_00458796:
    # block 0x00458796: entered by je at 0x00458447; jl at 0x00458753; jg at 0x00458762; jl at 0x00458771; jg at 0x00458780, 1 instruction(s), falls into the block at 0x00458798
    {load} xor eax, eax                          # 00458796
L_00458798:
    # block 0x00458798: entered by jmp at 0x004584e9; jmp at 0x004585aa; jmp at 0x00458676; jmp at 0x004586e6; more, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00458798
    pop ebp                                      # 0045879a
    ret 0xc                                      # 0045879b

