# FUN_004b05ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b05ae
# extent:       0x004b05ae-0x004b0f5f (2481 code bytes)
# span:         0x004b05ae-0x004b0f9f (code 2481, tables 64, padding 0)
# sha256:       72950bccc3fde79a1b413f68e1ed0f510b3b80e890b75ead3516076092fe8d20
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b05ae
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24
# fields:       [eax + n] field_4, field_8, field_c, field_10, field_18, field_1e, field_3f, field_41, field_43, field_1a8, field_1529, field_152d and 2 more; [ecx + n] field_4, field_8, field_c, field_10, field_18, field_3f, field_43, field_1531, field_1533; [edx + n] field_4, field_8, field_c, field_3b, field_3f, field_41, field_43, field_1a8, field_1531; [esi + n] field_43
# callees:      calls FUN_004b10e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 649 instruction(s), 28 conditional branch(es) and 3 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ local_24, 0x24  # offset -0x24
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_18, 0x18  # offset +0x18
.equ field_1e, 0x1e  # offset +0x1e
.equ field_3b, 0x3b  # offset +0x3b
.equ field_3f, 0x3f  # offset +0x3f
.equ field_41, 0x41  # offset +0x41
.equ field_43, 0x43  # offset +0x43
.equ field_1a8, 0x1a8  # offset +0x1a8
.equ field_1529, 0x1529  # offset +0x1529
.equ field_152d, 0x152d  # offset +0x152d
.equ field_1531, 0x1531  # offset +0x1531
.equ field_1533, 0x1533  # offset +0x1533

# --- external targets -----------------------------------------------
.set FUN_004b10e3, .text + (0x004b10e3 - 0x401000)

.org 0x004b05ae - 0x401000
.globl FUN_004b05ae
FUN_004b05ae:
    # block 0x004b05ae: entry, 35 instruction(s), ends with ja to 0x004b0712 (forward)
    push ebp                                     # 004b05ae
    {load} mov ebp, esp                          # 004b05af
    sub esp, 0x24                                # 004b05b1
    push esi                                     # 004b05b4
    push edi                                     # 004b05b5
    mov dword ptr [ebp - local_18], ecx          # 004b05b6
    mov eax, dword ptr [ebp - local_18]          # 004b05b9
    movsx ecx, word ptr [eax + field_1e]         # 004b05bc
    imul ecx, ecx, 0x8d                          # 004b05c0
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b05c6
    mov dword ptr [ebp - local_c], edx           # 004b05cc
    mov eax, dword ptr [ebp - local_18]          # 004b05cf
    mov cx, word ptr [eax + field_3f]            # 004b05d2
    mov word ptr [ebp - local_8], cx             # 004b05d6
    mov edx, dword ptr [ebp - local_18]          # 004b05da
    mov ax, word ptr [edx + field_41]            # 004b05dd
    mov word ptr [ebp - local_4], ax             # 004b05e1
    mov dword ptr [ebp - local_10], 0x0          # 004b05e5
    mov ecx, dword ptr [ebp - local_18]          # 004b05ec
    movsx edx, word ptr [ecx + field_3f]         # 004b05ef
    imul edx, edx, 0x1e4                         # 004b05f3
    mov eax, dword ptr [ebp - local_18]          # 004b05f9
    lea ecx, [eax + edx + field_43]              # 004b05fc
    mov edx, dword ptr [ebp - local_18]          # 004b0600
    movsx eax, word ptr [edx + field_41]         # 004b0603
    imul eax, eax, 0x2c                          # 004b0607
    mov cx, word ptr [ecx + eax + field_18]      # 004b060a
    mov word ptr [ebp - local_14], cx            # 004b060f
    movsx edx, word ptr [ebp - local_14]         # 004b0613
    mov dword ptr [ebp - local_1c], edx          # 004b0617
    mov eax, dword ptr [ebp - local_1c]          # 004b061a
    sub eax, 0x1                                 # 004b061d
    mov dword ptr [ebp - local_1c], eax          # 004b0620
    cmp dword ptr [ebp - local_1c], 0x5          # 004b0623
    ja.d32 L_004b0712                            # 004b0627
    # block 0x004b062d: entered by fall-through of ja at 0x004b0627, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4b0f5f]
    mov ecx, dword ptr [ebp - local_1c]          # 004b062d
    jmp dword ptr [4*ecx + SWTAB_004b0f5f_VA]    # 004b0630
L_004b0637:
    # block 0x004b0637: entered by switch case, 4 instruction(s), ends with jne to 0x004b0653 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b0637
    movsx eax, word ptr [edx + field_1531]       # 004b063a
    cmp eax, 0x2797                              # 004b0641
    jne.d8 L_004b0653                            # 004b0646
    # block 0x004b0648: entered by fall-through of jne at 0x004b0646, 3 instruction(s), falls into the block at 0x004b0653
    movsx ecx, word ptr [ebp - local_4]          # 004b0648
    sub ecx, 0x1                                 # 004b064c
    mov word ptr [ebp - local_4], cx             # 004b064f
L_004b0653:
    # block 0x004b0653: entered by jne at 0x004b0646, 1 instruction(s), ends with forward jump to 0x004b0712
    jmp.d32 L_004b0712                           # 004b0653
L_004b0658:
    # block 0x004b0658: entered by switch case, 4 instruction(s), ends with jne to 0x004b0674 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b0658
    movsx eax, word ptr [edx + field_1531]       # 004b065b
    cmp eax, 0x2797                              # 004b0662
    jne.d8 L_004b0674                            # 004b0667
    # block 0x004b0669: entered by fall-through of jne at 0x004b0667, 3 instruction(s), falls into the block at 0x004b0674
    movsx ecx, word ptr [ebp - local_4]          # 004b0669
    sub ecx, 0x2                                 # 004b066d
    mov word ptr [ebp - local_4], cx             # 004b0670
L_004b0674:
    # block 0x004b0674: entered by jne at 0x004b0667, 1 instruction(s), ends with forward jump to 0x004b0712
    jmp.d32 L_004b0712                           # 004b0674
L_004b0679:
    # block 0x004b0679: entered by switch case, 4 instruction(s), ends with jne to 0x004b0695 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b0679
    movsx eax, word ptr [edx + field_1531]       # 004b067c
    cmp eax, 0x2796                              # 004b0683
    jne.d8 L_004b0695                            # 004b0688
    # block 0x004b068a: entered by fall-through of jne at 0x004b0688, 3 instruction(s), falls into the block at 0x004b0695
    movsx ecx, word ptr [ebp - local_8]          # 004b068a
    sub ecx, 0x1                                 # 004b068e
    mov word ptr [ebp - local_8], cx             # 004b0691
