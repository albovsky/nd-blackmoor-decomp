# FUN_00482724
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00482724
# extent:       0x00482724-0x00482a08 (740 code bytes)
# span:         0x00482724-0x00482a08 (code 740, tables 0, padding 0)
# sha256:       104e459a861fa5a55905d936ff131298f7e225edfa36e340c16f8b8482dbb40c
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m482724_click_27b5_27b6
# naming:       native port src/original_methods_fl24a.c:m482724_click_27b5_27b6 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m482724_click_27b5_27b6 (events 27b5/27b6, word compares against the record object, 482595 byte result, tail stores). Differential and oracle: every instruction reached.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_78, field_91, field_92, field_94, field_a8, field_a9, field_39e, field_3a4; [ecx + n] field_91, field_92, field_a2, field_a9, field_ad, field_39e, field_3a0, field_3a2; [edx + n] field_4, field_8, field_a, field_28, field_78, field_91, field_92, field_95, field_a2, field_a9, field_ab, field_fb and 2 more
# callees:      calls FUN_00482595
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl24a.c:m482724_click_27b5_27b6 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 180 instruction(s), 20 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_a, 0xa  # offset +0xa
.equ field_1e, 0x1e  # offset +0x1e
.equ field_28, 0x28  # offset +0x28
.equ field_78, 0x78  # offset +0x78
.equ field_91, 0x91  # offset +0x91
.equ field_92, 0x92  # offset +0x92
.equ field_94, 0x94  # offset +0x94
.equ field_95, 0x95  # offset +0x95
.equ field_a2, 0xa2  # offset +0xa2
.equ field_a8, 0xa8  # offset +0xa8
.equ field_a9, 0xa9  # offset +0xa9
.equ field_ab, 0xab  # offset +0xab
.equ field_ad, 0xad  # offset +0xad
.equ field_fb, 0xfb  # offset +0xfb
.equ field_39e, 0x39e  # offset +0x39e
.equ field_3a0, 0x3a0  # offset +0x3a0
.equ field_3a2, 0x3a2  # offset +0x3a2
.equ field_3a4, 0x3a4  # offset +0x3a4

# --- external targets -----------------------------------------------
.set FUN_00482595, .text + (0x00482595 - 0x401000)

.org 0x00482724 - 0x401000
.globl FUN_00482724
FUN_00482724:
    # block 0x00482724: entry, 14 instruction(s), ends with je to 0x00482a04 (forward)
    push ebp                                     # 00482724
    {load} mov ebp, esp                          # 00482725
    sub esp, 0x8                                 # 00482727
    mov dword ptr [ebp - local_8], ecx           # 0048272a
    mov eax, dword ptr [ebp - local_8]           # 0048272d
    movsx ecx, word ptr [eax + field_1e]         # 00482730
    imul ecx, ecx, 0x8d                          # 00482734
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0048273a
    mov dword ptr [ebp - local_4], edx           # 00482740
    mov eax, dword ptr [ebp - local_8]           # 00482743
    {load} xor ecx, ecx                          # 00482746
    mov cl, byte ptr [eax + field_a8]            # 00482748
    test ecx, ecx                                # 0048274e
    je.d32 L_00482a04                            # 00482750
    # block 0x00482756: entered by fall-through of je at 0x00482750, 2 instruction(s), ends with jne to 0x00482788 (forward)
    cmp dword ptr [0x5c39e5], 0x27b6             # 00482756
    jne.d8 L_00482788                            # 00482760
    # block 0x00482762: entered by fall-through of jne at 0x00482760, 7 instruction(s), ends with forward jump to 0x00482a04
    mov edx, dword ptr [ebp - local_8]           # 00482762
    mov byte ptr [edx + field_ab], 0x1           # 00482765
    mov eax, dword ptr [ebp - local_8]           # 0048276c
    movsx ecx, word ptr [eax + field_1e]         # 0048276f
    imul ecx, ecx, 0x8d                          # 00482773
    mov dword ptr [ecx + 0x5bb632], 0x2          # 00482779
    jmp.d32 L_00482a04                           # 00482783
