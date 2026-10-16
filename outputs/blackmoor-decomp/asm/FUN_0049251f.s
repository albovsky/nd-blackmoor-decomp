# FUN_0049251f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049251f
# extent:       0x0049251f-0x004933ef (3792 code bytes)
# span:         0x0049251f-0x004933ff (code 3792, tables 16, padding 0)
# sha256:       50ed78abb4a9092d53001a7e22644ae2b4f61558f5d78ea4c324a4385e6fb6a6
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049251f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       19 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_b0, local_1b0, local_1b4, local_1b8, local_1bc, local_1c0 and 7 more
# fields:       [eax + n] field_1, field_2f, field_a0, field_2095, field_20e5, field_22d9, field_242d, field_2f31, field_3ed1, field_4345, field_43e5, field_459d and 7 more; [ecx + n] field_1, field_23, field_2b, field_2d, field_2f, field_20e5, field_242d, field_3431, field_41f1, field_4345, field_43e5, field_4539 and 8 more; [edx + n] field_1, field_23, field_2b, field_2d, field_2f, field_a0, field_20e5, field_2239, field_22d9, field_2491, field_4539, field_459d and 8 more
# callees:      calls FUN_0050d0bc, FUN_0050d8e0, FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, FUN_004c2790, FUN_0051dc43, FUN_0051dc6c, FUN_004933ff, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 869 instruction(s), 49 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_b0, 0xb0  # offset -0xb0
.equ local_1b0, 0x1b0  # offset -0x1b0
.equ local_1b4, 0x1b4  # offset -0x1b4
.equ local_1b8, 0x1b8  # offset -0x1b8
.equ local_1bc, 0x1bc  # offset -0x1bc
.equ local_1c0, 0x1c0  # offset -0x1c0
.equ local_1c4, 0x1c4  # offset -0x1c4
.equ local_1c8, 0x1c8  # offset -0x1c8
.equ local_1cc, 0x1cc  # offset -0x1cc
.equ local_1d0, 0x1d0  # offset -0x1d0
.equ local_1d4, 0x1d4  # offset -0x1d4
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc
.equ field_1, 0x1  # offset +0x1
.equ field_23, 0x23  # offset +0x23
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_a0, 0xa0  # offset +0xa0
.equ field_2095, 0x2095  # offset +0x2095
.equ field_20e5, 0x20e5  # offset +0x20e5
.equ field_2239, 0x2239  # offset +0x2239
.equ field_22d9, 0x22d9  # offset +0x22d9
.equ field_242d, 0x242d  # offset +0x242d
.equ field_2491, 0x2491  # offset +0x2491
.equ field_2f31, 0x2f31  # offset +0x2f31
.equ field_3431, 0x3431  # offset +0x3431
.equ field_3ed1, 0x3ed1  # offset +0x3ed1
.equ field_41f1, 0x41f1  # offset +0x41f1
.equ field_4345, 0x4345  # offset +0x4345
.equ field_43e5, 0x43e5  # offset +0x43e5
.equ field_4539, 0x4539  # offset +0x4539
.equ field_459d, 0x459d  # offset +0x459d
.equ field_45a1, 0x45a1  # offset +0x45a1
.equ field_45a5, 0x45a5  # offset +0x45a5
.equ field_45a9, 0x45a9  # offset +0x45a9
.equ field_47d1, 0x47d1  # offset +0x47d1
.equ field_47d5, 0x47d5  # offset +0x47d5
.equ field_47d9, 0x47d9  # offset +0x47d9
.equ field_47dd, 0x47dd  # offset +0x47dd
.equ field_47e1, 0x47e1  # offset +0x47e1
.equ field_47e5, 0x47e5  # offset +0x47e5

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004933ff, .text + (0x004933ff - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0050d8e0, .text + (0x0050d8e0 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x0049251f - 0x401000
.globl FUN_0049251f
FUN_0049251f:
    # block 0x0049251f: entry, 17 instruction(s), ends with forward jump to 0x00492589
    push ebp                                     # 0049251f
    {load} mov ebp, esp                          # 00492520
    sub esp, 0x1dc                               # 00492522
    push esi                                     # 00492528
    push edi                                     # 00492529
    mov dword ptr [ebp - local_1d8], ecx         # 0049252a
    mov dword ptr [ebp - local_4], 0x0           # 00492530
    mov eax, dword ptr [ebp - local_1d8]         # 00492537
    mov dword ptr [eax + field_45a1], 0x1        # 0049253d
    mov ecx, dword ptr [ebp - local_1d8]         # 00492547
    mov dword ptr [ecx + field_459d], 0x1        # 0049254d
    mov edx, dword ptr [ebp - local_1d8]         # 00492557
    mov dword ptr [edx + field_45a9], 0x0        # 0049255d
    mov eax, dword ptr [ebp - local_1d8]         # 00492567
    mov dword ptr [eax + field_45a5], 0x0        # 0049256d
    mov dword ptr [ebp - local_c], 0x0           # 00492577
    jmp.d8 L_00492589                            # 0049257e
L_00492580:
    # block 0x00492580: entered by jmp at 0x004925b9; jmp at 0x00492f42, 3 instruction(s), falls into the block at 0x00492589
    mov ecx, dword ptr [ebp - local_c]           # 00492580
    add ecx, 0x1                                 # 00492583
    mov dword ptr [ebp - local_c], ecx           # 00492586
L_00492589:
    # block 0x00492589: entered by jmp at 0x0049257e, 2 instruction(s), ends with jge to 0x00492f47 (forward)
    cmp dword ptr [ebp - local_c], 0xeb          # 00492589
    jge.d32 L_00492f47                           # 00492590
    # block 0x00492596: entered by fall-through of jge at 0x00492590, 11 instruction(s), ends with jne to 0x004925bb (forward)
    mov edx, dword ptr [ebp - local_c]           # 00492596
    imul edx, edx, 0x21                          # 00492599
    mov eax, dword ptr [ebp - local_1d8]         # 0049259c
    lea edi, [eax + edx + field_a0]              # 004925a2
    or ecx, -0x1                                 # 004925a9
    {load} xor eax, eax                          # 004925ac
    repne scasb al, byte ptr es:[edi]            # 004925ae
    not ecx                                      # 004925b0
    add ecx, -0x1                                # 004925b2
    test ecx, ecx                                # 004925b5
    jne.d8 L_004925bb                            # 004925b7
    # block 0x004925b9: entered by fall-through of jne at 0x004925b7, 1 instruction(s), ends with backward jump to 0x00492580
    jmp.d8 L_00492580                            # 004925b9
L_004925bb:
    # block 0x004925bb: entered by jne at 0x004925b7, 31 instruction(s), calls FUN_0050d0bc, FUN_0050d8e0, ends with je to 0x0049263d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004925bb
    imul ecx, ecx, 0x21                          # 004925be
    mov edx, dword ptr [ebp - local_1d8]         # 004925c1
    lea eax, [edx + ecx + field_a0]              # 004925c7
    {load} mov edi, eax                          # 004925ce
    lea edx, [ebp - local_1b0]                   # 004925d0
    or ecx, -0x1                                 # 004925d6
    {load} xor eax, eax                          # 004925d9
    repne scasb al, byte ptr es:[edi]            # 004925db
    not ecx                                      # 004925dd
    {load} sub edi, ecx                          # 004925df
    {load} mov esi, edi                          # 004925e1
    {load} mov eax, ecx                          # 004925e3
    {load} mov edi, edx                          # 004925e5
    shr ecx, 0x2                                 # 004925e7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004925ea
    {load} mov ecx, eax                          # 004925ec
    and ecx, 0x3                                 # 004925ee
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004925f1
    lea ecx, [ebp - local_1b0]                   # 004925f3
    push ecx                                     # 004925f9
    call FUN_0050d0bc                            # 004925fa
    add esp, 0x4                                 # 004925ff
    mov dword ptr [ebp - local_1c4], 0x0         # 00492602
    push 0x54f184                                # 0049260c
    lea edx, [ebp - local_1b0]                   # 00492611
    push edx                                     # 00492617
    call FUN_0050d8e0                            # 00492618
    add esp, 0x8                                 # 0049261d
    test eax, eax                                # 00492620
    je.d8 L_0049263d                             # 00492622
    # block 0x00492624: entered by fall-through of je at 0x00492622, 4 instruction(s), falls into the block at 0x0049263d
    mov dword ptr [ebp - local_1c0], 0x0         # 00492624
    mov eax, dword ptr [ebp - local_1c4]         # 0049262e
    add eax, 0x1                                 # 00492634
    mov dword ptr [ebp - local_1c4], eax         # 00492637
L_0049263d:
    # block 0x0049263d: entered by je at 0x00492622, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x0049266e (forward)
    push 0x54f18c                                # 0049263d
    lea ecx, [ebp - local_1b0]                   # 00492642
    push ecx                                     # 00492648
    call FUN_0050d8e0                            # 00492649
    add esp, 0x8                                 # 0049264e
    test eax, eax                                # 00492651
    je.d8 L_0049266e                             # 00492653
    # block 0x00492655: entered by fall-through of je at 0x00492653, 4 instruction(s), falls into the block at 0x0049266e
    mov dword ptr [ebp - local_1c0], 0x1         # 00492655
    mov edx, dword ptr [ebp - local_1c4]         # 0049265f
    add edx, 0x1                                 # 00492665
    mov dword ptr [ebp - local_1c4], edx         # 00492668
L_0049266e:
    # block 0x0049266e: entered by je at 0x00492653, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x0049269f (forward)
    push 0x54f190                                # 0049266e
    lea eax, [ebp - local_1b0]                   # 00492673
    push eax                                     # 00492679
    call FUN_0050d8e0                            # 0049267a
    add esp, 0x8                                 # 0049267f
    test eax, eax                                # 00492682
    je.d8 L_0049269f                             # 00492684
    # block 0x00492686: entered by fall-through of je at 0x00492684, 4 instruction(s), falls into the block at 0x0049269f
    mov dword ptr [ebp - local_1c0], 0x2         # 00492686
    mov ecx, dword ptr [ebp - local_1c4]         # 00492690
    add ecx, 0x1                                 # 00492696
    mov dword ptr [ebp - local_1c4], ecx         # 00492699
L_0049269f:
    # block 0x0049269f: entered by je at 0x00492684, 7 instruction(s), calls FUN_0050d8e0, ends with je to 0x004926d0 (forward)
    push 0x54f198                                # 0049269f
    lea edx, [ebp - local_1b0]                   # 004926a4
    push edx                                     # 004926aa
    call FUN_0050d8e0                            # 004926ab
    add esp, 0x8                                 # 004926b0
    test eax, eax                                # 004926b3
    je.d8 L_004926d0                             # 004926b5
    # block 0x004926b7: entered by fall-through of je at 0x004926b5, 4 instruction(s), falls into the block at 0x004926d0
    mov dword ptr [ebp - local_1c0], 0x3         # 004926b7
    mov eax, dword ptr [ebp - local_1c4]         # 004926c1
    add eax, 0x1                                 # 004926c7
    mov dword ptr [ebp - local_1c4], eax         # 004926ca
L_004926d0:
    # block 0x004926d0: entered by je at 0x004926b5, 2 instruction(s), ends with je to 0x00492711 (forward)
    cmp dword ptr [ebp - local_1c4], 0x1         # 004926d0
    je.d8 L_00492711                             # 004926d7
    # block 0x004926d9: entered by fall-through of je at 0x004926d7, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_004c97b4, falls into the block at 0x00492711
    lea ecx, [ebp - local_1b0]                   # 004926d9
    push ecx                                     # 004926df
    mov edx, dword ptr [ebp - local_1c4]         # 004926e0
    push edx                                     # 004926e6
    push 0x54f1a0                                # 004926e7
    push 0x63888b                                # 004926ec
    call FUN_0050ca3e                            # 004926f1
    add esp, 0x10                                # 004926f6
    push 0x0                                     # 004926f9
    push 0x0                                     # 004926fb
    push 0x63888b                                # 004926fd
    call FUN_0052139c                            # 00492702
    mov ecx, 0x5cf659                            # 00492707
    call FUN_004c97b4                            # 0049270c
L_00492711:
    # block 0x00492711: entered by je at 0x004926d7, 4 instruction(s), ends with ja to 0x00492f42 (forward)
    mov eax, dword ptr [ebp - local_1c0]         # 00492711
    mov dword ptr [ebp - local_1dc], eax         # 00492717
    cmp dword ptr [ebp - local_1dc], 0x3         # 0049271d
    ja.d32 L_00492f42                            # 00492724
    # block 0x0049272a: entered by fall-through of ja at 0x00492724, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4933ef]
    mov ecx, dword ptr [ebp - local_1dc]         # 0049272a
    jmp dword ptr [4*ecx + SWTAB_004933ef_VA]    # 00492730
L_00492737:
    # block 0x00492737: entered by switch case, 5 instruction(s), ends with je to 0x004929e6 (forward)
    mov edx, dword ptr [ebp - local_1d8]         # 00492737
    mov eax, dword ptr [edx + field_459d]        # 0049273d
    mov ecx, dword ptr [ebp - local_1d8]         # 00492743
    cmp dword ptr [ecx + 4*eax + field_41f1], 0x0 # 00492749
    je.d32 L_004929e6                            # 00492751
    # block 0x00492757: entered by fall-through of je at 0x00492751, 36 instruction(s), calls FUN_004c2790, FUN_0051dc43, ends with jne to 0x00492829 (forward)
    mov edx, dword ptr [ebp - local_1d8]         # 00492757
    mov eax, dword ptr [edx + field_459d]        # 0049275d
    mov ecx, dword ptr [ebp - local_1d8]         # 00492763
    mov dword ptr [ecx + 4*eax + field_41f1], 0x0 # 00492769
    push 0x54f1fc                                # 00492774
    push 0x6                                     # 00492779
    lea edx, [ebp - local_1b0]                   # 0049277b
    push edx                                     # 00492781
    push 0x54f214                                # 00492782
    mov ecx, 0x5cf659                            # 00492787
    call FUN_004c2790                            # 0049278c
    mov ecx, dword ptr [ebp - local_1d8]         # 00492791
    mov edx, dword ptr [ecx + field_459d]        # 00492797
    mov ecx, dword ptr [ebp - local_1d8]         # 0049279d
    mov dword ptr [ecx + 4*edx + field_20e5], eax # 004927a3
    mov edx, dword ptr [ebp - local_1d8]         # 004927aa
    mov eax, dword ptr [edx + field_459d]        # 004927b0
    mov ecx, dword ptr [ebp - local_1d8]         # 004927b6
    mov edx, dword ptr [ecx + 4*eax + field_20e5] # 004927bc
    mov dword ptr [ebp - local_1b8], edx         # 004927c3
    mov eax, dword ptr [ebp - local_1d8]         # 004927c9
    mov ecx, dword ptr [eax + field_459d]        # 004927cf
    mov edx, dword ptr [ebp - local_1d8]         # 004927d5
    mov eax, dword ptr [ebp - local_1b8]         # 004927db
    mov eax, dword ptr [eax]                     # 004927e1
    mov dword ptr [edx + 4*ecx + field_2491], eax # 004927e3
    mov ecx, dword ptr [ebp - local_1b8]         # 004927ea
    mov edx, dword ptr [ecx + field_23]          # 004927f0
    push edx                                     # 004927f3
    call FUN_0051dc43                            # 004927f4
    add esp, 0x4                                 # 004927f9
    mov dword ptr [ebp - local_1c8], eax         # 004927fc
    mov eax, dword ptr [ebp - local_1c8]         # 00492802
    mov dword ptr [ebp - local_4], eax           # 00492808
    cmp dword ptr [ebp - local_4], 0x0           # 0049280b
    jne.d8 L_00492829                            # 0049280f
    # block 0x00492811: entered by fall-through of jne at 0x0049280f, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00492829
    push 0x0                                     # 00492811
    push 0x0                                     # 00492813
    push 0x54f21c                                # 00492815
    call FUN_0052139c                            # 0049281a
    mov ecx, 0x5cf659                            # 0049281f
    call FUN_004c97b4                            # 00492824
L_00492829:
    # block 0x00492829: entered by jne at 0x0049280f, 13 instruction(s), ends with forward jump to 0x00492866
    mov ecx, dword ptr [ebp - local_1b8]         # 00492829
    mov ecx, dword ptr [ecx + field_23]          # 0049282f
    mov edx, dword ptr [ebp - local_1b8]         # 00492832
    mov esi, dword ptr [edx]                     # 00492838
    mov edi, dword ptr [ebp - local_4]           # 0049283a
    {load} mov eax, ecx                          # 0049283d
    shr ecx, 0x2                                 # 0049283f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00492842
    {load} mov ecx, eax                          # 00492844
    and ecx, 0x3                                 # 00492846
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00492849
    mov dword ptr [ebp - local_1bc], 0x0         # 0049284b
    jmp.d8 L_00492866                            # 00492855
L_00492857:
    # block 0x00492857: entered by jmp at 0x0049296a, 3 instruction(s), falls into the block at 0x00492866
    mov ecx, dword ptr [ebp - local_1bc]         # 00492857
    add ecx, 0x1                                 # 0049285d
    mov dword ptr [ebp - local_1bc], ecx         # 00492860
L_00492866:
    # block 0x00492866: entered by jmp at 0x00492855, 4 instruction(s), ends with jge to 0x0049296f (forward)
    mov edx, dword ptr [ebp - local_1b8]         # 00492866
    movsx eax, word ptr [edx + field_2d]         # 0049286c
    cmp dword ptr [ebp - local_1bc], eax         # 00492870
    jge.d32 L_0049296f                           # 00492876
    # block 0x0049287c: entered by fall-through of jge at 0x00492876, 2 instruction(s), ends with forward jump to 0x00492897
    mov dword ptr [ebp - local_1b4], 0x0         # 0049287c
    jmp.d8 L_00492897                            # 00492886
L_00492888:
    # block 0x00492888: entered by jmp at 0x00492965, 3 instruction(s), falls into the block at 0x00492897
    mov ecx, dword ptr [ebp - local_1b4]         # 00492888
    add ecx, 0x1                                 # 0049288e
    mov dword ptr [ebp - local_1b4], ecx         # 00492891
L_00492897:
    # block 0x00492897: entered by jmp at 0x00492886, 4 instruction(s), ends with jge to 0x0049296a (forward)
    mov edx, dword ptr [ebp - local_1b8]         # 00492897
    movsx eax, word ptr [edx + field_2b]         # 0049289d
    cmp dword ptr [ebp - local_1b4], eax         # 004928a1
    jge.d32 L_0049296a                           # 004928a7
    # block 0x004928ad: entered by fall-through of jge at 0x004928a7, 43 instruction(s), ends with backward jump to 0x00492888
    mov ecx, dword ptr [ebp - local_1b8]         # 004928ad
    movsx edx, word ptr [ecx + field_2f]         # 004928b3
    mov eax, dword ptr [ebp - local_1bc]         # 004928b7
    imul eax, edx                                # 004928bd
    mov ecx, dword ptr [ebp - local_4]           # 004928c0
    {load} add ecx, eax                          # 004928c3
    movsx edx, word ptr [0x639895]               # 004928c5
    mov eax, dword ptr [ebp - local_1b4]         # 004928cc
    imul eax, edx                                # 004928d2
    mov edx, dword ptr [ebp - local_1b8]         # 004928d5
    movsx edx, word ptr [edx + field_2f]         # 004928db
    mov esi, dword ptr [ebp - local_1b4]         # 004928df
    imul esi, edx                                # 004928e5
    mov edx, dword ptr [ebp - local_1b8]         # 004928e8
    mov edx, dword ptr [edx]                     # 004928ee
    {load} add edx, esi                          # 004928f0
    movsx esi, word ptr [0x639895]               # 004928f2
    mov edi, dword ptr [ebp - local_1bc]         # 004928f9
    imul edi, esi                                # 004928ff
    mov al, byte ptr [ecx + eax]                 # 00492902
    mov byte ptr [edx + edi], al                 # 00492905
    mov ecx, dword ptr [ebp - local_1b8]         # 00492908
    movsx edx, word ptr [ecx + field_2f]         # 0049290e
    mov eax, dword ptr [ebp - local_1bc]         # 00492912
    imul eax, edx                                # 00492918
    mov ecx, dword ptr [ebp - local_4]           # 0049291b
    {load} add ecx, eax                          # 0049291e
    movsx edx, word ptr [0x639895]               # 00492920
    mov eax, dword ptr [ebp - local_1b4]         # 00492927
    imul eax, edx                                # 0049292d
    mov edx, dword ptr [ebp - local_1b8]         # 00492930
    movsx edx, word ptr [edx + field_2f]         # 00492936
    mov esi, dword ptr [ebp - local_1b4]         # 0049293a
    imul esi, edx                                # 00492940
    mov edx, dword ptr [ebp - local_1b8]         # 00492943
    mov edx, dword ptr [edx]                     # 00492949
    {load} add edx, esi                          # 0049294b
    movsx esi, word ptr [0x639895]               # 0049294d
    mov edi, dword ptr [ebp - local_1bc]         # 00492954
    imul edi, esi                                # 0049295a
    mov al, byte ptr [ecx + eax + field_1]       # 0049295d
    mov byte ptr [edx + edi + field_1], al       # 00492961
    jmp.d32 L_00492888                           # 00492965
L_0049296a:
    # block 0x0049296a: entered by jge at 0x004928a7, 1 instruction(s), ends with backward jump to 0x00492857
    jmp.d32 L_00492857                           # 0049296a
L_0049296f:
    # block 0x0049296f: entered by jge at 0x00492876, 17 instruction(s), calls FUN_0051dc6c, FUN_004933ff, ends with je to 0x004929e6 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0049296f
    mov dword ptr [ebp - local_1cc], ecx         # 00492972
    mov edx, dword ptr [ebp - local_1cc]         # 00492978
    push edx                                     # 0049297e
    call FUN_0051dc6c                            # 0049297f
    add esp, 0x4                                 # 00492984
    mov eax, dword ptr [ebp - local_1d8]         # 00492987
    mov ecx, dword ptr [eax + field_459d]        # 0049298d
    push ecx                                     # 00492993
    push 0x0                                     # 00492994
    mov edx, dword ptr [ebp - local_1b8]         # 00492996
    push edx                                     # 0049299c
    mov ecx, dword ptr [ebp - local_1d8]         # 0049299d
    call FUN_004933ff                            # 004929a3
    movsx eax, word ptr [0x63a4cd]               # 004929a8
    test eax, eax                                # 004929af
    je.d8 L_004929e6                             # 004929b1
    # block 0x004929b3: entered by fall-through of je at 0x004929b1, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004929e6
    lea ecx, [ebp - local_1b0]                   # 004929b3
    push ecx                                     # 004929b9
    mov edx, dword ptr [ebp - local_1d8]         # 004929ba
    mov eax, dword ptr [edx + field_459d]        # 004929c0
    push eax                                     # 004929c6
    push 0x54f260                                # 004929c7
    push 0x63888b                                # 004929cc
    call FUN_0050ca3e                            # 004929d1
    add esp, 0x10                                # 004929d6
    push 0x63888b                                # 004929d9
    call FUN_0044a2b7                            # 004929de
    add esp, 0x4                                 # 004929e3
L_004929e6:
    # block 0x004929e6: entered by je at 0x00492751; je at 0x004929b1, 6 instruction(s), ends with forward jump to 0x00492f42
    mov ecx, dword ptr [ebp - local_1d8]         # 004929e6
    mov edx, dword ptr [ecx + field_459d]        # 004929ec
    add edx, 0x1                                 # 004929f2
    mov eax, dword ptr [ebp - local_1d8]         # 004929f5
    mov dword ptr [eax + field_459d], edx        # 004929fb
    jmp.d32 L_00492f42                           # 00492a01
L_00492a06:
    # block 0x00492a06: entered by switch case, 5 instruction(s), ends with je to 0x00492cb5 (forward)
    mov ecx, dword ptr [ebp - local_1d8]         # 00492a06
    mov edx, dword ptr [ecx + field_45a1]        # 00492a0c
    mov eax, dword ptr [ebp - local_1d8]         # 00492a12
    cmp dword ptr [eax + 4*edx + field_4345], 0x0 # 00492a18
    je.d32 L_00492cb5                            # 00492a20
    # block 0x00492a26: entered by fall-through of je at 0x00492a20, 36 instruction(s), calls FUN_004c2790, FUN_0051dc43, ends with jne to 0x00492af8 (forward)
    mov ecx, dword ptr [ebp - local_1d8]         # 00492a26
    mov edx, dword ptr [ecx + field_45a1]        # 00492a2c
    mov eax, dword ptr [ebp - local_1d8]         # 00492a32
    mov dword ptr [eax + 4*edx + field_4345], 0x0 # 00492a38
    push 0x54f2a0                                # 00492a43
    push 0x6                                     # 00492a48
    lea ecx, [ebp - local_1b0]                   # 00492a4a
    push ecx                                     # 00492a50
    push 0x54f2c0                                # 00492a51
    mov ecx, 0x5cf659                            # 00492a56
    call FUN_004c2790                            # 00492a5b
    mov edx, dword ptr [ebp - local_1d8]         # 00492a60
    mov ecx, dword ptr [edx + field_45a1]        # 00492a66
    mov edx, dword ptr [ebp - local_1d8]         # 00492a6c
    mov dword ptr [edx + 4*ecx + field_2239], eax # 00492a72
    mov eax, dword ptr [ebp - local_1d8]         # 00492a79
    mov ecx, dword ptr [eax + field_45a1]        # 00492a7f
    mov edx, dword ptr [ebp - local_1d8]         # 00492a85
    mov eax, dword ptr [edx + 4*ecx + field_2239] # 00492a8b
    mov dword ptr [ebp - local_1b8], eax         # 00492a92
    mov ecx, dword ptr [ebp - local_1d8]         # 00492a98
    mov edx, dword ptr [ecx + field_45a1]        # 00492a9e
    mov eax, dword ptr [ebp - local_1d8]         # 00492aa4
    mov ecx, dword ptr [ebp - local_1b8]         # 00492aaa
    mov ecx, dword ptr [ecx]                     # 00492ab0
    mov dword ptr [eax + 4*edx + field_2f31], ecx # 00492ab2
    mov edx, dword ptr [ebp - local_1b8]         # 00492ab9
    mov eax, dword ptr [edx + field_23]          # 00492abf
    push eax                                     # 00492ac2
    call FUN_0051dc43                            # 00492ac3
    add esp, 0x4                                 # 00492ac8
    mov dword ptr [ebp - local_1d0], eax         # 00492acb
    mov ecx, dword ptr [ebp - local_1d0]         # 00492ad1
    mov dword ptr [ebp - local_4], ecx           # 00492ad7
    cmp dword ptr [ebp - local_4], 0x0           # 00492ada
    jne.d8 L_00492af8                            # 00492ade
    # block 0x00492ae0: entered by fall-through of jne at 0x00492ade, 6 instruction(s), calls FUN_0052139c, FUN_004c97b4, falls into the block at 0x00492af8
    push 0x0                                     # 00492ae0
    push 0x0                                     # 00492ae2
    push 0x54f2c8                                # 00492ae4
    call FUN_0052139c                            # 00492ae9
    mov ecx, 0x5cf659                            # 00492aee
    call FUN_004c97b4                            # 00492af3
L_00492af8:
    # block 0x00492af8: entered by jne at 0x00492ade, 13 instruction(s), ends with forward jump to 0x00492b35
    mov edx, dword ptr [ebp - local_1b8]         # 00492af8
    mov ecx, dword ptr [edx + field_23]          # 00492afe
    mov eax, dword ptr [ebp - local_1b8]         # 00492b01
    mov esi, dword ptr [eax]                     # 00492b07
    mov edi, dword ptr [ebp - local_4]           # 00492b09
    {load} mov edx, ecx                          # 00492b0c
    shr ecx, 0x2                                 # 00492b0e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00492b11
    {load} mov ecx, edx                          # 00492b13
    and ecx, 0x3                                 # 00492b15
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00492b18
    mov dword ptr [ebp - local_1bc], 0x0         # 00492b1a
    jmp.d8 L_00492b35                            # 00492b24
L_00492b26:
    # block 0x00492b26: entered by jmp at 0x00492c39, 3 instruction(s), falls into the block at 0x00492b35
    mov eax, dword ptr [ebp - local_1bc]         # 00492b26
    add eax, 0x1                                 # 00492b2c
    mov dword ptr [ebp - local_1bc], eax         # 00492b2f
L_00492b35:
    # block 0x00492b35: entered by jmp at 0x00492b24, 4 instruction(s), ends with jge to 0x00492c3e (forward)
    mov ecx, dword ptr [ebp - local_1b8]         # 00492b35
    movsx edx, word ptr [ecx + field_2d]         # 00492b3b
    cmp dword ptr [ebp - local_1bc], edx         # 00492b3f
    jge.d32 L_00492c3e                           # 00492b45
    # block 0x00492b4b: entered by fall-through of jge at 0x00492b45, 2 instruction(s), ends with forward jump to 0x00492b66
    mov dword ptr [ebp - local_1b4], 0x0         # 00492b4b
    jmp.d8 L_00492b66                            # 00492b55
L_00492b57:
    # block 0x00492b57: entered by jmp at 0x00492c34, 3 instruction(s), falls into the block at 0x00492b66
    mov eax, dword ptr [ebp - local_1b4]         # 00492b57
    add eax, 0x1                                 # 00492b5d
    mov dword ptr [ebp - local_1b4], eax         # 00492b60
L_00492b66:
    # block 0x00492b66: entered by jmp at 0x00492b55, 4 instruction(s), ends with jge to 0x00492c39 (forward)
    mov ecx, dword ptr [ebp - local_1b8]         # 00492b66
    movsx edx, word ptr [ecx + field_2b]         # 00492b6c
    cmp dword ptr [ebp - local_1b4], edx         # 00492b70
    jge.d32 L_00492c39                           # 00492b76
    # block 0x00492b7c: entered by fall-through of jge at 0x00492b76, 43 instruction(s), ends with backward jump to 0x00492b57
    mov eax, dword ptr [ebp - local_1b8]         # 00492b7c
    movsx ecx, word ptr [eax + field_2f]         # 00492b82
    mov edx, dword ptr [ebp - local_1bc]         # 00492b86
    imul edx, ecx                                # 00492b8c
    mov eax, dword ptr [ebp - local_4]           # 00492b8f
    {load} add eax, edx                          # 00492b92
    movsx ecx, word ptr [0x639895]               # 00492b94
    mov edx, dword ptr [ebp - local_1b4]         # 00492b9b
    imul edx, ecx                                # 00492ba1
    mov ecx, dword ptr [ebp - local_1b8]         # 00492ba4
    movsx ecx, word ptr [ecx + field_2f]         # 00492baa
    mov esi, dword ptr [ebp - local_1b4]         # 00492bae
    imul esi, ecx                                # 00492bb4
    mov ecx, dword ptr [ebp - local_1b8]         # 00492bb7
    mov ecx, dword ptr [ecx]                     # 00492bbd
    {load} add ecx, esi                          # 00492bbf
    movsx esi, word ptr [0x639895]               # 00492bc1
    mov edi, dword ptr [ebp - local_1bc]         # 00492bc8
    imul edi, esi                                # 00492bce
    mov dl, byte ptr [eax + edx]                 # 00492bd1
    mov byte ptr [ecx + edi], dl                 # 00492bd4
    mov eax, dword ptr [ebp - local_1b8]         # 00492bd7
    movsx ecx, word ptr [eax + field_2f]         # 00492bdd
    mov edx, dword ptr [ebp - local_1bc]         # 00492be1
    imul edx, ecx                                # 00492be7
    mov eax, dword ptr [ebp - local_4]           # 00492bea
    {load} add eax, edx                          # 00492bed
    movsx ecx, word ptr [0x639895]               # 00492bef
    mov edx, dword ptr [ebp - local_1b4]         # 00492bf6
    imul edx, ecx                                # 00492bfc
    mov ecx, dword ptr [ebp - local_1b8]         # 00492bff
    movsx ecx, word ptr [ecx + field_2f]         # 00492c05
    mov esi, dword ptr [ebp - local_1b4]         # 00492c09
    imul esi, ecx                                # 00492c0f
    mov ecx, dword ptr [ebp - local_1b8]         # 00492c12
    mov ecx, dword ptr [ecx]                     # 00492c18
    {load} add ecx, esi                          # 00492c1a
    movsx esi, word ptr [0x639895]               # 00492c1c
    mov edi, dword ptr [ebp - local_1bc]         # 00492c23
    imul edi, esi                                # 00492c29
    mov dl, byte ptr [eax + edx + field_1]       # 00492c2c
    mov byte ptr [ecx + edi + field_1], dl       # 00492c30
    jmp.d32 L_00492b57                           # 00492c34
L_00492c39:
    # block 0x00492c39: entered by jge at 0x00492b76, 1 instruction(s), ends with backward jump to 0x00492b26
    jmp.d32 L_00492b26                           # 00492c39
L_00492c3e:
    # block 0x00492c3e: entered by jge at 0x00492b45, 17 instruction(s), calls FUN_0051dc6c, FUN_004933ff, ends with je to 0x00492cb5 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00492c3e
    mov dword ptr [ebp - local_1d4], eax         # 00492c41
    mov ecx, dword ptr [ebp - local_1d4]         # 00492c47
    push ecx                                     # 00492c4d
    call FUN_0051dc6c                            # 00492c4e
    add esp, 0x4                                 # 00492c53
    mov edx, dword ptr [ebp - local_1d8]         # 00492c56
    mov eax, dword ptr [edx + field_45a1]        # 00492c5c
    push eax                                     # 00492c62
    push 0x1                                     # 00492c63
    mov ecx, dword ptr [ebp - local_1b8]         # 00492c65
    push ecx                                     # 00492c6b
    mov ecx, dword ptr [ebp - local_1d8]         # 00492c6c
    call FUN_004933ff                            # 00492c72
    movsx edx, word ptr [0x63a4cd]               # 00492c77
    test edx, edx                                # 00492c7e
    je.d8 L_00492cb5                             # 00492c80
    # block 0x00492c82: entered by fall-through of je at 0x00492c80, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00492cb5
    lea eax, [ebp - local_1b0]                   # 00492c82
    push eax                                     # 00492c88
    mov ecx, dword ptr [ebp - local_1d8]         # 00492c89
    mov edx, dword ptr [ecx + field_45a1]        # 00492c8f
    push edx                                     # 00492c95
    push 0x54f30c                                # 00492c96
    push 0x63888b                                # 00492c9b
    call FUN_0050ca3e                            # 00492ca0
    add esp, 0x10                                # 00492ca5
    push 0x63888b                                # 00492ca8
    call FUN_0044a2b7                            # 00492cad
    add esp, 0x4                                 # 00492cb2
L_00492cb5:
    # block 0x00492cb5: entered by je at 0x00492a20; je at 0x00492c80, 6 instruction(s), ends with forward jump to 0x00492f42
    mov eax, dword ptr [ebp - local_1d8]         # 00492cb5
    mov ecx, dword ptr [eax + field_45a1]        # 00492cbb
    add ecx, 0x1                                 # 00492cc1
    mov edx, dword ptr [ebp - local_1d8]         # 00492cc4
    mov dword ptr [edx + field_45a1], ecx        # 00492cca
    jmp.d32 L_00492f42                           # 00492cd0
L_00492cd5:
    # block 0x00492cd5: entered by switch case, 5 instruction(s), ends with je to 0x00492dee (forward)
    mov eax, dword ptr [ebp - local_1d8]         # 00492cd5
    mov ecx, dword ptr [eax + field_45a9]        # 00492cdb
    mov edx, dword ptr [ebp - local_1d8]         # 00492ce1
    cmp dword ptr [edx + 4*ecx + field_4539], 0x0 # 00492ce7
    je.d32 L_00492dee                            # 00492cef
    # block 0x00492cf5: entered by fall-through of je at 0x00492cef, 38 instruction(s), calls FUN_004c2790, FUN_004933ff, ends with je to 0x00492dee (forward)
    mov eax, dword ptr [ebp - local_1d8]         # 00492cf5
    mov ecx, dword ptr [eax + field_45a9]        # 00492cfb
    mov edx, dword ptr [ebp - local_1d8]         # 00492d01
    mov dword ptr [edx + 4*ecx + field_4539], 0x0 # 00492d07
    push 0x54f354                                # 00492d12
    push 0x6                                     # 00492d17
    lea eax, [ebp - local_1b0]                   # 00492d19
    push eax                                     # 00492d1f
    push 0x54f370                                # 00492d20
    mov ecx, 0x5cf659                            # 00492d25
    call FUN_004c2790                            # 00492d2a
    mov ecx, dword ptr [ebp - local_1d8]         # 00492d2f
    mov edx, dword ptr [ecx + field_45a9]        # 00492d35
    mov ecx, dword ptr [ebp - local_1d8]         # 00492d3b
    mov dword ptr [ecx + 4*edx + field_242d], eax # 00492d41
    mov edx, dword ptr [ebp - local_1d8]         # 00492d48
    mov eax, dword ptr [edx + field_45a9]        # 00492d4e
    mov ecx, dword ptr [ebp - local_1d8]         # 00492d54
    mov edx, dword ptr [ecx + 4*eax + field_242d] # 00492d5a
    mov eax, dword ptr [ebp - local_1d8]         # 00492d61
    mov ecx, dword ptr [eax + field_45a9]        # 00492d67
    mov eax, dword ptr [ebp - local_1d8]         # 00492d6d
    mov edx, dword ptr [edx]                     # 00492d73
    mov dword ptr [eax + 4*ecx + field_3ed1], edx # 00492d75
    mov eax, dword ptr [ebp - local_1d8]         # 00492d7c
    mov ecx, dword ptr [eax + field_45a9]        # 00492d82
    push ecx                                     # 00492d88
    push 0x2                                     # 00492d89
    mov edx, dword ptr [ebp - local_1d8]         # 00492d8b
    mov eax, dword ptr [edx + field_45a9]        # 00492d91
    mov ecx, dword ptr [ebp - local_1d8]         # 00492d97
    mov edx, dword ptr [ecx + 4*eax + field_242d] # 00492d9d
    push edx                                     # 00492da4
    mov ecx, dword ptr [ebp - local_1d8]         # 00492da5
    call FUN_004933ff                            # 00492dab
    movsx eax, word ptr [0x63a4cd]               # 00492db0
    test eax, eax                                # 00492db7
    je.d8 L_00492dee                             # 00492db9
    # block 0x00492dbb: entered by fall-through of je at 0x00492db9, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00492dee
    lea ecx, [ebp - local_1b0]                   # 00492dbb
    push ecx                                     # 00492dc1
    mov edx, dword ptr [ebp - local_1d8]         # 00492dc2
    mov eax, dword ptr [edx + field_45a9]        # 00492dc8
    push eax                                     # 00492dce
    push 0x54f378                                # 00492dcf
    push 0x63888b                                # 00492dd4
    call FUN_0050ca3e                            # 00492dd9
    add esp, 0x10                                # 00492dde
    push 0x63888b                                # 00492de1
    call FUN_0044a2b7                            # 00492de6
    add esp, 0x4                                 # 00492deb
L_00492dee:
    # block 0x00492dee: entered by je at 0x00492cef; je at 0x00492db9, 6 instruction(s), ends with forward jump to 0x00492f42
    mov ecx, dword ptr [ebp - local_1d8]         # 00492dee
    mov edx, dword ptr [ecx + field_45a9]        # 00492df4
    add edx, 0x1                                 # 00492dfa
    mov eax, dword ptr [ebp - local_1d8]         # 00492dfd
    mov dword ptr [eax + field_45a9], edx        # 00492e03
    jmp.d32 L_00492f42                           # 00492e09
L_00492e0e:
    # block 0x00492e0e: entered by switch case, 5 instruction(s), ends with je to 0x00492f27 (forward)
    mov ecx, dword ptr [ebp - local_1d8]         # 00492e0e
    mov edx, dword ptr [ecx + field_45a5]        # 00492e14
    mov eax, dword ptr [ebp - local_1d8]         # 00492e1a
    cmp dword ptr [eax + 4*edx + field_43e5], 0x0 # 00492e20
    je.d32 L_00492f27                            # 00492e28
    # block 0x00492e2e: entered by fall-through of je at 0x00492e28, 38 instruction(s), calls FUN_004c2790, FUN_004933ff, ends with je to 0x00492f27 (forward)
    mov ecx, dword ptr [ebp - local_1d8]         # 00492e2e
    mov edx, dword ptr [ecx + field_45a5]        # 00492e34
    mov eax, dword ptr [ebp - local_1d8]         # 00492e3a
    mov dword ptr [eax + 4*edx + field_43e5], 0x0 # 00492e40
    push 0x54f3bc                                # 00492e4b
    push 0x6                                     # 00492e50
    lea ecx, [ebp - local_1b0]                   # 00492e52
    push ecx                                     # 00492e58
    push 0x54f3d8                                # 00492e59
    mov ecx, 0x5cf659                            # 00492e5e
    call FUN_004c2790                            # 00492e63
    mov edx, dword ptr [ebp - local_1d8]         # 00492e68
    mov ecx, dword ptr [edx + field_45a5]        # 00492e6e
    mov edx, dword ptr [ebp - local_1d8]         # 00492e74
    mov dword ptr [edx + 4*ecx + field_22d9], eax # 00492e7a
    mov eax, dword ptr [ebp - local_1d8]         # 00492e81
    mov ecx, dword ptr [eax + field_45a5]        # 00492e87
    mov edx, dword ptr [ebp - local_1d8]         # 00492e8d
    mov eax, dword ptr [edx + 4*ecx + field_22d9] # 00492e93
    mov ecx, dword ptr [ebp - local_1d8]         # 00492e9a
    mov edx, dword ptr [ecx + field_45a5]        # 00492ea0
    mov ecx, dword ptr [ebp - local_1d8]         # 00492ea6
    mov eax, dword ptr [eax]                     # 00492eac
    mov dword ptr [ecx + 4*edx + field_3431], eax # 00492eae
    mov ecx, dword ptr [ebp - local_1d8]         # 00492eb5
    mov edx, dword ptr [ecx + field_45a5]        # 00492ebb
    push edx                                     # 00492ec1
    push 0x3                                     # 00492ec2
    mov eax, dword ptr [ebp - local_1d8]         # 00492ec4
    mov ecx, dword ptr [eax + field_45a5]        # 00492eca
    mov edx, dword ptr [ebp - local_1d8]         # 00492ed0
    mov eax, dword ptr [edx + 4*ecx + field_22d9] # 00492ed6
    push eax                                     # 00492edd
    mov ecx, dword ptr [ebp - local_1d8]         # 00492ede
    call FUN_004933ff                            # 00492ee4
    movsx ecx, word ptr [0x63a4cd]               # 00492ee9
    test ecx, ecx                                # 00492ef0
    je.d8 L_00492f27                             # 00492ef2
    # block 0x00492ef4: entered by fall-through of je at 0x00492ef2, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00492f27
    lea edx, [ebp - local_1b0]                   # 00492ef4
    push edx                                     # 00492efa
    mov eax, dword ptr [ebp - local_1d8]         # 00492efb
    mov ecx, dword ptr [eax + field_45a5]        # 00492f01
    push ecx                                     # 00492f07
    push 0x54f3e0                                # 00492f08
    push 0x63888b                                # 00492f0d
    call FUN_0050ca3e                            # 00492f12
    add esp, 0x10                                # 00492f17
    push 0x63888b                                # 00492f1a
    call FUN_0044a2b7                            # 00492f1f
    add esp, 0x4                                 # 00492f24
L_00492f27:
    # block 0x00492f27: entered by je at 0x00492e28; je at 0x00492ef2, 5 instruction(s), falls into the block at 0x00492f42
    mov edx, dword ptr [ebp - local_1d8]         # 00492f27
    mov eax, dword ptr [edx + field_45a5]        # 00492f2d
    add eax, 0x1                                 # 00492f33
    mov ecx, dword ptr [ebp - local_1d8]         # 00492f36
    mov dword ptr [ecx + field_45a5], eax        # 00492f3c
L_00492f42:
    # block 0x00492f42: entered by ja at 0x00492724; jmp at 0x00492a01; jmp at 0x00492cd0; jmp at 0x00492e09, 1 instruction(s), ends with backward jump to 0x00492580
    jmp.d32 L_00492580                           # 00492f42
L_00492f47:
    # block 0x00492f47: entered by jge at 0x00492590, 3 instruction(s), ends with forward jump to 0x00492f60
    mov dword ptr [ebp - local_10], 0x0          # 00492f47
    mov dword ptr [ebp - local_c], 0x0           # 00492f4e
    jmp.d8 L_00492f60                            # 00492f55
L_00492f57:
    # block 0x00492f57: entered by jmp at 0x00492fc4, 3 instruction(s), falls into the block at 0x00492f60
    mov edx, dword ptr [ebp - local_c]           # 00492f57
    add edx, 0x1                                 # 00492f5a
    mov dword ptr [ebp - local_c], edx           # 00492f5d
L_00492f60:
    # block 0x00492f60: entered by jmp at 0x00492f55, 2 instruction(s), ends with jge to 0x00492fc6 (forward)
    cmp dword ptr [ebp - local_c], 0x55          # 00492f60
    jge.d8 L_00492fc6                            # 00492f64
    # block 0x00492f66: entered by fall-through of jge at 0x00492f64, 4 instruction(s), ends with je to 0x00492fc4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00492f66
    mov ecx, dword ptr [ebp - local_1d8]         # 00492f69
    cmp dword ptr [ecx + 4*eax + field_41f1], 0x0 # 00492f6f
    je.d8 L_00492fc4                             # 00492f77
    # block 0x00492f79: entered by fall-through of je at 0x00492f77, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x00492fc4 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00492f79
    add edx, 0x1                                 # 00492f7c
    mov dword ptr [ebp - local_10], edx          # 00492f7f
    mov eax, dword ptr [ebp - local_c]           # 00492f82
    push eax                                     # 00492f85
    push 0x54f420                                # 00492f86
    lea ecx, [ebp - local_b0]                    # 00492f8b
    push ecx                                     # 00492f91
    call FUN_0050ca3e                            # 00492f92
    add esp, 0xc                                 # 00492f97
    push 0x0                                     # 00492f9a
    push 0x0                                     # 00492f9c
    lea edx, [ebp - local_b0]                    # 00492f9e
    push edx                                     # 00492fa4
    call FUN_0052139c                            # 00492fa5
    movsx eax, word ptr [0x63a4cd]               # 00492faa
    test eax, eax                                # 00492fb1
    je.d8 L_00492fc4                             # 00492fb3
    # block 0x00492fb5: entered by fall-through of je at 0x00492fb3, 4 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00492fc4
    lea ecx, [ebp - local_b0]                    # 00492fb5
    push ecx                                     # 00492fbb
    call FUN_0044a2b7                            # 00492fbc
    add esp, 0x4                                 # 00492fc1
L_00492fc4:
    # block 0x00492fc4: entered by je at 0x00492f77; je at 0x00492fb3, 1 instruction(s), ends with backward jump to 0x00492f57
    jmp.d8 L_00492f57                            # 00492fc4
L_00492fc6:
    # block 0x00492fc6: entered by jge at 0x00492f64, 2 instruction(s), ends with forward jump to 0x00492fd8
    mov dword ptr [ebp - local_c], 0x0           # 00492fc6
    jmp.d8 L_00492fd8                            # 00492fcd
L_00492fcf:
    # block 0x00492fcf: entered by jmp at 0x0049303c, 3 instruction(s), falls into the block at 0x00492fd8
    mov edx, dword ptr [ebp - local_c]           # 00492fcf
    add edx, 0x1                                 # 00492fd2
    mov dword ptr [ebp - local_c], edx           # 00492fd5
L_00492fd8:
    # block 0x00492fd8: entered by jmp at 0x00492fcd, 2 instruction(s), ends with jge to 0x0049303e (forward)
    cmp dword ptr [ebp - local_c], 0x28          # 00492fd8
    jge.d8 L_0049303e                            # 00492fdc
    # block 0x00492fde: entered by fall-through of jge at 0x00492fdc, 4 instruction(s), ends with je to 0x0049303c (forward)
    mov eax, dword ptr [ebp - local_c]           # 00492fde
    mov ecx, dword ptr [ebp - local_1d8]         # 00492fe1
    cmp dword ptr [ecx + 4*eax + field_4345], 0x0 # 00492fe7
    je.d8 L_0049303c                             # 00492fef
    # block 0x00492ff1: entered by fall-through of je at 0x00492fef, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0049303c (forward)
    mov edx, dword ptr [ebp - local_10]          # 00492ff1
    add edx, 0x1                                 # 00492ff4
    mov dword ptr [ebp - local_10], edx          # 00492ff7
    mov eax, dword ptr [ebp - local_c]           # 00492ffa
    push eax                                     # 00492ffd
    push 0x54f484                                # 00492ffe
    lea ecx, [ebp - local_b0]                    # 00493003
    push ecx                                     # 00493009
    call FUN_0050ca3e                            # 0049300a
    add esp, 0xc                                 # 0049300f
    push 0x0                                     # 00493012
    push 0x0                                     # 00493014
    lea edx, [ebp - local_b0]                    # 00493016
    push edx                                     # 0049301c
    call FUN_0052139c                            # 0049301d
    movsx eax, word ptr [0x63a4cd]               # 00493022
    test eax, eax                                # 00493029
    je.d8 L_0049303c                             # 0049302b
    # block 0x0049302d: entered by fall-through of je at 0x0049302b, 4 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0049303c
    lea ecx, [ebp - local_b0]                    # 0049302d
    push ecx                                     # 00493033
    call FUN_0044a2b7                            # 00493034
    add esp, 0x4                                 # 00493039
L_0049303c:
    # block 0x0049303c: entered by je at 0x00492fef; je at 0x0049302b, 1 instruction(s), ends with backward jump to 0x00492fcf
    jmp.d8 L_00492fcf                            # 0049303c
L_0049303e:
    # block 0x0049303e: entered by jge at 0x00492fdc, 2 instruction(s), ends with forward jump to 0x00493050
    mov dword ptr [ebp - local_c], 0x0           # 0049303e
    jmp.d8 L_00493050                            # 00493045
L_00493047:
    # block 0x00493047: entered by jmp at 0x004930b4, 3 instruction(s), falls into the block at 0x00493050
    mov edx, dword ptr [ebp - local_c]           # 00493047
    add edx, 0x1                                 # 0049304a
    mov dword ptr [ebp - local_c], edx           # 0049304d
L_00493050:
    # block 0x00493050: entered by jmp at 0x00493045, 2 instruction(s), ends with jge to 0x004930b6 (forward)
    cmp dword ptr [ebp - local_c], 0x55          # 00493050
    jge.d8 L_004930b6                            # 00493054
    # block 0x00493056: entered by fall-through of jge at 0x00493054, 4 instruction(s), ends with je to 0x004930b4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00493056
    mov ecx, dword ptr [ebp - local_1d8]         # 00493059
    cmp dword ptr [ecx + 4*eax + field_43e5], 0x0 # 0049305f
    je.d8 L_004930b4                             # 00493067
    # block 0x00493069: entered by fall-through of je at 0x00493067, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x004930b4 (forward)
    mov edx, dword ptr [ebp - local_10]          # 00493069
    add edx, 0x1                                 # 0049306c
    mov dword ptr [ebp - local_10], edx          # 0049306f
    mov eax, dword ptr [ebp - local_c]           # 00493072
    push eax                                     # 00493075
    push 0x54f4f0                                # 00493076
    lea ecx, [ebp - local_b0]                    # 0049307b
    push ecx                                     # 00493081
    call FUN_0050ca3e                            # 00493082
    add esp, 0xc                                 # 00493087
    push 0x0                                     # 0049308a
    push 0x0                                     # 0049308c
    lea edx, [ebp - local_b0]                    # 0049308e
    push edx                                     # 00493094
    call FUN_0052139c                            # 00493095
    movsx eax, word ptr [0x63a4cd]               # 0049309a
    test eax, eax                                # 004930a1
    je.d8 L_004930b4                             # 004930a3
    # block 0x004930a5: entered by fall-through of je at 0x004930a3, 4 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004930b4
    lea ecx, [ebp - local_b0]                    # 004930a5
    push ecx                                     # 004930ab
    call FUN_0044a2b7                            # 004930ac
    add esp, 0x4                                 # 004930b1
L_004930b4:
    # block 0x004930b4: entered by je at 0x00493067; je at 0x004930a3, 1 instruction(s), ends with backward jump to 0x00493047
    jmp.d8 L_00493047                            # 004930b4
L_004930b6:
    # block 0x004930b6: entered by jge at 0x00493054, 2 instruction(s), ends with forward jump to 0x004930c8
    mov dword ptr [ebp - local_c], 0x0           # 004930b6
    jmp.d8 L_004930c8                            # 004930bd
L_004930bf:
    # block 0x004930bf: entered by jmp at 0x0049312c, 3 instruction(s), falls into the block at 0x004930c8
    mov edx, dword ptr [ebp - local_c]           # 004930bf
    add edx, 0x1                                 # 004930c2
    mov dword ptr [ebp - local_c], edx           # 004930c5
L_004930c8:
    # block 0x004930c8: entered by jmp at 0x004930bd, 2 instruction(s), ends with jge to 0x0049312e (forward)
    cmp dword ptr [ebp - local_c], 0x19          # 004930c8
    jge.d8 L_0049312e                            # 004930cc
    # block 0x004930ce: entered by fall-through of jge at 0x004930cc, 4 instruction(s), ends with je to 0x0049312c (forward)
    mov eax, dword ptr [ebp - local_c]           # 004930ce
    mov ecx, dword ptr [ebp - local_1d8]         # 004930d1
    cmp dword ptr [ecx + 4*eax + field_4539], 0x0 # 004930d7
    je.d8 L_0049312c                             # 004930df
    # block 0x004930e1: entered by fall-through of je at 0x004930df, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x0049312c (forward)
    mov edx, dword ptr [ebp - local_10]          # 004930e1
    add edx, 0x1                                 # 004930e4
    mov dword ptr [ebp - local_10], edx          # 004930e7
    mov eax, dword ptr [ebp - local_c]           # 004930ea
    push eax                                     # 004930ed
    push 0x54f554                                # 004930ee
    lea ecx, [ebp - local_b0]                    # 004930f3
    push ecx                                     # 004930f9
    call FUN_0050ca3e                            # 004930fa
    add esp, 0xc                                 # 004930ff
    push 0x0                                     # 00493102
    push 0x0                                     # 00493104
    lea edx, [ebp - local_b0]                    # 00493106
    push edx                                     # 0049310c
    call FUN_0052139c                            # 0049310d
    movsx eax, word ptr [0x63a4cd]               # 00493112
    test eax, eax                                # 00493119
    je.d8 L_0049312c                             # 0049311b
    # block 0x0049311d: entered by fall-through of je at 0x0049311b, 4 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0049312c
    lea ecx, [ebp - local_b0]                    # 0049311d
    push ecx                                     # 00493123
    call FUN_0044a2b7                            # 00493124
    add esp, 0x4                                 # 00493129
L_0049312c:
    # block 0x0049312c: entered by je at 0x004930df; je at 0x0049311b, 1 instruction(s), ends with backward jump to 0x004930bf
    jmp.d8 L_004930bf                            # 0049312c
L_0049312e:
    # block 0x0049312e: entered by jge at 0x004930cc, 2 instruction(s), ends with je to 0x0049313e (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 0049312e
    je.d8 L_0049313e                             # 00493132
    # block 0x00493134: entered by fall-through of je at 0x00493132, 2 instruction(s), calls FUN_004c97b4, falls into the block at 0x0049313e
    mov ecx, 0x5cf659                            # 00493134
    call FUN_004c97b4                            # 00493139
L_0049313e:
    # block 0x0049313e: entered by je at 0x00493132, 5 instruction(s), falls into the block at 0x0049315d
    mov edx, dword ptr [ebp - local_1d8]         # 0049313e
    mov dword ptr [edx + field_47d1], 0x0        # 00493144
    mov eax, dword ptr [ebp - local_1d8]         # 0049314e
    mov ecx, dword ptr [eax + field_2095]        # 00493154
    mov dword ptr [ebp - local_8], ecx           # 0049315a
L_0049315d:
    # block 0x0049315d: entered by jmp at 0x0049318a, 4 instruction(s), ends with jne to 0x0049318c (forward)
    mov edx, dword ptr [ebp - local_8]           # 0049315d
    and edx, 0x1                                 # 00493160
    test edx, edx                                # 00493163
    jne.d8 L_0049318c                            # 00493165
    # block 0x00493167: entered by fall-through of jne at 0x00493165, 9 instruction(s), ends with backward jump to 0x0049315d
    mov eax, dword ptr [ebp - local_8]           # 00493167
    sar eax                                      # 0049316a
    mov dword ptr [ebp - local_8], eax           # 0049316c
    mov ecx, dword ptr [ebp - local_1d8]         # 0049316f
    mov edx, dword ptr [ecx + field_47d1]        # 00493175
    add edx, 0x1                                 # 0049317b
    mov eax, dword ptr [ebp - local_1d8]         # 0049317e
    mov dword ptr [eax + field_47d1], edx        # 00493184
    jmp.d8 L_0049315d                            # 0049318a
L_0049318c:
    # block 0x0049318c: entered by jne at 0x00493165, 4 instruction(s), ends with forward jump to 0x004931ae
    mov ecx, dword ptr [ebp - local_1d8]         # 0049318c
    mov dword ptr [ecx + field_47d5], 0x0        # 00493192
    mov dword ptr [ebp - local_c], 0x0           # 0049319c
    jmp.d8 L_004931ae                            # 004931a3
L_004931a5:
    # block 0x004931a5: entered by jmp at 0x004931c9, 3 instruction(s), falls into the block at 0x004931ae
    mov edx, dword ptr [ebp - local_c]           # 004931a5
    add edx, 0x1                                 # 004931a8
    mov dword ptr [ebp - local_c], edx           # 004931ab
L_004931ae:
    # block 0x004931ae: entered by jmp at 0x004931a3, 2 instruction(s), ends with jge to 0x004931cb (forward)
    cmp dword ptr [ebp - local_c], 0x55          # 004931ae
    jge.d8 L_004931cb                            # 004931b2
    # block 0x004931b4: entered by fall-through of jge at 0x004931b2, 4 instruction(s), ends with je to 0x004931c9 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004931b4
    mov ecx, dword ptr [ebp - local_1d8]         # 004931b7
    cmp dword ptr [ecx + 4*eax + field_20e5], 0x0 # 004931bd
    je.d8 L_004931c9                             # 004931c5
    # block 0x004931c7: entered by fall-through of je at 0x004931c5, 1 instruction(s), ends with forward jump to 0x004931cb
    jmp.d8 L_004931cb                            # 004931c7
L_004931c9:
    # block 0x004931c9: entered by je at 0x004931c5, 1 instruction(s), ends with backward jump to 0x004931a5
    jmp.d8 L_004931a5                            # 004931c9
L_004931cb:
    # block 0x004931cb: entered by jge at 0x004931b2; jmp at 0x004931c7, 5 instruction(s), falls into the block at 0x004931e2
    mov edx, dword ptr [ebp - local_c]           # 004931cb
    mov eax, dword ptr [ebp - local_1d8]         # 004931ce
    mov ecx, dword ptr [eax + 4*edx + field_20e5] # 004931d4
    movsx edx, word ptr [ecx + field_2f]         # 004931db
    mov dword ptr [ebp - local_18], edx          # 004931df
L_004931e2:
    # block 0x004931e2: entered by jmp at 0x0049320f, 4 instruction(s), ends with jne to 0x00493211 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004931e2
    and eax, 0x1                                 # 004931e5
    test eax, eax                                # 004931e8
    jne.d8 L_00493211                            # 004931ea
    # block 0x004931ec: entered by fall-through of jne at 0x004931ea, 9 instruction(s), ends with backward jump to 0x004931e2
    mov ecx, dword ptr [ebp - local_18]          # 004931ec
    sar ecx                                      # 004931ef
    mov dword ptr [ebp - local_18], ecx          # 004931f1
    mov edx, dword ptr [ebp - local_1d8]         # 004931f4
    mov eax, dword ptr [edx + field_47d5]        # 004931fa
    add eax, 0x1                                 # 00493200
    mov ecx, dword ptr [ebp - local_1d8]         # 00493203
    mov dword ptr [ecx + field_47d5], eax        # 00493209
    jmp.d8 L_004931e2                            # 0049320f
L_00493211:
    # block 0x00493211: entered by jne at 0x004931ea, 4 instruction(s), ends with forward jump to 0x00493233
    mov edx, dword ptr [ebp - local_1d8]         # 00493211
    mov dword ptr [edx + field_47d9], 0x0        # 00493217
    mov dword ptr [ebp - local_c], 0x0           # 00493221
    jmp.d8 L_00493233                            # 00493228
L_0049322a:
    # block 0x0049322a: entered by jmp at 0x0049324e, 3 instruction(s), falls into the block at 0x00493233
    mov eax, dword ptr [ebp - local_c]           # 0049322a
    add eax, 0x1                                 # 0049322d
    mov dword ptr [ebp - local_c], eax           # 00493230
L_00493233:
    # block 0x00493233: entered by jmp at 0x00493228, 2 instruction(s), ends with jge to 0x00493250 (forward)
    cmp dword ptr [ebp - local_c], 0x55          # 00493233
    jge.d8 L_00493250                            # 00493237
    # block 0x00493239: entered by fall-through of jge at 0x00493237, 4 instruction(s), ends with je to 0x0049324e (forward)
    mov ecx, dword ptr [ebp - local_c]           # 00493239
    mov edx, dword ptr [ebp - local_1d8]         # 0049323c
    cmp dword ptr [edx + 4*ecx + field_20e5], 0x0 # 00493242
    je.d8 L_0049324e                             # 0049324a
    # block 0x0049324c: entered by fall-through of je at 0x0049324a, 1 instruction(s), ends with forward jump to 0x00493250
    jmp.d8 L_00493250                            # 0049324c
L_0049324e:
    # block 0x0049324e: entered by je at 0x0049324a, 1 instruction(s), ends with backward jump to 0x0049322a
    jmp.d8 L_0049322a                            # 0049324e
L_00493250:
    # block 0x00493250: entered by jge at 0x00493237; jmp at 0x0049324c, 5 instruction(s), falls into the block at 0x00493267
    mov eax, dword ptr [ebp - local_c]           # 00493250
    mov ecx, dword ptr [ebp - local_1d8]         # 00493253
    mov edx, dword ptr [ecx + 4*eax + field_20e5] # 00493259
    movsx eax, word ptr [edx + field_2f]         # 00493260
    mov dword ptr [ebp - local_18], eax          # 00493264
L_00493267:
    # block 0x00493267: entered by jmp at 0x00493294, 4 instruction(s), ends with jne to 0x00493296 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 00493267
    and ecx, 0x1                                 # 0049326a
    test ecx, ecx                                # 0049326d
    jne.d8 L_00493296                            # 0049326f
    # block 0x00493271: entered by fall-through of jne at 0x0049326f, 9 instruction(s), ends with backward jump to 0x00493267
    mov edx, dword ptr [ebp - local_18]          # 00493271
    sar edx                                      # 00493274
    mov dword ptr [ebp - local_18], edx          # 00493276
    mov eax, dword ptr [ebp - local_1d8]         # 00493279
    mov ecx, dword ptr [eax + field_47d9]        # 0049327f
    add ecx, 0x1                                 # 00493285
    mov edx, dword ptr [ebp - local_1d8]         # 00493288
    mov dword ptr [edx + field_47d9], ecx        # 0049328e
    jmp.d8 L_00493267                            # 00493294
L_00493296:
    # block 0x00493296: entered by jne at 0x0049326f, 4 instruction(s), ends with forward jump to 0x004932b8
    mov eax, dword ptr [ebp - local_1d8]         # 00493296
    mov dword ptr [eax + field_47dd], 0x0        # 0049329c
    mov dword ptr [ebp - local_c], 0x0           # 004932a6
    jmp.d8 L_004932b8                            # 004932ad
L_004932af:
    # block 0x004932af: entered by jmp at 0x004932d3, 3 instruction(s), falls into the block at 0x004932b8
    mov ecx, dword ptr [ebp - local_c]           # 004932af
    add ecx, 0x1                                 # 004932b2
    mov dword ptr [ebp - local_c], ecx           # 004932b5
L_004932b8:
    # block 0x004932b8: entered by jmp at 0x004932ad, 2 instruction(s), ends with jge to 0x004932d5 (forward)
    cmp dword ptr [ebp - local_c], 0x55          # 004932b8
    jge.d8 L_004932d5                            # 004932bc
    # block 0x004932be: entered by fall-through of jge at 0x004932bc, 4 instruction(s), ends with je to 0x004932d3 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004932be
    mov eax, dword ptr [ebp - local_1d8]         # 004932c1
    cmp dword ptr [eax + 4*edx + field_22d9], 0x0 # 004932c7
    je.d8 L_004932d3                             # 004932cf
    # block 0x004932d1: entered by fall-through of je at 0x004932cf, 1 instruction(s), ends with forward jump to 0x004932d5
    jmp.d8 L_004932d5                            # 004932d1
L_004932d3:
    # block 0x004932d3: entered by je at 0x004932cf, 1 instruction(s), ends with backward jump to 0x004932af
    jmp.d8 L_004932af                            # 004932d3
L_004932d5:
    # block 0x004932d5: entered by jge at 0x004932bc; jmp at 0x004932d1, 5 instruction(s), falls into the block at 0x004932ec
    mov ecx, dword ptr [ebp - local_c]           # 004932d5
    mov edx, dword ptr [ebp - local_1d8]         # 004932d8
    mov eax, dword ptr [edx + 4*ecx + field_22d9] # 004932de
    movsx ecx, word ptr [eax + field_2f]         # 004932e5
    mov dword ptr [ebp - local_18], ecx          # 004932e9
L_004932ec:
    # block 0x004932ec: entered by jmp at 0x00493319, 4 instruction(s), ends with jne to 0x0049331b (forward)
    mov edx, dword ptr [ebp - local_18]          # 004932ec
    and edx, 0x1                                 # 004932ef
    test edx, edx                                # 004932f2
    jne.d8 L_0049331b                            # 004932f4
    # block 0x004932f6: entered by fall-through of jne at 0x004932f4, 9 instruction(s), ends with backward jump to 0x004932ec
    mov eax, dword ptr [ebp - local_18]          # 004932f6
    sar eax                                      # 004932f9
    mov dword ptr [ebp - local_18], eax          # 004932fb
    mov ecx, dword ptr [ebp - local_1d8]         # 004932fe
    mov edx, dword ptr [ecx + field_47dd]        # 00493304
    add edx, 0x1                                 # 0049330a
    mov eax, dword ptr [ebp - local_1d8]         # 0049330d
    mov dword ptr [eax + field_47dd], edx        # 00493313
    jmp.d8 L_004932ec                            # 00493319
L_0049331b:
    # block 0x0049331b: entered by jne at 0x004932f4, 4 instruction(s), ends with forward jump to 0x0049333d
    mov ecx, dword ptr [ebp - local_1d8]         # 0049331b
    mov dword ptr [ecx + field_47e1], 0x0        # 00493321
    mov dword ptr [ebp - local_c], 0x0           # 0049332b
    jmp.d8 L_0049333d                            # 00493332
L_00493334:
    # block 0x00493334: entered by jmp at 0x00493358, 3 instruction(s), falls into the block at 0x0049333d
    mov edx, dword ptr [ebp - local_c]           # 00493334
    add edx, 0x1                                 # 00493337
    mov dword ptr [ebp - local_c], edx           # 0049333a
L_0049333d:
    # block 0x0049333d: entered by jmp at 0x00493332, 2 instruction(s), ends with jge to 0x0049335a (forward)
    cmp dword ptr [ebp - local_c], 0x19          # 0049333d
    jge.d8 L_0049335a                            # 00493341
    # block 0x00493343: entered by fall-through of jge at 0x00493341, 4 instruction(s), ends with je to 0x00493358 (forward)
    mov eax, dword ptr [ebp - local_c]           # 00493343
    mov ecx, dword ptr [ebp - local_1d8]         # 00493346
    cmp dword ptr [ecx + 4*eax + field_242d], 0x0 # 0049334c
    je.d8 L_00493358                             # 00493354
    # block 0x00493356: entered by fall-through of je at 0x00493354, 1 instruction(s), ends with forward jump to 0x0049335a
    jmp.d8 L_0049335a                            # 00493356
L_00493358:
    # block 0x00493358: entered by je at 0x00493354, 1 instruction(s), ends with backward jump to 0x00493334
    jmp.d8 L_00493334                            # 00493358
L_0049335a:
    # block 0x0049335a: entered by jge at 0x00493341; jmp at 0x00493356, 5 instruction(s), falls into the block at 0x00493371
    mov edx, dword ptr [ebp - local_c]           # 0049335a
    mov eax, dword ptr [ebp - local_1d8]         # 0049335d
    mov ecx, dword ptr [eax + 4*edx + field_242d] # 00493363
    movsx edx, word ptr [ecx + field_2f]         # 0049336a
    mov dword ptr [ebp - local_18], edx          # 0049336e
L_00493371:
    # block 0x00493371: entered by jmp at 0x0049339e, 4 instruction(s), ends with jne to 0x004933a0 (forward)
    mov eax, dword ptr [ebp - local_18]          # 00493371
    and eax, 0x1                                 # 00493374
    test eax, eax                                # 00493377
    jne.d8 L_004933a0                            # 00493379
    # block 0x0049337b: entered by fall-through of jne at 0x00493379, 9 instruction(s), ends with backward jump to 0x00493371
    mov ecx, dword ptr [ebp - local_18]          # 0049337b
    sar ecx                                      # 0049337e
    mov dword ptr [ebp - local_18], ecx          # 00493380
    mov edx, dword ptr [ebp - local_1d8]         # 00493383
    mov eax, dword ptr [edx + field_47e1]        # 00493389
    add eax, 0x1                                 # 0049338f
    mov ecx, dword ptr [ebp - local_1d8]         # 00493392
    mov dword ptr [ecx + field_47e1], eax        # 00493398
    jmp.d8 L_00493371                            # 0049339e
L_004933a0:
    # block 0x004933a0: entered by jne at 0x00493379, 4 instruction(s), falls into the block at 0x004933ba
    mov edx, dword ptr [ebp - local_1d8]         # 004933a0
    mov dword ptr [edx + field_47e5], 0x0        # 004933a6
    movsx eax, word ptr [0x639895]               # 004933b0
    mov dword ptr [ebp - local_14], eax          # 004933b7
L_004933ba:
    # block 0x004933ba: entered by jmp at 0x004933e7, 4 instruction(s), ends with jne to 0x004933e9 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004933ba
    and ecx, 0x1                                 # 004933bd
    test ecx, ecx                                # 004933c0
    jne.d8 L_004933e9                            # 004933c2
    # block 0x004933c4: entered by fall-through of jne at 0x004933c2, 9 instruction(s), ends with backward jump to 0x004933ba
    mov edx, dword ptr [ebp - local_14]          # 004933c4
    sar edx                                      # 004933c7
    mov dword ptr [ebp - local_14], edx          # 004933c9
    mov eax, dword ptr [ebp - local_1d8]         # 004933cc
    mov ecx, dword ptr [eax + field_47e5]        # 004933d2
    add ecx, 0x1                                 # 004933d8
    mov edx, dword ptr [ebp - local_1d8]         # 004933db
    mov dword ptr [edx + field_47e5], ecx        # 004933e1
    jmp.d8 L_004933ba                            # 004933e7
L_004933e9:
    # block 0x004933e9: entered by jne at 0x004933c2, 5 instruction(s), ends with ret
    pop edi                                      # 004933e9
    pop esi                                      # 004933ea
    {load} mov esp, ebp                          # 004933eb
    pop ebp                                      # 004933ed
    ret                                          # 004933ee

# --- data items (not part of the function) -------------------------
.org 0x004933ef - 0x401000
SWTAB_004933ef:  # 4 case address(es)
    .long L_00492737 - .text + 0x401000
    .long L_00492a06 - .text + 0x401000
    .long L_00492cd5 - .text + 0x401000
    .long L_00492e0e - .text + 0x401000
.set SWTAB_004933ef_VA, SWTAB_004933ef - .text + 0x401000

