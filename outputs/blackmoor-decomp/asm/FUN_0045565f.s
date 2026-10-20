# FUN_0045565f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045565f
# extent:       0x0045565f-0x00455a0e (943 code bytes)
# span:         0x0045565f-0x00455a0e (code 943, tables 0, padding 0)
# sha256:       f9754edc898b93412a51a739efc5ebe229d7fc0262bd7e59b9f71817a6a8428c
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45565f_click_27c4_27c8
# naming:       native port src/original_methods_fl25a.c:m45565f_click_27c4_27c8 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m45565f_click_27c4_27c8. Direct, Unicorn differential and oracle: every instruction reached, both jcc ways (untaken edges allowlisted in the handoff). See tasks/fl25a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_1e, field_23, field_2a, field_2e, field_36, field_38, field_8a, field_8c, field_cd and 5 more; [ecx + n] field_4, field_8, field_c, field_2a, field_36, field_8a, field_8c, field_8e, field_154, field_155, field_7e0; [edx + n] field_1e, field_2a, field_2e, field_32, field_36, field_38, field_8a, field_8c, field_c5, field_d5; [esi + n] field_c5, field_c9; [scaled index + n] field_minus_4
# callees:      calls FUN_00455ab8, FUN_00455a63, FUN_00455a0e, FUN_00455b2e, FUN_00455c4f
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl25a.c:m45565f_click_27c4_27c8 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 219 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_23, 0x23  # offset +0x23
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_38, 0x38  # offset +0x38
.equ field_8a, 0x8a  # offset +0x8a
.equ field_8c, 0x8c  # offset +0x8c
.equ field_8e, 0x8e  # offset +0x8e
.equ field_c5, 0xc5  # offset +0xc5
.equ field_c9, 0xc9  # offset +0xc9
.equ field_cd, 0xcd  # offset +0xcd
.equ field_d1, 0xd1  # offset +0xd1
.equ field_d5, 0xd5  # offset +0xd5
.equ field_d9, 0xd9  # offset +0xd9
.equ field_150, 0x150  # offset +0x150
.equ field_154, 0x154  # offset +0x154
.equ field_155, 0x155  # offset +0x155
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16c, 0x16c  # offset +0x16c
.equ field_7e0, 0x7e0  # offset +0x7e0
.equ field_minus_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00455a0e, .text + (0x00455a0e - 0x401000)
.set FUN_00455a63, .text + (0x00455a63 - 0x401000)
.set FUN_00455ab8, .text + (0x00455ab8 - 0x401000)
.set FUN_00455b2e, .text + (0x00455b2e - 0x401000)
.set FUN_00455c4f, .text + (0x00455c4f - 0x401000)

.org 0x0045565f - 0x401000
.globl FUN_0045565f
FUN_0045565f:
    # block 0x0045565f: entry, 13 instruction(s), ends with je to 0x00455a09 (forward)
    push ebp                                     # 0045565f
    {load} mov ebp, esp                          # 00455660
    sub esp, 0x10                                # 00455662
    push esi                                     # 00455665
    mov dword ptr [ebp - local_10], ecx          # 00455666
    mov eax, dword ptr [ebp - local_10]          # 00455669
    movsx ecx, word ptr [eax + field_1e]         # 0045566c
    imul ecx, ecx, 0x8d                          # 00455670
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00455676
    mov dword ptr [ebp - local_4], edx           # 0045567c
    mov eax, dword ptr [ebp - local_10]          # 0045567f
    cmp dword ptr [eax + field_150], 0x0         # 00455682
    je.d32 L_00455a09                            # 00455689
    # block 0x0045568f: entered by fall-through of je at 0x00455689, 3 instruction(s), ends with jne to 0x00455a09 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045568f
    cmp dword ptr [ecx + field_155], 0x0         # 00455692
    jne.d32 L_00455a09                           # 00455699
    # block 0x0045569f: entered by fall-through of jne at 0x00455699, 5 instruction(s), ends with jne to 0x00455a09 (forward)
    mov edx, dword ptr [ebp - local_10]          # 0045569f
    movsx eax, word ptr [edx + field_1e]         # 004556a2
    imul eax, eax, 0x8d                          # 004556a6
    cmp dword ptr [eax + 0x5bb632], 0x1          # 004556ac
    jne.d32 L_00455a09                           # 004556b3
    # block 0x004556b9: entered by fall-through of jne at 0x004556b3, 2 instruction(s), ends with jne to 0x004556eb (forward)
    cmp dword ptr [0x5c39e5], 0x27c7             # 004556b9
    jne.d8 L_004556eb                            # 004556c3
    # block 0x004556c5: entered by fall-through of jne at 0x004556c3, 7 instruction(s), ends with forward jump to 0x00455a09
    mov ecx, dword ptr [ebp - local_10]          # 004556c5
    mov byte ptr [ecx + field_154], 0x1          # 004556c8
    mov edx, dword ptr [ebp - local_10]          # 004556cf
    movsx eax, word ptr [edx + field_1e]         # 004556d2
    imul eax, eax, 0x8d                          # 004556d6
    mov dword ptr [eax + 0x5bb632], 0x2          # 004556dc
    jmp.d32 L_00455a09                           # 004556e6