L_004b0695:
    # block 0x004b0695: entered by jne at 0x004b0688, 1 instruction(s), ends with forward jump to 0x004b0712
    jmp.d8 L_004b0712                            # 004b0695
L_004b0697:
    # block 0x004b0697: entered by switch case, 4 instruction(s), ends with jne to 0x004b06b3 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b0697
    movsx eax, word ptr [edx + field_1531]       # 004b069a
    cmp eax, 0x2796                              # 004b06a1
    jne.d8 L_004b06b3                            # 004b06a6
    # block 0x004b06a8: entered by fall-through of jne at 0x004b06a6, 3 instruction(s), falls into the block at 0x004b06b3
    movsx ecx, word ptr [ebp - local_8]          # 004b06a8
    sub ecx, 0x2                                 # 004b06ac
    mov word ptr [ebp - local_8], cx             # 004b06af
L_004b06b3:
    # block 0x004b06b3: entered by jne at 0x004b06a6, 1 instruction(s), ends with forward jump to 0x004b0712
    jmp.d8 L_004b0712                            # 004b06b3
L_004b06b5:
    # block 0x004b06b5: entered by switch case, 4 instruction(s), ends with je to 0x004b06d8 (forward)
    mov edx, dword ptr [ebp - local_18]          # 004b06b5
    movsx eax, word ptr [edx + field_1531]       # 004b06b8
    cmp eax, 0x2797                              # 004b06bf
    je.d8 L_004b06d8                             # 004b06c4
    # block 0x004b06c6: entered by fall-through of je at 0x004b06c4, 4 instruction(s), ends with jne to 0x004b06e3 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b06c6
    movsx edx, word ptr [ecx + field_1531]       # 004b06c9
    cmp edx, 0x2796                              # 004b06d0
    jne.d8 L_004b06e3                            # 004b06d6
L_004b06d8:
    # block 0x004b06d8: entered by je at 0x004b06c4; fall-through of jne at 0x004b06d6, 3 instruction(s), falls into the block at 0x004b06e3
    movsx eax, word ptr [ebp - local_8]          # 004b06d8
    sub eax, 0x1                                 # 004b06dc
    mov word ptr [ebp - local_8], ax             # 004b06df
L_004b06e3:
    # block 0x004b06e3: entered by jne at 0x004b06d6, 4 instruction(s), ends with je to 0x004b0707 (forward)
    mov ecx, dword ptr [ebp - local_18]          # 004b06e3
    movsx edx, word ptr [ecx + field_1531]       # 004b06e6
    cmp edx, 0x2797                              # 004b06ed
    je.d8 L_004b0707                             # 004b06f3
    # block 0x004b06f5: entered by fall-through of je at 0x004b06f3, 4 instruction(s), ends with jne to 0x004b0712 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b06f5
    movsx ecx, word ptr [eax + field_1531]       # 004b06f8
    cmp ecx, 0x2795                              # 004b06ff
    jne.d8 L_004b0712                            # 004b0705
L_004b0707:
    # block 0x004b0707: entered by je at 0x004b06f3; fall-through of jne at 0x004b0705, 3 instruction(s), falls into the block at 0x004b0712
    movsx edx, word ptr [ebp - local_4]          # 004b0707
    sub edx, 0x1                                 # 004b070b
    mov word ptr [ebp - local_4], dx             # 004b070e
L_004b0712:
    # block 0x004b0712: entered by ja at 0x004b0627; jmp at 0x004b0653; jmp at 0x004b0674; jmp at 0x004b0695; more, 27 instruction(s), ends with ja to 0x004b0b64 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b0712
    imul eax, eax, 0x1e4                         # 004b0716
    mov ecx, dword ptr [ebp - local_18]          # 004b071c
    lea edx, [ecx + eax + field_43]              # 004b071f
    movsx eax, word ptr [ebp - local_4]          # 004b0723
    imul eax, eax, 0x2c                          # 004b0727
    lea ecx, [edx + eax + field_4]               # 004b072a
    mov edx, dword ptr [ebp - local_18]          # 004b072e
    add edx, 0x29                                # 004b0731
    mov eax, dword ptr [ecx]                     # 004b0734
    mov dword ptr [edx], eax                     # 004b0736
    mov eax, dword ptr [ecx + field_4]           # 004b0738
    mov dword ptr [edx + field_4], eax           # 004b073b
    mov eax, dword ptr [ecx + field_8]           # 004b073e
    mov dword ptr [edx + field_8], eax           # 004b0741
    mov ecx, dword ptr [ecx + field_c]           # 004b0744
    mov dword ptr [edx + field_c], ecx           # 004b0747
    mov edx, dword ptr [ebp - local_18]          # 004b074a
    mov dword ptr [edx + field_3b], 0x1          # 004b074d
    mov eax, dword ptr [ebp - local_18]          # 004b0754
    movsx ecx, word ptr [eax + field_1531]       # 004b0757
    mov dword ptr [ebp - local_20], ecx          # 004b075e
    mov edx, dword ptr [ebp - local_20]          # 004b0761
    sub edx, 0x2794                              # 004b0764
    mov dword ptr [ebp - local_20], edx          # 004b076a
    cmp dword ptr [ebp - local_20], 0x3          # 004b076d
    ja.d32 L_004b0b64                            # 004b0771
    # block 0x004b0777: entered by fall-through of ja at 0x004b0771, 2 instruction(s), ends with indirect jump dword ptr [4*eax + 0x4b0f77]
    mov eax, dword ptr [ebp - local_20]          # 004b0777
    jmp dword ptr [4*eax + SWTAB_004b0f77_VA]    # 004b077a
