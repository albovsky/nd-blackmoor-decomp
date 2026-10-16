# FUN_004a44c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a44c0
# extent:       0x004a44c0-0x004a4c05 (1861 code bytes)
# span:         0x004a44c0-0x004a4c15 (code 1861, tables 16, padding 0)
# sha256:       681627c2ee44126a28f9b82ae850cc395cade818db8da4815b33043f85f5ebb5
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a44c0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       [eax + n] field_1e, field_210, field_214, field_216, field_258, field_260, field_264, field_26a, field_26c, field_26e, field_276, field_278 and 3 more; [ecx + n] field_1e, field_21, field_210, field_216, field_25c, field_260, field_264, field_272, field_276, field_278, field_27a, field_27f and 2 more; [edx + n] field_1e, field_21, field_212, field_214, field_258, field_260, field_264, field_266, field_276, field_278, field_413
# callees:      calls FUN_004f6334, FUN_004fb2e3, FUN_004a4d55
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 412 instruction(s), 28 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ field_21, 0x21  # offset +0x21
.equ field_210, 0x210  # offset +0x210
.equ field_212, 0x212  # offset +0x212
.equ field_214, 0x214  # offset +0x214
.equ field_216, 0x216  # offset +0x216
.equ field_258, 0x258  # offset +0x258
.equ field_25c, 0x25c  # offset +0x25c
.equ field_260, 0x260  # offset +0x260
.equ field_264, 0x264  # offset +0x264
.equ field_266, 0x266  # offset +0x266
.equ field_26a, 0x26a  # offset +0x26a
.equ field_26c, 0x26c  # offset +0x26c
.equ field_26e, 0x26e  # offset +0x26e
.equ field_272, 0x272  # offset +0x272
.equ field_276, 0x276  # offset +0x276
.equ field_278, 0x278  # offset +0x278
.equ field_27a, 0x27a  # offset +0x27a
.equ field_27b, 0x27b  # offset +0x27b
.equ field_27f, 0x27f  # offset +0x27f
.equ field_413, 0x413  # offset +0x413
.equ field_5da, 0x5da  # offset +0x5da
.equ field_60b, 0x60b  # offset +0x60b
.equ field_63c, 0x63c  # offset +0x63c

