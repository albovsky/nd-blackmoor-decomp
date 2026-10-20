# FUN_00462577
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00462577
# extent:       0x00462577-0x00462b74 (1533 code bytes)
# span:         0x00462577-0x00462b84 (code 1533, tables 16, padding 0)
# sha256:       32cafa8b03bbe223768263810908c85b2479a52e33e09f1a63134f75d6857cfa
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         grid_setup
# naming:       native port src/action_family_d3_runtime.c:grid_setup (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with grid_setup (64-cell grid, arrows, start table). Native: setup flag is a byte (original word, only 0/1 stored); view origin passed in.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_1e, field_22, field_210, field_214, field_228, field_22c; [ecx + n] field_24, field_26, field_28, field_a8, field_220, field_224; [edx + n] field_4f, field_53, field_aa, field_218, field_21c, field_248
# callees:      calls FUN_00462b84
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:grid_setup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 385 instruction(s), 10 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
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
.equ local_20, 0x20  # offset -0x20
.equ field_1e, 0x1e  # offset +0x1e
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_28, 0x28  # offset +0x28
.equ field_4f, 0x4f  # offset +0x4f
.equ field_53, 0x53  # offset +0x53
.equ field_a8, 0xa8  # offset +0xa8
.equ field_aa, 0xaa  # offset +0xaa
.equ field_210, 0x210  # offset +0x210
.equ field_214, 0x214  # offset +0x214
.equ field_218, 0x218  # offset +0x218
.equ field_21c, 0x21c  # offset +0x21c
.equ field_220, 0x220  # offset +0x220
.equ field_224, 0x224  # offset +0x224
.equ field_228, 0x228  # offset +0x228
.equ field_22c, 0x22c  # offset +0x22c
.equ field_248, 0x248  # offset +0x248

# --- external targets -----------------------------------------------
.set FUN_00462b84, .text + (0x00462b84 - 0x401000)

.org 0x00462577 - 0x401000
.globl FUN_00462577
FUN_00462577:
    # block 0x00462577: entry, 14 instruction(s), ends with jne to 0x00462b6e (forward)
    push ebp                                     # 00462577
    {load} mov ebp, esp                          # 00462578
    sub esp, 0x20                                # 0046257a
    push esi                                     # 0046257d
    push edi                                     # 0046257e
    mov dword ptr [ebp - local_1c], ecx          # 0046257f
    mov eax, dword ptr [ebp - local_1c]          # 00462582
    movsx ecx, word ptr [eax + field_1e]         # 00462585
    imul ecx, ecx, 0x8d                          # 00462589
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046258f
    mov dword ptr [ebp - local_10], edx          # 00462595
    movsx eax, word ptr [0x594db3]               # 00462598
    test eax, eax                                # 0046259f
    jne.d32 L_00462b6e                           # 004625a1
    # block 0x004625a7: entered by fall-through of jne at 0x004625a1, 3 instruction(s), ends with forward jump to 0x004625c4
    mov word ptr [0x594db3], 0x1                 # 004625a7
    mov word ptr [ebp - local_c], 0x0            # 004625b0
    jmp.d8 L_004625c4                            # 004625b6
L_004625b8:
    # block 0x004625b8: entered by jmp at 0x00462b69, 3 instruction(s), falls into the block at 0x004625c4
    mov cx, word ptr [ebp - local_c]             # 004625b8
    add cx, 0x1                                  # 004625bc
    mov word ptr [ebp - local_c], cx             # 004625c0
L_004625c4:
    # block 0x004625c4: entered by jmp at 0x004625b6, 5 instruction(s), ends with jge to 0x00462b6e (forward)
    movsx edx, word ptr [ebp - local_c]          # 004625c4
    mov eax, dword ptr [ebp - local_10]          # 004625c8
    movsx ecx, word ptr [eax + field_22]         # 004625cb
    {load} cmp edx, ecx                          # 004625cf
    jge.d32 L_00462b6e                           # 004625d1
    # block 0x004625d7: entered by fall-through of jge at 0x004625d1, 2 instruction(s), ends with forward jump to 0x004625eb
    mov word ptr [ebp - local_14], 0x0           # 004625d7
    jmp.d8 L_004625eb                            # 004625dd
