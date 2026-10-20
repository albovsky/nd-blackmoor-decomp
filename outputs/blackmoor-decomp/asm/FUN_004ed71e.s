# FUN_004ed71e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ed71e
# extent:       0x004ed71e-0x004ed9e0 (706 code bytes)
# span:         0x004ed71e-0x004ed9e0 (code 706, tables 0, padding 0)
# sha256:       b747fc4966bc6bebff447492f5e0b29ceabd5b0f1ce0c8be1be3b7b2c8cf5f56
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_notebook_render
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ed71e.c.txt, not original source) refers to the data labelled s_Drawing_checked_box_0055cd80, s_Render_Journal_list_0055cd58, s_Render_Task_list_0055cd6c
# name-note:    Renders the notebook: tab strings, the Journal list or the Task list (with checked boxes), tagged write_tab_string, Render_Journal_list, Render_Task_list.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_985, field_b77, field_ca0, field_ca8, field_fc6, field_fca, field_fda, field_28da; [ecx + n] field_989, field_b7f, field_c70, field_ca0, field_fc6, field_fca, field_fde, field_28da; [edx + n] field_b85, field_fc6, field_fe6, field_28da
# callees:      calls FUN_004ee86f, FUN_004e2b99, FUN_004ee630, FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 168 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_985, 0x985  # offset +0x985
.equ field_989, 0x989  # offset +0x989
.equ field_b77, 0xb77  # offset +0xb77
.equ field_b7f, 0xb7f  # offset +0xb7f
.equ field_b85, 0xb85  # offset +0xb85
.equ field_c70, 0xc70  # offset +0xc70
.equ field_ca0, 0xca0  # offset +0xca0
.equ field_ca8, 0xca8  # offset +0xca8
.equ field_fc6, 0xfc6  # offset +0xfc6
.equ field_fca, 0xfca  # offset +0xfca
.equ field_fda, 0xfda  # offset +0xfda
.equ field_fde, 0xfde  # offset +0xfde
.equ field_fe6, 0xfe6  # offset +0xfe6
.equ field_28da, 0x28da  # offset +0x28da

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)
.set FUN_004ee630, .text + (0x004ee630 - 0x401000)
.set FUN_004ee86f, .text + (0x004ee86f - 0x401000)

.org 0x004ed71e - 0x401000
.globl FUN_004ed71e
FUN_004ed71e:
    # block 0x004ed71e: entry, 8 instruction(s), ends with je to 0x004ed74a (forward)
    push ebp                                     # 004ed71e
    {load} mov ebp, esp                          # 004ed71f
    sub esp, 0x8                                 # 004ed721
    mov dword ptr [ebp - local_8], ecx           # 004ed724
    mov word ptr [ebp - local_4], 0x0            # 004ed727
    mov eax, dword ptr [ebp - local_8]           # 004ed72d
    cmp dword ptr [eax + field_ca0], 0x2         # 004ed730
    je.d8 L_004ed74a                             # 004ed737
    # block 0x004ed739: entered by fall-through of je at 0x004ed737, 3 instruction(s), ends with je to 0x004ed74a (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ed739
    cmp dword ptr [ecx + field_ca0], 0x3         # 004ed73c
    je.d8 L_004ed74a                             # 004ed743
    # block 0x004ed745: entered by fall-through of je at 0x004ed743, 1 instruction(s), ends with forward jump to 0x004ed9dc
    jmp.d32 L_004ed9dc                           # 004ed745
L_004ed74a:
    # block 0x004ed74a: entered by je at 0x004ed737; je at 0x004ed743, 5 instruction(s), calls FUN_004ee86f, ends with forward jump to 0x004ed776
    mov ecx, dword ptr [ebp - local_8]           # 004ed74a
    call FUN_004ee86f                            # 004ed74d
    mov edx, dword ptr [ebp - local_8]           # 004ed752
    mov dword ptr [edx + field_fc6], 0x0         # 004ed755
    jmp.d8 L_004ed776                            # 004ed75f