L_004b0781:
    # block 0x004b0781: entered by switch case, 53 instruction(s), ends with jne to 0x004b0876 (forward)
    movsx ecx, word ptr [ebp - local_8]          # 004b0781
    imul ecx, ecx, 0x1e4                         # 004b0785
    mov edx, dword ptr [ebp - local_18]          # 004b078b
    lea ecx, [edx + ecx + field_43]              # 004b078e
    movsx esi, word ptr [ebp - local_4]          # 004b0792
    imul esi, esi, 0x2c                          # 004b0796
    mov edx, dword ptr [ebp - local_c]           # 004b0799
    movsx edi, word ptr [edx + field_1a8]        # 004b079c
    mov eax, dword ptr [ebp - local_18]          # 004b07a3
    mov eax, dword ptr [eax + field_1529]        # 004b07a6
    cdq                                          # 004b07ac
    idiv edi                                     # 004b07ad
    mov ecx, dword ptr [ecx + esi + field_4]     # 004b07af
    {load} sub ecx, eax                          # 004b07b3
    movsx edx, word ptr [ebp - local_4]          # 004b07b5
    imul edx, edx, 0x2c                          # 004b07b9
    movsx eax, word ptr [ebp - local_8]          # 004b07bc
    imul eax, eax, 0x1e4                         # 004b07c0
    mov esi, dword ptr [ebp - local_18]          # 004b07c6
    lea eax, [esi + eax + field_43]              # 004b07c9
    mov dword ptr [eax + edx + field_4], ecx     # 004b07cd
    movsx ecx, word ptr [ebp - local_8]          # 004b07d1
    imul ecx, ecx, 0x1e4                         # 004b07d5
    mov edx, dword ptr [ebp - local_18]          # 004b07db
    lea ecx, [edx + ecx + field_43]              # 004b07de
    movsx esi, word ptr [ebp - local_4]          # 004b07e2
    imul esi, esi, 0x2c                          # 004b07e6
    mov edx, dword ptr [ebp - local_c]           # 004b07e9
    movsx edi, word ptr [edx + field_1a8]        # 004b07ec
    mov eax, dword ptr [ebp - local_18]          # 004b07f3
    mov eax, dword ptr [eax + field_1529]        # 004b07f6
    cdq                                          # 004b07fc
    idiv edi                                     # 004b07fd
    mov ecx, dword ptr [ecx + esi + field_c]     # 004b07ff
    {load} sub ecx, eax                          # 004b0803
    movsx edx, word ptr [ebp - local_4]          # 004b0805
    imul edx, edx, 0x2c                          # 004b0809
    movsx eax, word ptr [ebp - local_8]          # 004b080c
    imul eax, eax, 0x1e4                         # 004b0810
    mov esi, dword ptr [ebp - local_18]          # 004b0816
    lea eax, [esi + eax + field_43]              # 004b0819
    mov dword ptr [eax + edx + field_c], ecx     # 004b081d
    mov ecx, dword ptr [ebp - local_18]          # 004b0821
    mov dx, word ptr [ecx + field_1533]          # 004b0824
    add dx, 0x1                                  # 004b082b
    mov eax, dword ptr [ebp - local_18]          # 004b082f
    mov word ptr [eax + field_1533], dx          # 004b0832
    mov ecx, dword ptr [ebp - local_18]          # 004b0839
    movsx edx, word ptr [ecx + field_1533]       # 004b083c
    mov eax, dword ptr [ebp - local_c]           # 004b0843
    movsx ecx, word ptr [eax + field_1a8]        # 004b0846
    {load} cmp edx, ecx                          # 004b084d
    jne.d8 L_004b0876                            # 004b084f
    # block 0x004b0851: entered by fall-through of jne at 0x004b084f, 9 instruction(s), falls into the block at 0x004b0876
    mov dword ptr [ebp - local_10], 0x1          # 004b0851
    mov dx, word ptr [ebp - local_4]             # 004b0858
    sub dx, 0x1                                  # 004b085c
    mov word ptr [ebp - local_4], dx             # 004b0860
    mov eax, dword ptr [ebp - local_18]          # 004b0864
    mov cx, word ptr [eax + field_41]            # 004b0867
    sub cx, 0x1                                  # 004b086b
    mov edx, dword ptr [ebp - local_18]          # 004b086f
    mov word ptr [edx + field_41], cx            # 004b0872
L_004b0876:
    # block 0x004b0876: entered by jne at 0x004b084f, 1 instruction(s), ends with forward jump to 0x004b0b64
    jmp.d32 L_004b0b64                           # 004b0876
L_004b087b:
    # block 0x004b087b: entered by switch case, 53 instruction(s), ends with jne to 0x004b0970 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b087b
    imul eax, eax, 0x1e4                         # 004b087f
    mov ecx, dword ptr [ebp - local_18]          # 004b0885
    lea ecx, [ecx + eax + field_43]              # 004b0888
    movsx esi, word ptr [ebp - local_4]          # 004b088c
    imul esi, esi, 0x2c                          # 004b0890
    mov edx, dword ptr [ebp - local_c]           # 004b0893
    movsx edi, word ptr [edx + field_1a8]        # 004b0896
    mov eax, dword ptr [ebp - local_18]          # 004b089d
    mov eax, dword ptr [eax + field_152d]        # 004b08a0
    cdq                                          # 004b08a6
    idiv edi                                     # 004b08a7
    mov ecx, dword ptr [ecx + esi + field_8]     # 004b08a9
    {load} sub ecx, eax                          # 004b08ad
    movsx edx, word ptr [ebp - local_4]          # 004b08af
    imul edx, edx, 0x2c                          # 004b08b3
    movsx eax, word ptr [ebp - local_8]          # 004b08b6
    imul eax, eax, 0x1e4                         # 004b08ba
    mov esi, dword ptr [ebp - local_18]          # 004b08c0
    lea eax, [esi + eax + field_43]              # 004b08c3
    mov dword ptr [eax + edx + field_8], ecx     # 004b08c7
    movsx ecx, word ptr [ebp - local_8]          # 004b08cb
    imul ecx, ecx, 0x1e4                         # 004b08cf
    mov edx, dword ptr [ebp - local_18]          # 004b08d5
    lea ecx, [edx + ecx + field_43]              # 004b08d8
    movsx esi, word ptr [ebp - local_4]          # 004b08dc
    imul esi, esi, 0x2c                          # 004b08e0
    mov edx, dword ptr [ebp - local_c]           # 004b08e3
    movsx edi, word ptr [edx + field_1a8]        # 004b08e6
    mov eax, dword ptr [ebp - local_18]          # 004b08ed
    mov eax, dword ptr [eax + field_152d]        # 004b08f0
    cdq                                          # 004b08f6
    idiv edi                                     # 004b08f7
    mov ecx, dword ptr [ecx + esi + field_10]    # 004b08f9
    {load} sub ecx, eax                          # 004b08fd
    movsx edx, word ptr [ebp - local_4]          # 004b08ff
    imul edx, edx, 0x2c                          # 004b0903
    movsx eax, word ptr [ebp - local_8]          # 004b0906
    imul eax, eax, 0x1e4                         # 004b090a
    mov esi, dword ptr [ebp - local_18]          # 004b0910
    lea eax, [esi + eax + field_43]              # 004b0913
    mov dword ptr [eax + edx + field_10], ecx    # 004b0917
    mov ecx, dword ptr [ebp - local_18]          # 004b091b
    mov dx, word ptr [ecx + field_1533]          # 004b091e
    add dx, 0x1                                  # 004b0925
    mov eax, dword ptr [ebp - local_18]          # 004b0929
    mov word ptr [eax + field_1533], dx          # 004b092c
    mov ecx, dword ptr [ebp - local_18]          # 004b0933
    movsx edx, word ptr [ecx + field_1533]       # 004b0936
    mov eax, dword ptr [ebp - local_c]           # 004b093d
    movsx ecx, word ptr [eax + field_1a8]        # 004b0940
    {load} cmp edx, ecx                          # 004b0947
    jne.d8 L_004b0970                            # 004b0949
    # block 0x004b094b: entered by fall-through of jne at 0x004b0949, 9 instruction(s), falls into the block at 0x004b0970
    mov dword ptr [ebp - local_10], 0x1          # 004b094b
    mov dx, word ptr [ebp - local_8]             # 004b0952
    sub dx, 0x1                                  # 004b0956
    mov word ptr [ebp - local_8], dx             # 004b095a
    mov eax, dword ptr [ebp - local_18]          # 004b095e
    mov cx, word ptr [eax + field_3f]            # 004b0961
    sub cx, 0x1                                  # 004b0965
    mov edx, dword ptr [ebp - local_18]          # 004b0969
    mov word ptr [edx + field_3f], cx            # 004b096c