L_004625df:
    # block 0x004625df: entered by jmp at 0x00462b64, 3 instruction(s), falls into the block at 0x004625eb
    mov dx, word ptr [ebp - local_14]            # 004625df
    add dx, 0x1                                  # 004625e3
    mov word ptr [ebp - local_14], dx            # 004625e7
L_004625eb:
    # block 0x004625eb: entered by jmp at 0x004625dd, 5 instruction(s), ends with jge to 0x00462b69 (forward)
    movsx eax, word ptr [ebp - local_14]         # 004625eb
    mov ecx, dword ptr [ebp - local_10]          # 004625ef
    movsx edx, word ptr [ecx + field_24]         # 004625f2
    {load} cmp eax, edx                          # 004625f6
    jge.d32 L_00462b69                           # 004625f8
    # block 0x004625fe: entered by fall-through of jge at 0x004625f8, 52 instruction(s), calls FUN_00462b84, ends with je to 0x00462ab7 (forward)
    mov ecx, 0xa                                 # 004625fe
    {load} xor eax, eax                          # 00462603
    movsx edx, word ptr [ebp - local_c]          # 00462605
    imul edx, edx, 0x140                         # 00462609
    movsx esi, word ptr [ebp - local_14]         # 0046260f
    imul esi, esi, 0x28                          # 00462613
    lea edi, [edx + esi + 0x594db5]              # 00462616
    rep stosd dword ptr es:[edi], eax            # 0046261d
    movsx eax, word ptr [ebp - local_c]          # 0046261f
    shl eax, 0x4                                 # 00462623
    mov ecx, dword ptr [ebp - local_10]          # 00462626
    lea edx, [ecx + eax + field_28]              # 00462629
    movsx eax, word ptr [ebp - local_14]         # 0046262d
    movsx ecx, word ptr [ebp - local_c]          # 00462631
    imul ecx, ecx, 0x140                         # 00462635
    movsx esi, word ptr [ebp - local_14]         # 0046263b
    imul esi, esi, 0x28                          # 0046263f
    mov dx, word ptr [edx + 2*eax]               # 00462642
    mov word ptr [ecx + esi + 0x594dd9], dx      # 00462646
    movsx eax, word ptr [ebp - local_c]          # 0046264e
    imul eax, eax, 0x140                         # 00462652
    movsx ecx, word ptr [ebp - local_14]         # 00462658
    imul ecx, ecx, 0x28                          # 0046265c
    lea edx, [eax + ecx + 0x594db9]              # 0046265f
    push edx                                     # 00462666
    push 0x0                                     # 00462667
    mov ax, word ptr [ebp - local_14]            # 00462669
    push eax                                     # 0046266d
    mov cx, word ptr [ebp - local_c]             # 0046266e
    push ecx                                     # 00462672
    mov ecx, dword ptr [ebp - local_1c]          # 00462673
    call FUN_00462b84                            # 00462676
    movsx edx, word ptr [ebp - local_c]          # 0046267b
    imul edx, edx, 0x140                         # 0046267f
    movsx eax, word ptr [ebp - local_14]         # 00462685
    imul eax, eax, 0x28                          # 00462689
    lea ecx, [edx + eax + 0x594dc9]              # 0046268c
    push ecx                                     # 00462693
    push 0x0                                     # 00462694
    mov dx, word ptr [ebp - local_14]            # 00462696
    push edx                                     # 0046269a
    mov ax, word ptr [ebp - local_c]             # 0046269b
    push eax                                     # 0046269f
    mov ecx, dword ptr [ebp - local_1c]          # 004626a0
    call FUN_00462b84                            # 004626a3
    movsx ecx, word ptr [ebp - local_c]          # 004626a8
    imul ecx, ecx, 0x140                         # 004626ac
    movsx edx, word ptr [ebp - local_14]         # 004626b2
    imul edx, edx, 0x28                          # 004626b6
    movsx eax, word ptr [ecx + edx + 0x594dd9]   # 004626b9
    test eax, eax                                # 004626c1
    je.d32 L_00462ab7                            # 004626c3
    # block 0x004626c9: entered by fall-through of je at 0x004626c3, 16 instruction(s), ends with ja to 0x00462ab7 (forward)
    movsx ecx, word ptr [ebp - local_c]          # 004626c9
    imul ecx, ecx, 0x140                         # 004626cd
    movsx edx, word ptr [ebp - local_14]         # 004626d3
    imul edx, edx, 0x28                          # 004626d7
    mov dword ptr [ecx + edx + 0x594db5], 0x1    # 004626da
    movsx eax, word ptr [ebp - local_c]          # 004626e5
    imul eax, eax, 0x140                         # 004626e9
    movsx ecx, word ptr [ebp - local_14]         # 004626ef
    imul ecx, ecx, 0x28                          # 004626f3
    movsx edx, word ptr [eax + ecx + 0x594dd9]   # 004626f6
    mov dword ptr [ebp - local_20], edx          # 004626fe
    mov eax, dword ptr [ebp - local_20]          # 00462701
    sub eax, 0x10                                # 00462704
    mov dword ptr [ebp - local_20], eax          # 00462707
    cmp dword ptr [ebp - local_20], 0x3          # 0046270a
    ja.d32 L_00462ab7                            # 0046270e
    # block 0x00462714: entered by fall-through of ja at 0x0046270e, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x462b74]
    mov ecx, dword ptr [ebp - local_20]          # 00462714
    jmp dword ptr [4*ecx + SWTAB_00462b74_VA]    # 00462717