L_00482788:
    # block 0x00482788: entered by jne at 0x00482760, 3 instruction(s), ends with je to 0x0048279e (forward)
    mov edx, dword ptr [ebp - local_8]           # 00482788
    cmp dword ptr [edx + field_78], 0x0          # 0048278b
    je.d8 L_0048279e                             # 0048278f
    # block 0x00482791: entered by fall-through of je at 0x0048278f, 3 instruction(s), ends with jne to 0x00482a04 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00482791
    cmp dword ptr [eax + field_78], 0x1          # 00482794
    jne.d32 L_00482a04                           # 00482798
L_0048279e:
    # block 0x0048279e: entered by je at 0x0048278f; fall-through of jne at 0x00482798, 4 instruction(s), ends with jne to 0x00482a04 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0048279e
    movsx edx, word ptr [ecx + field_a9]         # 004827a1
    cmp edx, -0x1                                # 004827a8
    jne.d32 L_00482a04                           # 004827ab
    # block 0x004827b1: entered by fall-through of jne at 0x004827ab, 2 instruction(s), ends with jne to 0x00482a04 (forward)
    cmp dword ptr [0x5c39e5], 0x27b5             # 004827b1
    jne.d32 L_00482a04                           # 004827bb
    # block 0x004827c1: entered by fall-through of jne at 0x004827bb, 14 instruction(s), ends with jne to 0x00482838 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004827c1
    mov ecx, dword ptr [ebp - local_8]           # 004827c4
    mov dx, word ptr [ecx + field_ad]            # 004827c7
    mov word ptr [eax + field_a9], dx            # 004827ce
    mov eax, dword ptr [ebp - local_8]           # 004827d5
    movsx ecx, word ptr [eax + field_a9]         # 004827d8
    mov edx, dword ptr [ebp - local_8]           # 004827df
    mov dword ptr [edx + 4*ecx + field_28], 0x1  # 004827e2
    mov eax, dword ptr [ebp - local_8]           # 004827ea
    movsx ecx, word ptr [eax + field_a9]         # 004827ed
    mov edx, dword ptr [ebp - local_4]           # 004827f4
    movsx eax, word ptr [edx + field_3a2]        # 004827f7
    {load} cmp ecx, eax                          # 004827fe
    jne.d8 L_00482838                            # 00482800
    # block 0x00482802: entered by fall-through of jne at 0x00482800, 4 instruction(s), ends with jg to 0x0048281f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00482802
    movsx edx, word ptr [ecx + field_92]         # 00482805
    test edx, edx                                # 0048280c
    jg.d8 L_0048281f                             # 0048280e
    # block 0x00482810: entered by fall-through of jg at 0x0048280e, 5 instruction(s), ends with je to 0x00482838 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00482810
    {load} xor ecx, ecx                          # 00482813
    mov cl, byte ptr [eax + field_91]            # 00482815
    test ecx, ecx                                # 0048281b
    je.d8 L_00482838                             # 0048281d
L_0048281f:
    # block 0x0048281f: entered by jg at 0x0048280e; fall-through of je at 0x0048281d, 5 instruction(s), ends with forward jump to 0x00482a04
    mov edx, dword ptr [ebp - local_8]           # 0048281f
    mov dword ptr [edx + field_78], 0x2          # 00482822
    mov eax, dword ptr [ebp - local_8]           # 00482829
    mov byte ptr [eax + field_91], 0x0           # 0048282c
    jmp.d32 L_00482a04                           # 00482833
L_00482838:
    # block 0x00482838: entered by jne at 0x00482800; je at 0x0048281d, 6 instruction(s), ends with je to 0x00482884 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00482838
    movsx edx, word ptr [ecx + field_a9]         # 0048283b
    mov eax, dword ptr [ebp - local_4]           # 00482842
    movsx ecx, word ptr [eax + field_3a4]        # 00482845
    {load} cmp edx, ecx                          # 0048284c
    je.d8 L_00482884                             # 0048284e
    # block 0x00482850: entered by fall-through of je at 0x0048284e, 6 instruction(s), ends with je to 0x00482884 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00482850
    movsx eax, word ptr [edx + field_a9]         # 00482853
    mov ecx, dword ptr [ebp - local_4]           # 0048285a
    movsx edx, word ptr [ecx + field_39e]        # 0048285d
    {load} cmp eax, edx                          # 00482864
    je.d8 L_00482884                             # 00482866
    # block 0x00482868: entered by fall-through of je at 0x00482866, 6 instruction(s), ends with jne to 0x00482932 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00482868
    movsx ecx, word ptr [eax + field_a9]         # 0048286b
    mov edx, dword ptr [ebp - local_4]           # 00482872
    movsx eax, word ptr [edx + field_3a0]        # 00482875
    {load} cmp ecx, eax                          # 0048287c
    jne.d32 L_00482932                           # 0048287e