L_004556eb:
    # block 0x004556eb: entered by jne at 0x004556c3, 2 instruction(s), ends with jne to 0x0045574d (forward)
    cmp dword ptr [0x5c39e5], 0x27c6             # 004556eb
    jne.d8 L_0045574d                            # 004556f5
    # block 0x004556f7: entered by fall-through of jne at 0x004556f5, 8 instruction(s), ends with jge to 0x00455734 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004556f7
    mov edx, dword ptr [ebp - local_10]          # 004556fa
    mov ax, word ptr [edx + field_8a]            # 004556fd
    mov word ptr [ecx + field_8e], ax            # 00455704
    mov ecx, dword ptr [ebp - local_10]          # 0045570b
    movsx edx, word ptr [ecx + field_8a]         # 0045570e
    cmp edx, 0x3                                 # 00455715
    jge.d8 L_00455734                            # 00455718
    # block 0x0045571a: entered by fall-through of jge at 0x00455718, 6 instruction(s), ends with forward jump to 0x00455740
    mov eax, dword ptr [ebp - local_10]          # 0045571a
    mov cx, word ptr [eax + field_8a]            # 0045571d
    add cx, 0x1                                  # 00455724
    mov edx, dword ptr [ebp - local_10]          # 00455728
    mov word ptr [edx + field_8a], cx            # 0045572b
    jmp.d8 L_00455740                            # 00455732
L_00455734:
    # block 0x00455734: entered by jge at 0x00455718, 2 instruction(s), falls into the block at 0x00455740
    mov eax, dword ptr [ebp - local_10]          # 00455734
    mov word ptr [eax + field_8a], 0x0           # 00455737
L_00455740:
    # block 0x00455740: entered by jmp at 0x00455732, 3 instruction(s), calls FUN_00455ab8, ends with forward jump to 0x00455a09
    mov ecx, dword ptr [ebp - local_10]          # 00455740
    call FUN_00455ab8                            # 00455743
    jmp.d32 L_00455a09                           # 00455748
L_0045574d:
    # block 0x0045574d: entered by jne at 0x004556f5, 2 instruction(s), ends with jne to 0x004557ae (forward)
    cmp dword ptr [0x5c39e5], 0x27c5             # 0045574d
    jne.d8 L_004557ae                            # 00455757
    # block 0x00455759: entered by fall-through of jne at 0x00455757, 8 instruction(s), ends with jle to 0x00455795 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 00455759
    mov edx, dword ptr [ebp - local_10]          # 0045575c
    mov ax, word ptr [edx + field_8a]            # 0045575f
    mov word ptr [ecx + field_8e], ax            # 00455766
    mov ecx, dword ptr [ebp - local_10]          # 0045576d
    movsx edx, word ptr [ecx + field_8a]         # 00455770
    test edx, edx                                # 00455777
    jle.d8 L_00455795                            # 00455779
    # block 0x0045577b: entered by fall-through of jle at 0x00455779, 6 instruction(s), ends with forward jump to 0x004557a1
    mov eax, dword ptr [ebp - local_10]          # 0045577b
    mov cx, word ptr [eax + field_8a]            # 0045577e
    sub cx, 0x1                                  # 00455785
    mov edx, dword ptr [ebp - local_10]          # 00455789
    mov word ptr [edx + field_8a], cx            # 0045578c
    jmp.d8 L_004557a1                            # 00455793
L_00455795:
    # block 0x00455795: entered by jle at 0x00455779, 2 instruction(s), falls into the block at 0x004557a1
    mov eax, dword ptr [ebp - local_10]          # 00455795
    mov word ptr [eax + field_8a], 0x3           # 00455798