L_0046271e:
    # block 0x0046271e: entered by switch case, 51 instruction(s), ends with jne to 0x0046286a (forward)
    mov edx, dword ptr [ebp - local_10]          # 0046271e
    mov eax, dword ptr [ebp - local_10]          # 00462721
    mov ecx, dword ptr [edx + field_218]         # 00462724
    sub ecx, dword ptr [eax + field_210]         # 0046272a
    mov dword ptr [ebp - local_18], ecx          # 00462730
    mov edx, dword ptr [ebp - local_10]          # 00462733
    mov eax, dword ptr [ebp - local_10]          # 00462736
    mov ecx, dword ptr [edx + field_21c]         # 00462739
    sub ecx, dword ptr [eax + field_214]         # 0046273f
    mov dword ptr [ebp - local_8], ecx           # 00462745
    movsx ecx, word ptr [ebp - local_c]          # 00462748
    imul ecx, ecx, 0x140                         # 0046274c
    movsx esi, word ptr [ebp - local_14]         # 00462752
    imul esi, esi, 0x28                          # 00462756
    mov edx, dword ptr [ebp - local_1c]          # 00462759
    mov eax, dword ptr [edx + field_53]          # 0046275c
    sub eax, dword ptr [ebp - local_8]           # 0046275f
    cdq                                          # 00462762
    {load} sub eax, edx                          # 00462763
    sar eax                                      # 00462765
    mov ecx, dword ptr [ecx + esi + 0x594dbd]    # 00462767
    {load} add ecx, eax                          # 0046276e
    movsx edx, word ptr [ebp - local_14]         # 00462770
    imul edx, edx, 0x28                          # 00462774
    movsx eax, word ptr [ebp - local_c]          # 00462777
    imul eax, eax, 0x140                         # 0046277b
    mov dword ptr [eax + edx + 0x594dbd], ecx    # 00462781
    movsx ecx, word ptr [ebp - local_c]          # 00462788
    imul ecx, ecx, 0x140                         # 0046278c
    movsx esi, word ptr [ebp - local_14]         # 00462792
    imul esi, esi, 0x28                          # 00462796
    mov edx, dword ptr [ebp - local_1c]          # 00462799
    mov eax, dword ptr [edx + field_53]          # 0046279c
    sub eax, dword ptr [ebp - local_8]           # 0046279f
    cdq                                          # 004627a2
    {load} sub eax, edx                          # 004627a3
    sar eax                                      # 004627a5
    mov ecx, dword ptr [ecx + esi + 0x594dc5]    # 004627a7
    {load} sub ecx, eax                          # 004627ae
    movsx edx, word ptr [ebp - local_14]         # 004627b0
    imul edx, edx, 0x28                          # 004627b4
    movsx eax, word ptr [ebp - local_c]          # 004627b7
    imul eax, eax, 0x140                         # 004627bb
    mov dword ptr [eax + edx + 0x594dc5], ecx    # 004627c1
    movsx ecx, word ptr [ebp - local_c]          # 004627c8
    imul ecx, ecx, 0x140                         # 004627cc
    movsx edx, word ptr [ebp - local_14]         # 004627d2
    imul edx, edx, 0x28                          # 004627d6
    movsx eax, word ptr [ecx + edx + 0x594dd9]   # 004627d9
    cmp eax, 0x10                                # 004627e1
    jne.d32 L_0046286a                           # 004627e4
    # block 0x004627ea: entered by fall-through of jne at 0x004627e4, 33 instruction(s), ends with forward jump to 0x004628e8
    movsx ecx, word ptr [ebp - local_c]          # 004627ea
    imul ecx, ecx, 0x140                         # 004627ee
    movsx esi, word ptr [ebp - local_14]         # 004627f4
    imul esi, esi, 0x28                          # 004627f8
    mov edx, dword ptr [ebp - local_10]          # 004627fb
    movsx eax, word ptr [edx + field_248]        # 004627fe
    cdq                                          # 00462805
    {load} sub eax, edx                          # 00462806
    sar eax                                      # 00462808
    mov ecx, dword ptr [ecx + esi + 0x594db9]    # 0046280a
    {load} sub ecx, eax                          # 00462811
    mov eax, dword ptr [ebp - local_18]          # 00462813
    cdq                                          # 00462816
    {load} sub eax, edx                          # 00462817
    sar eax                                      # 00462819
    {load} sub ecx, eax                          # 0046281b
    movsx edx, word ptr [ebp - local_c]          # 0046281d
    imul edx, edx, 0x140                         # 00462821
    movsx eax, word ptr [ebp - local_14]         # 00462827
    imul eax, eax, 0x28                          # 0046282b
    mov dword ptr [edx + eax + 0x594db9], ecx    # 0046282e
    movsx ecx, word ptr [ebp - local_c]          # 00462835
    imul ecx, ecx, 0x140                         # 00462839
    movsx edx, word ptr [ebp - local_14]         # 0046283f
    imul edx, edx, 0x28                          # 00462843
    mov eax, dword ptr [ecx + edx + 0x594db9]    # 00462846
    add eax, dword ptr [ebp - local_18]          # 0046284d
    movsx ecx, word ptr [ebp - local_c]          # 00462850
    imul ecx, ecx, 0x140                         # 00462854
    movsx edx, word ptr [ebp - local_14]         # 0046285a
    imul edx, edx, 0x28                          # 0046285e
    mov dword ptr [ecx + edx + 0x594dc1], eax    # 00462861
    jmp.d8 L_004628e8                            # 00462868