L_004ed761:
    # block 0x004ed761: entered by jmp at 0x004ed823, 5 instruction(s), falls into the block at 0x004ed776
    mov eax, dword ptr [ebp - local_8]           # 004ed761
    mov ecx, dword ptr [eax + field_fc6]         # 004ed764
    add ecx, 0x1                                 # 004ed76a
    mov edx, dword ptr [ebp - local_8]           # 004ed76d
    mov dword ptr [edx + field_fc6], ecx         # 004ed770
L_004ed776:
    # block 0x004ed776: entered by jmp at 0x004ed75f, 3 instruction(s), ends with jge to 0x004ed828 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ed776
    cmp dword ptr [eax + field_fc6], 0x2         # 004ed779
    jge.d32 L_004ed828                           # 004ed780
    # block 0x004ed786: entered by fall-through of jge at 0x004ed780, 6 instruction(s), ends with je to 0x004ed7c0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ed786
    mov edx, dword ptr [ecx + field_fc6]         # 004ed789
    imul edx, edx, 0xf7                          # 004ed78f
    mov eax, dword ptr [ebp - local_8]           # 004ed795
    cmp dword ptr [eax + edx + field_985], 0x0   # 004ed798
    je.d8 L_004ed7c0                             # 004ed7a0
    # block 0x004ed7a2: entered by fall-through of je at 0x004ed7a0, 6 instruction(s), calls FUN_004e2b99, falls into the block at 0x004ed7c0
    mov ecx, dword ptr [ebp - local_8]           # 004ed7a2
    mov edx, dword ptr [ecx + field_fc6]         # 004ed7a5
    imul edx, edx, 0x18f                         # 004ed7ab
    mov eax, dword ptr [ebp - local_8]           # 004ed7b1
    lea ecx, [eax + edx + field_ca8]             # 004ed7b4
    call FUN_004e2b99                            # 004ed7bb
L_004ed7c0:
    # block 0x004ed7c0: entered by je at 0x004ed7a0, 8 instruction(s), ends with jne to 0x004ed823 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ed7c0
    mov edx, dword ptr [ecx + field_fc6]         # 004ed7c3
    imul edx, edx, 0xf7                          # 004ed7c9
    mov eax, dword ptr [ebp - local_8]           # 004ed7cf
    mov ecx, dword ptr [ebp - local_8]           # 004ed7d2
    mov eax, dword ptr [eax + field_fca]         # 004ed7d5
    cmp eax, dword ptr [ecx + edx + field_989]   # 004ed7db
    jne.d8 L_004ed823                            # 004ed7e2
    # block 0x004ed7e4: entered by fall-through of jne at 0x004ed7e2, 17 instruction(s), calls FUN_004ee630, FUN_004c5377, falls into the block at 0x004ed823
    push 0x55cd44                                # 004ed7e4
    mov ecx, dword ptr [ebp - local_8]           # 004ed7e9
    add ecx, 0xc90                               # 004ed7ec
    push ecx                                     # 004ed7f2
    mov edx, dword ptr [ebp - local_8]           # 004ed7f3
    mov eax, dword ptr [edx + field_fc6]         # 004ed7f6
    shl eax, 0x4                                 # 004ed7fc
    mov ecx, dword ptr [ebp - local_8]           # 004ed7ff
    lea edx, [ecx + eax + field_c70]             # 004ed802
    push edx                                     # 004ed809
    mov eax, dword ptr [0x5cf665]                # 004ed80a
    push eax                                     # 004ed80f
    mov ecx, dword ptr [ebp - local_8]           # 004ed810
    call FUN_004ee630                            # 004ed813
    push eax                                     # 004ed818
    mov ecx, 0x5cf659                            # 004ed819
    call FUN_004c5377                            # 004ed81e
L_004ed823:
    # block 0x004ed823: entered by jne at 0x004ed7e2, 1 instruction(s), ends with backward jump to 0x004ed761
    jmp.d32 L_004ed761                           # 004ed823
