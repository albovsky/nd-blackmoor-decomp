# FUN_004956d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004956d3
# extent:       0x004956d3-0x0049581a (327 code bytes)
# span:         0x004956d3-0x0049581a (code 327, tables 0, padding 0)
# sha256:       a379a066a85d7d7ab92746d528d1f23aa48cd23bb2a7ff384c12bc640c707630
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004956d3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_c, field_18, field_1eff; [ecx + n] field_c, field_10, field_14, field_1f03, field_201f, field_45c1, field_4765; [edx + n] field_8, field_c, field_26, field_1eff, field_1f03, field_201f
# callees:      calls FUN_0049581a, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 97 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_26, 0x26  # offset +0x26
.equ field_1eff, 0x1eff  # offset +0x1eff
.equ field_1f03, 0x1f03  # offset +0x1f03
.equ field_201f, 0x201f  # offset +0x201f
.equ field_45c1, 0x45c1  # offset +0x45c1
.equ field_4765, 0x4765  # offset +0x4765

# --- external targets -----------------------------------------------
.set FUN_0049581a, .text + (0x0049581a - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004956d3 - 0x401000
.globl FUN_004956d3
FUN_004956d3:
    # block 0x004956d3: entry, 8 instruction(s), ends with forward jump to 0x004956f0
    push ebp                                     # 004956d3
    {load} mov ebp, esp                          # 004956d4
    sub esp, 0x1c                                # 004956d6
    push esi                                     # 004956d9
    push edi                                     # 004956da
    mov dword ptr [ebp - local_14], ecx          # 004956db
    mov dword ptr [ebp - local_8], 0x0           # 004956de
    jmp.d8 L_004956f0                            # 004956e5
L_004956e7:
    # block 0x004956e7: entered by jmp at 0x0049571d; jmp at 0x0049580f, 3 instruction(s), falls into the block at 0x004956f0
    mov eax, dword ptr [ebp - local_8]           # 004956e7
    add eax, 0x1                                 # 004956ea
    mov dword ptr [ebp - local_8], eax           # 004956ed
L_004956f0:
    # block 0x004956f0: entered by jmp at 0x004956e5, 4 instruction(s), ends with jge to 0x00495814 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004956f0
    mov edx, dword ptr [ebp - local_8]           # 004956f3
    cmp edx, dword ptr [ecx + field_4765]        # 004956f6
    jge.d32 L_00495814                           # 004956fc
    # block 0x00495702: entered by fall-through of jge at 0x004956fc, 8 instruction(s), ends with jne to 0x0049571f (forward)
    mov eax, dword ptr [ebp - local_8]           # 00495702
    imul eax, eax, 0x1c                          # 00495705
    mov ecx, dword ptr [ebp - local_14]          # 00495708
    lea edx, [ecx + eax + field_45c1]            # 0049570b
    mov dword ptr [ebp - local_10], edx          # 00495712
    mov eax, dword ptr [ebp - local_10]          # 00495715
    cmp dword ptr [eax], 0x0                     # 00495718
    jne.d8 L_0049571f                            # 0049571b
    # block 0x0049571d: entered by fall-through of jne at 0x0049571b, 1 instruction(s), ends with backward jump to 0x004956e7
    jmp.d8 L_004956e7                            # 0049571d
L_0049571f:
    # block 0x0049571f: entered by jne at 0x0049571b, 11 instruction(s), ends with je to 0x00495745 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0049571f
    mov edx, dword ptr [ecx + field_14]          # 00495722
    mov dword ptr [ebp - local_4], edx           # 00495725
    mov eax, dword ptr [ebp - local_10]          # 00495728
    mov ecx, dword ptr [eax + field_18]          # 0049572b
    mov dword ptr [ebp - local_c], ecx           # 0049572e
    mov edx, dword ptr [ebp - local_10]          # 00495731
    mov eax, dword ptr [edx + field_8]           # 00495734
    mov dword ptr [ebp - local_18], eax          # 00495737
    cmp dword ptr [ebp - local_18], 0x2          # 0049573a
    je.d8 L_00495745                             # 0049573e
    # block 0x00495740: entered by fall-through of je at 0x0049573e, 1 instruction(s), ends with forward jump to 0x0049580f
    jmp.d32 L_0049580f                           # 00495740
L_00495745:
    # block 0x00495745: entered by je at 0x0049573e, 5 instruction(s), ends with je to 0x0049575f (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00495745
    mov edx, dword ptr [ecx + field_10]          # 00495748
    mov dword ptr [ebp - local_1c], edx          # 0049574b
    cmp dword ptr [ebp - local_1c], 0x0          # 0049574e
    je.d8 L_0049575f                             # 00495752
    # block 0x00495754: entered by fall-through of je at 0x00495752, 2 instruction(s), ends with je to 0x0049578a (forward)
    cmp dword ptr [ebp - local_1c], 0x1          # 00495754
    je.d8 L_0049578a                             # 00495758
    # block 0x0049575a: entered by fall-through of je at 0x00495758, 1 instruction(s), ends with forward jump to 0x0049580f
    jmp.d32 L_0049580f                           # 0049575a
L_0049575f:
    # block 0x0049575f: entered by je at 0x00495752, 4 instruction(s), ends with jne to 0x0049577b (forward)
    mov eax, dword ptr [ebp - local_14]          # 0049575f
    mov ecx, dword ptr [eax + field_1eff]        # 00495762
    cmp ecx, dword ptr [ebp - local_4]           # 00495768
    jne.d8 L_0049577b                            # 0049576b
    # block 0x0049576d: entered by fall-through of jne at 0x0049576b, 4 instruction(s), ends with je to 0x00495785 (forward)
    mov edx, dword ptr [ebp - local_14]          # 0049576d
    mov eax, dword ptr [edx + field_1f03]        # 00495770
    cmp eax, dword ptr [ebp - local_c]           # 00495776
    je.d8 L_00495785                             # 00495779
L_0049577b:
    # block 0x0049577b: entered by jne at 0x0049576b; fall-through of je at 0x00495779, 2 instruction(s), falls into the block at 0x00495785
    mov ecx, dword ptr [ebp - local_10]          # 0049577b
    mov dword ptr [ecx + field_10], 0x1          # 0049577e
L_00495785:
    # block 0x00495785: entered by je at 0x00495779, 1 instruction(s), ends with forward jump to 0x0049580f
    jmp.d32 L_0049580f                           # 00495785
L_0049578a:
    # block 0x0049578a: entered by je at 0x00495758, 4 instruction(s), ends with jne to 0x0049580f (forward)
    mov edx, dword ptr [ebp - local_14]          # 0049578a
    mov eax, dword ptr [edx + field_1eff]        # 0049578d
    cmp eax, dword ptr [ebp - local_4]           # 00495793
    jne.d8 L_0049580f                            # 00495796
    # block 0x00495798: entered by fall-through of jne at 0x00495796, 4 instruction(s), ends with jne to 0x0049580f (forward)
    mov ecx, dword ptr [ebp - local_14]          # 00495798
    mov edx, dword ptr [ecx + field_1f03]        # 0049579b
    cmp edx, dword ptr [ebp - local_c]           # 004957a1
    jne.d8 L_0049580f                            # 004957a4
    # block 0x004957a6: entered by fall-through of jne at 0x004957a4, 3 instruction(s), ends with je to 0x004957bb (forward)
    mov eax, dword ptr [ebp - local_10]          # 004957a6
    cmp dword ptr [eax + field_c], 0x0           # 004957a9
    je.d8 L_004957bb                             # 004957ad
    # block 0x004957af: entered by fall-through of je at 0x004957ad, 3 instruction(s), ends with forward jump to 0x004957c5
    mov ecx, dword ptr [ebp - local_10]          # 004957af
    mov dword ptr [ecx + field_c], 0x0           # 004957b2
    jmp.d8 L_004957c5                            # 004957b9
L_004957bb:
    # block 0x004957bb: entered by je at 0x004957ad, 2 instruction(s), falls into the block at 0x004957c5
    mov edx, dword ptr [ebp - local_10]          # 004957bb
    mov dword ptr [edx + field_c], 0x1           # 004957be
L_004957c5:
    # block 0x004957c5: entered by jmp at 0x004957b9, 14 instruction(s), calls FUN_0049581a, ends with je to 0x0049580f (forward)
    mov eax, dword ptr [ebp - local_8]           # 004957c5
    push eax                                     # 004957c8
    mov ecx, dword ptr [ebp - local_14]          # 004957c9
    call FUN_0049581a                            # 004957cc
    mov ecx, dword ptr [ebp - local_10]          # 004957d1
    mov dword ptr [ecx + field_10], 0x0          # 004957d4
    mov edi, 0x54f8a0                            # 004957db
    mov edx, dword ptr [ebp - local_14]          # 004957e0
    mov esi, dword ptr [edx + field_201f]        # 004957e3
    add esi, 0x5                                 # 004957e9
    mov ecx, 0x9                                 # 004957ec
    {load} xor eax, eax                          # 004957f1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004957f3
    je.d8 L_0049580f                             # 004957f5
    # block 0x004957f7: entered by fall-through of je at 0x004957f5, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x0049580f
    mov ecx, dword ptr [ebp - local_14]          # 004957f7
    mov edx, dword ptr [ecx + field_201f]        # 004957fa
    mov ax, word ptr [edx + field_26]            # 00495800
    push eax                                     # 00495804
    mov ecx, 0x5c3a67                            # 00495805
    call FUN_004fb2e3                            # 0049580a
L_0049580f:
    # block 0x0049580f: entered by jmp at 0x00495740; jmp at 0x0049575a; jmp at 0x00495785; jne at 0x00495796; more, 1 instruction(s), ends with backward jump to 0x004956e7
    jmp.d32 L_004956e7                           # 0049580f
L_00495814:
    # block 0x00495814: entered by jge at 0x004956fc, 5 instruction(s), ends with ret
    pop edi                                      # 00495814
    pop esi                                      # 00495815
    {load} mov esp, ebp                          # 00495816
    pop ebp                                      # 00495818
    ret                                          # 00495819