L_0046286a:
    # block 0x0046286a: entered by jne at 0x004627e4, 32 instruction(s), falls into the block at 0x004628e8
    movsx ecx, word ptr [ebp - local_c]          # 0046286a
    imul ecx, ecx, 0x140                         # 0046286e
    movsx esi, word ptr [ebp - local_14]         # 00462874
    imul esi, esi, 0x28                          # 00462878
    mov edx, dword ptr [ebp - local_10]          # 0046287b
    movsx eax, word ptr [edx + field_248]        # 0046287e
    cdq                                          # 00462885
    {load} sub eax, edx                          # 00462886
    sar eax                                      # 00462888
    mov ecx, dword ptr [ecx + esi + 0x594dc1]    # 0046288a
    {load} add ecx, eax                          # 00462891
    mov eax, dword ptr [ebp - local_18]          # 00462893
    cdq                                          # 00462896
    {load} sub eax, edx                          # 00462897
    sar eax                                      # 00462899
    {load} sub ecx, eax                          # 0046289b
    movsx edx, word ptr [ebp - local_c]          # 0046289d
    imul edx, edx, 0x140                         # 004628a1
    movsx eax, word ptr [ebp - local_14]         # 004628a7
    imul eax, eax, 0x28                          # 004628ab
    mov dword ptr [edx + eax + 0x594db9], ecx    # 004628ae
    movsx ecx, word ptr [ebp - local_c]          # 004628b5
    imul ecx, ecx, 0x140                         # 004628b9
    movsx edx, word ptr [ebp - local_14]         # 004628bf
    imul edx, edx, 0x28                          # 004628c3
    mov eax, dword ptr [ecx + edx + 0x594db9]    # 004628c6
    add eax, dword ptr [ebp - local_18]          # 004628cd
    movsx ecx, word ptr [ebp - local_c]          # 004628d0
    imul ecx, ecx, 0x140                         # 004628d4
    movsx edx, word ptr [ebp - local_14]         # 004628da
    imul edx, edx, 0x28                          # 004628de
    mov dword ptr [ecx + edx + 0x594dc1], eax    # 004628e1