L_004b0970:
    # block 0x004b0970: entered by jne at 0x004b0949, 1 instruction(s), ends with forward jump to 0x004b0b64
    jmp.d32 L_004b0b64                           # 004b0970
L_004b0975:
    # block 0x004b0975: entered by switch case, 53 instruction(s), ends with jne to 0x004b0a6a (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b0975
    imul eax, eax, 0x1e4                         # 004b0979
    mov ecx, dword ptr [ebp - local_18]          # 004b097f
    lea ecx, [ecx + eax + field_43]              # 004b0982
    movsx esi, word ptr [ebp - local_4]          # 004b0986
    imul esi, esi, 0x2c                          # 004b098a
    mov edx, dword ptr [ebp - local_c]           # 004b098d
    movsx edi, word ptr [edx + field_1a8]        # 004b0990
    mov eax, dword ptr [ebp - local_18]          # 004b0997
    mov eax, dword ptr [eax + field_152d]        # 004b099a
    cdq                                          # 004b09a0
    idiv edi                                     # 004b09a1
    mov ecx, dword ptr [ecx + esi + field_8]     # 004b09a3
    {load} add ecx, eax                          # 004b09a7
    movsx edx, word ptr [ebp - local_4]          # 004b09a9
    imul edx, edx, 0x2c                          # 004b09ad
    movsx eax, word ptr [ebp - local_8]          # 004b09b0
    imul eax, eax, 0x1e4                         # 004b09b4
    mov esi, dword ptr [ebp - local_18]          # 004b09ba
    lea eax, [esi + eax + field_43]              # 004b09bd
    mov dword ptr [eax + edx + field_8], ecx     # 004b09c1
    movsx ecx, word ptr [ebp - local_8]          # 004b09c5
    imul ecx, ecx, 0x1e4                         # 004b09c9
    mov edx, dword ptr [ebp - local_18]          # 004b09cf
    lea ecx, [edx + ecx + field_43]              # 004b09d2
    movsx esi, word ptr [ebp - local_4]          # 004b09d6
    imul esi, esi, 0x2c                          # 004b09da
    mov edx, dword ptr [ebp - local_c]           # 004b09dd
    movsx edi, word ptr [edx + field_1a8]        # 004b09e0
    mov eax, dword ptr [ebp - local_18]          # 004b09e7
    mov eax, dword ptr [eax + field_152d]        # 004b09ea
    cdq                                          # 004b09f0
    idiv edi                                     # 004b09f1
    mov ecx, dword ptr [ecx + esi + field_10]    # 004b09f3
    {load} add ecx, eax                          # 004b09f7
    movsx edx, word ptr [ebp - local_4]          # 004b09f9
    imul edx, edx, 0x2c                          # 004b09fd
    movsx eax, word ptr [ebp - local_8]          # 004b0a00
    imul eax, eax, 0x1e4                         # 004b0a04
    mov esi, dword ptr [ebp - local_18]          # 004b0a0a
    lea eax, [esi + eax + field_43]              # 004b0a0d
    mov dword ptr [eax + edx + field_10], ecx    # 004b0a11
    mov ecx, dword ptr [ebp - local_18]          # 004b0a15
    mov dx, word ptr [ecx + field_1533]          # 004b0a18
    add dx, 0x1                                  # 004b0a1f
    mov eax, dword ptr [ebp - local_18]          # 004b0a23
    mov word ptr [eax + field_1533], dx          # 004b0a26
    mov ecx, dword ptr [ebp - local_18]          # 004b0a2d
    movsx edx, word ptr [ecx + field_1533]       # 004b0a30
    mov eax, dword ptr [ebp - local_c]           # 004b0a37
    movsx ecx, word ptr [eax + field_1a8]        # 004b0a3a
    {load} cmp edx, ecx                          # 004b0a41
    jne.d8 L_004b0a6a                            # 004b0a43
    # block 0x004b0a45: entered by fall-through of jne at 0x004b0a43, 9 instruction(s), falls into the block at 0x004b0a6a
    mov dword ptr [ebp - local_10], 0x1          # 004b0a45
    mov dx, word ptr [ebp - local_8]             # 004b0a4c
    add dx, 0x1                                  # 004b0a50
    mov word ptr [ebp - local_8], dx             # 004b0a54
    mov eax, dword ptr [ebp - local_18]          # 004b0a58
    mov cx, word ptr [eax + field_3f]            # 004b0a5b
    add cx, 0x1                                  # 004b0a5f
    mov edx, dword ptr [ebp - local_18]          # 004b0a63
    mov word ptr [edx + field_3f], cx            # 004b0a66
L_004b0a6a:
    # block 0x004b0a6a: entered by jne at 0x004b0a43, 1 instruction(s), ends with forward jump to 0x004b0b64
    jmp.d32 L_004b0b64                           # 004b0a6a