L_004557a1:
    # block 0x004557a1: entered by jmp at 0x00455793, 3 instruction(s), calls FUN_00455ab8, ends with forward jump to 0x00455a09
    mov ecx, dword ptr [ebp - local_10]          # 004557a1
    call FUN_00455ab8                            # 004557a4
    jmp.d32 L_00455a09                           # 004557a9
L_004557ae:
    # block 0x004557ae: entered by jne at 0x00455757, 2 instruction(s), ends with jne to 0x004558de (forward)
    cmp dword ptr [0x5c39e5], 0x27c4             # 004557ae
    jne.d32 L_004558de                           # 004557b8
    # block 0x004557be: entered by fall-through of jne at 0x004557b8, 3 instruction(s), ends with je to 0x004557d9 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004557be
    cmp dword ptr [ecx + field_2a], 0x0          # 004557c1
    je.d8 L_004557d9                             # 004557c5
    # block 0x004557c7: entered by fall-through of je at 0x004557c5, 4 instruction(s), calls FUN_00455a63, falls into the block at 0x004557d9
    mov ecx, dword ptr [ebp - local_10]          # 004557c7
    call FUN_00455a63                            # 004557ca
    mov edx, dword ptr [ebp - local_10]          # 004557cf
    mov dword ptr [edx + field_2e], 0x1          # 004557d2
L_004557d9:
    # block 0x004557d9: entered by je at 0x004557c5, 3 instruction(s), ends with je to 0x0045580c (forward)
    mov eax, dword ptr [ebp - local_10]          # 004557d9
    cmp dword ptr [eax + field_2a], 0x0          # 004557dc
    je.d8 L_0045580c                             # 004557e0
    # block 0x004557e2: entered by fall-through of je at 0x004557e0, 6 instruction(s), ends with jne to 0x0045580c (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004557e2
    movsx edx, word ptr [ecx + field_36]         # 004557e5
    mov eax, dword ptr [ebp - local_10]          # 004557e9
    movsx ecx, word ptr [eax + field_38]         # 004557ec
    {load} cmp edx, ecx                          # 004557f0
    jne.d8 L_0045580c                            # 004557f2
    # block 0x004557f4: entered by fall-through of jne at 0x004557f2, 5 instruction(s), ends with forward jump to 0x004558d9
    mov edx, dword ptr [ebp - local_10]          # 004557f4
    mov dword ptr [edx + field_2a], 0x0          # 004557f7
    mov eax, dword ptr [ebp - local_10]          # 004557fe
    mov word ptr [eax + field_36], 0xffff        # 00455801
    jmp.d32 L_004558d9                           # 00455807