L_004628e8:
    # block 0x004628e8: entered by jmp at 0x00462868, 1 instruction(s), ends with forward jump to 0x00462ab7
    jmp.d32 L_00462ab7                           # 004628e8
L_004628ed:
    # block 0x004628ed: entered by switch case, 51 instruction(s), ends with jne to 0x00462a39 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004628ed
    mov ecx, dword ptr [ebp - local_10]          # 004628f0
    mov edx, dword ptr [eax + field_228]         # 004628f3
    sub edx, dword ptr [ecx + field_220]         # 004628f9
    mov dword ptr [ebp - local_18], edx          # 004628ff
    mov eax, dword ptr [ebp - local_10]          # 00462902
    mov ecx, dword ptr [ebp - local_10]          # 00462905
    mov edx, dword ptr [eax + field_22c]         # 00462908
    sub edx, dword ptr [ecx + field_224]         # 0046290e
    mov dword ptr [ebp - local_8], edx           # 00462914
    movsx ecx, word ptr [ebp - local_c]          # 00462917
    imul ecx, ecx, 0x140                         # 0046291b
    movsx esi, word ptr [ebp - local_14]         # 00462921
    imul esi, esi, 0x28                          # 00462925
    mov edx, dword ptr [ebp - local_1c]          # 00462928
    mov eax, dword ptr [edx + field_4f]          # 0046292b
    sub eax, dword ptr [ebp - local_18]          # 0046292e
    cdq                                          # 00462931
    {load} sub eax, edx                          # 00462932
    sar eax                                      # 00462934
    mov ecx, dword ptr [ecx + esi + 0x594db9]    # 00462936
    {load} add ecx, eax                          # 0046293d
    movsx edx, word ptr [ebp - local_14]         # 0046293f
    imul edx, edx, 0x28                          # 00462943
    movsx eax, word ptr [ebp - local_c]          # 00462946
    imul eax, eax, 0x140                         # 0046294a
    mov dword ptr [eax + edx + 0x594db9], ecx    # 00462950
    movsx ecx, word ptr [ebp - local_c]          # 00462957
    imul ecx, ecx, 0x140                         # 0046295b
    movsx esi, word ptr [ebp - local_14]         # 00462961
    imul esi, esi, 0x28                          # 00462965
    mov edx, dword ptr [ebp - local_1c]          # 00462968
    mov eax, dword ptr [edx + field_4f]          # 0046296b
    sub eax, dword ptr [ebp - local_18]          # 0046296e
    cdq                                          # 00462971
    {load} sub eax, edx                          # 00462972
    sar eax                                      # 00462974
    mov ecx, dword ptr [ecx + esi + 0x594dc1]    # 00462976
    {load} sub ecx, eax                          # 0046297d
    movsx edx, word ptr [ebp - local_14]         # 0046297f
    imul edx, edx, 0x28                          # 00462983
    movsx eax, word ptr [ebp - local_c]          # 00462986
    imul eax, eax, 0x140                         # 0046298a
    mov dword ptr [eax + edx + 0x594dc1], ecx    # 00462990
    movsx ecx, word ptr [ebp - local_c]          # 00462997
    imul ecx, ecx, 0x140                         # 0046299b
    movsx edx, word ptr [ebp - local_14]         # 004629a1
    imul edx, edx, 0x28                          # 004629a5
    movsx eax, word ptr [ecx + edx + 0x594dd9]   # 004629a8
    cmp eax, 0x11                                # 004629b0
    jne.d32 L_00462a39                           # 004629b3
    # block 0x004629b9: entered by fall-through of jne at 0x004629b3, 33 instruction(s), ends with forward jump to 0x00462ab7
    movsx ecx, word ptr [ebp - local_c]          # 004629b9
    imul ecx, ecx, 0x140                         # 004629bd
    movsx esi, word ptr [ebp - local_14]         # 004629c3
    imul esi, esi, 0x28                          # 004629c7
    mov edx, dword ptr [ebp - local_10]          # 004629ca
    movsx eax, word ptr [edx + field_248]        # 004629cd
    cdq                                          # 004629d4
    {load} sub eax, edx                          # 004629d5
    sar eax                                      # 004629d7
    mov ecx, dword ptr [ecx + esi + 0x594dbd]    # 004629d9
    {load} sub ecx, eax                          # 004629e0
    mov eax, dword ptr [ebp - local_8]           # 004629e2
    cdq                                          # 004629e5
    {load} sub eax, edx                          # 004629e6
    sar eax                                      # 004629e8
    {load} sub ecx, eax                          # 004629ea
    movsx edx, word ptr [ebp - local_c]          # 004629ec
    imul edx, edx, 0x140                         # 004629f0
    movsx eax, word ptr [ebp - local_14]         # 004629f6
    imul eax, eax, 0x28                          # 004629fa
    mov dword ptr [edx + eax + 0x594dbd], ecx    # 004629fd
    movsx ecx, word ptr [ebp - local_c]          # 00462a04
    imul ecx, ecx, 0x140                         # 00462a08
    movsx edx, word ptr [ebp - local_14]         # 00462a0e
    imul edx, edx, 0x28                          # 00462a12
    mov eax, dword ptr [ecx + edx + 0x594dbd]    # 00462a15
    add eax, dword ptr [ebp - local_8]           # 00462a1c
    movsx ecx, word ptr [ebp - local_c]          # 00462a1f
    imul ecx, ecx, 0x140                         # 00462a23
    movsx edx, word ptr [ebp - local_14]         # 00462a29
    imul edx, edx, 0x28                          # 00462a2d
    mov dword ptr [ecx + edx + 0x594dc5], eax    # 00462a30
    jmp.d8 L_00462ab7                            # 00462a37