L_004b0a6f:
    # block 0x004b0a6f: entered by switch case, 53 instruction(s), ends with jne to 0x004b0b64 (forward)
    movsx eax, word ptr [ebp - local_8]          # 004b0a6f
    imul eax, eax, 0x1e4                         # 004b0a73
    mov ecx, dword ptr [ebp - local_18]          # 004b0a79
    lea ecx, [ecx + eax + field_43]              # 004b0a7c
    movsx esi, word ptr [ebp - local_4]          # 004b0a80
    imul esi, esi, 0x2c                          # 004b0a84
    mov edx, dword ptr [ebp - local_c]           # 004b0a87
    movsx edi, word ptr [edx + field_1a8]        # 004b0a8a
    mov eax, dword ptr [ebp - local_18]          # 004b0a91
    mov eax, dword ptr [eax + field_1529]        # 004b0a94
    cdq                                          # 004b0a9a
    idiv edi                                     # 004b0a9b
    mov ecx, dword ptr [ecx + esi + field_4]     # 004b0a9d
    {load} add ecx, eax                          # 004b0aa1
    movsx edx, word ptr [ebp - local_4]          # 004b0aa3
    imul edx, edx, 0x2c                          # 004b0aa7
    movsx eax, word ptr [ebp - local_8]          # 004b0aaa
    imul eax, eax, 0x1e4                         # 004b0aae
    mov esi, dword ptr [ebp - local_18]          # 004b0ab4
    lea eax, [esi + eax + field_43]              # 004b0ab7
    mov dword ptr [eax + edx + field_4], ecx     # 004b0abb
    movsx ecx, word ptr [ebp - local_8]          # 004b0abf
    imul ecx, ecx, 0x1e4                         # 004b0ac3
    mov edx, dword ptr [ebp - local_18]          # 004b0ac9
    lea ecx, [edx + ecx + field_43]              # 004b0acc
    movsx esi, word ptr [ebp - local_4]          # 004b0ad0
    imul esi, esi, 0x2c                          # 004b0ad4
    mov edx, dword ptr [ebp - local_c]           # 004b0ad7
    movsx edi, word ptr [edx + field_1a8]        # 004b0ada
    mov eax, dword ptr [ebp - local_18]          # 004b0ae1
    mov eax, dword ptr [eax + field_1529]        # 004b0ae4
    cdq                                          # 004b0aea
    idiv edi                                     # 004b0aeb
    mov ecx, dword ptr [ecx + esi + field_c]     # 004b0aed
    {load} add ecx, eax                          # 004b0af1
    movsx edx, word ptr [ebp - local_4]          # 004b0af3
    imul edx, edx, 0x2c                          # 004b0af7
    movsx eax, word ptr [ebp - local_8]          # 004b0afa
    imul eax, eax, 0x1e4                         # 004b0afe
    mov esi, dword ptr [ebp - local_18]          # 004b0b04
    lea eax, [esi + eax + field_43]              # 004b0b07
    mov dword ptr [eax + edx + field_c], ecx     # 004b0b0b
    mov ecx, dword ptr [ebp - local_18]          # 004b0b0f
    mov dx, word ptr [ecx + field_1533]          # 004b0b12
    add dx, 0x1                                  # 004b0b19
    mov eax, dword ptr [ebp - local_18]          # 004b0b1d
    mov word ptr [eax + field_1533], dx          # 004b0b20
    mov ecx, dword ptr [ebp - local_18]          # 004b0b27
    movsx edx, word ptr [ecx + field_1533]       # 004b0b2a
    mov eax, dword ptr [ebp - local_c]           # 004b0b31
    movsx ecx, word ptr [eax + field_1a8]        # 004b0b34
    {load} cmp edx, ecx                          # 004b0b3b
    jne.d8 L_004b0b64                            # 004b0b3d
    # block 0x004b0b3f: entered by fall-through of jne at 0x004b0b3d, 9 instruction(s), falls into the block at 0x004b0b64
    mov dword ptr [ebp - local_10], 0x1          # 004b0b3f
    mov dx, word ptr [ebp - local_4]             # 004b0b46
    add dx, 0x1                                  # 004b0b4a
    mov word ptr [ebp - local_4], dx             # 004b0b4e
    mov eax, dword ptr [ebp - local_18]          # 004b0b52
    mov cx, word ptr [eax + field_41]            # 004b0b55
    add cx, 0x1                                  # 004b0b59
    mov edx, dword ptr [ebp - local_18]          # 004b0b5d
    mov word ptr [edx + field_41], cx            # 004b0b60
L_004b0b64:
    # block 0x004b0b64: entered by ja at 0x004b0771; jmp at 0x004b0876; jmp at 0x004b0970; jmp at 0x004b0a6a; more, 2 instruction(s), ends with je to 0x004b0f56 (forward)
    cmp dword ptr [ebp - local_10], 0x0          # 004b0b64
    je.d32 L_004b0f56                            # 004b0b68
    # block 0x004b0b6e: entered by fall-through of je at 0x004b0b68, 29 instruction(s), calls FUN_004b10e3, ends with ja to 0x004b0f56 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0b6e
    mov word ptr [eax + field_1533], 0x0         # 004b0b71
    movsx ecx, word ptr [ebp - local_8]          # 004b0b7a
    imul ecx, ecx, 0x1e4                         # 004b0b7e
    mov edx, dword ptr [ebp - local_18]          # 004b0b84
    lea eax, [edx + ecx + field_43]              # 004b0b87
    movsx ecx, word ptr [ebp - local_4]          # 004b0b8b
    imul ecx, ecx, 0x2c                          # 004b0b8f
    mov dx, word ptr [ebp - local_14]            # 004b0b92
    mov word ptr [eax + ecx + field_18], dx      # 004b0b96
    mov ax, word ptr [ebp - local_4]             # 004b0b9b
    push eax                                     # 004b0b9f
    mov cx, word ptr [ebp - local_8]             # 004b0ba0
    push ecx                                     # 004b0ba4
    mov ecx, dword ptr [ebp - local_18]          # 004b0ba5
    call FUN_004b10e3                            # 004b0ba8
    movsx edx, word ptr [ebp - local_8]          # 004b0bad
    imul edx, edx, 0x1e4                         # 004b0bb1
    mov eax, dword ptr [ebp - local_18]          # 004b0bb7
    lea ecx, [eax + edx + field_43]              # 004b0bba
    movsx edx, word ptr [ebp - local_4]          # 004b0bbe
    imul edx, edx, 0x2c                          # 004b0bc2
    movsx eax, word ptr [ecx + edx + field_18]   # 004b0bc5
    mov dword ptr [ebp - local_24], eax          # 004b0bca
    mov ecx, dword ptr [ebp - local_24]          # 004b0bcd
    sub ecx, 0x1                                 # 004b0bd0
    mov dword ptr [ebp - local_24], ecx          # 004b0bd3
    cmp dword ptr [ebp - local_24], 0x5          # 004b0bd6
    ja.d32 L_004b0f56                            # 004b0bda
    # block 0x004b0be0: entered by fall-through of ja at 0x004b0bda, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4b0f87]
    mov edx, dword ptr [ebp - local_24]          # 004b0be0
    jmp dword ptr [4*edx + SWTAB_004b0f87_VA]    # 004b0be3