L_00482884:
    # block 0x00482884: entered by je at 0x0048284e; je at 0x00482866; fall-through of jne at 0x0048287e, 5 instruction(s), ends with jne to 0x004828bf (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00482884
    {load} xor edx, edx                          # 00482887
    mov dl, byte ptr [ecx + field_91]            # 00482889
    test edx, edx                                # 0048288f
    jne.d8 L_004828bf                            # 00482891
    # block 0x00482893: entered by fall-through of jne at 0x00482891, 11 instruction(s), calls FUN_00482595, ends with forward jump to 0x0048292d
    mov eax, dword ptr [ebp - local_8]           # 00482893
    mov word ptr [eax + field_92], 0x0           # 00482896
    push 0x1                                     # 0048289f
    mov ecx, dword ptr [ebp - local_4]           # 004828a1
    mov dx, word ptr [ecx + field_39e]           # 004828a4
    push edx                                     # 004828ab
    mov ecx, dword ptr [ebp - local_8]           # 004828ac
    call FUN_00482595                            # 004828af
    mov ecx, dword ptr [ebp - local_8]           # 004828b4
    mov byte ptr [ecx + field_91], al            # 004828b7
    jmp.d8 L_0048292d                            # 004828bd
L_004828bf:
    # block 0x004828bf: entered by jne at 0x00482891, 6 instruction(s), ends with jne to 0x004828f7 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004828bf
    movsx eax, word ptr [edx + field_a9]         # 004828c2
    mov ecx, dword ptr [ebp - local_4]           # 004828c9
    movsx edx, word ptr [ecx + field_39e]        # 004828cc
    {load} cmp eax, edx                          # 004828d3
    jne.d8 L_004828f7                            # 004828d5
    # block 0x004828d7: entered by fall-through of jne at 0x004828d5, 9 instruction(s), calls FUN_00482595, ends with forward jump to 0x0048292d
    push 0x0                                     # 004828d7
    mov eax, dword ptr [ebp - local_4]           # 004828d9
    mov cx, word ptr [eax + field_39e]           # 004828dc
    push ecx                                     # 004828e3
    mov ecx, dword ptr [ebp - local_8]           # 004828e4
    call FUN_00482595                            # 004828e7
    mov edx, dword ptr [ebp - local_8]           # 004828ec
    mov byte ptr [edx + field_91], al            # 004828ef
    jmp.d8 L_0048292d                            # 004828f5
L_004828f7:
    # block 0x004828f7: entered by jne at 0x004828d5, 6 instruction(s), ends with jne to 0x0048292d (forward)
    mov eax, dword ptr [ebp - local_8]           # 004828f7
    movsx ecx, word ptr [eax + field_a9]         # 004828fa
    mov edx, dword ptr [ebp - local_4]           # 00482901
    movsx eax, word ptr [edx + field_3a0]        # 00482904
    {load} cmp ecx, eax                          # 0048290b
    jne.d8 L_0048292d                            # 0048290d
    # block 0x0048290f: entered by fall-through of jne at 0x0048290d, 8 instruction(s), calls FUN_00482595, falls into the block at 0x0048292d
    push 0x0                                     # 0048290f
    mov ecx, dword ptr [ebp - local_4]           # 00482911
    mov dx, word ptr [ecx + field_3a0]           # 00482914
    push edx                                     # 0048291b
    mov ecx, dword ptr [ebp - local_8]           # 0048291c
    call FUN_00482595                            # 0048291f
    mov ecx, dword ptr [ebp - local_8]           # 00482924
    mov byte ptr [ecx + field_91], al            # 00482927
L_0048292d:
    # block 0x0048292d: entered by jmp at 0x004828bd; jmp at 0x004828f5; jne at 0x0048290d, 1 instruction(s), ends with forward jump to 0x00482a04
    jmp.d32 L_00482a04                           # 0048292d