L_0045580c:
    # block 0x0045580c: entered by je at 0x004557e0; jne at 0x004557f2, 49 instruction(s), calls FUN_00455a0e, falls into the block at 0x004558d9
    mov ecx, dword ptr [ebp - local_10]          # 0045580c
    mov edx, dword ptr [ebp - local_10]          # 0045580f
    mov ax, word ptr [edx + field_38]            # 00455812
    mov word ptr [ecx + field_36], ax            # 00455816
    mov ecx, dword ptr [ebp - local_10]          # 0045581a
    movsx edx, word ptr [ecx + field_36]         # 0045581d
    imul edx, edx, 0x96                          # 00455821
    mov eax, dword ptr [ebp - local_10]          # 00455827
    movsx ecx, word ptr [eax + field_36]         # 0045582a
    imul ecx, ecx, 0x96                          # 0045582e
    mov eax, dword ptr [ebp - local_4]           # 00455834
    mov esi, dword ptr [ebp - local_4]           # 00455837
    mov edx, dword ptr [eax + edx + field_cd]    # 0045583a
    sub edx, dword ptr [esi + ecx + field_c5]    # 00455841
    mov eax, dword ptr [ebp - local_10]          # 00455848
    mov word ptr [eax + field_16a], dx           # 0045584b
    mov ecx, dword ptr [ebp - local_10]          # 00455852
    movsx edx, word ptr [ecx + field_36]         # 00455855
    imul edx, edx, 0x96                          # 00455859
    mov eax, dword ptr [ebp - local_10]          # 0045585f
    movsx ecx, word ptr [eax + field_36]         # 00455862
    imul ecx, ecx, 0x96                          # 00455866
    mov eax, dword ptr [ebp - local_4]           # 0045586c
    mov esi, dword ptr [ebp - local_4]           # 0045586f
    mov edx, dword ptr [eax + edx + field_d1]    # 00455872
    sub edx, dword ptr [esi + ecx + field_c9]    # 00455879
    mov eax, dword ptr [ebp - local_10]          # 00455880
    mov word ptr [eax + field_16c], dx           # 00455883
    mov ecx, dword ptr [ebp - local_10]          # 0045588a
    call FUN_00455a0e                            # 0045588d
    mov ecx, dword ptr [ebp - local_10]          # 00455892
    mov dword ptr [ecx + field_2a], 0x1          # 00455895
    mov edx, dword ptr [ebp - local_10]          # 0045589c
    mov dword ptr [edx + field_32], 0x1          # 0045589f
    mov eax, dword ptr [ebp - local_10]          # 004558a6
    movsx ecx, word ptr [eax + field_36]         # 004558a9
    imul ecx, ecx, 0x96                          # 004558ad
    mov edx, dword ptr [ebp - local_4]           # 004558b3
    lea eax, [edx + ecx + field_c5]              # 004558b6
    mov ecx, dword ptr [ebp - local_10]          # 004558bd
    add ecx, 0x7a                                # 004558c0
    mov edx, dword ptr [eax]                     # 004558c3
    mov dword ptr [ecx], edx                     # 004558c5
    mov edx, dword ptr [eax + field_4]           # 004558c7
    mov dword ptr [ecx + field_4], edx           # 004558ca
    mov edx, dword ptr [eax + field_8]           # 004558cd
    mov dword ptr [ecx + field_8], edx           # 004558d0
    mov eax, dword ptr [eax + field_c]           # 004558d3
    mov dword ptr [ecx + field_c], eax           # 004558d6
L_004558d9:
    # block 0x004558d9: entered by jmp at 0x00455807, 1 instruction(s), ends with forward jump to 0x00455a09
    jmp.d32 L_00455a09                           # 004558d9
L_004558de:
    # block 0x004558de: entered by jne at 0x004557b8, 2 instruction(s), ends with jne to 0x00455a09 (forward)
    cmp dword ptr [0x5c39e5], 0x27c8             # 004558de
    jne.d32 L_00455a09                           # 004558e8
    # block 0x004558ee: entered by fall-through of jne at 0x004558e8, 4 instruction(s), ends with je to 0x0045592f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004558ee
    movsx edx, word ptr [ecx + field_7e0]        # 004558f1
    test edx, edx                                # 004558f8
    je.d8 L_0045592f                             # 004558fa
    # block 0x004558fc: entered by fall-through of je at 0x004558fa, 9 instruction(s), ends with je to 0x0045592f (forward)
    mov eax, dword ptr [ebp - local_10]          # 004558fc
    movsx ecx, word ptr [eax + field_8a]         # 004558ff
    mov edx, dword ptr [ebp - local_10]          # 00455906
    movsx eax, word ptr [edx + field_36]         # 00455909
    imul eax, eax, 0x96                          # 0045590d
    mov edx, dword ptr [ebp - local_4]           # 00455913
    movsx eax, word ptr [edx + eax + field_d5]   # 00455916
    {load} cmp ecx, eax                          # 0045591e
    je.d8 L_0045592f                             # 00455920
    # block 0x00455922: entered by fall-through of je at 0x00455920, 3 instruction(s), calls FUN_00455b2e, ends with forward jump to 0x004559e4
    mov ecx, dword ptr [ebp - local_10]          # 00455922
    call FUN_00455b2e                            # 00455925
    jmp.d32 L_004559e4                           # 0045592a
L_0045592f:
    # block 0x0045592f: entered by je at 0x004558fa; je at 0x00455920, 13 instruction(s), calls FUN_00455a63, ends with jge to 0x004559e4 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0045592f
    call FUN_00455a63                            # 00455932
    mov ecx, dword ptr [ebp - local_10]          # 00455937
    movsx edx, word ptr [ecx + field_36]         # 0045593a
    imul edx, edx, 0x96                          # 0045593e
    mov eax, dword ptr [ebp - local_4]           # 00455944
    mov word ptr [eax + edx + field_d9], 0x1     # 00455947
    mov ecx, dword ptr [ebp - local_10]          # 00455951
    movsx edx, word ptr [ecx + field_8c]         # 00455954
    mov eax, dword ptr [ebp - local_4]           # 0045595b
    movsx ecx, word ptr [eax + field_23]         # 0045595e
    {load} cmp edx, ecx                          # 00455962
    jge.d8 L_004559e4                            # 00455964
    # block 0x00455966: entered by fall-through of jge at 0x00455964, 6 instruction(s), ends with forward jump to 0x0045598c
    mov dword ptr [ebp - local_c], 0x1           # 00455966
    mov edx, dword ptr [ebp - local_10]          # 0045596d
    movsx eax, word ptr [edx + field_8c]         # 00455970
    lea ecx, [4*eax - field_minus_4]             # 00455977
    mov dword ptr [ebp - local_8], ecx           # 0045597e
    jmp.d8 L_0045598c                            # 00455981