L_004b0bea:
    # block 0x004b0bea: entered by switch case, 4 instruction(s), ends with jne to 0x004b0c24 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0bea
    movsx ecx, word ptr [eax + field_1531]       # 004b0bed
    cmp ecx, 0x2797                              # 004b0bf4
    jne.d8 L_004b0c24                            # 004b0bfa
    # block 0x004b0bfc: entered by fall-through of jne at 0x004b0bfa, 12 instruction(s), ends with forward jump to 0x004b0c5c
    mov ecx, 0xb                                 # 004b0bfc
    {load} xor eax, eax                          # 004b0c01
    movsx edx, word ptr [ebp - local_8]          # 004b0c03
    imul edx, edx, 0x1e4                         # 004b0c07
    mov esi, dword ptr [ebp - local_18]          # 004b0c0d
    lea edi, [esi + edx + field_43]              # 004b0c10
    movsx edx, word ptr [ebp - local_4]          # 004b0c14
    sub edx, 0x1                                 # 004b0c18
    imul edx, edx, 0x2c                          # 004b0c1b
    {load} add edi, edx                          # 004b0c1e
    rep stosd dword ptr es:[edi], eax            # 004b0c20
    jmp.d8 L_004b0c5c                            # 004b0c22
L_004b0c24:
    # block 0x004b0c24: entered by jne at 0x004b0bfa, 4 instruction(s), ends with jne to 0x004b0c5c (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0c24
    movsx ecx, word ptr [eax + field_1531]       # 004b0c27
    cmp ecx, 0x2794                              # 004b0c2e
    jne.d8 L_004b0c5c                            # 004b0c34
    # block 0x004b0c36: entered by fall-through of jne at 0x004b0c34, 11 instruction(s), falls into the block at 0x004b0c5c
    mov ecx, 0xb                                 # 004b0c36
    {load} xor eax, eax                          # 004b0c3b
    movsx edx, word ptr [ebp - local_8]          # 004b0c3d
    imul edx, edx, 0x1e4                         # 004b0c41
    mov esi, dword ptr [ebp - local_18]          # 004b0c47
    lea edi, [esi + edx + field_43]              # 004b0c4a
    movsx edx, word ptr [ebp - local_4]          # 004b0c4e
    add edx, 0x2                                 # 004b0c52
    imul edx, edx, 0x2c                          # 004b0c55
    {load} add edi, edx                          # 004b0c58
    rep stosd dword ptr es:[edi], eax            # 004b0c5a
L_004b0c5c:
    # block 0x004b0c5c: entered by jmp at 0x004b0c22; jne at 0x004b0c34, 1 instruction(s), ends with forward jump to 0x004b0f56
    jmp.d32 L_004b0f56                           # 004b0c5c
L_004b0c61:
    # block 0x004b0c61: entered by switch case, 4 instruction(s), ends with jne to 0x004b0c9b (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0c61
    movsx ecx, word ptr [eax + field_1531]       # 004b0c64
    cmp ecx, 0x2797                              # 004b0c6b
    jne.d8 L_004b0c9b                            # 004b0c71
    # block 0x004b0c73: entered by fall-through of jne at 0x004b0c71, 12 instruction(s), ends with forward jump to 0x004b0cd3
    mov ecx, 0xb                                 # 004b0c73
    {load} xor eax, eax                          # 004b0c78
    movsx edx, word ptr [ebp - local_8]          # 004b0c7a
    imul edx, edx, 0x1e4                         # 004b0c7e
    mov esi, dword ptr [ebp - local_18]          # 004b0c84
    lea edi, [esi + edx + field_43]              # 004b0c87
    movsx edx, word ptr [ebp - local_4]          # 004b0c8b
    sub edx, 0x1                                 # 004b0c8f
    imul edx, edx, 0x2c                          # 004b0c92
    {load} add edi, edx                          # 004b0c95
    rep stosd dword ptr es:[edi], eax            # 004b0c97
    jmp.d8 L_004b0cd3                            # 004b0c99
L_004b0c9b:
    # block 0x004b0c9b: entered by jne at 0x004b0c71, 4 instruction(s), ends with jne to 0x004b0cd3 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0c9b
    movsx ecx, word ptr [eax + field_1531]       # 004b0c9e
    cmp ecx, 0x2794                              # 004b0ca5
    jne.d8 L_004b0cd3                            # 004b0cab
    # block 0x004b0cad: entered by fall-through of jne at 0x004b0cab, 11 instruction(s), falls into the block at 0x004b0cd3
    mov ecx, 0xb                                 # 004b0cad
    {load} xor eax, eax                          # 004b0cb2
    movsx edx, word ptr [ebp - local_8]          # 004b0cb4
    imul edx, edx, 0x1e4                         # 004b0cb8
    mov esi, dword ptr [ebp - local_18]          # 004b0cbe
    lea edi, [esi + edx + field_43]              # 004b0cc1
    movsx edx, word ptr [ebp - local_4]          # 004b0cc5
    add edx, 0x3                                 # 004b0cc9
    imul edx, edx, 0x2c                          # 004b0ccc
    {load} add edi, edx                          # 004b0ccf
    rep stosd dword ptr es:[edi], eax            # 004b0cd1
L_004b0cd3:
    # block 0x004b0cd3: entered by jmp at 0x004b0c99; jne at 0x004b0cab, 1 instruction(s), ends with forward jump to 0x004b0f56
    jmp.d32 L_004b0f56                           # 004b0cd3
L_004b0cd8:
    # block 0x004b0cd8: entered by switch case, 4 instruction(s), ends with jne to 0x004b0d12 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0cd8
    movsx ecx, word ptr [eax + field_1531]       # 004b0cdb
    cmp ecx, 0x2796                              # 004b0ce2
    jne.d8 L_004b0d12                            # 004b0ce8
    # block 0x004b0cea: entered by fall-through of jne at 0x004b0ce8, 12 instruction(s), ends with forward jump to 0x004b0d4a
    mov ecx, 0xb                                 # 004b0cea
    {load} xor eax, eax                          # 004b0cef
    movsx edx, word ptr [ebp - local_8]          # 004b0cf1
    sub edx, 0x1                                 # 004b0cf5
    imul edx, edx, 0x1e4                         # 004b0cf8
    mov esi, dword ptr [ebp - local_18]          # 004b0cfe
    lea edi, [esi + edx + field_43]              # 004b0d01
    movsx edx, word ptr [ebp - local_4]          # 004b0d05
    imul edx, edx, 0x2c                          # 004b0d09
    {load} add edi, edx                          # 004b0d0c
    rep stosd dword ptr es:[edi], eax            # 004b0d0e
    jmp.d8 L_004b0d4a                            # 004b0d10
L_004b0d12:
    # block 0x004b0d12: entered by jne at 0x004b0ce8, 4 instruction(s), ends with jne to 0x004b0d4a (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0d12
    movsx ecx, word ptr [eax + field_1531]       # 004b0d15
    cmp ecx, 0x2795                              # 004b0d1c
    jne.d8 L_004b0d4a                            # 004b0d22
    # block 0x004b0d24: entered by fall-through of jne at 0x004b0d22, 11 instruction(s), falls into the block at 0x004b0d4a
    mov ecx, 0xb                                 # 004b0d24
    {load} xor eax, eax                          # 004b0d29
    movsx edx, word ptr [ebp - local_8]          # 004b0d2b
    add edx, 0x2                                 # 004b0d2f
    imul edx, edx, 0x1e4                         # 004b0d32
    mov esi, dword ptr [ebp - local_18]          # 004b0d38
    lea edi, [esi + edx + field_43]              # 004b0d3b
    movsx edx, word ptr [ebp - local_4]          # 004b0d3f
    imul edx, edx, 0x2c                          # 004b0d43
    {load} add edi, edx                          # 004b0d46
    rep stosd dword ptr es:[edi], eax            # 004b0d48