L_00482932:
    # block 0x00482932: entered by jne at 0x0048287e, 6 instruction(s), ends with je to 0x00482a04 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00482932
    movsx eax, word ptr [edx + field_a9]         # 00482935
    mov ecx, dword ptr [ebp - local_4]           # 0048293c
    movsx edx, word ptr [ecx + field_3a2]        # 0048293f
    {load} cmp eax, edx                          # 00482946
    je.d32 L_00482a04                            # 00482948
    # block 0x0048294e: entered by fall-through of je at 0x00482948, 6 instruction(s), ends with jne to 0x00482987 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0048294e
    mov byte ptr [eax + field_91], 0x0           # 00482951
    mov ecx, dword ptr [ebp - local_8]           # 00482958
    movsx edx, word ptr [ecx + field_92]         # 0048295b
    test edx, edx                                # 00482962
    jne.d8 L_00482987                            # 00482964
    # block 0x00482966: entered by fall-through of jne at 0x00482964, 9 instruction(s), falls into the block at 0x00482987
    mov eax, dword ptr [ebp - local_8]           # 00482966
    mov byte ptr [eax + field_94], 0x1           # 00482969
    {load} xor ecx, ecx                          # 00482970
    mov edx, dword ptr [ebp - local_8]           # 00482972
    add edx, 0x95                                # 00482975
    mov dword ptr [edx], ecx                     # 0048297b
    mov dword ptr [edx + field_4], ecx           # 0048297d
    mov word ptr [edx + field_8], cx             # 00482980
    mov byte ptr [edx + field_a], cl             # 00482984
L_00482987:
    # block 0x00482987: entered by jne at 0x00482964, 10 instruction(s), ends with jne to 0x004829ec (forward)
    mov eax, dword ptr [ebp - local_8]           # 00482987
    movsx ecx, word ptr [eax + field_92]         # 0048298a
    mov edx, dword ptr [ebp - local_8]           # 00482991
    mov eax, dword ptr [ebp - local_8]           # 00482994
    mov al, byte ptr [eax + field_a9]            # 00482997
    mov byte ptr [edx + ecx + field_95], al      # 0048299d
    mov ecx, dword ptr [ebp - local_8]           # 004829a4
    movsx edx, word ptr [ecx + field_92]         # 004829a7
    test edx, edx                                # 004829ae
    jne.d8 L_004829ec                            # 004829b0
    # block 0x004829b2: entered by fall-through of jne at 0x004829b0, 4 instruction(s), ends with je to 0x004829d0 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004829b2
    movsx ecx, word ptr [eax + field_a9]         # 004829b5
    cmp ecx, 0x1                                 # 004829bc
    je.d8 L_004829d0                             # 004829bf
    # block 0x004829c1: entered by fall-through of je at 0x004829bf, 5 instruction(s), ends with jne to 0x004829df (forward)
    mov edx, dword ptr [ebp - local_4]           # 004829c1
    {load} xor eax, eax                          # 004829c4
    mov al, byte ptr [edx + field_fb]            # 004829c6
    test eax, eax                                # 004829cc
    jne.d8 L_004829df                            # 004829ce
L_004829d0:
    # block 0x004829d0: entered by je at 0x004829bf; fall-through of jne at 0x004829ce, 3 instruction(s), ends with forward jump to 0x004829ec
    mov ecx, dword ptr [ebp - local_8]           # 004829d0
    mov dword ptr [ecx + field_a2], 0x1          # 004829d3
    jmp.d8 L_004829ec                            # 004829dd
L_004829df:
    # block 0x004829df: entered by jne at 0x004829ce, 2 instruction(s), falls into the block at 0x004829ec
    mov edx, dword ptr [ebp - local_8]           # 004829df
    mov dword ptr [edx + field_a2], 0x0          # 004829e2
L_004829ec:
    # block 0x004829ec: entered by jne at 0x004829b0; jmp at 0x004829dd, 5 instruction(s), falls into the block at 0x00482a04
    mov eax, dword ptr [ebp - local_8]           # 004829ec
    mov cx, word ptr [eax + field_92]            # 004829ef
    add cx, 0x1                                  # 004829f6
    mov edx, dword ptr [ebp - local_8]           # 004829fa
    mov word ptr [edx + field_92], cx            # 004829fd
L_00482a04:
    # block 0x00482a04: entered by je at 0x00482750; jmp at 0x00482783; jne at 0x00482798; jne at 0x004827ab; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00482a04
    pop ebp                                      # 00482a06
    ret                                          # 00482a07

