# FUN_0044753b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044753b
# extent:       0x0044753b-0x004477b2 (631 code bytes)
# span:         0x0044753b-0x004477b2 (code 631, tables 0, padding 0)
# sha256:       9a6e4a46e707f4ab63856ab1cdec9b7635aa5c08a3a34d716c88996c603f6773
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_special_effect_frame_loop
# naming:       INFERRED (lower confidence, not verified): the repository text src/session_exit.h:25 says "the frame loop 0x44753b is the reviewed A-28 kernel"
# name-note:    Frame loop of the A-28 special effect, running the sequence through the host.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       14 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_1c, local_24, local_28, local_2c, local_30, local_34, local_3c and 2 more
# fields:       [eax + n] field_1d, field_29, field_31, field_35, field_49, field_4a; [ecx + n] field_21, field_2d, field_35, field_49, field_4a, field_4c; [edx + n] field_1c, field_25, field_31, field_35, field_49
# callees:      calls KERNEL32.dll!GetTickCount, FUN_0050de00, FUN_004477d1, FUN_004f52a9, FUN_004d36ed, FUN_0050ca3e, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/action_family_28.c:action_family28_run_sequence (function ledger class candidate_port; also action_family28_sequence_weight_for_cw; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 183 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_1c, 0x1c  # offset -0x1c
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_3c, 0x3c  # offset -0x3c
.equ local_44, 0x44  # offset -0x44
.equ local_4c, 0x4c  # offset -0x4c
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_49, 0x49  # offset +0x49
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------
.set FUN_004477d1, .text + (0x004477d1 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004f52a9, .text + (0x004f52a9 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050de00, .text + (0x0050de00 - 0x401000)

.org 0x0044753b - 0x401000
.globl FUN_0044753b
FUN_0044753b:
    # block 0x0044753b: entry, 8 instruction(s), falls into the block at 0x00447560
    push ebp                                     # 0044753b
    {load} mov ebp, esp                          # 0044753c
    sub esp, 0x4c                                # 0044753e
    mov dword ptr [ebp - local_30], ecx          # 00447541
    mov dword ptr [ebp - local_8], 0x0           # 00447544
    mov dword ptr [ebp - local_4], 0x1           # 0044754b
    mov dword ptr [ebp - local_10], 0x0          # 00447552
    mov dword ptr [ebp - local_c], 0x0           # 00447559
L_00447560:
    # block 0x00447560: entered by jl at 0x0044768c, 2 instruction(s), ends with jne to 0x0044756f (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 00447560
    jne.d8 L_0044756f                            # 00447564
    # block 0x00447566: entered by fall-through of jne at 0x00447564, 2 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x0044756f
    call dword ptr [0x52a23c]                    # 00447566
    mov dword ptr [ebp - local_2c], eax          # 0044756c
L_0044756f:
    # block 0x0044756f: entered by jne at 0x00447564, 5 instruction(s), ends with jbe to 0x00447606 (forward)
    mov eax, dword ptr [ebp - local_30]          # 0044756f
    mov cl, byte ptr [eax + field_49]            # 00447572
    mov byte ptr [ebp - local_34], cl            # 00447575
    cmp byte ptr [ebp - local_34], 0x0           # 00447578
    jbe.d32 L_00447606                           # 0044757c
    # block 0x00447582: entered by fall-through of jbe at 0x0044757c, 2 instruction(s), ends with jbe to 0x0044758a (forward)
    cmp byte ptr [ebp - local_34], 0x3           # 00447582
    jbe.d8 L_0044758a                            # 00447586
    # block 0x00447588: entered by fall-through of jbe at 0x00447586, 1 instruction(s), ends with forward jump to 0x00447606
    jmp.d8 L_00447606                            # 00447588
L_0044758a:
    # block 0x0044758a: entered by jbe at 0x00447586, 2 instruction(s), ends with jge to 0x004475a0 (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 0044758a
    jge.d8 L_004475a0                            # 0044758e
    # block 0x00447590: entered by fall-through of jge at 0x0044758e, 3 instruction(s), ends with forward jump to 0x00447606
    mov dword ptr [ebp - local_10], 0x0          # 00447590
    mov dword ptr [ebp - local_c], 0x3ff00000    # 00447597
    jmp.d8 L_00447606                            # 0044759e
L_004475a0:
    # block 0x004475a0: entered by jge at 0x0044758e, 30 instruction(s), calls FUN_0050de00, falls into the block at 0x00447606
    fild dword ptr [ebp - local_8]               # 004475a0
    fstp qword ptr [ebp - local_3c]              # 004475a3
    fild dword ptr [ebp - local_4]               # 004475a6
    fstp qword ptr [ebp - local_44]              # 004475a9
    fld qword ptr [0x52cab8]                     # 004475ac
    fmul qword ptr [ebp - local_44]              # 004475b2
    fsubr qword ptr [ebp - local_3c]             # 004475b5
    fstp qword ptr [ebp - local_1c]              # 004475b8
    fild dword ptr [ebp - local_4]               # 004475bb
    fstp qword ptr [ebp - local_4c]              # 004475be
    fld qword ptr [0x52cab0]                     # 004475c1
    fmul qword ptr [ebp - local_4c]              # 004475c7
    fstp qword ptr [ebp - local_24]              # 004475ca
    fld qword ptr [ebp - local_1c]               # 004475cd
    fmul qword ptr [ebp - local_1c]              # 004475d0
    fmul qword ptr [ebp - local_1c]              # 004475d3
    fmul qword ptr [ebp - local_1c]              # 004475d6
    fchs                                         # 004475d9
    fld qword ptr [ebp - local_24]               # 004475db
    fmul qword ptr [ebp - local_24]              # 004475de
    fmul qword ptr [ebp - local_24]              # 004475e1
    fmul qword ptr [ebp - local_24]              # 004475e4
    fdiv qword ptr [0x52caa8]                    # 004475e7
    fdivp st(1), st                              # 004475ed
    sub esp, 0x8                                 # 004475ef
    fstp qword ptr [esp]                         # 004475f2
    call FUN_0050de00                            # 004475f5
    add esp, 0x8                                 # 004475fa
    fsubr qword ptr [0x52c598]                   # 004475fd
    fstp qword ptr [ebp - local_10]              # 00447603
L_00447606:
    # block 0x00447606: entered by jbe at 0x0044757c; jmp at 0x00447588; jmp at 0x0044759e, 16 instruction(s), calls FUN_004477d1, ends with jne to 0x00447673 (forward)
    mov edx, dword ptr [ebp - local_c]           # 00447606
    push edx                                     # 00447609
    mov eax, dword ptr [ebp - local_10]          # 0044760a
    push eax                                     # 0044760d
    mov ecx, dword ptr [ebp - local_30]          # 0044760e
    mov edx, dword ptr [ecx + field_35]          # 00447611
    push edx                                     # 00447614
    mov eax, dword ptr [ebp - local_30]          # 00447615
    mov ecx, dword ptr [eax + field_31]          # 00447618
    push ecx                                     # 0044761b
    mov edx, dword ptr [0x5cf665]                # 0044761c
    push edx                                     # 00447622
    mov ecx, dword ptr [ebp - local_30]          # 00447623
    call FUN_004477d1                            # 00447626
    cmp dword ptr [ebp - local_8], 0x0           # 0044762b
    jne.d8 L_00447673                            # 0044762f
    # block 0x00447631: entered by fall-through of jne at 0x0044762f, 5 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x0044764c (forward)
    call dword ptr [0x52a23c]                    # 00447631
    sub eax, dword ptr [ebp - local_2c]          # 00447637
    mov dword ptr [ebp - local_14], eax          # 0044763a
    cmp dword ptr [ebp - local_14], 0x0          # 0044763d
    jne.d8 L_0044764c                            # 00447641
    # block 0x00447643: entered by fall-through of jne at 0x00447641, 2 instruction(s), ends with forward jump to 0x00447673
    mov dword ptr [ebp - local_4], 0x1e          # 00447643
    jmp.d8 L_00447673                            # 0044764a
L_0044764c:
    # block 0x0044764c: entered by jne at 0x00447641, 6 instruction(s), ends with jge to 0x0044766c (forward)
    mov eax, dword ptr [ebp - local_14]          # 0044764c
    shl eax                                      # 0044764f
    mov ecx, dword ptr [ebp - local_30]          # 00447651
    movsx edx, word ptr [ecx + field_4a]         # 00447654
    {load} cmp eax, edx                          # 00447658
    jge.d8 L_0044766c                            # 0044765a
    # block 0x0044765c: entered by fall-through of jge at 0x0044765a, 6 instruction(s), ends with forward jump to 0x00447673
    mov eax, dword ptr [ebp - local_30]          # 0044765c
    movsx eax, word ptr [eax + field_4a]         # 0044765f
    cdq                                          # 00447663
    idiv dword ptr [ebp - local_14]              # 00447664
    mov dword ptr [ebp - local_4], eax           # 00447667
    jmp.d8 L_00447673                            # 0044766a
L_0044766c:
    # block 0x0044766c: entered by jge at 0x0044765a, 1 instruction(s), falls into the block at 0x00447673
    mov dword ptr [ebp - local_4], 0x2           # 0044766c
L_00447673:
    # block 0x00447673: entered by jne at 0x0044762f; jmp at 0x0044764a; jmp at 0x0044766a, 8 instruction(s), calls FUN_004f52a9, ends with jl to 0x00447560 (backward)
    mov ecx, 0x5cf1eb                            # 00447673
    call FUN_004f52a9                            # 00447678
    mov ecx, dword ptr [ebp - local_8]           # 0044767d
    add ecx, 0x1                                 # 00447680
    mov dword ptr [ebp - local_8], ecx           # 00447683
    mov edx, dword ptr [ebp - local_8]           # 00447686
    cmp edx, dword ptr [ebp - local_4]           # 00447689
    jl.d32 L_00447560                            # 0044768c
    # block 0x00447692: entered by fall-through of jl at 0x0044768c, 5 instruction(s), ends with je to 0x004476ac (forward)
    mov eax, dword ptr [ebp - local_30]          # 00447692
    {load} xor ecx, ecx                          # 00447695
    mov cl, byte ptr [eax + field_49]            # 00447697
    cmp ecx, 0x1                                 # 0044769a
    je.d8 L_004476ac                             # 0044769d
    # block 0x0044769f: entered by fall-through of je at 0x0044769d, 5 instruction(s), ends with jne to 0x004476d5 (forward)
    mov edx, dword ptr [ebp - local_30]          # 0044769f
    {load} xor eax, eax                          # 004476a2
    mov al, byte ptr [edx + field_49]            # 004476a4
    cmp eax, 0x3                                 # 004476a7
    jne.d8 L_004476d5                            # 004476aa
L_004476ac:
    # block 0x004476ac: entered by je at 0x0044769d; fall-through of jne at 0x004476aa, 5 instruction(s), calls KERNEL32.dll!GetTickCount, falls into the block at 0x004476be
    call dword ptr [0x52a23c]                    # 004476ac
    mov ecx, dword ptr [ebp - local_30]          # 004476b2
    movsx edx, word ptr [ecx + field_4c]         # 004476b5
    {load} add eax, edx                          # 004476b9
    mov dword ptr [ebp - local_2c], eax          # 004476bb
L_004476be:
    # block 0x004476be: entered by jmp at 0x004476d3, 3 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jae to 0x004476d5 (forward)
    call dword ptr [0x52a23c]                    # 004476be
    cmp eax, dword ptr [ebp - local_2c]          # 004476c4
    jae.d8 L_004476d5                            # 004476c7
    # block 0x004476c9: entered by fall-through of jae at 0x004476c7, 3 instruction(s), calls FUN_004f52a9, ends with backward jump to 0x004476be
    mov ecx, 0x5cf1eb                            # 004476c9
    call FUN_004f52a9                            # 004476ce
    jmp.d8 L_004476be                            # 004476d3
L_004476d5:
    # block 0x004476d5: entered by jne at 0x004476aa; jae at 0x004476c7, 4 instruction(s), calls FUN_004d36ed, ends with je to 0x00447749 (forward)
    call FUN_004d36ed                            # 004476d5
    movsx eax, word ptr [0x63a4cd]               # 004476da
    test eax, eax                                # 004476e1
    je.d8 L_00447749                             # 004476e3
    # block 0x004476e5: entered by fall-through of je at 0x004476e3, 31 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00447749
    mov ecx, dword ptr [ebp - local_14]          # 004476e5
    push ecx                                     # 004476e8
    mov edx, dword ptr [ebp - local_4]           # 004476e9
    push edx                                     # 004476ec
    mov eax, dword ptr [ebp - local_30]          # 004476ed
    mov ecx, dword ptr [eax + field_29]          # 004476f0
    sub ecx, dword ptr [0x58318a]                # 004476f3
    push ecx                                     # 004476f9
    mov edx, dword ptr [ebp - local_30]          # 004476fa
    mov eax, dword ptr [edx + field_25]          # 004476fd
    sub eax, dword ptr [0x583186]                # 00447700
    push eax                                     # 00447706
    mov ecx, dword ptr [ebp - local_30]          # 00447707
    mov edx, dword ptr [ecx + field_21]          # 0044770a
    sub edx, dword ptr [0x58318a]                # 0044770d
    push edx                                     # 00447713
    mov eax, dword ptr [ebp - local_30]          # 00447714
    mov ecx, dword ptr [eax + field_1d]          # 00447717
    sub ecx, dword ptr [0x583186]                # 0044771a
    push ecx                                     # 00447720
    mov edx, dword ptr [ebp - local_30]          # 00447721
    {load} xor eax, eax                          # 00447724
    mov al, byte ptr [edx + field_49]            # 00447726
    push eax                                     # 00447729
    push 0x5484cc                                # 0044772a
    push 0x63888b                                # 0044772f
    call FUN_0050ca3e                            # 00447734
    add esp, 0x24                                # 00447739
    push 0x63888b                                # 0044773c
    call FUN_0044a2b7                            # 00447741
    add esp, 0x4                                 # 00447746
L_00447749:
    # block 0x00447749: entered by je at 0x004476e3, 5 instruction(s), ends with jne to 0x00447793 (forward)
    mov ecx, dword ptr [ebp - local_30]          # 00447749
    {load} xor edx, edx                          # 0044774c
    mov dl, byte ptr [ecx + field_49]            # 0044774e
    cmp edx, 0x3                                 # 00447751
    jne.d8 L_00447793                            # 00447754
    # block 0x00447756: entered by fall-through of jne at 0x00447754, 14 instruction(s), ends with jne to 0x00447791 (forward)
    mov eax, dword ptr [ebp - local_30]          # 00447756
    mov ecx, dword ptr [eax + field_31]          # 00447759
    mov dword ptr [ebp - local_28], ecx          # 0044775c
    mov edx, dword ptr [ebp - local_30]          # 0044775f
    mov eax, dword ptr [ebp - local_30]          # 00447762
    mov ecx, dword ptr [eax + field_35]          # 00447765
    mov dword ptr [edx + field_31], ecx          # 00447768
    mov edx, dword ptr [ebp - local_30]          # 0044776b
    mov eax, dword ptr [ebp - local_28]          # 0044776e
    mov dword ptr [edx + field_35], eax          # 00447771
    mov ecx, dword ptr [ebp - local_30]          # 00447774
    mov dword ptr [ecx + field_2d], 0x1          # 00447777
    cmp dword ptr [0x583999], 0x4                # 0044777e
    jne.d8 L_00447791                            # 00447785
    # block 0x00447787: entered by fall-through of jne at 0x00447785, 1 instruction(s), falls into the block at 0x00447791
    mov dword ptr [0x583999], 0x1                # 00447787
L_00447791:
    # block 0x00447791: entered by jne at 0x00447785, 1 instruction(s), ends with forward jump to 0x004477ae
    jmp.d8 L_004477ae                            # 00447791
L_00447793:
    # block 0x00447793: entered by jne at 0x00447754, 4 instruction(s), falls into the block at 0x004477ae
    mov edx, dword ptr [ebp - local_30]          # 00447793
    mov byte ptr [edx + field_1c], 0x0           # 00447796
    mov dword ptr [0x5839a9], 0x0                # 0044779a
    mov dword ptr [0x5d1639], 0x1                # 004477a4
L_004477ae:
    # block 0x004477ae: entered by jmp at 0x00447791, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004477ae
    pop ebp                                      # 004477b0
    ret                                          # 004477b1