L_004b0d4a:
    # block 0x004b0d4a: entered by jmp at 0x004b0d10; jne at 0x004b0d22, 1 instruction(s), ends with forward jump to 0x004b0f56
    jmp.d32 L_004b0f56                           # 004b0d4a
L_004b0d4f:
    # block 0x004b0d4f: entered by switch case, 4 instruction(s), ends with jne to 0x004b0d89 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0d4f
    movsx ecx, word ptr [eax + field_1531]       # 004b0d52
    cmp ecx, 0x2796                              # 004b0d59
    jne.d8 L_004b0d89                            # 004b0d5f
    # block 0x004b0d61: entered by fall-through of jne at 0x004b0d5f, 12 instruction(s), ends with forward jump to 0x004b0dc1
    mov ecx, 0xb                                 # 004b0d61
    {load} xor eax, eax                          # 004b0d66
    movsx edx, word ptr [ebp - local_8]          # 004b0d68
    sub edx, 0x1                                 # 004b0d6c
    imul edx, edx, 0x1e4                         # 004b0d6f
    mov esi, dword ptr [ebp - local_18]          # 004b0d75
    lea edi, [esi + edx + field_43]              # 004b0d78
    movsx edx, word ptr [ebp - local_4]          # 004b0d7c
    imul edx, edx, 0x2c                          # 004b0d80
    {load} add edi, edx                          # 004b0d83
    rep stosd dword ptr es:[edi], eax            # 004b0d85
    jmp.d8 L_004b0dc1                            # 004b0d87
L_004b0d89:
    # block 0x004b0d89: entered by jne at 0x004b0d5f, 4 instruction(s), ends with jne to 0x004b0dc1 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0d89
    movsx ecx, word ptr [eax + field_1531]       # 004b0d8c
    cmp ecx, 0x2795                              # 004b0d93
    jne.d8 L_004b0dc1                            # 004b0d99
    # block 0x004b0d9b: entered by fall-through of jne at 0x004b0d99, 11 instruction(s), falls into the block at 0x004b0dc1
    mov ecx, 0xb                                 # 004b0d9b
    {load} xor eax, eax                          # 004b0da0
    movsx edx, word ptr [ebp - local_8]          # 004b0da2
    add edx, 0x3                                 # 004b0da6
    imul edx, edx, 0x1e4                         # 004b0da9
    mov esi, dword ptr [ebp - local_18]          # 004b0daf
    lea edi, [esi + edx + field_43]              # 004b0db2
    movsx edx, word ptr [ebp - local_4]          # 004b0db6
    imul edx, edx, 0x2c                          # 004b0dba
    {load} add edi, edx                          # 004b0dbd
    rep stosd dword ptr es:[edi], eax            # 004b0dbf
L_004b0dc1:
    # block 0x004b0dc1: entered by jmp at 0x004b0d87; jne at 0x004b0d99, 1 instruction(s), ends with forward jump to 0x004b0f56
    jmp.d32 L_004b0f56                           # 004b0dc1
L_004b0dc6:
    # block 0x004b0dc6: entered by switch case, 4 instruction(s), ends with jne to 0x004b0e2c (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0dc6
    movsx ecx, word ptr [eax + field_1531]       # 004b0dc9
    cmp ecx, 0x2797                              # 004b0dd0
    jne.d8 L_004b0e2c                            # 004b0dd6
    # block 0x004b0dd8: entered by fall-through of jne at 0x004b0dd6, 24 instruction(s), ends with forward jump to 0x004b0f56
    mov ecx, 0xb                                 # 004b0dd8
    {load} xor eax, eax                          # 004b0ddd
    movsx edx, word ptr [ebp - local_8]          # 004b0ddf
    imul edx, edx, 0x1e4                         # 004b0de3
    mov esi, dword ptr [ebp - local_18]          # 004b0de9
    lea edi, [esi + edx + field_43]              # 004b0dec
    movsx edx, word ptr [ebp - local_4]          # 004b0df0
    sub edx, 0x1                                 # 004b0df4
    imul edx, edx, 0x2c                          # 004b0df7
    {load} add edi, edx                          # 004b0dfa
    rep stosd dword ptr es:[edi], eax            # 004b0dfc
    mov ecx, 0xb                                 # 004b0dfe
    {load} xor eax, eax                          # 004b0e03
    movsx edx, word ptr [ebp - local_8]          # 004b0e05
    add edx, 0x1                                 # 004b0e09
    imul edx, edx, 0x1e4                         # 004b0e0c
    mov esi, dword ptr [ebp - local_18]          # 004b0e12
    lea edi, [esi + edx + field_43]              # 004b0e15
    movsx edx, word ptr [ebp - local_4]          # 004b0e19
    sub edx, 0x1                                 # 004b0e1d
    imul edx, edx, 0x2c                          # 004b0e20
    {load} add edi, edx                          # 004b0e23
    rep stosd dword ptr es:[edi], eax            # 004b0e25
    jmp.d32 L_004b0f56                           # 004b0e27
L_004b0e2c:
    # block 0x004b0e2c: entered by jne at 0x004b0dd6, 4 instruction(s), ends with jne to 0x004b0e92 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0e2c
    movsx ecx, word ptr [eax + field_1531]       # 004b0e2f
    cmp ecx, 0x2794                              # 004b0e36
    jne.d8 L_004b0e92                            # 004b0e3c
    # block 0x004b0e3e: entered by fall-through of jne at 0x004b0e3c, 24 instruction(s), ends with forward jump to 0x004b0f56
    mov ecx, 0xb                                 # 004b0e3e
    {load} xor eax, eax                          # 004b0e43
    movsx edx, word ptr [ebp - local_8]          # 004b0e45
    imul edx, edx, 0x1e4                         # 004b0e49
    mov esi, dword ptr [ebp - local_18]          # 004b0e4f
    lea edi, [esi + edx + field_43]              # 004b0e52
    movsx edx, word ptr [ebp - local_4]          # 004b0e56
    add edx, 0x2                                 # 004b0e5a
    imul edx, edx, 0x2c                          # 004b0e5d
    {load} add edi, edx                          # 004b0e60
    rep stosd dword ptr es:[edi], eax            # 004b0e62
    mov ecx, 0xb                                 # 004b0e64
    {load} xor eax, eax                          # 004b0e69
    movsx edx, word ptr [ebp - local_8]          # 004b0e6b
    add edx, 0x1                                 # 004b0e6f
    imul edx, edx, 0x1e4                         # 004b0e72
    mov esi, dword ptr [ebp - local_18]          # 004b0e78
    lea edi, [esi + edx + field_43]              # 004b0e7b
    movsx edx, word ptr [ebp - local_4]          # 004b0e7f
    add edx, 0x2                                 # 004b0e83
    imul edx, edx, 0x2c                          # 004b0e86
    {load} add edi, edx                          # 004b0e89
    rep stosd dword ptr es:[edi], eax            # 004b0e8b
    jmp.d32 L_004b0f56                           # 004b0e8d