L_00455983:
    # block 0x00455983: entered by jmp at 0x004559c4, 3 instruction(s), falls into the block at 0x0045598c
    mov edx, dword ptr [ebp - local_8]           # 00455983
    add edx, 0x1                                 # 00455986
    mov dword ptr [ebp - local_8], edx           # 00455989
L_0045598c:
    # block 0x0045598c: entered by jmp at 0x00455981, 5 instruction(s), ends with jge to 0x004559c6 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0045598c
    movsx ecx, word ptr [eax + field_8c]         # 0045598f
    shl ecx, 0x2                                 # 00455996
    cmp dword ptr [ebp - local_8], ecx           # 00455999
    jge.d8 L_004559c6                            # 0045599c
    # block 0x0045599e: entered by fall-through of jge at 0x0045599c, 2 instruction(s), ends with jne to 0x004559c6 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 0045599e
    jne.d8 L_004559c6                            # 004559a2
    # block 0x004559a4: entered by fall-through of jne at 0x004559a2, 6 instruction(s), ends with je to 0x004559c4 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004559a4
    imul edx, edx, 0x96                          # 004559a7
    mov eax, dword ptr [ebp - local_4]           # 004559ad
    movsx ecx, word ptr [eax + edx + field_d9]   # 004559b0
    cmp ecx, 0x1                                 # 004559b8
    je.d8 L_004559c4                             # 004559bb
    # block 0x004559bd: entered by fall-through of je at 0x004559bb, 1 instruction(s), falls into the block at 0x004559c4
    mov dword ptr [ebp - local_c], 0x0           # 004559bd
L_004559c4:
    # block 0x004559c4: entered by je at 0x004559bb, 1 instruction(s), ends with backward jump to 0x00455983
    jmp.d8 L_00455983                            # 004559c4
L_004559c6:
    # block 0x004559c6: entered by jge at 0x0045599c; jne at 0x004559a2, 2 instruction(s), ends with je to 0x004559e4 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004559c6
    je.d8 L_004559e4                             # 004559ca
    # block 0x004559cc: entered by fall-through of je at 0x004559ca, 5 instruction(s), falls into the block at 0x004559e4
    mov edx, dword ptr [ebp - local_10]          # 004559cc
    mov ax, word ptr [edx + field_8c]            # 004559cf
    .insn 0x66, 0x05, 0x0001{:u16}               # 004559d6
    mov ecx, dword ptr [ebp - local_10]          # 004559da
    mov word ptr [ecx + field_8c], ax            # 004559dd
L_004559e4:
    # block 0x004559e4: entered by jmp at 0x0045592a; jge at 0x00455964; je at 0x004559ca, 8 instruction(s), calls FUN_00455c4f, falls into the block at 0x00455a09
    mov edx, dword ptr [ebp - local_10]          # 004559e4
    mov dword ptr [edx + field_2a], 0x0          # 004559e7
    mov eax, dword ptr [ebp - local_10]          # 004559ee
    mov dword ptr [eax + field_2e], 0x1          # 004559f1
    mov ecx, dword ptr [ebp - local_10]          # 004559f8
    mov word ptr [ecx + field_36], 0xffff        # 004559fb
    mov ecx, dword ptr [ebp - local_10]          # 00455a01
    call FUN_00455c4f                            # 00455a04
L_00455a09:
    # block 0x00455a09: entered by je at 0x00455689; jne at 0x00455699; jne at 0x004556b3; jmp at 0x004556e6; more, 4 instruction(s), ends with ret
    pop esi                                      # 00455a09
    {load} mov esp, ebp                          # 00455a0a
    pop ebp                                      # 00455a0c
    ret                                          # 00455a0d

