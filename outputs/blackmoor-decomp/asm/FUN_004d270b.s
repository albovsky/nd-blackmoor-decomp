# FUN_004d270b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d270b
# extent:       0x004d270b-0x004d2c20 (1301 code bytes)
# span:         0x004d270b-0x004d2c20 (code 1301, tables 0, padding 0)
# sha256:       56eb3e1c05f2a110bc4915aaad0efbba56f38d9c2881de536a2d158312235d73
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d270b_draw_text
# naming:       native port src/original_methods_fl30a.c:m4d270b_draw_text (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Draws a string glyph by glyph (0x4d214b, class routines, 0x4c5b3a, pen globals, __ftol, word fill); all instructions and jump directions run; flag set with no glyph is a native rejection.
# arguments:    10 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       14 ebp-relative slot(s): local_4, local_c, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30, local_34, local_38 and 2 more
# fields:       [eax + n] field_2f, field_3f, field_43, field_c3, field_c7, field_cb, field_cf, field_minus_1, field_minus_30, field_minus_61; [ecx + n] field_2, field_3f, field_43, field_4f, field_55, field_57, field_c3, field_c7, field_cb, field_cf, field_minus_1, field_minus_41; [edx + n] field_3f, field_43, field_51, field_53, field_c3, field_c7, field_cb, field_cf
# callees:      calls FUN_0052139c, FUN_004c97b4, FUN_004d214b, FUN_0050d651, FUN_0050d67f, FUN_0050d6a7, FUN_0050d6cf, FUN_004c5b3a, FUN_0050ce04
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30a.c:m4d270b_draw_text (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 350 instruction(s), 17 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30
.equ field_minus_30, 0x30  # offset -0x30
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ field_minus_41, 0x41  # offset -0x41
.equ field_minus_61, 0x61  # offset -0x61
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ arg_2c, 0x2c  # offset +0x2c
.equ field_2f, 0x2f  # offset +0x2f
.equ field_3f, 0x3f  # offset +0x3f
.equ field_43, 0x43  # offset +0x43
.equ field_4f, 0x4f  # offset +0x4f
.equ field_51, 0x51  # offset +0x51
.equ field_53, 0x53  # offset +0x53
.equ field_55, 0x55  # offset +0x55
.equ field_57, 0x57  # offset +0x57
.equ field_c3, 0xc3  # offset +0xc3
.equ field_c7, 0xc7  # offset +0xc7
.equ field_cb, 0xcb  # offset +0xcb
.equ field_cf, 0xcf  # offset +0xcf

# --- external targets -----------------------------------------------
.set FUN_004c5b3a, .text + (0x004c5b3a - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d214b, .text + (0x004d214b - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0050d651, .text + (0x0050d651 - 0x401000)
.set FUN_0050d67f, .text + (0x0050d67f - 0x401000)
.set FUN_0050d6a7, .text + (0x0050d6a7 - 0x401000)
.set FUN_0050d6cf, .text + (0x0050d6cf - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004d270b - 0x401000
.globl FUN_004d270b
FUN_004d270b:
    # block 0x004d270b: entry, 6 instruction(s), ends with je to 0x004d2740 (forward)
    push ebp                                     # 004d270b
    {load} mov ebp, esp                          # 004d270c
    sub esp, 0x40                                # 004d270e
    movsx eax, word ptr [0x63a4cd]               # 004d2711
    test eax, eax                                # 004d2718
    je.d8 L_004d2740                             # 004d271a
    # block 0x004d271c: entered by fall-through of je at 0x004d271a, 2 instruction(s), ends with je to 0x004d2728 (forward)
    cmp dword ptr [ebp + arg_1c], 0x0            # 004d271c
    je.d8 L_004d2728                             # 004d2720
    # block 0x004d2722: entered by fall-through of je at 0x004d2720, 2 instruction(s), ends with jne to 0x004d2740 (forward)
    cmp dword ptr [ebp + arg_20], 0x0            # 004d2722
    jne.d8 L_004d2740                            # 004d2726
L_004d2728:
    # block 0x004d2728: entered by je at 0x004d2720; fall-through of jne at 0x004d2726, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x004d2740
    push 0x0                                     # 004d2728
    push 0x0                                     # 004d272a
    push 0x55a2fc                                # 004d272c
    call FUN_0052139c                            # 004d2731
    mov ecx, 0x5cf659                            # 004d2736
    call FUN_004c97b4                            # 004d273b
L_004d2740:
    # block 0x004d2740: entered by je at 0x004d271a; jne at 0x004d2726, 12 instruction(s), ends with forward jump to 0x004d2788
    movsx ecx, word ptr [ebp + arg_18]           # 004d2740
    mov dword ptr [0x63a8fc], ecx                # 004d2744
    mov dword ptr [0x63a8f4], 0x0                # 004d274a
    movsx edx, word ptr [ebp + arg_14]           # 004d2754
    mov dword ptr [0x63a8f0], edx                # 004d2758
    mov dword ptr [0x63a8f8], 0x0                # 004d275e
    mov eax, dword ptr [0x63a8f0]                # 004d2768
    mov dword ptr [ebp - local_14], eax          # 004d276d
    mov dword ptr [ebp - local_18], 0x0          # 004d2770
    mov ecx, dword ptr [ebp + arg_8]             # 004d2777
    mov dword ptr [ebp - local_30], ecx          # 004d277a
    jmp.d8 L_004d2788                            # 004d277d
L_004d277f:
    # block 0x004d277f: entered by jmp at 0x004d2ad2; jmp at 0x004d2bb1, 3 instruction(s), falls into the block at 0x004d2788
    mov edx, dword ptr [ebp + arg_8]             # 004d277f
    add edx, 0x1                                 # 004d2782
    mov dword ptr [ebp + arg_8], edx             # 004d2785
L_004d2788:
    # block 0x004d2788: entered by jmp at 0x004d277d, 4 instruction(s), ends with je to 0x004d2bb6 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d2788
    movsx ecx, byte ptr [eax]                    # 004d278b
    test ecx, ecx                                # 004d278e
    je.d32 L_004d2bb6                            # 004d2790
    # block 0x004d2796: entered by fall-through of je at 0x004d2790, 11 instruction(s), calls FUN_004d214b, ends with je to 0x004d2835 (forward)
    lea edx, [ebp - local_2c]                    # 004d2796
    push edx                                     # 004d2799
    mov eax, dword ptr [ebp + arg_c]             # 004d279a
    push eax                                     # 004d279d
    mov ecx, dword ptr [ebp + arg_8]             # 004d279e
    mov dl, byte ptr [ecx]                       # 004d27a1
    push edx                                     # 004d27a3
    call FUN_004d214b                            # 004d27a4
    add esp, 0xc                                 # 004d27a9
    test eax, eax                                # 004d27ac
    je.d32 L_004d2835                            # 004d27ae
    # block 0x004d27b4: entered by fall-through of je at 0x004d27ae, 33 instruction(s), ends with forward jump to 0x004d2ad7
    movsx eax, word ptr [ebp - local_2c]         # 004d27b4
    shl eax, 0x4                                 # 004d27b8
    movsx ecx, word ptr [ebp + arg_24]           # 004d27bb
    mov edx, dword ptr [ebp + arg_c]             # 004d27bf
    mov eax, dword ptr [edx + eax + field_c7]    # 004d27c2
    mov edx, dword ptr [ebp + arg_c]             # 004d27c9
    add eax, dword ptr [edx + 8*ecx + field_43]  # 004d27cc
    mov dword ptr [ebp - local_24], eax          # 004d27d0
    movsx eax, word ptr [ebp - local_2c]         # 004d27d3
    shl eax, 0x4                                 # 004d27d7
    movsx ecx, word ptr [ebp + arg_24]           # 004d27da
    mov edx, dword ptr [ebp + arg_c]             # 004d27de
    mov eax, dword ptr [edx + eax + field_cf]    # 004d27e1
    mov edx, dword ptr [ebp + arg_c]             # 004d27e8
    add eax, dword ptr [edx + 8*ecx + field_43]  # 004d27eb
    mov dword ptr [ebp - local_1c], eax          # 004d27ef
    movsx eax, word ptr [ebp - local_2c]         # 004d27f2
    shl eax, 0x4                                 # 004d27f6
    movsx ecx, word ptr [ebp + arg_24]           # 004d27f9
    mov edx, dword ptr [ebp + arg_c]             # 004d27fd
    mov eax, dword ptr [edx + eax + field_c3]    # 004d2800
    mov edx, dword ptr [ebp + arg_c]             # 004d2807
    add eax, dword ptr [edx + 8*ecx + field_3f]  # 004d280a
    mov dword ptr [ebp - local_28], eax          # 004d280e
    movsx eax, word ptr [ebp - local_2c]         # 004d2811
    shl eax, 0x4                                 # 004d2815
    movsx ecx, word ptr [ebp + arg_24]           # 004d2818
    mov edx, dword ptr [ebp + arg_c]             # 004d281c
    mov eax, dword ptr [edx + eax + field_cb]    # 004d281f
    mov edx, dword ptr [ebp + arg_c]             # 004d2826
    add eax, dword ptr [edx + 8*ecx + field_3f]  # 004d2829
    mov dword ptr [ebp - local_20], eax          # 004d282d
    jmp.d32 L_004d2ad7                           # 004d2830
L_004d2835:
    # block 0x004d2835: entered by je at 0x004d27ae, 7 instruction(s), calls FUN_0050d651, ends with je to 0x004d290c (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d2835
    movsx ecx, byte ptr [eax]                    # 004d2838
    push ecx                                     # 004d283b
    call FUN_0050d651                            # 004d283c
    add esp, 0x4                                 # 004d2841
    test eax, eax                                # 004d2844
    je.d32 L_004d290c                            # 004d2846
    # block 0x004d284c: entered by fall-through of je at 0x004d2846, 7 instruction(s), calls FUN_0050d67f, ends with je to 0x004d290c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d284c
    movsx eax, byte ptr [edx]                    # 004d284f
    push eax                                     # 004d2852
    call FUN_0050d67f                            # 004d2853
    add esp, 0x4                                 # 004d2858
    test eax, eax                                # 004d285b
    je.d32 L_004d290c                            # 004d285d
    # block 0x004d2863: entered by fall-through of je at 0x004d285d, 5 instruction(s), ends with jge to 0x004d290c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d2863
    {load} xor edx, edx                          # 004d2866
    mov dl, byte ptr [ecx]                       # 004d2868
    cmp edx, 0x80                                # 004d286a
    jge.d32 L_004d290c                           # 004d2870
    # block 0x004d2876: entered by fall-through of jge at 0x004d2870, 39 instruction(s), ends with forward jump to 0x004d2ad7
    mov eax, dword ptr [ebp + arg_8]             # 004d2876
    movsx ecx, byte ptr [eax]                    # 004d2879
    mov edx, dword ptr [ebp + arg_c]             # 004d287c
    movsx eax, word ptr [edx + field_53]         # 004d287f
    lea ecx, [ecx + eax - field_minus_41]        # 004d2883
    mov word ptr [ebp - local_2c], cx            # 004d2887
    movsx edx, word ptr [ebp - local_2c]         # 004d288b
    shl edx, 0x4                                 # 004d288f
    movsx eax, word ptr [ebp + arg_24]           # 004d2892
    mov ecx, dword ptr [ebp + arg_c]             # 004d2896
    mov edx, dword ptr [ecx + edx + field_c7]    # 004d2899
    mov ecx, dword ptr [ebp + arg_c]             # 004d28a0
    add edx, dword ptr [ecx + 8*eax + field_43]  # 004d28a3
    mov dword ptr [ebp - local_24], edx          # 004d28a7
    movsx edx, word ptr [ebp - local_2c]         # 004d28aa
    shl edx, 0x4                                 # 004d28ae
    movsx eax, word ptr [ebp + arg_24]           # 004d28b1
    mov ecx, dword ptr [ebp + arg_c]             # 004d28b5
    mov edx, dword ptr [ecx + edx + field_cf]    # 004d28b8
    mov ecx, dword ptr [ebp + arg_c]             # 004d28bf
    add edx, dword ptr [ecx + 8*eax + field_43]  # 004d28c2
    mov dword ptr [ebp - local_1c], edx          # 004d28c6
    movsx edx, word ptr [ebp - local_2c]         # 004d28c9
    shl edx, 0x4                                 # 004d28cd
    movsx eax, word ptr [ebp + arg_24]           # 004d28d0
    mov ecx, dword ptr [ebp + arg_c]             # 004d28d4
    mov edx, dword ptr [ecx + edx + field_c3]    # 004d28d7
    mov ecx, dword ptr [ebp + arg_c]             # 004d28de
    add edx, dword ptr [ecx + 8*eax + field_3f]  # 004d28e1
    mov dword ptr [ebp - local_28], edx          # 004d28e5
    movsx edx, word ptr [ebp - local_2c]         # 004d28e8
    shl edx, 0x4                                 # 004d28ec
    movsx eax, word ptr [ebp + arg_24]           # 004d28ef
    mov ecx, dword ptr [ebp + arg_c]             # 004d28f3
    mov edx, dword ptr [ecx + edx + field_cb]    # 004d28f6
    mov ecx, dword ptr [ebp + arg_c]             # 004d28fd
    add edx, dword ptr [ecx + 8*eax + field_3f]  # 004d2900
    mov dword ptr [ebp - local_20], edx          # 004d2904
    jmp.d32 L_004d2ad7                           # 004d2907
L_004d290c:
    # block 0x004d290c: entered by je at 0x004d2846; je at 0x004d285d; jge at 0x004d2870, 7 instruction(s), calls FUN_0050d651, ends with je to 0x004d29e3 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004d290c
    movsx eax, byte ptr [edx]                    # 004d290f
    push eax                                     # 004d2912
    call FUN_0050d651                            # 004d2913
    add esp, 0x4                                 # 004d2918
    test eax, eax                                # 004d291b
    je.d32 L_004d29e3                            # 004d291d
    # block 0x004d2923: entered by fall-through of je at 0x004d291d, 7 instruction(s), calls FUN_0050d6a7, ends with je to 0x004d29e3 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d2923
    movsx edx, byte ptr [ecx]                    # 004d2926
    push edx                                     # 004d2929
    call FUN_0050d6a7                            # 004d292a
    add esp, 0x4                                 # 004d292f
    test eax, eax                                # 004d2932
    je.d32 L_004d29e3                            # 004d2934
    # block 0x004d293a: entered by fall-through of je at 0x004d2934, 5 instruction(s), ends with jge to 0x004d29e3 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d293a
    {load} xor ecx, ecx                          # 004d293d
    mov cl, byte ptr [eax]                       # 004d293f
    cmp ecx, 0x80                                # 004d2941
    jge.d32 L_004d29e3                           # 004d2947
    # block 0x004d294d: entered by fall-through of jge at 0x004d2947, 39 instruction(s), ends with forward jump to 0x004d2ad7
    mov edx, dword ptr [ebp + arg_8]             # 004d294d
    movsx eax, byte ptr [edx]                    # 004d2950
    mov ecx, dword ptr [ebp + arg_c]             # 004d2953
    movsx edx, word ptr [ecx + field_55]         # 004d2956
    lea eax, [eax + edx - field_minus_61]        # 004d295a
    mov word ptr [ebp - local_2c], ax            # 004d295e
    movsx ecx, word ptr [ebp - local_2c]         # 004d2962
    shl ecx, 0x4                                 # 004d2966
    movsx edx, word ptr [ebp + arg_24]           # 004d2969
    mov eax, dword ptr [ebp + arg_c]             # 004d296d
    mov ecx, dword ptr [eax + ecx + field_c7]    # 004d2970
    mov eax, dword ptr [ebp + arg_c]             # 004d2977
    add ecx, dword ptr [eax + 8*edx + field_43]  # 004d297a
    mov dword ptr [ebp - local_24], ecx          # 004d297e
    movsx ecx, word ptr [ebp - local_2c]         # 004d2981
    shl ecx, 0x4                                 # 004d2985
    movsx edx, word ptr [ebp + arg_24]           # 004d2988
    mov eax, dword ptr [ebp + arg_c]             # 004d298c
    mov ecx, dword ptr [eax + ecx + field_cf]    # 004d298f
    mov eax, dword ptr [ebp + arg_c]             # 004d2996
    add ecx, dword ptr [eax + 8*edx + field_43]  # 004d2999
    mov dword ptr [ebp - local_1c], ecx          # 004d299d
    movsx ecx, word ptr [ebp - local_2c]         # 004d29a0
    shl ecx, 0x4                                 # 004d29a4
    movsx edx, word ptr [ebp + arg_24]           # 004d29a7
    mov eax, dword ptr [ebp + arg_c]             # 004d29ab
    mov ecx, dword ptr [eax + ecx + field_c3]    # 004d29ae
    mov eax, dword ptr [ebp + arg_c]             # 004d29b5
    add ecx, dword ptr [eax + 8*edx + field_3f]  # 004d29b8
    mov dword ptr [ebp - local_28], ecx          # 004d29bc
    movsx ecx, word ptr [ebp - local_2c]         # 004d29bf
    shl ecx, 0x4                                 # 004d29c3
    movsx edx, word ptr [ebp + arg_24]           # 004d29c6
    mov eax, dword ptr [ebp + arg_c]             # 004d29ca
    mov ecx, dword ptr [eax + ecx + field_cb]    # 004d29cd
    mov eax, dword ptr [ebp + arg_c]             # 004d29d4
    add ecx, dword ptr [eax + 8*edx + field_3f]  # 004d29d7
    mov dword ptr [ebp - local_20], ecx          # 004d29db
    jmp.d32 L_004d2ad7                           # 004d29de
L_004d29e3:
    # block 0x004d29e3: entered by je at 0x004d291d; je at 0x004d2934; jge at 0x004d2947, 7 instruction(s), calls FUN_0050d6cf, ends with je to 0x004d2aa0 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004d29e3
    movsx edx, byte ptr [ecx]                    # 004d29e6
    push edx                                     # 004d29e9
    call FUN_0050d6cf                            # 004d29ea
    add esp, 0x4                                 # 004d29ef
    test eax, eax                                # 004d29f2
    je.d32 L_004d2aa0                            # 004d29f4
    # block 0x004d29fa: entered by fall-through of je at 0x004d29f4, 5 instruction(s), ends with jge to 0x004d2aa0 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004d29fa
    {load} xor ecx, ecx                          # 004d29fd
    mov cl, byte ptr [eax]                       # 004d29ff
    cmp ecx, 0x80                                # 004d2a01
    jge.d32 L_004d2aa0                           # 004d2a07
    # block 0x004d2a0d: entered by fall-through of jge at 0x004d2a07, 39 instruction(s), ends with forward jump to 0x004d2ad7
    mov edx, dword ptr [ebp + arg_8]             # 004d2a0d
    movsx eax, byte ptr [edx]                    # 004d2a10
    mov ecx, dword ptr [ebp + arg_c]             # 004d2a13
    movsx edx, word ptr [ecx + field_57]         # 004d2a16
    lea eax, [eax + edx - field_minus_30]        # 004d2a1a
    mov word ptr [ebp - local_2c], ax            # 004d2a1e
    movsx ecx, word ptr [ebp - local_2c]         # 004d2a22
    shl ecx, 0x4                                 # 004d2a26
    movsx edx, word ptr [ebp + arg_24]           # 004d2a29
    mov eax, dword ptr [ebp + arg_c]             # 004d2a2d
    mov ecx, dword ptr [eax + ecx + field_c7]    # 004d2a30
    mov eax, dword ptr [ebp + arg_c]             # 004d2a37
    add ecx, dword ptr [eax + 8*edx + field_43]  # 004d2a3a
    mov dword ptr [ebp - local_24], ecx          # 004d2a3e
    movsx ecx, word ptr [ebp - local_2c]         # 004d2a41
    shl ecx, 0x4                                 # 004d2a45
    movsx edx, word ptr [ebp + arg_24]           # 004d2a48
    mov eax, dword ptr [ebp + arg_c]             # 004d2a4c
    mov ecx, dword ptr [eax + ecx + field_cf]    # 004d2a4f
    mov eax, dword ptr [ebp + arg_c]             # 004d2a56
    add ecx, dword ptr [eax + 8*edx + field_43]  # 004d2a59
    mov dword ptr [ebp - local_1c], ecx          # 004d2a5d
    movsx ecx, word ptr [ebp - local_2c]         # 004d2a60
    shl ecx, 0x4                                 # 004d2a64
    movsx edx, word ptr [ebp + arg_24]           # 004d2a67
    mov eax, dword ptr [ebp + arg_c]             # 004d2a6b
    mov ecx, dword ptr [eax + ecx + field_c3]    # 004d2a6e
    mov eax, dword ptr [ebp + arg_c]             # 004d2a75
    add ecx, dword ptr [eax + 8*edx + field_3f]  # 004d2a78
    mov dword ptr [ebp - local_28], ecx          # 004d2a7c
    movsx ecx, word ptr [ebp - local_2c]         # 004d2a7f
    shl ecx, 0x4                                 # 004d2a83
    movsx edx, word ptr [ebp + arg_24]           # 004d2a86
    mov eax, dword ptr [ebp + arg_c]             # 004d2a8a
    mov ecx, dword ptr [eax + ecx + field_cb]    # 004d2a8d
    mov eax, dword ptr [ebp + arg_c]             # 004d2a94
    add ecx, dword ptr [eax + 8*edx + field_3f]  # 004d2a97
    mov dword ptr [ebp - local_20], ecx          # 004d2a9b
    jmp.d8 L_004d2ad7                            # 004d2a9e
L_004d2aa0:
    # block 0x004d2aa0: entered by je at 0x004d29f4; jge at 0x004d2a07, 13 instruction(s), ends with backward jump to 0x004d277f
    mov ecx, dword ptr [ebp + arg_c]             # 004d2aa0
    movsx edx, word ptr [ecx + field_4f]         # 004d2aa3
    mov eax, dword ptr [0x63a8f0]                # 004d2aa7
    {load} add eax, edx                          # 004d2aac
    mov dword ptr [0x63a8f0], eax                # 004d2aae
    mov ecx, dword ptr [ebp + arg_c]             # 004d2ab3
    movsx edx, word ptr [ecx + field_4f]         # 004d2ab6
    mov eax, dword ptr [0x63a8f0]                # 004d2aba
    lea ecx, [eax + edx - field_minus_1]         # 004d2abf
    mov dword ptr [0x63a8f8], ecx                # 004d2ac3
    mov edx, dword ptr [0x63a8f8]                # 004d2ac9
    mov dword ptr [ebp - local_c], edx           # 004d2acf
    jmp.d32 L_004d277f                           # 004d2ad2
L_004d2ad7:
    # block 0x004d2ad7: entered by jmp at 0x004d2830; jmp at 0x004d2907; jmp at 0x004d29de; jmp at 0x004d2a9e, 27 instruction(s), calls FUN_004c5b3a, ends with je to 0x004d2b77 (forward)
    movsx eax, word ptr [ebp - local_2c]         # 004d2ad7
    mov ecx, dword ptr [ebp + arg_10]            # 004d2adb
    movsx edx, word ptr [ecx + 4*eax + field_2]  # 004d2ade
    mov eax, dword ptr [0x63a8fc]                # 004d2ae3
    {load} sub eax, edx                          # 004d2ae8
    add eax, 0x1                                 # 004d2aea
    mov dword ptr [0x63a8f4], eax                # 004d2aed
    movsx ecx, word ptr [ebp - local_2c]         # 004d2af2
    mov edx, dword ptr [ebp + arg_10]            # 004d2af6
    movsx eax, word ptr [edx + 4*ecx]            # 004d2af9
    mov ecx, dword ptr [0x63a8f0]                # 004d2afd
    lea edx, [ecx + eax - field_minus_1]         # 004d2b03
    mov dword ptr [0x63a8f8], edx                # 004d2b07
    mov eax, dword ptr [0x63a8f8]                # 004d2b0d
    mov dword ptr [ebp - local_c], eax           # 004d2b12
    push 0x55a338                                # 004d2b15
    push 0x63a8f0                                # 004d2b1a
    lea ecx, [ebp - local_28]                    # 004d2b1f
    push ecx                                     # 004d2b22
    mov edx, dword ptr [ebp + arg_20]            # 004d2b23
    push edx                                     # 004d2b26
    mov eax, dword ptr [ebp + arg_1c]            # 004d2b27
    push eax                                     # 004d2b2a
    mov ecx, 0x5cf659                            # 004d2b2b
    call FUN_004c5b3a                            # 004d2b30
    cmp dword ptr [ebp + arg_28], 0x0            # 004d2b35
    je.d8 L_004d2b77                             # 004d2b39
    # block 0x004d2b3b: entered by fall-through of je at 0x004d2b39, 2 instruction(s), ends with jne to 0x004d2b77 (forward)
    cmp dword ptr [ebp - local_18], 0x0          # 004d2b3b
    jne.d8 L_004d2b77                            # 004d2b3f
    # block 0x004d2b41: entered by fall-through of jne at 0x004d2b3f, 12 instruction(s), calls FUN_0050ce04, falls into the block at 0x004d2b77
    mov ecx, dword ptr [0x63a8fc]                # 004d2b41
    sub ecx, dword ptr [0x63a8f4]                # 004d2b47
    add ecx, 0x1                                 # 004d2b4d
    mov dword ptr [ebp - local_3c], ecx          # 004d2b50
    fild dword ptr [ebp - local_3c]              # 004d2b53
    fstp dword ptr [ebp - local_40]              # 004d2b56
    fld dword ptr [ebp - local_40]               # 004d2b59
    fmul dword ptr [0x52e2d4]                    # 004d2b5c
    call FUN_0050ce04                            # 004d2b62
    add eax, dword ptr [0x63a8f4]                # 004d2b67
    mov dword ptr [ebp - local_4], eax           # 004d2b6d
    mov dword ptr [ebp - local_18], 0x1          # 004d2b70
L_004d2b77:
    # block 0x004d2b77: entered by je at 0x004d2b39; jne at 0x004d2b3f, 15 instruction(s), ends with backward jump to 0x004d277f
    movsx edx, word ptr [ebp - local_2c]         # 004d2b77
    mov eax, dword ptr [ebp + arg_10]            # 004d2b7b
    movsx ecx, word ptr [eax + 4*edx]            # 004d2b7e
    mov edx, dword ptr [ebp + arg_c]             # 004d2b82
    movsx eax, word ptr [edx + field_51]         # 004d2b85
    add eax, dword ptr [0x63a8f0]                # 004d2b89
    {load} add eax, ecx                          # 004d2b8f
    mov dword ptr [0x63a8f0], eax                # 004d2b91
    movsx ecx, word ptr [ebp - local_2c]         # 004d2b96
    mov edx, dword ptr [ebp + arg_10]            # 004d2b9a
    movsx eax, word ptr [edx + 4*ecx]            # 004d2b9d
    mov ecx, dword ptr [0x63a8f0]                # 004d2ba1
    lea edx, [ecx + eax - field_minus_1]         # 004d2ba7
    mov dword ptr [0x63a8f8], edx                # 004d2bab
    jmp.d32 L_004d277f                           # 004d2bb1
L_004d2bb6:
    # block 0x004d2bb6: entered by je at 0x004d2790, 2 instruction(s), ends with je to 0x004d2c17 (forward)
    cmp dword ptr [ebp + arg_28], 0x0            # 004d2bb6
    je.d8 L_004d2c17                             # 004d2bba
    # block 0x004d2bbc: entered by fall-through of je at 0x004d2bba, 14 instruction(s), ends with forward jump to 0x004d2bf4
    mov eax, dword ptr [ebp + arg_20]            # 004d2bbc
    movsx ecx, word ptr [eax + field_2f]         # 004d2bbf
    mov edx, dword ptr [ebp - local_4]           # 004d2bc3
    imul edx, ecx                                # 004d2bc6
    mov eax, dword ptr [ebp + arg_20]            # 004d2bc9
    mov ecx, dword ptr [eax]                     # 004d2bcc
    {load} add ecx, edx                          # 004d2bce
    movsx edx, word ptr [0x639895]               # 004d2bd0
    mov eax, dword ptr [ebp - local_14]          # 004d2bd7
    imul eax, edx                                # 004d2bda
    {load} add ecx, eax                          # 004d2bdd
    mov dword ptr [ebp - local_34], ecx          # 004d2bdf
    mov dword ptr [ebp - local_38], 0x0          # 004d2be2
    jmp.d8 L_004d2bf4                            # 004d2be9
L_004d2beb:
    # block 0x004d2beb: entered by jmp at 0x004d2c15, 3 instruction(s), falls into the block at 0x004d2bf4
    mov ecx, dword ptr [ebp - local_38]          # 004d2beb
    add ecx, 0x1                                 # 004d2bee
    mov dword ptr [ebp - local_38], ecx          # 004d2bf1
L_004d2bf4:
    # block 0x004d2bf4: entered by jmp at 0x004d2be9, 5 instruction(s), ends with jge to 0x004d2c17 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004d2bf4
    sub edx, dword ptr [ebp - local_14]          # 004d2bf7
    add edx, 0x1                                 # 004d2bfa
    cmp dword ptr [ebp - local_38], edx          # 004d2bfd
    jge.d8 L_004d2c17                            # 004d2c00
    # block 0x004d2c02: entered by fall-through of jge at 0x004d2c00, 7 instruction(s), ends with backward jump to 0x004d2beb
    mov eax, dword ptr [ebp - local_34]          # 004d2c02
    mov cx, word ptr [ebp + arg_2c]              # 004d2c05
    mov word ptr [eax], cx                       # 004d2c09
    mov edx, dword ptr [ebp - local_34]          # 004d2c0c
    add edx, 0x2                                 # 004d2c0f
    mov dword ptr [ebp - local_34], edx          # 004d2c12
    jmp.d8 L_004d2beb                            # 004d2c15
L_004d2c17:
    # block 0x004d2c17: entered by je at 0x004d2bba; jge at 0x004d2c00, 4 instruction(s), ends with ret
    mov eax, 0x63a8f0                            # 004d2c17
    {load} mov esp, ebp                          # 004d2c1c
    pop ebp                                      # 004d2c1e
    ret                                          # 004d2c1f

