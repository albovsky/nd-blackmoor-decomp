# FUN_004ce602
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ce602
# extent:       0x004ce602-0x004ce8ea (744 code bytes)
# span:         0x004ce602-0x004ce8ea (code 744, tables 0, padding 0)
# sha256:       95c0617d94a8a943c638a47d0ef461588ba78f53025b946a212cefd46af7d595
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ce602
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_23, field_182, field_192, field_1ca, field_1d4, field_1de, field_206, field_20e, field_212, field_232, field_246; [ecx + n] field_23, field_17a, field_1c6, field_1d4, field_1da, field_20a, field_20e, field_212, field_232; [edx + n] field_23, field_24, field_17a, field_182, field_1da, field_20e, field_212, field_226, field_232
# callees:      calls FUN_004ceb8c, FUN_004cec6c, KERNEL32.dll!GetTickCount, FUN_0050ca3e, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:random_present (function ledger class native_tests_only; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 187 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_17a, 0x17a  # offset +0x17a
.equ field_182, 0x182  # offset +0x182
.equ field_192, 0x192  # offset +0x192
.equ field_1c6, 0x1c6  # offset +0x1c6
.equ field_1ca, 0x1ca  # offset +0x1ca
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1da, 0x1da  # offset +0x1da
.equ field_1de, 0x1de  # offset +0x1de
.equ field_206, 0x206  # offset +0x206
.equ field_20a, 0x20a  # offset +0x20a
.equ field_20e, 0x20e  # offset +0x20e
.equ field_212, 0x212  # offset +0x212
.equ field_226, 0x226  # offset +0x226
.equ field_232, 0x232  # offset +0x232
.equ field_246, 0x246  # offset +0x246

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004ceb8c, .text + (0x004ceb8c - 0x401000)
.set FUN_004cec6c, .text + (0x004cec6c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004ce602 - 0x401000
.globl FUN_004ce602
FUN_004ce602:
    # block 0x004ce602: entry, 18 instruction(s), ends with je to 0x004ce648 (forward)
    push ebp                                     # 004ce602
    {load} mov ebp, esp                          # 004ce603
    sub esp, 0xc                                 # 004ce605
    push esi                                     # 004ce608
    push edi                                     # 004ce609
    mov dword ptr [ebp - local_8], ecx           # 004ce60a
    mov eax, dword ptr [ebp - local_8]           # 004ce60d
    mov ecx, dword ptr [eax + field_246]         # 004ce610
    imul ecx, ecx, 0x35                          # 004ce616
    mov edx, dword ptr [ebp - local_8]           # 004ce619
    mov eax, dword ptr [edx + field_226]         # 004ce61c
    {load} add eax, ecx                          # 004ce622
    mov dword ptr [ebp - local_4], eax           # 004ce624
    mov ecx, dword ptr [ebp - local_8]           # 004ce627
    mov edx, dword ptr [ecx + field_1da]         # 004ce62a
    mov dword ptr [ebp - local_c], edx           # 004ce630
    cmp dword ptr [ebp - local_c], 0x0           # 004ce633
    je.d8 L_004ce648                             # 004ce637
    # block 0x004ce639: entered by fall-through of je at 0x004ce637, 2 instruction(s), ends with je to 0x004ce76a (forward)
    cmp dword ptr [ebp - local_c], 0x4           # 004ce639
    je.d32 L_004ce76a                            # 004ce63d
    # block 0x004ce643: entered by fall-through of je at 0x004ce63d, 1 instruction(s), ends with forward jump to 0x004ce8e4
    jmp.d32 L_004ce8e4                           # 004ce643
L_004ce648:
    # block 0x004ce648: entered by je at 0x004ce637, 4 instruction(s), ends with je to 0x004ce765 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce648
    movsx ecx, word ptr [eax + field_1d4]        # 004ce64b
    test ecx, ecx                                # 004ce652
    je.d32 L_004ce765                            # 004ce654
    # block 0x004ce65a: entered by fall-through of je at 0x004ce654, 3 instruction(s), ends with jne to 0x004ce696 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ce65a
    cmp dword ptr [edx + field_17a], 0x0         # 004ce65d
    jne.d8 L_004ce696                            # 004ce664
    # block 0x004ce666: entered by fall-through of jne at 0x004ce664, 15 instruction(s), ends with forward jump to 0x004ce6cf
    mov eax, dword ptr [ebp - local_8]           # 004ce666
    mov ecx, dword ptr [eax + field_212]         # 004ce669
    mov ecx, dword ptr [ecx + field_23]          # 004ce66f
    mov edx, dword ptr [ebp - local_8]           # 004ce672
    mov esi, dword ptr [edx + field_182]         # 004ce675
    mov eax, dword ptr [ebp - local_8]           # 004ce67b
    mov edx, dword ptr [eax + field_212]         # 004ce67e
    mov edi, dword ptr [edx]                     # 004ce684
    {load} mov eax, ecx                          # 004ce686
    shr ecx, 0x2                                 # 004ce688
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ce68b
    {load} mov ecx, eax                          # 004ce68d
    and ecx, 0x3                                 # 004ce68f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ce692
    jmp.d8 L_004ce6cf                            # 004ce694
L_004ce696:
    # block 0x004ce696: entered by jne at 0x004ce664, 16 instruction(s), falls into the block at 0x004ce6cf
    mov ecx, dword ptr [ebp - local_8]           # 004ce696
    mov edx, dword ptr [ecx + field_212]         # 004ce699
    mov ecx, dword ptr [edx + field_23]          # 004ce69f
    mov eax, dword ptr [ebp - local_8]           # 004ce6a2
    movsx edx, word ptr [eax + field_192]        # 004ce6a5
    mov eax, dword ptr [ebp - local_8]           # 004ce6ac
    mov esi, dword ptr [eax + 4*edx + field_182] # 004ce6af
    mov edx, dword ptr [ebp - local_8]           # 004ce6b6
    mov eax, dword ptr [edx + field_212]         # 004ce6b9
    mov edi, dword ptr [eax]                     # 004ce6bf
    {load} mov edx, ecx                          # 004ce6c1
    shr ecx, 0x2                                 # 004ce6c3
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ce6c6
    {load} mov ecx, edx                          # 004ce6c8
    and ecx, 0x3                                 # 004ce6ca
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ce6cd
L_004ce6cf:
    # block 0x004ce6cf: entered by jmp at 0x004ce694, 22 instruction(s), calls FUN_004ceb8c, FUN_004cec6c, KERNEL32.dll!GetTickCount, ends with jne to 0x004ce740 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce6cf
    movsx ecx, word ptr [eax + field_1ca]        # 004ce6d2
    mov edx, dword ptr [ebp - local_8]           # 004ce6d9
    mov dword ptr [edx + field_232], ecx         # 004ce6dc
    mov eax, dword ptr [ebp - local_8]           # 004ce6e2
    mov dword ptr [eax + field_206], 0x1         # 004ce6e5
    mov ecx, dword ptr [ebp - local_8]           # 004ce6ef
    mov dword ptr [ecx + field_20a], 0x1         # 004ce6f2
    mov ecx, dword ptr [ebp - local_8]           # 004ce6fc
    call FUN_004ceb8c                            # 004ce6ff
    mov ecx, dword ptr [ebp - local_8]           # 004ce704
    call FUN_004cec6c                            # 004ce707
    call dword ptr [0x52a23c]                    # 004ce70c
    mov edx, dword ptr [ebp - local_8]           # 004ce712
    add eax, dword ptr [edx + field_24]          # 004ce715
    mov ecx, dword ptr [ebp - local_8]           # 004ce718
    mov dword ptr [ecx + field_1c6], eax         # 004ce71b
    mov edx, dword ptr [ebp - local_4]           # 004ce721
    movsx eax, word ptr [edx + field_23]         # 004ce724
    mov ecx, dword ptr [ebp - local_8]           # 004ce728
    cmp dword ptr [ecx + field_232], eax         # 004ce72b
    jne.d8 L_004ce740                            # 004ce731
    # block 0x004ce733: entered by fall-through of jne at 0x004ce731, 2 instruction(s), falls into the block at 0x004ce740
    mov edx, dword ptr [ebp - local_8]           # 004ce733
    mov dword ptr [edx + field_20e], 0x1         # 004ce736
L_004ce740:
    # block 0x004ce740: entered by jne at 0x004ce731, 3 instruction(s), ends with jne to 0x004ce758 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce740
    cmp dword ptr [eax + field_20e], 0x0         # 004ce743
    jne.d8 L_004ce758                            # 004ce74a
    # block 0x004ce74c: entered by fall-through of jne at 0x004ce74a, 2 instruction(s), falls into the block at 0x004ce758
    mov ecx, dword ptr [ebp - local_8]           # 004ce74c
    mov word ptr [ecx + field_1d4], 0x0          # 004ce74f
L_004ce758:
    # block 0x004ce758: entered by jne at 0x004ce74a, 2 instruction(s), falls into the block at 0x004ce765
    mov edx, dword ptr [ebp - local_8]           # 004ce758
    mov dword ptr [edx + field_1da], 0x4         # 004ce75b
L_004ce765:
    # block 0x004ce765: entered by je at 0x004ce654, 1 instruction(s), ends with forward jump to 0x004ce8e4
    jmp.d32 L_004ce8e4                           # 004ce765
L_004ce76a:
    # block 0x004ce76a: entered by je at 0x004ce63d, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004ce8e4 (forward)
    call dword ptr [0x52a23c]                    # 004ce76a
    mov ecx, dword ptr [ebp - local_8]           # 004ce770
    cmp eax, dword ptr [ecx + field_1c6]         # 004ce773
    jb.d32 L_004ce8e4                            # 004ce779
    # block 0x004ce77f: entered by fall-through of jb at 0x004ce779, 3 instruction(s), ends with je to 0x004ce7d1 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ce77f
    cmp dword ptr [edx + field_20e], 0x0         # 004ce782
    je.d8 L_004ce7d1                             # 004ce789
    # block 0x004ce78b: entered by fall-through of je at 0x004ce789, 5 instruction(s), ends with je to 0x004ce7cc (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce78b
    mov dword ptr [eax + field_1de], 0x3         # 004ce78e
    movsx ecx, word ptr [0x63a4cd]               # 004ce798
    test ecx, ecx                                # 004ce79f
    je.d8 L_004ce7cc                             # 004ce7a1
    # block 0x004ce7a3: entered by fall-through of je at 0x004ce7a1, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004ce7cc
    mov edx, dword ptr [ebp - local_8]           # 004ce7a3
    mov eax, dword ptr [edx + field_232]         # 004ce7a6
    push eax                                     # 004ce7ac
    push 0x5599ac                                # 004ce7ad
    push 0x63888b                                # 004ce7b2
    call FUN_0050ca3e                            # 004ce7b7
    add esp, 0xc                                 # 004ce7bc
    push 0x63888b                                # 004ce7bf
    call FUN_0044a2b7                            # 004ce7c4
    add esp, 0x4                                 # 004ce7c9
L_004ce7cc:
    # block 0x004ce7cc: entered by je at 0x004ce7a1, 1 instruction(s), ends with forward jump to 0x004ce8e4
    jmp.d32 L_004ce8e4                           # 004ce7cc
L_004ce7d1:
    # block 0x004ce7d1: entered by je at 0x004ce789, 4 instruction(s), ends with je to 0x004ce8e4 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ce7d1
    movsx edx, word ptr [ecx + field_1d4]        # 004ce7d4
    test edx, edx                                # 004ce7db
    je.d32 L_004ce8e4                            # 004ce7dd
    # block 0x004ce7e3: entered by fall-through of je at 0x004ce7dd, 3 instruction(s), ends with jne to 0x004ce8e4 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce7e3
    cmp dword ptr [eax + field_20e], 0x0         # 004ce7e6
    jne.d32 L_004ce8e4                           # 004ce7ed
    # block 0x004ce7f3: entered by fall-through of jne at 0x004ce7ed, 3 instruction(s), ends with jne to 0x004ce82f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ce7f3
    cmp dword ptr [ecx + field_17a], 0x0         # 004ce7f6
    jne.d8 L_004ce82f                            # 004ce7fd
    # block 0x004ce7ff: entered by fall-through of jne at 0x004ce7fd, 15 instruction(s), ends with forward jump to 0x004ce868
    mov edx, dword ptr [ebp - local_8]           # 004ce7ff
    mov eax, dword ptr [edx + field_212]         # 004ce802
    mov ecx, dword ptr [eax + field_23]          # 004ce808
    mov edx, dword ptr [ebp - local_8]           # 004ce80b
    mov esi, dword ptr [edx + field_182]         # 004ce80e
    mov eax, dword ptr [ebp - local_8]           # 004ce814
    mov edx, dword ptr [eax + field_212]         # 004ce817
    mov edi, dword ptr [edx]                     # 004ce81d
    {load} mov eax, ecx                          # 004ce81f
    shr ecx, 0x2                                 # 004ce821
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ce824
    {load} mov ecx, eax                          # 004ce826
    and ecx, 0x3                                 # 004ce828
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ce82b
    jmp.d8 L_004ce868                            # 004ce82d
L_004ce82f:
    # block 0x004ce82f: entered by jne at 0x004ce7fd, 16 instruction(s), falls into the block at 0x004ce868
    mov ecx, dword ptr [ebp - local_8]           # 004ce82f
    mov edx, dword ptr [ecx + field_212]         # 004ce832
    mov ecx, dword ptr [edx + field_23]          # 004ce838
    mov eax, dword ptr [ebp - local_8]           # 004ce83b
    movsx edx, word ptr [eax + field_192]        # 004ce83e
    mov eax, dword ptr [ebp - local_8]           # 004ce845
    mov esi, dword ptr [eax + 4*edx + field_182] # 004ce848
    mov edx, dword ptr [ebp - local_8]           # 004ce84f
    mov eax, dword ptr [edx + field_212]         # 004ce852
    mov edi, dword ptr [eax]                     # 004ce858
    {load} mov edx, ecx                          # 004ce85a
    shr ecx, 0x2                                 # 004ce85c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ce85f
    {load} mov ecx, edx                          # 004ce861
    and ecx, 0x3                                 # 004ce863
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ce866
L_004ce868:
    # block 0x004ce868: entered by jmp at 0x004ce82d, 13 instruction(s), calls FUN_004ceb8c, ends with jne to 0x004ce8af (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ce868
    movsx ecx, word ptr [eax + field_1ca]        # 004ce86b
    mov edx, dword ptr [ebp - local_8]           # 004ce872
    mov dword ptr [edx + field_232], ecx         # 004ce875
    mov eax, dword ptr [ebp - local_8]           # 004ce87b
    mov dword ptr [eax + field_206], 0x1         # 004ce87e
    mov ecx, dword ptr [ebp - local_8]           # 004ce888
    call FUN_004ceb8c                            # 004ce88b
    mov ecx, dword ptr [ebp - local_4]           # 004ce890
    movsx edx, word ptr [ecx + field_23]         # 004ce893
    mov eax, dword ptr [ebp - local_8]           # 004ce897
    cmp dword ptr [eax + field_232], edx         # 004ce89a
    jne.d8 L_004ce8af                            # 004ce8a0
    # block 0x004ce8a2: entered by fall-through of jne at 0x004ce8a0, 2 instruction(s), falls into the block at 0x004ce8af
    mov ecx, dword ptr [ebp - local_8]           # 004ce8a2
    mov dword ptr [ecx + field_20e], 0x1         # 004ce8a5
L_004ce8af:
    # block 0x004ce8af: entered by jne at 0x004ce8a0, 8 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jne to 0x004ce8e4 (forward)
    call dword ptr [0x52a23c]                    # 004ce8af
    mov edx, dword ptr [ebp - local_8]           # 004ce8b5
    add eax, dword ptr [edx + field_24]          # 004ce8b8
    mov ecx, dword ptr [ebp - local_8]           # 004ce8bb
    mov dword ptr [ecx + field_1c6], eax         # 004ce8be
    mov edx, dword ptr [ebp - local_8]           # 004ce8c4
    cmp dword ptr [edx + field_20e], 0x0         # 004ce8c7
    jne.d8 L_004ce8e4                            # 004ce8ce
    # block 0x004ce8d0: entered by fall-through of jne at 0x004ce8ce, 4 instruction(s), calls FUN_004cec6c, falls into the block at 0x004ce8e4
    mov ecx, dword ptr [ebp - local_8]           # 004ce8d0
    call FUN_004cec6c                            # 004ce8d3
    mov eax, dword ptr [ebp - local_8]           # 004ce8d8
    mov word ptr [eax + field_1d4], 0x0          # 004ce8db
L_004ce8e4:
    # block 0x004ce8e4: entered by jmp at 0x004ce643; jmp at 0x004ce765; jb at 0x004ce779; jmp at 0x004ce7cc; more, 5 instruction(s), ends with ret
    pop edi                                      # 004ce8e4
    pop esi                                      # 004ce8e5
    {load} mov esp, ebp                          # 004ce8e6
    pop ebp                                      # 004ce8e8
    ret                                          # 004ce8e9