L_004b0e92:
    # block 0x004b0e92: entered by jne at 0x004b0e3c, 4 instruction(s), ends with jne to 0x004b0ef5 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0e92
    movsx ecx, word ptr [eax + field_1531]       # 004b0e95
    cmp ecx, 0x2796                              # 004b0e9c
    jne.d8 L_004b0ef5                            # 004b0ea2
    # block 0x004b0ea4: entered by fall-through of jne at 0x004b0ea2, 24 instruction(s), ends with forward jump to 0x004b0f56
    mov ecx, 0xb                                 # 004b0ea4
    {load} xor eax, eax                          # 004b0ea9
    movsx edx, word ptr [ebp - local_8]          # 004b0eab
    sub edx, 0x1                                 # 004b0eaf
    imul edx, edx, 0x1e4                         # 004b0eb2
    mov esi, dword ptr [ebp - local_18]          # 004b0eb8
    lea edi, [esi + edx + field_43]              # 004b0ebb
    movsx edx, word ptr [ebp - local_4]          # 004b0ebf
    imul edx, edx, 0x2c                          # 004b0ec3
    {load} add edi, edx                          # 004b0ec6
    rep stosd dword ptr es:[edi], eax            # 004b0ec8
    mov ecx, 0xb                                 # 004b0eca
    {load} xor eax, eax                          # 004b0ecf
    movsx edx, word ptr [ebp - local_8]          # 004b0ed1
    sub edx, 0x1                                 # 004b0ed5
    imul edx, edx, 0x1e4                         # 004b0ed8
    mov esi, dword ptr [ebp - local_18]          # 004b0ede
    lea edi, [esi + edx + field_43]              # 004b0ee1
    movsx edx, word ptr [ebp - local_4]          # 004b0ee5
    add edx, 0x1                                 # 004b0ee9
    imul edx, edx, 0x2c                          # 004b0eec
    {load} add edi, edx                          # 004b0eef
    rep stosd dword ptr es:[edi], eax            # 004b0ef1
    jmp.d8 L_004b0f56                            # 004b0ef3
L_004b0ef5:
    # block 0x004b0ef5: entered by jne at 0x004b0ea2, 4 instruction(s), ends with jne to 0x004b0f56 (forward)
    mov eax, dword ptr [ebp - local_18]          # 004b0ef5
    movsx ecx, word ptr [eax + field_1531]       # 004b0ef8
    cmp ecx, 0x2795                              # 004b0eff
    jne.d8 L_004b0f56                            # 004b0f05
    # block 0x004b0f07: entered by fall-through of jne at 0x004b0f05, 23 instruction(s), falls into the block at 0x004b0f56
    mov ecx, 0xb                                 # 004b0f07
    {load} xor eax, eax                          # 004b0f0c
    movsx edx, word ptr [ebp - local_8]          # 004b0f0e
    add edx, 0x2                                 # 004b0f12
    imul edx, edx, 0x1e4                         # 004b0f15
    mov esi, dword ptr [ebp - local_18]          # 004b0f1b
    lea edi, [esi + edx + field_43]              # 004b0f1e
    movsx edx, word ptr [ebp - local_4]          # 004b0f22
    imul edx, edx, 0x2c                          # 004b0f26
    {load} add edi, edx                          # 004b0f29
    rep stosd dword ptr es:[edi], eax            # 004b0f2b
    mov ecx, 0xb                                 # 004b0f2d
    {load} xor eax, eax                          # 004b0f32
    movsx edx, word ptr [ebp - local_8]          # 004b0f34
    add edx, 0x2                                 # 004b0f38
    imul edx, edx, 0x1e4                         # 004b0f3b
    mov esi, dword ptr [ebp - local_18]          # 004b0f41
    lea edi, [esi + edx + field_43]              # 004b0f44
    movsx edx, word ptr [ebp - local_4]          # 004b0f48
    add edx, 0x1                                 # 004b0f4c
    imul edx, edx, 0x2c                          # 004b0f4f
    {load} add edi, edx                          # 004b0f52
    rep stosd dword ptr es:[edi], eax            # 004b0f54
L_004b0f56:
    # block 0x004b0f56: entered by je at 0x004b0b68; ja at 0x004b0bda; jmp at 0x004b0c5c; jmp at 0x004b0cd3; more, 6 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_10]          # 004b0f56
    pop edi                                      # 004b0f59
    pop esi                                      # 004b0f5a
    {load} mov esp, ebp                          # 004b0f5b
    pop ebp                                      # 004b0f5d
    ret                                          # 004b0f5e

# --- data items (not part of the function) -------------------------
.org 0x004b0f5f - 0x401000
SWTAB_004b0f5f:  # 6 case address(es)
    .long L_004b0637 - .text + 0x401000
    .long L_004b0679 - .text + 0x401000
    .long L_004b0658 - .text + 0x401000
    .long L_004b0697 - .text + 0x401000
    .long L_004b06b5 - .text + 0x401000
    .long L_004b0637 - .text + 0x401000
.org 0x004b0f77 - 0x401000
SWTAB_004b0f77:  # 4 case address(es)
    .long L_004b0781 - .text + 0x401000
    .long L_004b087b - .text + 0x401000
    .long L_004b0975 - .text + 0x401000
    .long L_004b0a6f - .text + 0x401000
.org 0x004b0f87 - 0x401000
SWTAB_004b0f87:  # 6 case address(es)
    .long L_004b0bea - .text + 0x401000
    .long L_004b0cd8 - .text + 0x401000
    .long L_004b0c61 - .text + 0x401000
    .long L_004b0d4f - .text + 0x401000
    .long L_004b0dc6 - .text + 0x401000
    .long L_004b0bea - .text + 0x401000
.set SWTAB_004b0f5f_VA, SWTAB_004b0f5f - .text + 0x401000
.set SWTAB_004b0f77_VA, SWTAB_004b0f77 - .text + 0x401000
.set SWTAB_004b0f87_VA, SWTAB_004b0f87 - .text + 0x401000

