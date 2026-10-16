# FUN_004f2710
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f2710
# extent:       0x004f2710-0x004f3415 (3333 code bytes)
# span:         0x004f2710-0x004f3415 (code 3333, tables 0, padding 0)
# sha256:       474a1899054e467d8603f6403f39fc94665553060a1d1634dcbc7d08ffa2c91f
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f2710
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_18, field_194, field_198, field_19c, field_1a0, field_1a8, field_1ac, field_1bc and 18 more; [ecx + n] field_4, field_8, field_38, field_194, field_198, field_19c, field_1a4, field_1a8, field_1b8, field_1c8, field_1f0, field_208 and 19 more; [edx + n] field_8, field_10, field_190, field_194, field_198, field_1a8, field_1b0, field_1c4, field_1ec, field_1f8, field_208, field_210 and 18 more
# callees:      calls FUN_004f709c, FUN_004f83c8, FUN_004fceca, FUN_0044a2b7, FUN_0050ca3e, FUN_004f8364, FUN_004f80d3, FUN_004f84a6, FUN_004f8a66, KERNEL32.dll!CreateEventA, binkw32.dll!_BinkSetSoundSystem@8; plus 7 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 798 instruction(s), 38 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18
.equ field_38, 0x38  # offset +0x38
.equ field_190, 0x190  # offset +0x190
.equ field_194, 0x194  # offset +0x194
.equ field_198, 0x198  # offset +0x198
.equ field_19c, 0x19c  # offset +0x19c
.equ field_1a0, 0x1a0  # offset +0x1a0
.equ field_1a4, 0x1a4  # offset +0x1a4
.equ field_1a8, 0x1a8  # offset +0x1a8
.equ field_1ac, 0x1ac  # offset +0x1ac
.equ field_1b0, 0x1b0  # offset +0x1b0
.equ field_1b8, 0x1b8  # offset +0x1b8
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1e8, 0x1e8  # offset +0x1e8
.equ field_1ec, 0x1ec  # offset +0x1ec
.equ field_1f0, 0x1f0  # offset +0x1f0
.equ field_1f4, 0x1f4  # offset +0x1f4
.equ field_1f8, 0x1f8  # offset +0x1f8
.equ field_208, 0x208  # offset +0x208
.equ field_20c, 0x20c  # offset +0x20c
.equ field_210, 0x210  # offset +0x210
.equ field_214, 0x214  # offset +0x214
.equ field_218, 0x218  # offset +0x218
.equ field_21c, 0x21c  # offset +0x21c
.equ field_220, 0x220  # offset +0x220
.equ field_228, 0x228  # offset +0x228
.equ field_23c, 0x23c  # offset +0x23c
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_254, 0x254  # offset +0x254
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_264, 0x264  # offset +0x264
.equ field_268, 0x268  # offset +0x268
.equ field_26c, 0x26c  # offset +0x26c
.equ field_270, 0x270  # offset +0x270
.equ field_274, 0x274  # offset +0x274
.equ field_278, 0x278  # offset +0x278
.equ field_288, 0x288  # offset +0x288
.equ field_28a, 0x28a  # offset +0x28a
.equ field_28c, 0x28c  # offset +0x28c
.equ field_290, 0x290  # offset +0x290
.equ field_294, 0x294  # offset +0x294
.equ field_296, 0x296  # offset +0x296
.equ field_2ba, 0x2ba  # offset +0x2ba
.equ field_2f1, 0x2f1  # offset +0x2f1
.equ field_3ba, 0x3ba  # offset +0x3ba
.equ field_3be, 0x3be  # offset +0x3be
.equ field_3c2, 0x3c2  # offset +0x3c2
.equ field_3ca, 0x3ca  # offset +0x3ca
.equ field_3ce, 0x3ce  # offset +0x3ce
.equ field_436, 0x436  # offset +0x436
.equ field_43a, 0x43a  # offset +0x43a
.equ field_43e, 0x43e  # offset +0x43e
.equ field_442, 0x442  # offset +0x442

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f709c, .text + (0x004f709c - 0x401000)
.set FUN_004f80d3, .text + (0x004f80d3 - 0x401000)
.set FUN_004f8364, .text + (0x004f8364 - 0x401000)
.set FUN_004f83c8, .text + (0x004f83c8 - 0x401000)
.set FUN_004f84a6, .text + (0x004f84a6 - 0x401000)
.set FUN_004f8a66, .text + (0x004f8a66 - 0x401000)
.set FUN_004fceca, .text + (0x004fceca - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004f2710 - 0x401000
.globl FUN_004f2710
FUN_004f2710:
    # block 0x004f2710: entry, 15 instruction(s), calls FUN_004f709c, ends with je to 0x004f2775 (forward)
    push ebp                                     # 004f2710
    {load} mov ebp, esp                          # 004f2711
    sub esp, 0x8                                 # 004f2713
    push edi                                     # 004f2716
    mov dword ptr [ebp - local_8], ecx           # 004f2717
    mov eax, dword ptr [ebp - local_8]           # 004f271a
    mov dword ptr [eax + field_3be], 0x1         # 004f271d
    mov ecx, dword ptr [ebp - local_8]           # 004f2727
    mov dword ptr [ecx + field_3c2], 0x3e8       # 004f272a
    mov edx, dword ptr [ebp - local_8]           # 004f2734
    mov dword ptr [edx + field_3ca], 0x0         # 004f2737
    mov ecx, dword ptr [ebp - local_8]           # 004f2741
    call FUN_004f709c                            # 004f2744
    test eax, eax                                # 004f2749
    je.d8 L_004f2775                             # 004f274b
    # block 0x004f274d: entered by fall-through of je at 0x004f274b, 7 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f274d
    mov dword ptr [eax + field_3c2], 0x3e9       # 004f2750
    mov ecx, dword ptr [ebp - local_8]           # 004f275a
    mov dword ptr [ecx + field_3be], 0x0         # 004f275d
    mov edx, dword ptr [ebp - local_8]           # 004f2767
    mov eax, dword ptr [edx + field_3be]         # 004f276a
    jmp.d32 L_004f340e                           # 004f2770
L_004f2775:
    # block 0x004f2775: entered by je at 0x004f274b, 2 instruction(s), ends with jne to 0x004f27a3 (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 004f2775
    jne.d8 L_004f27a3                            # 004f2779
    # block 0x004f277b: entered by fall-through of jne at 0x004f2779, 7 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f277b
    mov dword ptr [eax + field_3c2], 0x3f0       # 004f277e
    mov ecx, dword ptr [ebp - local_8]           # 004f2788
    mov dword ptr [ecx + field_3be], 0x0         # 004f278b
    mov edx, dword ptr [ebp - local_8]           # 004f2795
    mov eax, dword ptr [edx + field_3be]         # 004f2798
    jmp.d32 L_004f340e                           # 004f279e
L_004f27a3:
    # block 0x004f27a3: entered by jne at 0x004f2779, 10 instruction(s), calls FUN_004f83c8, ends with jne to 0x004f27ef (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f27a3
    mov ecx, dword ptr [ebp + arg_8]             # 004f27a6
    mov dword ptr [eax + field_3ba], ecx         # 004f27a9
    mov edx, dword ptr [ebp - local_8]           # 004f27af
    mov eax, dword ptr [ebp + arg_c]             # 004f27b2
    mov dword ptr [edx + field_3ce], eax         # 004f27b5
    mov ecx, dword ptr [ebp - local_8]           # 004f27bb
    call FUN_004f83c8                            # 004f27be
    test eax, eax                                # 004f27c3
    jne.d8 L_004f27ef                            # 004f27c5
    # block 0x004f27c7: entered by fall-through of jne at 0x004f27c5, 7 instruction(s), ends with forward jump to 0x004f340e
    mov ecx, dword ptr [ebp - local_8]           # 004f27c7
    mov dword ptr [ecx + field_3c2], 0x3fa       # 004f27ca
    mov edx, dword ptr [ebp - local_8]           # 004f27d4
    mov dword ptr [edx + field_3be], 0x0         # 004f27d7
    mov eax, dword ptr [ebp - local_8]           # 004f27e1
    mov eax, dword ptr [eax + field_3be]         # 004f27e4
    jmp.d32 L_004f340e                           # 004f27ea
L_004f27ef:
    # block 0x004f27ef: entered by jne at 0x004f27c5, 13 instruction(s), calls FUN_004fceca, ends with je to 0x004f2854 (forward)
    push 0x0                                     # 004f27ef
    mov ecx, dword ptr [ebp - local_8]           # 004f27f1
    add ecx, 0x194                               # 004f27f4
    push ecx                                     # 004f27fa
    mov edx, dword ptr [ebp - local_8]           # 004f27fb
    mov eax, dword ptr [edx + field_190]         # 004f27fe
    push eax                                     # 004f2804
    call FUN_004fceca                            # 004f2805
    mov ecx, dword ptr [ebp - local_8]           # 004f280a
    mov dword ptr [ecx + field_3ca], eax         # 004f280d
    mov edx, dword ptr [ebp - local_8]           # 004f2813
    cmp dword ptr [edx + field_3ca], 0x0         # 004f2816
    je.d8 L_004f2854                             # 004f281d
    # block 0x004f281f: entered by fall-through of je at 0x004f281d, 9 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f281f
    mov dword ptr [eax + field_194], 0x0         # 004f2822
    mov ecx, dword ptr [ebp - local_8]           # 004f282c
    mov dword ptr [ecx + field_3c2], 0x3fb       # 004f282f
    mov edx, dword ptr [ebp - local_8]           # 004f2839
    mov dword ptr [edx + field_3be], 0x0         # 004f283c
    mov eax, dword ptr [ebp - local_8]           # 004f2846
    mov eax, dword ptr [eax + field_3be]         # 004f2849
    jmp.d32 L_004f340e                           # 004f284f
L_004f2854:
    # block 0x004f2854: entered by je at 0x004f281d, 3 instruction(s), ends with je to 0x004f286c (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f2854
    test ecx, ecx                                # 004f285b
    je.d8 L_004f286c                             # 004f285d
    # block 0x004f285f: entered by fall-through of je at 0x004f285d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f286c
    push 0x55cf44                                # 004f285f
    call FUN_0044a2b7                            # 004f2864
    add esp, 0x4                                 # 004f2869
L_004f286c:
    # block 0x004f286c: entered by je at 0x004f285d, 16 instruction(s), calls indirect dword ptr [eax + 0x18], ends with je to 0x004f28cd (forward)
    push 0x2                                     # 004f286c
    mov edx, dword ptr [ebp - local_8]           # 004f286e
    mov eax, dword ptr [edx + field_3ba]         # 004f2871
    push eax                                     # 004f2877
    mov ecx, dword ptr [ebp - local_8]           # 004f2878
    mov edx, dword ptr [ecx + field_194]         # 004f287b
    mov eax, dword ptr [ebp - local_8]           # 004f2881
    mov ecx, dword ptr [eax + field_194]         # 004f2884
    mov eax, dword ptr [ecx]                     # 004f288a
    push edx                                     # 004f288c
    call dword ptr [eax + field_18]              # 004f288d
    mov ecx, dword ptr [ebp - local_8]           # 004f2890
    mov dword ptr [ecx + field_3ca], eax         # 004f2893
    mov edx, dword ptr [ebp - local_8]           # 004f2899
    cmp dword ptr [edx + field_3ca], 0x0         # 004f289c
    je.d8 L_004f28cd                             # 004f28a3
    # block 0x004f28a5: entered by fall-through of je at 0x004f28a3, 7 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f28a5
    mov dword ptr [eax + field_3c2], 0x3fc       # 004f28a8
    mov ecx, dword ptr [ebp - local_8]           # 004f28b2
    mov dword ptr [ecx + field_3be], 0x0         # 004f28b5
    mov edx, dword ptr [ebp - local_8]           # 004f28bf
    mov eax, dword ptr [edx + field_3be]         # 004f28c2
    jmp.d32 L_004f340e                           # 004f28c8
L_004f28cd:
    # block 0x004f28cd: entered by je at 0x004f28a3, 3 instruction(s), ends with je to 0x004f28e5 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f28cd
    test eax, eax                                # 004f28d4
    je.d8 L_004f28e5                             # 004f28d6
    # block 0x004f28d8: entered by fall-through of je at 0x004f28d6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f28e5
    push 0x55cf7c                                # 004f28d8
    call FUN_0044a2b7                            # 004f28dd
    add esp, 0x4                                 # 004f28e2
L_004f28e5:
    # block 0x004f28e5: entered by je at 0x004f28d6, 22 instruction(s), calls indirect dword ptr [edx + 0x10], ends with je to 0x004f2963 (forward)
    mov ecx, 0x18                                # 004f28e5
    {load} xor eax, eax                          # 004f28ea
    mov edi, dword ptr [ebp - local_8]           # 004f28ec
    add edi, 0x1a4                               # 004f28ef
    rep stosd dword ptr es:[edi], eax            # 004f28f5
    mov ecx, dword ptr [ebp - local_8]           # 004f28f7
    mov dword ptr [ecx + field_1a4], 0x60        # 004f28fa
    mov edx, dword ptr [ebp - local_8]           # 004f2904
    add edx, 0x1a4                               # 004f2907
    push edx                                     # 004f290d
    mov eax, dword ptr [ebp - local_8]           # 004f290e
    mov ecx, dword ptr [eax + field_194]         # 004f2911
    mov edx, dword ptr [ebp - local_8]           # 004f2917
    mov eax, dword ptr [edx + field_194]         # 004f291a
    mov edx, dword ptr [eax]                     # 004f2920
    push ecx                                     # 004f2922
    call dword ptr [edx + field_10]              # 004f2923
    mov ecx, dword ptr [ebp - local_8]           # 004f2926
    mov dword ptr [ecx + field_3ca], eax         # 004f2929
    mov edx, dword ptr [ebp - local_8]           # 004f292f
    cmp dword ptr [edx + field_3ca], 0x0         # 004f2932
    je.d8 L_004f2963                             # 004f2939
    # block 0x004f293b: entered by fall-through of je at 0x004f2939, 7 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f293b
    mov dword ptr [eax + field_3c2], 0x3fd       # 004f293e
    mov ecx, dword ptr [ebp - local_8]           # 004f2948
    mov dword ptr [ecx + field_3be], 0x0         # 004f294b
    mov edx, dword ptr [ebp - local_8]           # 004f2955
    mov eax, dword ptr [edx + field_3be]         # 004f2958
    jmp.d32 L_004f340e                           # 004f295e
L_004f2963:
    # block 0x004f2963: entered by je at 0x004f2939, 3 instruction(s), ends with je to 0x004f2c62 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004f2963
    test eax, eax                                # 004f296a
    je.d32 L_004f2c62                            # 004f296c
    # block 0x004f2972: entered by fall-through of je at 0x004f296c, 5 instruction(s), ends with je to 0x004f298f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f2972
    mov edx, dword ptr [ecx + field_1a8]         # 004f2975
    and edx, 0x40                                # 004f297b
    test edx, edx                                # 004f297e
    je.d8 L_004f298f                             # 004f2980
    # block 0x004f2982: entered by fall-through of je at 0x004f2980, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f298f
    push 0x55cfb8                                # 004f2982
    call FUN_0044a2b7                            # 004f2987
    add esp, 0x4                                 # 004f298c
L_004f298f:
    # block 0x004f298f: entered by je at 0x004f2980, 5 instruction(s), ends with je to 0x004f29ac (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f298f
    mov ecx, dword ptr [eax + field_1a8]         # 004f2992
    and ecx, 0x20                                # 004f2998
    test ecx, ecx                                # 004f299b
    je.d8 L_004f29ac                             # 004f299d
    # block 0x004f299f: entered by fall-through of je at 0x004f299d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f29ac
    push 0x55cff0                                # 004f299f
    call FUN_0044a2b7                            # 004f29a4
    add esp, 0x4                                 # 004f29a9
L_004f29ac:
    # block 0x004f29ac: entered by je at 0x004f299d, 5 instruction(s), ends with je to 0x004f29c9 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f29ac
    mov eax, dword ptr [edx + field_1a8]         # 004f29af
    and eax, 0x4                                 # 004f29b5
    test eax, eax                                # 004f29b8
    je.d8 L_004f29c9                             # 004f29ba
    # block 0x004f29bc: entered by fall-through of je at 0x004f29ba, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f29c9
    push 0x55d02c                                # 004f29bc
    call FUN_0044a2b7                            # 004f29c1
    add esp, 0x4                                 # 004f29c6
L_004f29c9:
    # block 0x004f29c9: entered by je at 0x004f29ba, 5 instruction(s), ends with je to 0x004f29e6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f29c9
    mov edx, dword ptr [ecx + field_1a8]         # 004f29cc
    and edx, 0x8                                 # 004f29d2
    test edx, edx                                # 004f29d5
    je.d8 L_004f29e6                             # 004f29d7
    # block 0x004f29d9: entered by fall-through of je at 0x004f29d7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f29e6
    push 0x55d068                                # 004f29d9
    call FUN_0044a2b7                            # 004f29de
    add esp, 0x4                                 # 004f29e3
L_004f29e6:
    # block 0x004f29e6: entered by je at 0x004f29d7, 5 instruction(s), ends with je to 0x004f2a03 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f29e6
    mov ecx, dword ptr [eax + field_1a8]         # 004f29e9
    and ecx, 0x1                                 # 004f29ef
    test ecx, ecx                                # 004f29f2
    je.d8 L_004f2a03                             # 004f29f4
    # block 0x004f29f6: entered by fall-through of je at 0x004f29f4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2a03
    push 0x55d0a4                                # 004f29f6
    call FUN_0044a2b7                            # 004f29fb
    add esp, 0x4                                 # 004f2a00
L_004f2a03:
    # block 0x004f2a03: entered by je at 0x004f29f4, 5 instruction(s), ends with je to 0x004f2a20 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f2a03
    mov eax, dword ptr [edx + field_1a8]         # 004f2a06
    and eax, 0x2                                 # 004f2a0c
    test eax, eax                                # 004f2a0f
    je.d8 L_004f2a20                             # 004f2a11
    # block 0x004f2a13: entered by fall-through of je at 0x004f2a11, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2a20
    push 0x55d0e0                                # 004f2a13
    call FUN_0044a2b7                            # 004f2a18
    add esp, 0x4                                 # 004f2a1d
L_004f2a20:
    # block 0x004f2a20: entered by je at 0x004f2a11, 5 instruction(s), ends with je to 0x004f2a40 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f2a20
    mov edx, dword ptr [ecx + field_1a8]         # 004f2a23
    and edx, 0x800                               # 004f2a29
    test edx, edx                                # 004f2a2f
    je.d8 L_004f2a40                             # 004f2a31
    # block 0x004f2a33: entered by fall-through of je at 0x004f2a31, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2a40
    push 0x55d11c                                # 004f2a33
    call FUN_0044a2b7                            # 004f2a38
    add esp, 0x4                                 # 004f2a3d
L_004f2a40:
    # block 0x004f2a40: entered by je at 0x004f2a31, 5 instruction(s), ends with je to 0x004f2a60 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f2a40
    mov ecx, dword ptr [eax + field_1a8]         # 004f2a43
    and ecx, 0x400                               # 004f2a49
    test ecx, ecx                                # 004f2a4f
    je.d8 L_004f2a60                             # 004f2a51
    # block 0x004f2a53: entered by fall-through of je at 0x004f2a51, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2a60
    push 0x55d15c                                # 004f2a53
    call FUN_0044a2b7                            # 004f2a58
    add esp, 0x4                                 # 004f2a5d
L_004f2a60:
    # block 0x004f2a60: entered by je at 0x004f2a51, 5 instruction(s), ends with je to 0x004f2a7f (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f2a60
    mov eax, dword ptr [edx + field_1a8]         # 004f2a63
    and eax, 0x100                               # 004f2a69
    test eax, eax                                # 004f2a6e
    je.d8 L_004f2a7f                             # 004f2a70
    # block 0x004f2a72: entered by fall-through of je at 0x004f2a70, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2a7f
    push 0x55d198                                # 004f2a72
    call FUN_0044a2b7                            # 004f2a77
    add esp, 0x4                                 # 004f2a7c
L_004f2a7f:
    # block 0x004f2a7f: entered by je at 0x004f2a70, 5 instruction(s), ends with je to 0x004f2a9f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f2a7f
    mov edx, dword ptr [ecx + field_1a8]         # 004f2a82
    and edx, 0x200                               # 004f2a88
    test edx, edx                                # 004f2a8e
    je.d8 L_004f2a9f                             # 004f2a90
    # block 0x004f2a92: entered by fall-through of je at 0x004f2a90, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2a9f
    push 0x55d1d4                                # 004f2a92
    call FUN_0044a2b7                            # 004f2a97
    add esp, 0x4                                 # 004f2a9c
L_004f2a9f:
    # block 0x004f2a9f: entered by je at 0x004f2a90, 110 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f2c62
    mov eax, dword ptr [ebp - local_8]           # 004f2a9f
    mov ecx, dword ptr [eax + field_1ac]         # 004f2aa2
    push ecx                                     # 004f2aa8
    push 0x55d214                                # 004f2aa9
    push 0x63888b                                # 004f2aae
    call FUN_0050ca3e                            # 004f2ab3
    add esp, 0xc                                 # 004f2ab8
    push 0x63888b                                # 004f2abb
    call FUN_0044a2b7                            # 004f2ac0
    add esp, 0x4                                 # 004f2ac5
    mov edx, dword ptr [ebp - local_8]           # 004f2ac8
    mov eax, dword ptr [edx + field_1b0]         # 004f2acb
    push eax                                     # 004f2ad1
    push 0x55d25c                                # 004f2ad2
    push 0x63888b                                # 004f2ad7
    call FUN_0050ca3e                            # 004f2adc
    add esp, 0xc                                 # 004f2ae1
    push 0x63888b                                # 004f2ae4
    call FUN_0044a2b7                            # 004f2ae9
    add esp, 0x4                                 # 004f2aee
    mov ecx, dword ptr [ebp - local_8]           # 004f2af1
    mov edx, dword ptr [ecx + field_1b8]         # 004f2af4
    push edx                                     # 004f2afa
    push 0x55d2a4                                # 004f2afb
    push 0x63888b                                # 004f2b00
    call FUN_0050ca3e                            # 004f2b05
    add esp, 0xc                                 # 004f2b0a
    push 0x63888b                                # 004f2b0d
    call FUN_0044a2b7                            # 004f2b12
    add esp, 0x4                                 # 004f2b17
    mov eax, dword ptr [ebp - local_8]           # 004f2b1a
    mov ecx, dword ptr [eax + field_1bc]         # 004f2b1d
    push ecx                                     # 004f2b23
    push 0x55d2e8                                # 004f2b24
    push 0x63888b                                # 004f2b29
    call FUN_0050ca3e                            # 004f2b2e
    add esp, 0xc                                 # 004f2b33
    push 0x63888b                                # 004f2b36
    call FUN_0044a2b7                            # 004f2b3b
    add esp, 0x4                                 # 004f2b40
    mov edx, dword ptr [ebp - local_8]           # 004f2b43
    mov eax, dword ptr [edx + field_1c4]         # 004f2b46
    push eax                                     # 004f2b4c
    push 0x55d330                                # 004f2b4d
    push 0x63888b                                # 004f2b52
    call FUN_0050ca3e                            # 004f2b57
    add esp, 0xc                                 # 004f2b5c
    push 0x63888b                                # 004f2b5f
    call FUN_0044a2b7                            # 004f2b64
    add esp, 0x4                                 # 004f2b69
    mov ecx, dword ptr [ebp - local_8]           # 004f2b6c
    mov edx, dword ptr [ecx + field_1c8]         # 004f2b6f
    push edx                                     # 004f2b75
    push 0x55d378                                # 004f2b76
    push 0x63888b                                # 004f2b7b
    call FUN_0050ca3e                            # 004f2b80
    add esp, 0xc                                 # 004f2b85
    push 0x63888b                                # 004f2b88
    call FUN_0044a2b7                            # 004f2b8d
    add esp, 0x4                                 # 004f2b92
    mov eax, dword ptr [ebp - local_8]           # 004f2b95
    mov ecx, dword ptr [eax + field_1e8]         # 004f2b98
    push ecx                                     # 004f2b9e
    push 0x55d3c0                                # 004f2b9f
    push 0x63888b                                # 004f2ba4
    call FUN_0050ca3e                            # 004f2ba9
    add esp, 0xc                                 # 004f2bae
    push 0x63888b                                # 004f2bb1
    call FUN_0044a2b7                            # 004f2bb6
    add esp, 0x4                                 # 004f2bbb
    mov edx, dword ptr [ebp - local_8]           # 004f2bbe
    mov eax, dword ptr [edx + field_1ec]         # 004f2bc1
    push eax                                     # 004f2bc7
    push 0x55d400                                # 004f2bc8
    push 0x63888b                                # 004f2bcd
    call FUN_0050ca3e                            # 004f2bd2
    add esp, 0xc                                 # 004f2bd7
    push 0x63888b                                # 004f2bda
    call FUN_0044a2b7                            # 004f2bdf
    add esp, 0x4                                 # 004f2be4
    mov ecx, dword ptr [ebp - local_8]           # 004f2be7
    mov edx, dword ptr [ecx + field_1f0]         # 004f2bea
    push edx                                     # 004f2bf0
    push 0x55d440                                # 004f2bf1
    push 0x63888b                                # 004f2bf6
    call FUN_0050ca3e                            # 004f2bfb
    add esp, 0xc                                 # 004f2c00
    push 0x63888b                                # 004f2c03
    call FUN_0044a2b7                            # 004f2c08
    add esp, 0x4                                 # 004f2c0d
    mov eax, dword ptr [ebp - local_8]           # 004f2c10
    mov ecx, dword ptr [eax + field_1f4]         # 004f2c13
    push ecx                                     # 004f2c19
    push 0x55d488                                # 004f2c1a
    push 0x63888b                                # 004f2c1f
    call FUN_0050ca3e                            # 004f2c24
    add esp, 0xc                                 # 004f2c29
    push 0x63888b                                # 004f2c2c
    call FUN_0044a2b7                            # 004f2c31
    add esp, 0x4                                 # 004f2c36
    mov edx, dword ptr [ebp - local_8]           # 004f2c39
    mov eax, dword ptr [edx + field_1f8]         # 004f2c3c
    push eax                                     # 004f2c42
    push 0x55d4d4                                # 004f2c43
    push 0x63888b                                # 004f2c48
    call FUN_0050ca3e                            # 004f2c4d
    add esp, 0xc                                 # 004f2c52
    push 0x63888b                                # 004f2c55
    call FUN_0044a2b7                            # 004f2c5a
    add esp, 0x4                                 # 004f2c5f
L_004f2c62:
    # block 0x004f2c62: entered by je at 0x004f296c, 32 instruction(s), calls indirect dword ptr [eax + 0xc], ends with je to 0x004f2d1f (forward)
    mov ecx, 0x9                                 # 004f2c62
    {load} xor eax, eax                          # 004f2c67
    mov edi, dword ptr [ebp - local_8]           # 004f2c69
    add edi, 0x218                               # 004f2c6c
    rep stosd dword ptr es:[edi], eax            # 004f2c72
    mov ecx, dword ptr [ebp - local_8]           # 004f2c74
    mov dword ptr [ecx + field_218], 0x24        # 004f2c77
    mov edx, dword ptr [ebp - local_8]           # 004f2c81
    mov dword ptr [edx + field_21c], 0x11        # 004f2c84
    mov eax, dword ptr [ebp - local_8]           # 004f2c8e
    mov dword ptr [eax + field_220], 0x0         # 004f2c91
    mov ecx, dword ptr [ebp - local_8]           # 004f2c9b
    mov dword ptr [ecx + field_228], 0x0         # 004f2c9e
    push 0x0                                     # 004f2ca8
    mov edx, dword ptr [ebp - local_8]           # 004f2caa
    add edx, 0x198                               # 004f2cad
    push edx                                     # 004f2cb3
    mov eax, dword ptr [ebp - local_8]           # 004f2cb4
    add eax, 0x218                               # 004f2cb7
    push eax                                     # 004f2cbc
    mov ecx, dword ptr [ebp - local_8]           # 004f2cbd
    mov edx, dword ptr [ecx + field_194]         # 004f2cc0
    mov eax, dword ptr [ebp - local_8]           # 004f2cc6
    mov ecx, dword ptr [eax + field_194]         # 004f2cc9
    mov eax, dword ptr [ecx]                     # 004f2ccf
    push edx                                     # 004f2cd1
    call dword ptr [eax + field_c]               # 004f2cd2
    mov ecx, dword ptr [ebp - local_8]           # 004f2cd5
    mov dword ptr [ecx + field_3ca], eax         # 004f2cd8
    mov edx, dword ptr [ebp - local_8]           # 004f2cde
    cmp dword ptr [edx + field_3ca], 0x0         # 004f2ce1
    je.d8 L_004f2d1f                             # 004f2ce8
    # block 0x004f2cea: entered by fall-through of je at 0x004f2ce8, 9 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f2cea
    mov dword ptr [eax + field_198], 0x0         # 004f2ced
    mov ecx, dword ptr [ebp - local_8]           # 004f2cf7
    mov dword ptr [ecx + field_3c2], 0x3ff       # 004f2cfa
    mov edx, dword ptr [ebp - local_8]           # 004f2d04
    mov dword ptr [edx + field_3be], 0x0         # 004f2d07
    mov eax, dword ptr [ebp - local_8]           # 004f2d11
    mov eax, dword ptr [eax + field_3be]         # 004f2d14
    jmp.d32 L_004f340e                           # 004f2d1a
L_004f2d1f:
    # block 0x004f2d1f: entered by je at 0x004f2ce8, 3 instruction(s), ends with je to 0x004f2d37 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f2d1f
    test ecx, ecx                                # 004f2d26
    je.d8 L_004f2d37                             # 004f2d28
    # block 0x004f2d2a: entered by fall-through of je at 0x004f2d28, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2d37
    push 0x55d51c                                # 004f2d2a
    call FUN_0044a2b7                            # 004f2d2f
    add esp, 0x4                                 # 004f2d34
L_004f2d37:
    # block 0x004f2d37: entered by je at 0x004f2d28, 52 instruction(s), calls indirect dword ptr [ecx + 0x38], ends with je to 0x004f2e2f (forward)
    {load} xor edx, edx                          # 004f2d37
    mov eax, dword ptr [ebp - local_8]           # 004f2d39
    add eax, 0x288                               # 004f2d3c
    mov dword ptr [eax], edx                     # 004f2d41
    mov dword ptr [eax + field_4], edx           # 004f2d43
    mov dword ptr [eax + field_8], edx           # 004f2d46
    mov dword ptr [eax + field_c], edx           # 004f2d49
    mov word ptr [eax + field_10], dx            # 004f2d4c
    mov ecx, dword ptr [ebp - local_8]           # 004f2d50
    mov word ptr [ecx + field_288], 0x1          # 004f2d53
    mov edx, dword ptr [ebp - local_8]           # 004f2d5c
    mov word ptr [edx + field_28a], 0x2          # 004f2d5f
    mov eax, dword ptr [ebp - local_8]           # 004f2d68
    mov dword ptr [eax + field_28c], 0xac44      # 004f2d6b
    mov ecx, dword ptr [ebp - local_8]           # 004f2d75
    mov word ptr [ecx + field_296], 0x10         # 004f2d78
    mov edx, dword ptr [ebp - local_8]           # 004f2d81
    {load} xor eax, eax                          # 004f2d84
    mov ax, word ptr [edx + field_296]           # 004f2d86
    cdq                                          # 004f2d8d
    and edx, 0x7                                 # 004f2d8e
    {load} add eax, edx                          # 004f2d91
    sar eax, 0x3                                 # 004f2d93
    mov ecx, dword ptr [ebp - local_8]           # 004f2d96
    {load} xor edx, edx                          # 004f2d99
    mov dx, word ptr [ecx + field_28a]           # 004f2d9b
    imul eax, edx                                # 004f2da2
    mov ecx, dword ptr [ebp - local_8]           # 004f2da5
    mov word ptr [ecx + field_294], ax           # 004f2da8
    mov edx, dword ptr [ebp - local_8]           # 004f2daf
    {load} xor eax, eax                          # 004f2db2
    mov ax, word ptr [edx + field_294]           # 004f2db4
    mov ecx, dword ptr [ebp - local_8]           # 004f2dbb
    mov edx, dword ptr [ecx + field_28c]         # 004f2dbe
    imul edx, eax                                # 004f2dc4
    mov eax, dword ptr [ebp - local_8]           # 004f2dc7
    mov dword ptr [eax + field_290], edx         # 004f2dca
    mov ecx, dword ptr [ebp - local_8]           # 004f2dd0
    add ecx, 0x288                               # 004f2dd3
    push ecx                                     # 004f2dd9
    mov edx, dword ptr [ebp - local_8]           # 004f2dda
    mov eax, dword ptr [edx + field_198]         # 004f2ddd
    mov ecx, dword ptr [ebp - local_8]           # 004f2de3
    mov edx, dword ptr [ecx + field_198]         # 004f2de6
    mov ecx, dword ptr [edx]                     # 004f2dec
    push eax                                     # 004f2dee
    call dword ptr [ecx + field_38]              # 004f2def
    mov edx, dword ptr [ebp - local_8]           # 004f2df2
    mov dword ptr [edx + field_3ca], eax         # 004f2df5
    mov eax, dword ptr [ebp - local_8]           # 004f2dfb
    cmp dword ptr [eax + field_3ca], 0x0         # 004f2dfe
    je.d8 L_004f2e2f                             # 004f2e05
    # block 0x004f2e07: entered by fall-through of je at 0x004f2e05, 7 instruction(s), ends with forward jump to 0x004f340e
    mov ecx, dword ptr [ebp - local_8]           # 004f2e07
    mov dword ptr [ecx + field_3c2], 0x400       # 004f2e0a
    mov edx, dword ptr [ebp - local_8]           # 004f2e14
    mov dword ptr [edx + field_3be], 0x0         # 004f2e17
    mov eax, dword ptr [ebp - local_8]           # 004f2e21
    mov eax, dword ptr [eax + field_3be]         # 004f2e24
    jmp.d32 L_004f340e                           # 004f2e2a
L_004f2e2f:
    # block 0x004f2e2f: entered by je at 0x004f2e05, 3 instruction(s), ends with je to 0x004f2e47 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f2e2f
    test ecx, ecx                                # 004f2e36
    je.d8 L_004f2e47                             # 004f2e38
    # block 0x004f2e3a: entered by fall-through of je at 0x004f2e38, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2e47
    push 0x55d560                                # 004f2e3a
    call FUN_0044a2b7                            # 004f2e3f
    add esp, 0x4                                 # 004f2e44
L_004f2e47:
    # block 0x004f2e47: entered by je at 0x004f2e38, 10 instruction(s), calls FUN_004f8364, ends with jne to 0x004f2e8f (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f2e47
    add edx, 0x204                               # 004f2e4a
    push edx                                     # 004f2e50
    mov eax, dword ptr [ebp - local_8]           # 004f2e51
    mov ecx, dword ptr [eax + field_198]         # 004f2e54
    push ecx                                     # 004f2e5a
    mov ecx, dword ptr [ebp - local_8]           # 004f2e5b
    call FUN_004f8364                            # 004f2e5e
    test eax, eax                                # 004f2e63
    jne.d8 L_004f2e8f                            # 004f2e65
    # block 0x004f2e67: entered by fall-through of jne at 0x004f2e65, 7 instruction(s), ends with forward jump to 0x004f340e
    mov edx, dword ptr [ebp - local_8]           # 004f2e67
    mov dword ptr [edx + field_3c2], 0x401       # 004f2e6a
    mov eax, dword ptr [ebp - local_8]           # 004f2e74
    mov dword ptr [eax + field_3be], 0x0         # 004f2e77
    mov ecx, dword ptr [ebp - local_8]           # 004f2e81
    mov eax, dword ptr [ecx + field_3be]         # 004f2e84
    jmp.d32 L_004f340e                           # 004f2e8a
L_004f2e8f:
    # block 0x004f2e8f: entered by jne at 0x004f2e65, 3 instruction(s), ends with je to 0x004f2f70 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f2e8f
    test edx, edx                                # 004f2e96
    je.d32 L_004f2f70                            # 004f2e98
    # block 0x004f2e9e: entered by fall-through of je at 0x004f2e98, 5 instruction(s), ends with je to 0x004f2ebb (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f2e9e
    mov ecx, dword ptr [eax + field_208]         # 004f2ea1
    and ecx, 0x4                                 # 004f2ea7
    test ecx, ecx                                # 004f2eaa
    je.d8 L_004f2ebb                             # 004f2eac
    # block 0x004f2eae: entered by fall-through of je at 0x004f2eac, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2ebb
    push 0x55d5ac                                # 004f2eae
    call FUN_0044a2b7                            # 004f2eb3
    add esp, 0x4                                 # 004f2eb8
L_004f2ebb:
    # block 0x004f2ebb: entered by je at 0x004f2eac, 5 instruction(s), ends with je to 0x004f2ed8 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004f2ebb
    mov eax, dword ptr [edx + field_208]         # 004f2ebe
    and eax, 0x8                                 # 004f2ec4
    test eax, eax                                # 004f2ec7
    je.d8 L_004f2ed8                             # 004f2ec9
    # block 0x004f2ecb: entered by fall-through of je at 0x004f2ec9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2ed8
    push 0x55d5fc                                # 004f2ecb
    call FUN_0044a2b7                            # 004f2ed0
    add esp, 0x4                                 # 004f2ed5
L_004f2ed8:
    # block 0x004f2ed8: entered by je at 0x004f2ec9, 5 instruction(s), ends with je to 0x004f2ef5 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004f2ed8
    mov edx, dword ptr [ecx + field_208]         # 004f2edb
    and edx, 0x1                                 # 004f2ee1
    test edx, edx                                # 004f2ee4
    je.d8 L_004f2ef5                             # 004f2ee6
    # block 0x004f2ee8: entered by fall-through of je at 0x004f2ee6, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2ef5
    push 0x55d64c                                # 004f2ee8
    call FUN_0044a2b7                            # 004f2eed
    add esp, 0x4                                 # 004f2ef2
L_004f2ef5:
    # block 0x004f2ef5: entered by je at 0x004f2ee6, 30 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f2f70
    mov eax, dword ptr [ebp - local_8]           # 004f2ef5
    mov ecx, dword ptr [eax + field_20c]         # 004f2ef8
    push ecx                                     # 004f2efe
    push 0x55d69c                                # 004f2eff
    push 0x63888b                                # 004f2f04
    call FUN_0050ca3e                            # 004f2f09
    add esp, 0xc                                 # 004f2f0e
    push 0x63888b                                # 004f2f11
    call FUN_0044a2b7                            # 004f2f16
    add esp, 0x4                                 # 004f2f1b
    mov edx, dword ptr [ebp - local_8]           # 004f2f1e
    mov eax, dword ptr [edx + field_210]         # 004f2f21
    push eax                                     # 004f2f27
    push 0x55d6e8                                # 004f2f28
    push 0x63888b                                # 004f2f2d
    call FUN_0050ca3e                            # 004f2f32
    add esp, 0xc                                 # 004f2f37
    push 0x63888b                                # 004f2f3a
    call FUN_0044a2b7                            # 004f2f3f
    add esp, 0x4                                 # 004f2f44
    mov ecx, dword ptr [ebp - local_8]           # 004f2f47
    mov edx, dword ptr [ecx + field_214]         # 004f2f4a
    push edx                                     # 004f2f50
    push 0x55d73c                                # 004f2f51
    push 0x63888b                                # 004f2f56
    call FUN_0050ca3e                            # 004f2f5b
    add esp, 0xc                                 # 004f2f60
    push 0x63888b                                # 004f2f63
    call FUN_0044a2b7                            # 004f2f68
    add esp, 0x4                                 # 004f2f6d
L_004f2f70:
    # block 0x004f2f70: entered by je at 0x004f2e98, 8 instruction(s), calls FUN_004f80d3, ends with jne to 0x004f2fb0 (forward)
    push 0x1                                     # 004f2f70
    mov eax, dword ptr [ebp - local_8]           # 004f2f72
    mov ecx, dword ptr [eax + field_198]         # 004f2f75
    push ecx                                     # 004f2f7b
    mov ecx, dword ptr [ebp - local_8]           # 004f2f7c
    call FUN_004f80d3                            # 004f2f7f
    test eax, eax                                # 004f2f84
    jne.d8 L_004f2fb0                            # 004f2f86
    # block 0x004f2f88: entered by fall-through of jne at 0x004f2f86, 7 instruction(s), ends with forward jump to 0x004f340e
    mov edx, dword ptr [ebp - local_8]           # 004f2f88
    mov dword ptr [edx + field_3c2], 0x402       # 004f2f8b
    mov eax, dword ptr [ebp - local_8]           # 004f2f95
    mov dword ptr [eax + field_3be], 0x0         # 004f2f98
    mov ecx, dword ptr [ebp - local_8]           # 004f2fa2
    mov eax, dword ptr [ecx + field_3be]         # 004f2fa5
    jmp.d32 L_004f340e                           # 004f2fab
L_004f2fb0:
    # block 0x004f2fb0: entered by jne at 0x004f2f86, 3 instruction(s), ends with je to 0x004f2fc8 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f2fb0
    test edx, edx                                # 004f2fb7
    je.d8 L_004f2fc8                             # 004f2fb9
    # block 0x004f2fbb: entered by fall-through of je at 0x004f2fb9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f2fc8
    push 0x55d78c                                # 004f2fbb
    call FUN_0044a2b7                            # 004f2fc0
    add esp, 0x4                                 # 004f2fc5
L_004f2fc8:
    # block 0x004f2fc8: entered by je at 0x004f2fb9, 16 instruction(s), calls indirect dword ptr [eax], ends with je to 0x004f3037 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f2fc8
    add eax, 0x19c                               # 004f2fcb
    push eax                                     # 004f2fd0
    push 0x52e54c                                # 004f2fd1
    mov ecx, dword ptr [ebp - local_8]           # 004f2fd6
    mov edx, dword ptr [ecx + field_198]         # 004f2fd9
    mov eax, dword ptr [ebp - local_8]           # 004f2fdf
    mov ecx, dword ptr [eax + field_198]         # 004f2fe2
    mov eax, dword ptr [ecx]                     # 004f2fe8
    push edx                                     # 004f2fea
    call dword ptr [eax]                         # 004f2feb
    mov ecx, dword ptr [ebp - local_8]           # 004f2fed
    mov dword ptr [ecx + field_3ca], eax         # 004f2ff0
    mov edx, dword ptr [ebp - local_8]           # 004f2ff6
    cmp dword ptr [edx + field_3ca], 0x0         # 004f2ff9
    je.d8 L_004f3037                             # 004f3000
    # block 0x004f3002: entered by fall-through of je at 0x004f3000, 9 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f3002
    mov dword ptr [eax + field_19c], 0x0         # 004f3005
    mov ecx, dword ptr [ebp - local_8]           # 004f300f
    mov dword ptr [ecx + field_3c2], 0x415       # 004f3012
    mov edx, dword ptr [ebp - local_8]           # 004f301c
    mov dword ptr [edx + field_3be], 0x0         # 004f301f
    mov eax, dword ptr [ebp - local_8]           # 004f3029
    mov eax, dword ptr [eax + field_3be]         # 004f302c
    jmp.d32 L_004f340e                           # 004f3032
L_004f3037:
    # block 0x004f3037: entered by je at 0x004f3000, 3 instruction(s), ends with je to 0x004f304f (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004f3037
    test ecx, ecx                                # 004f303e
    je.d8 L_004f304f                             # 004f3040
    # block 0x004f3042: entered by fall-through of je at 0x004f3040, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f304f
    push 0x55d7d4                                # 004f3042
    call FUN_0044a2b7                            # 004f3047
    add esp, 0x4                                 # 004f304c
L_004f304f:
    # block 0x004f304f: entered by je at 0x004f3040, 28 instruction(s), calls FUN_004f84a6, FUN_004f8a66, indirect dword ptr [eax + 0xc], ends with je to 0x004f30e6 (forward)
    push 0x3f800000                              # 004f304f
    mov ecx, dword ptr [ebp - local_8]           # 004f3054
    call FUN_004f84a6                            # 004f3057
    push 0x3f800000                              # 004f305c
    mov ecx, dword ptr [ebp - local_8]           # 004f3061
    call FUN_004f8a66                            # 004f3064
    mov ecx, 0x10                                # 004f3069
    {load} xor eax, eax                          # 004f306e
    mov edi, dword ptr [ebp - local_8]           # 004f3070
    add edi, 0x23c                               # 004f3073
    rep stosd dword ptr es:[edi], eax            # 004f3079
    mov edx, dword ptr [ebp - local_8]           # 004f307b
    mov dword ptr [edx + field_23c], 0x40        # 004f307e
    mov eax, dword ptr [ebp - local_8]           # 004f3088
    add eax, 0x23c                               # 004f308b
    push eax                                     # 004f3090
    mov ecx, dword ptr [ebp - local_8]           # 004f3091
    mov edx, dword ptr [ecx + field_19c]         # 004f3094
    mov eax, dword ptr [ebp - local_8]           # 004f309a
    mov ecx, dword ptr [eax + field_19c]         # 004f309d
    mov eax, dword ptr [ecx]                     # 004f30a3
    push edx                                     # 004f30a5
    call dword ptr [eax + field_c]               # 004f30a6
    mov ecx, dword ptr [ebp - local_8]           # 004f30a9
    mov dword ptr [ecx + field_3ca], eax         # 004f30ac
    mov edx, dword ptr [ebp - local_8]           # 004f30b2
    cmp dword ptr [edx + field_3ca], 0x0         # 004f30b5
    je.d8 L_004f30e6                             # 004f30bc
    # block 0x004f30be: entered by fall-through of je at 0x004f30bc, 7 instruction(s), ends with forward jump to 0x004f340e
    mov eax, dword ptr [ebp - local_8]           # 004f30be
    mov dword ptr [eax + field_3c2], 0x416       # 004f30c1
    mov ecx, dword ptr [ebp - local_8]           # 004f30cb
    mov dword ptr [ecx + field_3be], 0x0         # 004f30ce
    mov edx, dword ptr [ebp - local_8]           # 004f30d8
    mov eax, dword ptr [edx + field_3be]         # 004f30db
    jmp.d32 L_004f340e                           # 004f30e1
L_004f30e6:
    # block 0x004f30e6: entered by je at 0x004f30bc, 13 instruction(s), ends with je to 0x004f32d0 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004f30e6
    add eax, 0x264                               # 004f30e9
    mov ecx, dword ptr [ebp - local_8]           # 004f30ee
    add ecx, 0x27c                               # 004f30f1
    mov edx, dword ptr [eax]                     # 004f30f7
    mov dword ptr [ecx], edx                     # 004f30f9
    mov edx, dword ptr [eax + field_4]           # 004f30fb
    mov dword ptr [ecx + field_4], edx           # 004f30fe
    mov eax, dword ptr [eax + field_8]           # 004f3101
    mov dword ptr [ecx + field_8], eax           # 004f3104
    movsx ecx, word ptr [0x63a4cd]               # 004f3107
    test ecx, ecx                                # 004f310e
    je.d32 L_004f32d0                            # 004f3110
    # block 0x004f3116: entered by fall-through of je at 0x004f3110, 109 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004f32d0
    mov edx, dword ptr [ebp - local_8]           # 004f3116
    fld dword ptr [edx + field_248]              # 004f3119
    sub esp, 0x8                                 # 004f311f
    fstp qword ptr [esp]                         # 004f3122
    mov eax, dword ptr [ebp - local_8]           # 004f3125
    fld dword ptr [eax + field_244]              # 004f3128
    sub esp, 0x8                                 # 004f312e
    fstp qword ptr [esp]                         # 004f3131
    mov ecx, dword ptr [ebp - local_8]           # 004f3134
    fld dword ptr [ecx + field_240]              # 004f3137
    sub esp, 0x8                                 # 004f313d
    fstp qword ptr [esp]                         # 004f3140
    push 0x55d810                                # 004f3143
    push 0x63888b                                # 004f3148
    call FUN_0050ca3e                            # 004f314d
    add esp, 0x20                                # 004f3152
    push 0x63888b                                # 004f3155
    call FUN_0044a2b7                            # 004f315a
    add esp, 0x4                                 # 004f315f
    mov edx, dword ptr [ebp - local_8]           # 004f3162
    fld dword ptr [edx + field_254]              # 004f3165
    sub esp, 0x8                                 # 004f316b
    fstp qword ptr [esp]                         # 004f316e
    mov eax, dword ptr [ebp - local_8]           # 004f3171
    fld dword ptr [eax + field_250]              # 004f3174
    sub esp, 0x8                                 # 004f317a
    fstp qword ptr [esp]                         # 004f317d
    mov ecx, dword ptr [ebp - local_8]           # 004f3180
    fld dword ptr [ecx + field_24c]              # 004f3183
    sub esp, 0x8                                 # 004f3189
    fstp qword ptr [esp]                         # 004f318c
    push 0x55d868                                # 004f318f
    push 0x63888b                                # 004f3194
    call FUN_0050ca3e                            # 004f3199
    add esp, 0x20                                # 004f319e
    push 0x63888b                                # 004f31a1
    call FUN_0044a2b7                            # 004f31a6
    add esp, 0x4                                 # 004f31ab
    mov edx, dword ptr [ebp - local_8]           # 004f31ae
    fld dword ptr [edx + field_260]              # 004f31b1
    sub esp, 0x8                                 # 004f31b7
    fstp qword ptr [esp]                         # 004f31ba
    mov eax, dword ptr [ebp - local_8]           # 004f31bd
    fld dword ptr [eax + field_25c]              # 004f31c0
    sub esp, 0x8                                 # 004f31c6
    fstp qword ptr [esp]                         # 004f31c9
    mov ecx, dword ptr [ebp - local_8]           # 004f31cc
    fld dword ptr [ecx + field_258]              # 004f31cf
    sub esp, 0x8                                 # 004f31d5
    fstp qword ptr [esp]                         # 004f31d8
    push 0x55d8c0                                # 004f31db
    push 0x63888b                                # 004f31e0
    call FUN_0050ca3e                            # 004f31e5
    add esp, 0x20                                # 004f31ea
    push 0x63888b                                # 004f31ed
    call FUN_0044a2b7                            # 004f31f2
    add esp, 0x4                                 # 004f31f7
    mov edx, dword ptr [ebp - local_8]           # 004f31fa
    fld dword ptr [edx + field_26c]              # 004f31fd
    sub esp, 0x8                                 # 004f3203
    fstp qword ptr [esp]                         # 004f3206
    mov eax, dword ptr [ebp - local_8]           # 004f3209
    fld dword ptr [eax + field_268]              # 004f320c
    sub esp, 0x8                                 # 004f3212
    fstp qword ptr [esp]                         # 004f3215
    mov ecx, dword ptr [ebp - local_8]           # 004f3218
    fld dword ptr [ecx + field_264]              # 004f321b
    sub esp, 0x8                                 # 004f3221
    fstp qword ptr [esp]                         # 004f3224
    push 0x55d91c                                # 004f3227
    push 0x63888b                                # 004f322c
    call FUN_0050ca3e                            # 004f3231
    add esp, 0x20                                # 004f3236
    push 0x63888b                                # 004f3239
    call FUN_0044a2b7                            # 004f323e
    add esp, 0x4                                 # 004f3243
    mov edx, dword ptr [ebp - local_8]           # 004f3246
    fld dword ptr [edx + field_270]              # 004f3249
    sub esp, 0x8                                 # 004f324f
    fstp qword ptr [esp]                         # 004f3252
    push 0x55d974                                # 004f3255
    push 0x63888b                                # 004f325a
    call FUN_0050ca3e                            # 004f325f
    add esp, 0x10                                # 004f3264
    push 0x63888b                                # 004f3267
    call FUN_0044a2b7                            # 004f326c
    add esp, 0x4                                 # 004f3271
    mov eax, dword ptr [ebp - local_8]           # 004f3274
    fld dword ptr [eax + field_274]              # 004f3277
    sub esp, 0x8                                 # 004f327d
    fstp qword ptr [esp]                         # 004f3280
    push 0x55d9bc                                # 004f3283
    push 0x63888b                                # 004f3288
    call FUN_0050ca3e                            # 004f328d
    add esp, 0x10                                # 004f3292
    push 0x63888b                                # 004f3295
    call FUN_0044a2b7                            # 004f329a
    add esp, 0x4                                 # 004f329f
    mov ecx, dword ptr [ebp - local_8]           # 004f32a2
    fld dword ptr [ecx + field_278]              # 004f32a5
    sub esp, 0x8                                 # 004f32ab
    fstp qword ptr [esp]                         # 004f32ae
    push 0x55da00                                # 004f32b1
    push 0x63888b                                # 004f32b6
    call FUN_0050ca3e                            # 004f32bb
    add esp, 0x10                                # 004f32c0
    push 0x63888b                                # 004f32c3
    call FUN_0044a2b7                            # 004f32c8
    add esp, 0x4                                 # 004f32cd
L_004f32d0:
    # block 0x004f32d0: entered by je at 0x004f3110, 2 instruction(s), ends with forward jump to 0x004f32e2
    mov dword ptr [ebp - local_4], 0x0           # 004f32d0
    jmp.d8 L_004f32e2                            # 004f32d7
L_004f32d9:
    # block 0x004f32d9: entered by jmp at 0x004f333b, 3 instruction(s), falls into the block at 0x004f32e2
    mov edx, dword ptr [ebp - local_4]           # 004f32d9
    add edx, 0x1                                 # 004f32dc
    mov dword ptr [ebp - local_4], edx           # 004f32df
L_004f32e2:
    # block 0x004f32e2: entered by jmp at 0x004f32d7, 2 instruction(s), ends with jge to 0x004f333d (forward)
    cmp dword ptr [ebp - local_4], 0x40          # 004f32e2
    jge.d8 L_004f333d                            # 004f32e6
    # block 0x004f32e8: entered by fall-through of jge at 0x004f32e6, 12 instruction(s), calls KERNEL32.dll!CreateEventA, ends with jne to 0x004f333b (forward)
    push 0x0                                     # 004f32e8
    push 0x0                                     # 004f32ea
    push 0x0                                     # 004f32ec
    push 0x0                                     # 004f32ee
    call dword ptr [0x52a254]                    # 004f32f0
    mov ecx, dword ptr [ebp - local_4]           # 004f32f6
    mov edx, dword ptr [ebp - local_8]           # 004f32f9
    mov dword ptr [edx + 4*ecx + field_2ba], eax # 004f32fc
    mov eax, dword ptr [ebp - local_4]           # 004f3303
    mov ecx, dword ptr [ebp - local_8]           # 004f3306
    cmp dword ptr [ecx + 4*eax + field_2ba], 0x0 # 004f3309
    jne.d8 L_004f333b                            # 004f3311
    # block 0x004f3313: entered by fall-through of jne at 0x004f3311, 7 instruction(s), ends with forward jump to 0x004f340e
    mov edx, dword ptr [ebp - local_8]           # 004f3313
    mov dword ptr [edx + field_3c2], 0x413       # 004f3316
    mov eax, dword ptr [ebp - local_8]           # 004f3320
    mov dword ptr [eax + field_3be], 0x0         # 004f3323
    mov ecx, dword ptr [ebp - local_8]           # 004f332d
    mov eax, dword ptr [ecx + field_3be]         # 004f3330
    jmp.d32 L_004f340e                           # 004f3336
L_004f333b:
    # block 0x004f333b: entered by jne at 0x004f3311, 1 instruction(s), ends with backward jump to 0x004f32d9
    jmp.d8 L_004f32d9                            # 004f333b
L_004f333d:
    # block 0x004f333d: entered by jge at 0x004f32e6, 3 instruction(s), ends with je to 0x004f3355 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004f333d
    test edx, edx                                # 004f3344
    je.d8 L_004f3355                             # 004f3346
    # block 0x004f3348: entered by fall-through of je at 0x004f3346, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004f3355
    push 0x55da44                                # 004f3348
    call FUN_0044a2b7                            # 004f334d
    add esp, 0x4                                 # 004f3352
L_004f3355:
    # block 0x004f3355: entered by je at 0x004f3346, 11 instruction(s), calls indirect dword ptr [edx + 0x8], ends with forward jump to 0x004f338c
    mov eax, dword ptr [ebp - local_8]           # 004f3355
    mov ecx, dword ptr [eax + field_198]         # 004f3358
    mov edx, dword ptr [ebp - local_8]           # 004f335e
    mov eax, dword ptr [edx + field_198]         # 004f3361
    mov edx, dword ptr [eax]                     # 004f3367
    push ecx                                     # 004f3369
    call dword ptr [edx + field_8]               # 004f336a
    mov eax, dword ptr [ebp - local_8]           # 004f336d
    mov dword ptr [eax + field_198], 0x0         # 004f3370
    mov dword ptr [ebp - local_4], 0x0           # 004f337a
    jmp.d8 L_004f338c                            # 004f3381
L_004f3383:
    # block 0x004f3383: entered by jmp at 0x004f33af, 3 instruction(s), falls into the block at 0x004f338c
    mov ecx, dword ptr [ebp - local_4]           # 004f3383
    add ecx, 0x1                                 # 004f3386
    mov dword ptr [ebp - local_4], ecx           # 004f3389
L_004f338c:
    # block 0x004f338c: entered by jmp at 0x004f3381, 2 instruction(s), ends with jge to 0x004f33b1 (forward)
    cmp dword ptr [ebp - local_4], 0x20          # 004f338c
    jge.d8 L_004f33b1                            # 004f3390
    # block 0x004f3392: entered by fall-through of jge at 0x004f3390, 6 instruction(s), ends with backward jump to 0x004f3383
    mov edx, dword ptr [ebp - local_4]           # 004f3392
    imul edx, edx, 0x5bb                         # 004f3395
    mov eax, dword ptr [ebp - local_8]           # 004f339b
    mov ecx, dword ptr [eax + field_3ce]         # 004f339e
    mov dword ptr [ecx + edx + field_2f1], 0x0   # 004f33a4
    jmp.d8 L_004f3383                            # 004f33af
L_004f33b1:
    # block 0x004f33b1: entered by jge at 0x004f3390, 17 instruction(s), calls binkw32.dll!_BinkSetSoundSystem@8, falls into the block at 0x004f340e
    mov edx, dword ptr [ebp - local_8]           # 004f33b1
    mov dword ptr [edx + field_436], 0x50cf61    # 004f33b4
    mov eax, dword ptr [ebp - local_8]           # 004f33be
    mov dword ptr [eax + field_43a], 0x50ce2b    # 004f33c1
    mov ecx, dword ptr [ebp - local_8]           # 004f33cb
    mov dword ptr [ecx + field_43e], 0x50cee4    # 004f33ce
    mov edx, dword ptr [ebp - local_8]           # 004f33d8
    mov dword ptr [edx + field_442], 0x50d337    # 004f33db
    mov eax, dword ptr [ebp - local_8]           # 004f33e5
    mov ecx, dword ptr [eax + field_194]         # 004f33e8
    push ecx                                     # 004f33ee
    mov edx, dword ptr [0x52a50c]                # 004f33ef
    push edx                                     # 004f33f5
    call dword ptr [0x52a510]                    # 004f33f6
    mov eax, dword ptr [ebp - local_8]           # 004f33fc
    mov dword ptr [eax + field_1a0], 0x1         # 004f33ff
    mov eax, 0x1                                 # 004f3409
L_004f340e:
    # block 0x004f340e: entered by jmp at 0x004f2770; jmp at 0x004f279e; jmp at 0x004f27ea; jmp at 0x004f284f; more, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 004f340e
    {load} mov esp, ebp                          # 004f340f
    pop ebp                                      # 004f3411
    ret 0x8                                      # 004f3412