L_004ed828:
    # block 0x004ed828: entered by jge at 0x004ed780, 3 instruction(s), ends with jne to 0x004ed872 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ed828
    cmp dword ptr [ecx + field_fca], 0x1         # 004ed82b
    jne.d8 L_004ed872                            # 004ed832
    # block 0x004ed834: entered by fall-through of jne at 0x004ed832, 2 instruction(s), ends with je to 0x004ed872 (forward)
    cmp dword ptr [0x5d03a7], 0x0                # 004ed834
    je.d8 L_004ed872                             # 004ed83b
    # block 0x004ed83d: entered by fall-through of je at 0x004ed83b, 14 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004ed9dc
    push 0x55cd58                                # 004ed83d
    mov edx, dword ptr [ebp - local_8]           # 004ed842
    add edx, 0xb73                               # 004ed845
    push edx                                     # 004ed84b
    mov eax, dword ptr [ebp - local_8]           # 004ed84c
    add eax, 0x28e0                              # 004ed84f
    push eax                                     # 004ed854
    mov ecx, dword ptr [0x5cf665]                # 004ed855
    push ecx                                     # 004ed85b
    mov edx, dword ptr [0x5d03a7]                # 004ed85c
    push edx                                     # 004ed862
    mov ecx, 0x5cf659                            # 004ed863
    call FUN_004c5d4b                            # 004ed868
    jmp.d32 L_004ed9dc                           # 004ed86d
L_004ed872:
    # block 0x004ed872: entered by jne at 0x004ed832; je at 0x004ed83b, 3 instruction(s), ends with jne to 0x004ed9dc (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ed872
    cmp dword ptr [eax + field_fca], 0x2         # 004ed875
    jne.d32 L_004ed9dc                           # 004ed87c
    # block 0x004ed882: entered by fall-through of jne at 0x004ed87c, 2 instruction(s), ends with je to 0x004ed9dc (forward)
    cmp dword ptr [0x5d03a3], 0x0                # 004ed882
    je.d32 L_004ed9dc                            # 004ed889
    # block 0x004ed88f: entered by fall-through of je at 0x004ed889, 16 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004ed8e3
    push 0x55cd6c                                # 004ed88f
    mov ecx, dword ptr [ebp - local_8]           # 004ed894
    add ecx, 0xb73                               # 004ed897
    push ecx                                     # 004ed89d
    mov edx, dword ptr [ebp - local_8]           # 004ed89e
    add edx, 0x28e0                              # 004ed8a1
    push edx                                     # 004ed8a7
    mov eax, dword ptr [0x5cf665]                # 004ed8a8
    push eax                                     # 004ed8ad
    mov ecx, dword ptr [0x5d03a3]                # 004ed8ae
    push ecx                                     # 004ed8b4
    mov ecx, 0x5cf659                            # 004ed8b5
    call FUN_004c5d4b                            # 004ed8ba
    mov edx, dword ptr [ebp - local_8]           # 004ed8bf
    mov dword ptr [edx + field_fc6], 0x0         # 004ed8c2
    jmp.d8 L_004ed8e3                            # 004ed8cc
L_004ed8ce:
    # block 0x004ed8ce: entered by jmp at 0x004ed9d7, 5 instruction(s), falls into the block at 0x004ed8e3
    mov eax, dword ptr [ebp - local_8]           # 004ed8ce
    mov ecx, dword ptr [eax + field_fc6]         # 004ed8d1
    add ecx, 0x1                                 # 004ed8d7
    mov edx, dword ptr [ebp - local_8]           # 004ed8da
    mov dword ptr [edx + field_fc6], ecx         # 004ed8dd