L_00462a39:
    # block 0x00462a39: entered by jne at 0x004629b3, 32 instruction(s), falls into the block at 0x00462ab7
    movsx ecx, word ptr [ebp - local_c]          # 00462a39
    imul ecx, ecx, 0x140                         # 00462a3d
    movsx esi, word ptr [ebp - local_14]         # 00462a43
    imul esi, esi, 0x28                          # 00462a47
    mov edx, dword ptr [ebp - local_10]          # 00462a4a
    movsx eax, word ptr [edx + field_248]        # 00462a4d
    cdq                                          # 00462a54
    {load} sub eax, edx                          # 00462a55
    sar eax                                      # 00462a57
    mov ecx, dword ptr [ecx + esi + 0x594dc5]    # 00462a59
    {load} add ecx, eax                          # 00462a60
    mov eax, dword ptr [ebp - local_8]           # 00462a62
    cdq                                          # 00462a65
    {load} sub eax, edx                          # 00462a66
    sar eax                                      # 00462a68
    {load} sub ecx, eax                          # 00462a6a
    movsx edx, word ptr [ebp - local_c]          # 00462a6c
    imul edx, edx, 0x140                         # 00462a70
    movsx eax, word ptr [ebp - local_14]         # 00462a76
    imul eax, eax, 0x28                          # 00462a7a
    mov dword ptr [edx + eax + 0x594dbd], ecx    # 00462a7d
    movsx ecx, word ptr [ebp - local_c]          # 00462a84
    imul ecx, ecx, 0x140                         # 00462a88
    movsx edx, word ptr [ebp - local_14]         # 00462a8e
    imul edx, edx, 0x28                          # 00462a92
    mov eax, dword ptr [ecx + edx + 0x594dbd]    # 00462a95
    add eax, dword ptr [ebp - local_8]           # 00462a9c
    movsx ecx, word ptr [ebp - local_c]          # 00462a9f
    imul ecx, ecx, 0x140                         # 00462aa3
    movsx edx, word ptr [ebp - local_14]         # 00462aa9
    imul edx, edx, 0x28                          # 00462aad
    mov dword ptr [ecx + edx + 0x594dc5], eax    # 00462ab0
L_00462ab7:
    # block 0x00462ab7: entered by je at 0x004626c3; ja at 0x0046270e; jmp at 0x004628e8; jmp at 0x00462a37, 7 instruction(s), ends with forward jump to 0x00462ae6
    movsx eax, word ptr [ebp - local_c]          # 00462ab7
    imul eax, eax, 0x140                         # 00462abb
    movsx ecx, word ptr [ebp - local_14]         # 00462ac1
    imul ecx, ecx, 0x28                          # 00462ac5
    mov word ptr [eax + ecx + 0x594ddb], 0x0     # 00462ac8
    mov word ptr [ebp - local_4], 0x0            # 00462ad2
    jmp.d8 L_00462ae6                            # 00462ad8