# --- external targets -----------------------------------------------
.set FUN_004a4d55, .text + (0x004a4d55 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004a44c0 - 0x401000
.globl FUN_004a44c0
FUN_004a44c0:
    # block 0x004a44c0: entry, 14 instruction(s), ends with je to 0x004a4bff (forward)
    push ebp                                     # 004a44c0
    {load} mov ebp, esp                          # 004a44c1
    sub esp, 0x20                                # 004a44c3
    push esi                                     # 004a44c6
    push edi                                     # 004a44c7
    mov dword ptr [ebp - local_1c], ecx          # 004a44c8
    mov eax, dword ptr [ebp - local_1c]          # 004a44cb
    movsx ecx, word ptr [eax + field_1e]         # 004a44ce
    imul ecx, ecx, 0x8d                          # 004a44d2
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004a44d8
    mov dword ptr [ebp - local_4], edx           # 004a44de
    mov eax, dword ptr [ebp - local_1c]          # 004a44e1
    cmp dword ptr [eax + field_26e], 0x0         # 004a44e4
    je.d32 L_004a4bff                            # 004a44eb
    # block 0x004a44f1: entered by fall-through of je at 0x004a44eb, 5 instruction(s), ends with jne to 0x004a4bff (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004a44f1
    {load} xor edx, edx                          # 004a44f4
    mov dl, byte ptr [ecx + field_27f]           # 004a44f6
    test edx, edx                                # 004a44fc
    jne.d32 L_004a4bff                           # 004a44fe
    # block 0x004a4504: entered by fall-through of jne at 0x004a44fe, 3 instruction(s), ends with jne to 0x004a4bff (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004a4504
    cmp dword ptr [eax + field_27b], 0x0         # 004a4507
    jne.d32 L_004a4bff                           # 004a450e
    # block 0x004a4514: entered by fall-through of jne at 0x004a450e, 5 instruction(s), ends with jne to 0x004a4bff (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004a4514
    movsx edx, word ptr [ecx + field_1e]         # 004a4517
    imul edx, edx, 0x8d                          # 004a451b
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004a4521
    jne.d32 L_004a4bff                           # 004a4528
    # block 0x004a452e: entered by fall-through of jne at 0x004a4528, 3 instruction(s), ends with jne to 0x004a456c (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004a452e
    cmp dword ptr [eax + field_260], 0x0         # 004a4531
    jne.d8 L_004a456c                            # 004a4538
    # block 0x004a453a: entered by fall-through of jne at 0x004a4538, 2 instruction(s), ends with jne to 0x004a456c (forward)
    cmp dword ptr [0x5c39e5], 0x274f             # 004a453a
    jne.d8 L_004a456c                            # 004a4544
    # block 0x004a4546: entered by fall-through of jne at 0x004a4544, 7 instruction(s), ends with forward jump to 0x004a4bff
    mov ecx, dword ptr [ebp - local_1c]          # 004a4546
    mov byte ptr [ecx + field_27a], 0x1          # 004a4549
    mov edx, dword ptr [ebp - local_1c]          # 004a4550
    movsx eax, word ptr [edx + field_1e]         # 004a4553
    imul eax, eax, 0x8d                          # 004a4557
    mov dword ptr [eax + 0x5bb632], 0x2          # 004a455d
    jmp.d32 L_004a4bff                           # 004a4567
L_004a456c:
    # block 0x004a456c: entered by jne at 0x004a4538; jne at 0x004a4544, 3 instruction(s), ends with jne to 0x004a47cd (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004a456c
    cmp dword ptr [ecx + field_260], 0x0         # 004a456f
    jne.d32 L_004a47cd                           # 004a4576
    # block 0x004a457c: entered by fall-through of jne at 0x004a4576, 2 instruction(s), ends with jne to 0x004a47cd (forward)
    cmp dword ptr [0x5c39e5], 0x274e             # 004a457c
    jne.d32 L_004a47cd                           # 004a4586
    # block 0x004a458c: entered by fall-through of jne at 0x004a4586, 13 instruction(s), ends with ja to 0x004a4735 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004a458c
    movsx eax, word ptr [edx + field_264]        # 004a458f
    imul eax, eax, 0x7c                          # 004a4596
    mov ecx, dword ptr [ebp - local_1c]          # 004a4599
    movsx edx, word ptr [ecx + field_278]        # 004a459c
    imul edx, edx, 0xc                           # 004a45a3
    lea eax, [eax + edx + 0x591a64]              # 004a45a6
    mov ecx, dword ptr [ebp - local_1c]          # 004a45ad
    movsx edx, word ptr [ecx + field_276]        # 004a45b0
    movsx eax, word ptr [eax + 2*edx]            # 004a45b7
    mov dword ptr [ebp - local_20], eax          # 004a45bb
    cmp dword ptr [ebp - local_20], 0x3          # 004a45be
    ja.d32 L_004a4735                            # 004a45c2
    # block 0x004a45c8: entered by fall-through of ja at 0x004a45c2, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4a4c05]
    mov ecx, dword ptr [ebp - local_20]          # 004a45c8
    jmp dword ptr [4*ecx + SWTAB_004a4c05_VA]    # 004a45cb
L_004a45d2:
    # block 0x004a45d2: entered by switch case, 4 instruction(s), ends with jne to 0x004a4614 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a45d2
    movsx eax, word ptr [edx + field_413]        # 004a45d5
    cmp eax, 0x1                                 # 004a45dc
    jne.d8 L_004a4614                            # 004a45df
    # block 0x004a45e1: entered by fall-through of jne at 0x004a45df, 11 instruction(s), ends with forward jump to 0x004a4645
    mov ecx, dword ptr [ebp - local_1c]          # 004a45e1
    movsx edx, word ptr [ecx + field_264]        # 004a45e4
    imul edx, edx, 0x7c                          # 004a45eb
    mov eax, dword ptr [ebp - local_1c]          # 004a45ee
    movsx ecx, word ptr [eax + field_278]        # 004a45f1
    imul ecx, ecx, 0xc                           # 004a45f8
    lea edx, [edx + ecx + 0x591a64]              # 004a45fb
    mov eax, dword ptr [ebp - local_1c]          # 004a4602
    movsx ecx, word ptr [eax + field_276]        # 004a4605
    mov word ptr [edx + 2*ecx], 0x1              # 004a460c
    jmp.d8 L_004a4645                            # 004a4612
L_004a4614:
    # block 0x004a4614: entered by jne at 0x004a45df, 10 instruction(s), falls into the block at 0x004a4645
    mov edx, dword ptr [ebp - local_1c]          # 004a4614
    movsx eax, word ptr [edx + field_264]        # 004a4617
    imul eax, eax, 0x7c                          # 004a461e
    mov ecx, dword ptr [ebp - local_1c]          # 004a4621
    movsx edx, word ptr [ecx + field_278]        # 004a4624
    imul edx, edx, 0xc                           # 004a462b
    lea eax, [eax + edx + 0x591a64]              # 004a462e
    mov ecx, dword ptr [ebp - local_1c]          # 004a4635
    movsx edx, word ptr [ecx + field_276]        # 004a4638
    mov word ptr [eax + 2*edx], 0x2              # 004a463f
L_004a4645:
    # block 0x004a4645: entered by jmp at 0x004a4612, 1 instruction(s), ends with forward jump to 0x004a4735
    jmp.d32 L_004a4735                           # 004a4645
L_004a464a:
    # block 0x004a464a: entered by switch case, 11 instruction(s), ends with forward jump to 0x004a4735
    mov eax, dword ptr [ebp - local_1c]          # 004a464a
    movsx ecx, word ptr [eax + field_264]        # 004a464d
    imul ecx, ecx, 0x7c                          # 004a4654
    mov edx, dword ptr [ebp - local_1c]          # 004a4657
    movsx eax, word ptr [edx + field_278]        # 004a465a
    imul eax, eax, 0xc                           # 004a4661
    lea ecx, [ecx + eax + 0x591a64]              # 004a4664
    mov edx, dword ptr [ebp - local_1c]          # 004a466b
    movsx eax, word ptr [edx + field_276]        # 004a466e
    mov word ptr [ecx + 2*eax], 0x2              # 004a4675
    jmp.d32 L_004a4735                           # 004a467b
L_004a4680:
    # block 0x004a4680: entered by switch case, 4 instruction(s), ends with jne to 0x004a46c2 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a4680
    movsx edx, word ptr [ecx + field_413]        # 004a4683
    cmp edx, 0x1                                 # 004a468a
    jne.d8 L_004a46c2                            # 004a468d
    # block 0x004a468f: entered by fall-through of jne at 0x004a468d, 11 instruction(s), ends with forward jump to 0x004a46f3
    mov eax, dword ptr [ebp - local_1c]          # 004a468f
    movsx ecx, word ptr [eax + field_264]        # 004a4692
    imul ecx, ecx, 0x7c                          # 004a4699
    mov edx, dword ptr [ebp - local_1c]          # 004a469c
    movsx eax, word ptr [edx + field_278]        # 004a469f
    imul eax, eax, 0xc                           # 004a46a6
    lea ecx, [ecx + eax + 0x591a64]              # 004a46a9
    mov edx, dword ptr [ebp - local_1c]          # 004a46b0
    movsx eax, word ptr [edx + field_276]        # 004a46b3
    mov word ptr [ecx + 2*eax], 0x3              # 004a46ba
    jmp.d8 L_004a46f3                            # 004a46c0
L_004a46c2:
    # block 0x004a46c2: entered by jne at 0x004a468d, 10 instruction(s), falls into the block at 0x004a46f3
    mov ecx, dword ptr [ebp - local_1c]          # 004a46c2
    movsx edx, word ptr [ecx + field_264]        # 004a46c5
    imul edx, edx, 0x7c                          # 004a46cc
    mov eax, dword ptr [ebp - local_1c]          # 004a46cf
    movsx ecx, word ptr [eax + field_278]        # 004a46d2
    imul ecx, ecx, 0xc                           # 004a46d9
    lea edx, [edx + ecx + 0x591a64]              # 004a46dc
    mov eax, dword ptr [ebp - local_1c]          # 004a46e3
    movsx ecx, word ptr [eax + field_276]        # 004a46e6
    mov word ptr [edx + 2*ecx], 0x0              # 004a46ed
L_004a46f3:
    # block 0x004a46f3: entered by jmp at 0x004a46c0, 1 instruction(s), ends with forward jump to 0x004a4735
    jmp.d8 L_004a4735                            # 004a46f3
L_004a46f5:
    # block 0x004a46f5: entered by switch case, 4 instruction(s), ends with jne to 0x004a4735 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a46f5
    movsx eax, word ptr [edx + field_413]        # 004a46f8
    cmp eax, 0x1                                 # 004a46ff
    jne.d8 L_004a4735                            # 004a4702
    # block 0x004a4704: entered by fall-through of jne at 0x004a4702, 10 instruction(s), falls into the block at 0x004a4735
    mov ecx, dword ptr [ebp - local_1c]          # 004a4704
    movsx edx, word ptr [ecx + field_264]        # 004a4707
    imul edx, edx, 0x7c                          # 004a470e
    mov eax, dword ptr [ebp - local_1c]          # 004a4711
    movsx ecx, word ptr [eax + field_278]        # 004a4714
    imul ecx, ecx, 0xc                           # 004a471b
    lea edx, [edx + ecx + 0x591a64]              # 004a471e
    mov eax, dword ptr [ebp - local_1c]          # 004a4725
    movsx ecx, word ptr [eax + field_276]        # 004a4728
    mov word ptr [edx + 2*ecx], 0x0              # 004a472f
L_004a4735:
    # block 0x004a4735: entered by ja at 0x004a45c2; jmp at 0x004a4645; jmp at 0x004a467b; jmp at 0x004a46f3; more, 2 instruction(s), ends with je to 0x004a478b (forward)
    cmp dword ptr [0x5bb1ca], 0x0                # 004a4735
    je.d8 L_004a478b                             # 004a473c
    # block 0x004a473e: entered by fall-through of je at 0x004a473c, 7 instruction(s), ends with je to 0x004a478b (forward)
    mov edi, 0x550570                            # 004a473e
    mov esi, dword ptr [ebp - local_4]           # 004a4743
    add esi, 0x61b                               # 004a4746
    mov ecx, 0x9                                 # 004a474c
    {load} xor edx, edx                          # 004a4751
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a4753
    je.d8 L_004a478b                             # 004a4755
    # block 0x004a4757: entered by fall-through of je at 0x004a4755, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a478b (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a4757
    movsx ecx, word ptr [eax + field_63c]        # 004a475a
    mov dword ptr [ebp - local_10], ecx          # 004a4761
    mov edx, dword ptr [ebp - local_10]          # 004a4764
    push edx                                     # 004a4767
    mov ecx, 0x5cf1eb                            # 004a4768
    call FUN_004f6334                            # 004a476d
    test eax, eax                                # 004a4772
    jne.d8 L_004a478b                            # 004a4774
    # block 0x004a4776: entered by fall-through of jne at 0x004a4774, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a478b
    mov eax, dword ptr [ebp - local_4]           # 004a4776
    mov cx, word ptr [eax + field_63c]           # 004a4779
    push ecx                                     # 004a4780
    mov ecx, 0x5c3a67                            # 004a4781
    call FUN_004fb2e3                            # 004a4786
L_004a478b:
    # block 0x004a478b: entered by je at 0x004a473c; je at 0x004a4755; jne at 0x004a4774, 13 instruction(s), calls FUN_004a4d55, ends with forward jump to 0x004a4bff
    mov edx, dword ptr [ebp - local_1c]          # 004a478b
    mov dword ptr [edx + field_266], 0x1         # 004a478e
    mov eax, dword ptr [ebp - local_1c]          # 004a4798
    mov ecx, dword ptr [ebp - local_1c]          # 004a479b
    mov dx, word ptr [ecx + field_276]           # 004a479e
    mov word ptr [eax + field_26a], dx           # 004a47a5
    mov eax, dword ptr [ebp - local_1c]          # 004a47ac
    mov ecx, dword ptr [ebp - local_1c]          # 004a47af
    mov dx, word ptr [ecx + field_278]           # 004a47b2
    mov word ptr [eax + field_26c], dx           # 004a47b9
    mov ecx, dword ptr [ebp - local_1c]          # 004a47c0
    call FUN_004a4d55                            # 004a47c3
    jmp.d32 L_004a4bff                           # 004a47c8
L_004a47cd:
    # block 0x004a47cd: entered by jne at 0x004a4576; jne at 0x004a4586, 3 instruction(s), ends with jne to 0x004a49b3 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004a47cd
    cmp dword ptr [eax + field_260], 0x0         # 004a47d0
    jne.d32 L_004a49b3                           # 004a47d7
    # block 0x004a47dd: entered by fall-through of jne at 0x004a47d7, 2 instruction(s), ends with jne to 0x004a49b3 (forward)
    cmp dword ptr [0x5c39e5], 0x274c             # 004a47dd
    jne.d32 L_004a49b3                           # 004a47e7
    # block 0x004a47ed: entered by fall-through of jne at 0x004a47e7, 22 instruction(s), ends with jne to 0x004a4875 (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004a47ed
    mov dword ptr [ecx + field_272], 0x0         # 004a47f0
    mov edx, dword ptr [ebp - local_1c]          # 004a47fa
    mov dword ptr [edx + field_260], 0x1         # 004a47fd
    mov eax, dword ptr [ebp - local_1c]          # 004a4807
    mov dword ptr [eax + field_258], 0x1         # 004a480a
    mov ecx, dword ptr [ebp - local_1c]          # 004a4814
    movsx edx, word ptr [ecx + field_264]        # 004a4817
    imul edx, edx, 0x7c                          # 004a481e
    mov eax, dword ptr [ebp - local_1c]          # 004a4821
    movsx ecx, word ptr [eax + field_278]        # 004a4824
    imul ecx, ecx, 0xc                           # 004a482b
    lea edx, [edx + ecx + 0x591a28]              # 004a482e
    mov eax, dword ptr [ebp - local_1c]          # 004a4835
    movsx ecx, word ptr [eax + field_276]        # 004a4838
    mov eax, dword ptr [ebp - local_1c]          # 004a483f
    mov cx, word ptr [edx + 2*ecx]               # 004a4842
    mov word ptr [eax + field_214], cx           # 004a4846
    mov edx, dword ptr [ebp - local_1c]          # 004a484d
    movsx eax, word ptr [edx + field_214]        # 004a4850
    test eax, eax                                # 004a4857
    jne.d8 L_004a4875                            # 004a4859
    # block 0x004a485b: entered by fall-through of jne at 0x004a4859, 5 instruction(s), ends with forward jump to 0x004a48bd
    mov ecx, dword ptr [ebp - local_1c]          # 004a485b
    mov word ptr [ecx + field_210], 0x0          # 004a485e
    mov edx, dword ptr [ebp - local_1c]          # 004a4867
    mov word ptr [edx + field_212], 0x0          # 004a486a
    jmp.d8 L_004a48bd                            # 004a4873
L_004a4875:
    # block 0x004a4875: entered by jne at 0x004a4859, 18 instruction(s), falls into the block at 0x004a48bd
    mov eax, dword ptr [ebp - local_1c]          # 004a4875
    movsx eax, word ptr [eax + field_214]        # 004a4878
    mov ecx, dword ptr [ebp - local_4]           # 004a487f
    movsx ecx, byte ptr [ecx + field_21]         # 004a4882
    cdq                                          # 004a4886
    idiv ecx                                     # 004a4887
    mov edx, dword ptr [ebp - local_1c]          # 004a4889
    mov word ptr [edx + field_212], ax           # 004a488c
    mov eax, dword ptr [ebp - local_1c]          # 004a4893
    movsx ecx, word ptr [eax + field_214]        # 004a4896
    mov edx, dword ptr [ebp - local_1c]          # 004a489d
    movsx eax, word ptr [edx + field_212]        # 004a48a0
    mov edx, dword ptr [ebp - local_4]           # 004a48a7
    movsx edx, byte ptr [edx + field_21]         # 004a48aa
    imul eax, edx                                # 004a48ae
    {load} sub ecx, eax                          # 004a48b1
    mov eax, dword ptr [ebp - local_1c]          # 004a48b3
    mov word ptr [eax + field_210], cx           # 004a48b6
L_004a48bd:
    # block 0x004a48bd: entered by jmp at 0x004a4873, 34 instruction(s), ends with je to 0x004a49ae (forward)
    mov ecx, dword ptr [ebp - local_1c]          # 004a48bd
    movsx edx, word ptr [ecx + field_264]        # 004a48c0
    imul edx, edx, 0x7c                          # 004a48c7
    mov eax, dword ptr [ebp - local_1c]          # 004a48ca
    movsx ecx, word ptr [eax + field_278]        # 004a48cd
    imul ecx, ecx, 0xc                           # 004a48d4
    lea edx, [edx + ecx + 0x591a64]              # 004a48d7
    mov eax, dword ptr [ebp - local_1c]          # 004a48de
    movsx ecx, word ptr [eax + field_276]        # 004a48e1
    mov eax, dword ptr [ebp - local_1c]          # 004a48e8
    mov cx, word ptr [edx + 2*ecx]               # 004a48eb
    mov word ptr [eax + field_216], cx           # 004a48ef
    mov edx, dword ptr [ebp - local_1c]          # 004a48f6
    movsx eax, word ptr [edx + field_264]        # 004a48f9
    imul eax, eax, 0x7c                          # 004a4900
    mov ecx, dword ptr [ebp - local_1c]          # 004a4903
    movsx edx, word ptr [ecx + field_278]        # 004a4906
    imul edx, edx, 0xc                           # 004a490d
    lea eax, [eax + edx + 0x591a28]              # 004a4910
    mov ecx, dword ptr [ebp - local_1c]          # 004a4917
    movsx edx, word ptr [ecx + field_276]        # 004a491a
    mov word ptr [eax + 2*edx], 0xfff6           # 004a4921
    mov eax, dword ptr [ebp - local_1c]          # 004a4927
    movsx ecx, word ptr [eax + field_264]        # 004a492a
    imul ecx, ecx, 0x7c                          # 004a4931
    mov edx, dword ptr [ebp - local_1c]          # 004a4934
    movsx eax, word ptr [edx + field_278]        # 004a4937
    imul eax, eax, 0xc                           # 004a493e
    lea ecx, [ecx + eax + 0x591a64]              # 004a4941
    mov edx, dword ptr [ebp - local_1c]          # 004a4948
    movsx eax, word ptr [edx + field_276]        # 004a494b
    mov word ptr [ecx + 2*eax], 0xfff6           # 004a4952
    cmp dword ptr [0x5bb1ca], 0x0                # 004a4958
    je.d8 L_004a49ae                             # 004a495f
    # block 0x004a4961: entered by fall-through of je at 0x004a495f, 7 instruction(s), ends with je to 0x004a49ae (forward)
    mov edi, 0x55057c                            # 004a4961
    mov esi, dword ptr [ebp - local_4]           # 004a4966
    add esi, 0x5b9                               # 004a4969
    mov ecx, 0x9                                 # 004a496f
    {load} xor edx, edx                          # 004a4974
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a4976
    je.d8 L_004a49ae                             # 004a4978
    # block 0x004a497a: entered by fall-through of je at 0x004a4978, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a49ae (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a497a
    movsx ecx, word ptr [eax + field_5da]        # 004a497d
    mov dword ptr [ebp - local_14], ecx          # 004a4984
    mov edx, dword ptr [ebp - local_14]          # 004a4987
    push edx                                     # 004a498a
    mov ecx, 0x5cf1eb                            # 004a498b
    call FUN_004f6334                            # 004a4990
    test eax, eax                                # 004a4995
    jne.d8 L_004a49ae                            # 004a4997
    # block 0x004a4999: entered by fall-through of jne at 0x004a4997, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a49ae
    mov eax, dword ptr [ebp - local_4]           # 004a4999
    mov cx, word ptr [eax + field_5da]           # 004a499c
    push ecx                                     # 004a49a3
    mov ecx, 0x5c3a67                            # 004a49a4
    call FUN_004fb2e3                            # 004a49a9
L_004a49ae:
    # block 0x004a49ae: entered by je at 0x004a495f; je at 0x004a4978; jne at 0x004a4997, 1 instruction(s), ends with forward jump to 0x004a4bff
    jmp.d32 L_004a4bff                           # 004a49ae
L_004a49b3:
    # block 0x004a49b3: entered by jne at 0x004a47d7; jne at 0x004a47e7, 3 instruction(s), ends with je to 0x004a4bff (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004a49b3
    cmp dword ptr [edx + field_260], 0x0         # 004a49b6
    je.d32 L_004a4bff                            # 004a49bd
    # block 0x004a49c3: entered by fall-through of je at 0x004a49bd, 2 instruction(s), ends with jne to 0x004a4bff (forward)
    cmp dword ptr [0x5c39e5], 0x274d             # 004a49c3
    jne.d32 L_004a4bff                           # 004a49cd
    # block 0x004a49d3: entered by fall-through of jne at 0x004a49cd, 60 instruction(s), ends with je to 0x004a4b43 (forward)
    mov eax, dword ptr [ebp - local_1c]          # 004a49d3
    movsx ecx, word ptr [eax + field_264]        # 004a49d6
    imul ecx, ecx, 0x7c                          # 004a49dd
    mov edx, dword ptr [ebp - local_1c]          # 004a49e0
    movsx eax, word ptr [edx + field_278]        # 004a49e3
    imul eax, eax, 0xc                           # 004a49ea
    lea ecx, [ecx + eax + 0x591a28]              # 004a49ed
    mov edx, dword ptr [ebp - local_1c]          # 004a49f4
    movsx eax, word ptr [edx + field_276]        # 004a49f7
    mov cx, word ptr [ecx + 2*eax]               # 004a49fe
    mov word ptr [ebp - local_8], cx             # 004a4a02
    mov edx, dword ptr [ebp - local_1c]          # 004a4a06
    movsx eax, word ptr [edx + field_264]        # 004a4a09
    imul eax, eax, 0x7c                          # 004a4a10
    mov ecx, dword ptr [ebp - local_1c]          # 004a4a13
    movsx edx, word ptr [ecx + field_278]        # 004a4a16
    imul edx, edx, 0xc                           # 004a4a1d
    lea eax, [eax + edx + 0x591a64]              # 004a4a20
    mov ecx, dword ptr [ebp - local_1c]          # 004a4a27
    movsx edx, word ptr [ecx + field_276]        # 004a4a2a
    mov ax, word ptr [eax + 2*edx]               # 004a4a31
    mov word ptr [ebp - local_c], ax             # 004a4a35
    mov ecx, dword ptr [ebp - local_1c]          # 004a4a39
    movsx edx, word ptr [ecx + field_264]        # 004a4a3c
    imul edx, edx, 0x7c                          # 004a4a43
    mov eax, dword ptr [ebp - local_1c]          # 004a4a46
    movsx ecx, word ptr [eax + field_278]        # 004a4a49
    imul ecx, ecx, 0xc                           # 004a4a50
    lea edx, [edx + ecx + 0x591a28]              # 004a4a53
    mov eax, dword ptr [ebp - local_1c]          # 004a4a5a
    movsx ecx, word ptr [eax + field_276]        # 004a4a5d
    mov eax, dword ptr [ebp - local_1c]          # 004a4a64
    mov ax, word ptr [eax + field_214]           # 004a4a67
    mov word ptr [edx + 2*ecx], ax               # 004a4a6e
    mov ecx, dword ptr [ebp - local_1c]          # 004a4a72
    movsx edx, word ptr [ecx + field_264]        # 004a4a75
    imul edx, edx, 0x7c                          # 004a4a7c
    mov eax, dword ptr [ebp - local_1c]          # 004a4a7f
    movsx ecx, word ptr [eax + field_278]        # 004a4a82
    imul ecx, ecx, 0xc                           # 004a4a89
    lea edx, [edx + ecx + 0x591a64]              # 004a4a8c
    mov eax, dword ptr [ebp - local_1c]          # 004a4a93
    movsx ecx, word ptr [eax + field_276]        # 004a4a96
    mov eax, dword ptr [ebp - local_1c]          # 004a4a9d
    mov ax, word ptr [eax + field_216]           # 004a4aa0
    mov word ptr [edx + 2*ecx], ax               # 004a4aa7
    mov ecx, dword ptr [ebp - local_1c]          # 004a4aab
    mov dword ptr [ecx + field_25c], 0x1         # 004a4aae
    mov edx, dword ptr [ebp - local_1c]          # 004a4ab8
    mov dword ptr [edx + field_266], 0x1         # 004a4abb
    mov eax, dword ptr [ebp - local_1c]          # 004a4ac5
    mov ecx, dword ptr [ebp - local_1c]          # 004a4ac8
    mov dx, word ptr [ecx + field_276]           # 004a4acb
    mov word ptr [eax + field_26a], dx           # 004a4ad2
    mov eax, dword ptr [ebp - local_1c]          # 004a4ad9
    mov ecx, dword ptr [ebp - local_1c]          # 004a4adc
    mov dx, word ptr [ecx + field_278]           # 004a4adf
    mov word ptr [eax + field_26c], dx           # 004a4ae6
    cmp dword ptr [0x5bb1ca], 0x0                # 004a4aed
    je.d8 L_004a4b43                             # 004a4af4
    # block 0x004a4af6: entered by fall-through of je at 0x004a4af4, 7 instruction(s), ends with je to 0x004a4b43 (forward)
    mov edi, 0x550588                            # 004a4af6
    mov esi, dword ptr [ebp - local_4]           # 004a4afb
    add esi, 0x5ea                               # 004a4afe
    mov ecx, 0x9                                 # 004a4b04
    {load} xor eax, eax                          # 004a4b09
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004a4b0b
    je.d8 L_004a4b43                             # 004a4b0d
    # block 0x004a4b0f: entered by fall-through of je at 0x004a4b0d, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004a4b43 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a4b0f
    movsx edx, word ptr [ecx + field_60b]        # 004a4b12
    mov dword ptr [ebp - local_18], edx          # 004a4b19
    mov eax, dword ptr [ebp - local_18]          # 004a4b1c
    push eax                                     # 004a4b1f
    mov ecx, 0x5cf1eb                            # 004a4b20
    call FUN_004f6334                            # 004a4b25
    test eax, eax                                # 004a4b2a
    jne.d8 L_004a4b43                            # 004a4b2c
    # block 0x004a4b2e: entered by fall-through of jne at 0x004a4b2c, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004a4b43
    mov ecx, dword ptr [ebp - local_4]           # 004a4b2e
    mov dx, word ptr [ecx + field_60b]           # 004a4b31
    push edx                                     # 004a4b38
    mov ecx, 0x5c3a67                            # 004a4b39
    call FUN_004fb2e3                            # 004a4b3e
L_004a4b43:
    # block 0x004a4b43: entered by je at 0x004a4af4; je at 0x004a4b0d; jne at 0x004a4b2c, 3 instruction(s), ends with jne to 0x004a4b66 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004a4b43
    cmp eax, -0xa                                # 004a4b47
    jne.d8 L_004a4b66                            # 004a4b4a
    # block 0x004a4b4c: entered by fall-through of jne at 0x004a4b4a, 5 instruction(s), calls FUN_004a4d55, ends with forward jump to 0x004a4bff
    mov ecx, dword ptr [ebp - local_1c]          # 004a4b4c
    mov dword ptr [ecx + field_260], 0x0         # 004a4b4f
    mov ecx, dword ptr [ebp - local_1c]          # 004a4b59
    call FUN_004a4d55                            # 004a4b5c
    jmp.d32 L_004a4bff                           # 004a4b61
L_004a4b66:
    # block 0x004a4b66: entered by jne at 0x004a4b4a, 9 instruction(s), ends with jne to 0x004a4ba9 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004a4b66
    mov dword ptr [edx + field_258], 0x1         # 004a4b69
    mov eax, dword ptr [ebp - local_1c]          # 004a4b73
    mov cx, word ptr [ebp - local_8]             # 004a4b76
    mov word ptr [eax + field_214], cx           # 004a4b7a
    mov edx, dword ptr [ebp - local_1c]          # 004a4b81
    movsx eax, word ptr [edx + field_214]        # 004a4b84
    test eax, eax                                # 004a4b8b
    jne.d8 L_004a4ba9                            # 004a4b8d
    # block 0x004a4b8f: entered by fall-through of jne at 0x004a4b8d, 5 instruction(s), ends with forward jump to 0x004a4bf1
    mov ecx, dword ptr [ebp - local_1c]          # 004a4b8f
    mov word ptr [ecx + field_210], 0x0          # 004a4b92
    mov edx, dword ptr [ebp - local_1c]          # 004a4b9b
    mov word ptr [edx + field_212], 0x0          # 004a4b9e
    jmp.d8 L_004a4bf1                            # 004a4ba7
L_004a4ba9:
    # block 0x004a4ba9: entered by jne at 0x004a4b8d, 18 instruction(s), falls into the block at 0x004a4bf1
    mov eax, dword ptr [ebp - local_1c]          # 004a4ba9
    movsx eax, word ptr [eax + field_214]        # 004a4bac
    mov ecx, dword ptr [ebp - local_4]           # 004a4bb3
    movsx ecx, byte ptr [ecx + field_21]         # 004a4bb6
    cdq                                          # 004a4bba
    idiv ecx                                     # 004a4bbb
    mov edx, dword ptr [ebp - local_1c]          # 004a4bbd
    mov word ptr [edx + field_212], ax           # 004a4bc0
    mov eax, dword ptr [ebp - local_1c]          # 004a4bc7
    movsx ecx, word ptr [eax + field_214]        # 004a4bca
    mov edx, dword ptr [ebp - local_1c]          # 004a4bd1
    movsx eax, word ptr [edx + field_212]        # 004a4bd4
    mov edx, dword ptr [ebp - local_4]           # 004a4bdb
    movsx edx, byte ptr [edx + field_21]         # 004a4bde
    imul eax, edx                                # 004a4be2
    {load} sub ecx, eax                          # 004a4be5
    mov eax, dword ptr [ebp - local_1c]          # 004a4be7
    mov word ptr [eax + field_210], cx           # 004a4bea
L_004a4bf1:
    # block 0x004a4bf1: entered by jmp at 0x004a4ba7, 3 instruction(s), falls into the block at 0x004a4bff
    mov ecx, dword ptr [ebp - local_1c]          # 004a4bf1
    mov dx, word ptr [ebp - local_c]             # 004a4bf4
    mov word ptr [ecx + field_216], dx           # 004a4bf8
L_004a4bff:
    # block 0x004a4bff: entered by je at 0x004a44eb; jne at 0x004a44fe; jne at 0x004a450e; jne at 0x004a4528; more, 5 instruction(s), ends with ret
    pop edi                                      # 004a4bff
    pop esi                                      # 004a4c00
    {load} mov esp, ebp                          # 004a4c01
    pop ebp                                      # 004a4c03
    ret                                          # 004a4c04

# --- data items (not part of the function) -------------------------
.org 0x004a4c05 - 0x401000
SWTAB_004a4c05:  # 4 case address(es)
    .long L_004a45d2 - .text + 0x401000
    .long L_004a464a - .text + 0x401000
    .long L_004a4680 - .text + 0x401000
    .long L_004a46f5 - .text + 0x401000
.set SWTAB_004a4c05_VA, SWTAB_004a4c05 - .text + 0x401000