L_004ed8e3:
    # block 0x004ed8e3: entered by jmp at 0x004ed8cc, 5 instruction(s), ends with jge to 0x004ed9dc (forward)
    mov eax, dword ptr [ebp - local_8]           # 004ed8e3
    movsx ecx, word ptr [eax + field_28da]       # 004ed8e6
    mov edx, dword ptr [ebp - local_8]           # 004ed8ed
    cmp dword ptr [edx + field_fc6], ecx         # 004ed8f0
    jge.d32 L_004ed9dc                           # 004ed8f6
    # block 0x004ed8fc: entered by fall-through of jge at 0x004ed8f6, 7 instruction(s), ends with jne to 0x004ed9d7 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004ed8fc
    imul eax, eax, 0x320                         # 004ed900
    mov ecx, dword ptr [ebp - local_8]           # 004ed906
    mov edx, dword ptr [ecx + field_fc6]         # 004ed909
    movsx eax, word ptr [eax + 2*edx + 0x59f27b] # 004ed90f
    cmp eax, 0x8                                 # 004ed917
    jne.d32 L_004ed9d7                           # 004ed91a
    # block 0x004ed920: entered by fall-through of jne at 0x004ed91a, 11 instruction(s), ends with jl to 0x004ed9d7 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ed920
    movsx edx, word ptr [ecx + field_28da]       # 004ed923
    mov eax, dword ptr [ebp - local_8]           # 004ed92a
    sub edx, dword ptr [eax + field_fc6]         # 004ed92d
    sub edx, 0x1                                 # 004ed933
    shl edx, 0x4                                 # 004ed936
    mov ecx, dword ptr [ebp - local_8]           # 004ed939
    mov eax, dword ptr [ebp - local_8]           # 004ed93c
    mov ecx, dword ptr [ecx + edx + field_fde]   # 004ed93f
    cmp ecx, dword ptr [eax + field_b77]         # 004ed946
    jl.d32 L_004ed9d7                            # 004ed94c
    # block 0x004ed952: entered by fall-through of jl at 0x004ed94c, 11 instruction(s), ends with jg to 0x004ed9d7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004ed952
    movsx eax, word ptr [edx + field_28da]       # 004ed955
    mov ecx, dword ptr [ebp - local_8]           # 004ed95c
    sub eax, dword ptr [ecx + field_fc6]         # 004ed95f
    sub eax, 0x1                                 # 004ed965
    shl eax, 0x4                                 # 004ed968
    mov edx, dword ptr [ebp - local_8]           # 004ed96b
    mov ecx, dword ptr [ebp - local_8]           # 004ed96e
    mov edx, dword ptr [edx + eax + field_fe6]   # 004ed971
    cmp edx, dword ptr [ecx + field_b7f]         # 004ed978
    jg.d8 L_004ed9d7                             # 004ed97e
    # block 0x004ed980: entered by fall-through of jg at 0x004ed97e, 22 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004ed9d7
    push 0x55cd80                                # 004ed980
    mov eax, dword ptr [ebp - local_8]           # 004ed985
    movsx ecx, word ptr [eax + field_28da]       # 004ed988
    mov edx, dword ptr [ebp - local_8]           # 004ed98f
    sub ecx, dword ptr [edx + field_fc6]         # 004ed992
    sub ecx, 0x1                                 # 004ed998
    shl ecx, 0x4                                 # 004ed99b
    mov eax, dword ptr [ebp - local_8]           # 004ed99e
    lea ecx, [eax + ecx + field_fda]             # 004ed9a1
    push ecx                                     # 004ed9a8
    mov edx, dword ptr [ebp - local_8]           # 004ed9a9
    movsx eax, word ptr [edx + field_b85]        # 004ed9ac
    sub eax, 0x1                                 # 004ed9b3
    shl eax, 0x4                                 # 004ed9b6
    add eax, 0x5afc7e                            # 004ed9b9
    push eax                                     # 004ed9be
    mov ecx, dword ptr [0x5cf665]                # 004ed9bf
    push ecx                                     # 004ed9c5
    mov edx, dword ptr [0x5d0377]                # 004ed9c6
    push edx                                     # 004ed9cc
    mov ecx, 0x5cf659                            # 004ed9cd
    call FUN_004c5d4b                            # 004ed9d2
L_004ed9d7:
    # block 0x004ed9d7: entered by jne at 0x004ed91a; jl at 0x004ed94c; jg at 0x004ed97e, 1 instruction(s), ends with backward jump to 0x004ed8ce
    jmp.d32 L_004ed8ce                           # 004ed9d7
L_004ed9dc:
    # block 0x004ed9dc: entered by jmp at 0x004ed745; jmp at 0x004ed86d; jne at 0x004ed87c; je at 0x004ed889; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ed9dc
    pop ebp                                      # 004ed9de
    ret                                          # 004ed9df