L_00462ada:
    # block 0x00462ada: entered by jmp at 0x00462b5f, 3 instruction(s), falls into the block at 0x00462ae6
    mov dx, word ptr [ebp - local_4]             # 00462ada
    add dx, 0x1                                  # 00462ade
    mov word ptr [ebp - local_4], dx             # 00462ae2
L_00462ae6:
    # block 0x00462ae6: entered by jmp at 0x00462ad8, 5 instruction(s), ends with jge to 0x00462b64 (forward)
    movsx eax, word ptr [ebp - local_4]          # 00462ae6
    mov ecx, dword ptr [ebp - local_10]          # 00462aea
    movsx edx, word ptr [ecx + field_26]         # 00462aed
    {load} cmp eax, edx                          # 00462af1
    jge.d8 L_00462b64                            # 00462af3
    # block 0x00462af5: entered by fall-through of jge at 0x00462af3, 6 instruction(s), ends with jne to 0x00462b5f (forward)
    movsx eax, word ptr [ebp - local_4]          # 00462af5
    mov ecx, dword ptr [ebp - local_10]          # 00462af9
    movsx edx, word ptr [ecx + 4*eax + field_a8] # 00462afc
    movsx eax, word ptr [ebp - local_14]         # 00462b04
    {load} cmp edx, eax                          # 00462b08
    jne.d8 L_00462b5f                            # 00462b0a
    # block 0x00462b0c: entered by fall-through of jne at 0x00462b0a, 6 instruction(s), ends with jne to 0x00462b5f (forward)
    movsx ecx, word ptr [ebp - local_4]          # 00462b0c
    mov edx, dword ptr [ebp - local_10]          # 00462b10
    movsx eax, word ptr [edx + 4*ecx + field_aa] # 00462b13
    movsx ecx, word ptr [ebp - local_c]          # 00462b1b
    {load} cmp eax, ecx                          # 00462b1f
    jne.d8 L_00462b5f                            # 00462b21
    # block 0x00462b23: entered by fall-through of jne at 0x00462b21, 12 instruction(s), falls into the block at 0x00462b5f
    movsx edx, word ptr [ebp - local_c]          # 00462b23
    imul edx, edx, 0x140                         # 00462b27
    movsx eax, word ptr [ebp - local_14]         # 00462b2d
    imul eax, eax, 0x28                          # 00462b31
    mov dword ptr [edx + eax + 0x594db5], 0x1    # 00462b34
    movsx ecx, word ptr [ebp - local_4]          # 00462b3f
    add ecx, 0x1                                 # 00462b43
    movsx edx, word ptr [ebp - local_c]          # 00462b46
    imul edx, edx, 0x140                         # 00462b4a
    movsx eax, word ptr [ebp - local_14]         # 00462b50
    imul eax, eax, 0x28                          # 00462b54
    mov word ptr [edx + eax + 0x594ddb], cx      # 00462b57
L_00462b5f:
    # block 0x00462b5f: entered by jne at 0x00462b0a; jne at 0x00462b21, 1 instruction(s), ends with backward jump to 0x00462ada
    jmp.d32 L_00462ada                           # 00462b5f
L_00462b64:
    # block 0x00462b64: entered by jge at 0x00462af3, 1 instruction(s), ends with backward jump to 0x004625df
    jmp.d32 L_004625df                           # 00462b64
L_00462b69:
    # block 0x00462b69: entered by jge at 0x004625f8, 1 instruction(s), ends with backward jump to 0x004625b8
    jmp.d32 L_004625b8                           # 00462b69
L_00462b6e:
    # block 0x00462b6e: entered by jne at 0x004625a1; jge at 0x004625d1, 5 instruction(s), ends with ret
    pop edi                                      # 00462b6e
    pop esi                                      # 00462b6f
    {load} mov esp, ebp                          # 00462b70
    pop ebp                                      # 00462b72
    ret                                          # 00462b73

# --- data items (not part of the function) -------------------------
.org 0x00462b74 - 0x401000
SWTAB_00462b74:  # 4 case address(es)
    .long L_0046271e - .text + 0x401000
    .long L_004628ed - .text + 0x401000
    .long L_004628ed - .text + 0x401000
    .long L_0046271e - .text + 0x401000
.set SWTAB_00462b74_VA, SWTAB_00462b74 - .text + 0x401000

