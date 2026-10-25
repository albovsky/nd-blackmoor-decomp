# FUN_004b777d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b777d
# extent:       0x004b777d-0x004b7ddd (1632 code bytes)
# span:         0x004b777d-0x004b7ddd (code 1632, tables 0, padding 0)
# sha256:       ad45298ad08e1e39eb81d78efc2ff50d93619b5b670088896b541dccc02947dc
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b777d
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       7 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c
# fields:       [eax + n] field_1c, field_21, field_25, field_2f, field_31, field_33, field_310, field_341, field_351, field_355, field_35d, field_367 and 4 more; [ecx + n] field_1d, field_21, field_25, field_27, field_29, field_2f, field_35, field_36, field_2eb, field_353, field_359, field_365 and 6 more; [edx + n] field_1d, field_21, field_2f, field_31, field_36, field_3b, field_2ed, field_351, field_357, field_361, field_369, field_38d and 4 more
# callees:      calls FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004fb2e3, FUN_004f6334, FUN_004fba69, FUN_0042ba3a, FUN_004b7229
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 394 instruction(s), 28 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
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
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_2f, 0x2f  # offset +0x2f
.equ field_31, 0x31  # offset +0x31
.equ field_33, 0x33  # offset +0x33
.equ field_35, 0x35  # offset +0x35
.equ field_36, 0x36  # offset +0x36
.equ field_3b, 0x3b  # offset +0x3b
.equ field_2eb, 0x2eb  # offset +0x2eb
.equ field_2ed, 0x2ed  # offset +0x2ed
.equ field_310, 0x310  # offset +0x310
.equ field_341, 0x341  # offset +0x341
.equ field_351, 0x351  # offset +0x351
.equ field_353, 0x353  # offset +0x353
.equ field_355, 0x355  # offset +0x355
.equ field_357, 0x357  # offset +0x357
.equ field_359, 0x359  # offset +0x359
.equ field_35d, 0x35d  # offset +0x35d
.equ field_361, 0x361  # offset +0x361
.equ field_365, 0x365  # offset +0x365
.equ field_367, 0x367  # offset +0x367
.equ field_369, 0x369  # offset +0x369
.equ field_38d, 0x38d  # offset +0x38d
.equ field_39d, 0x39d  # offset +0x39d
.equ field_39f, 0x39f  # offset +0x39f
.equ field_3a1, 0x3a1  # offset +0x3a1
.equ field_3a3, 0x3a3  # offset +0x3a3
.equ field_3a5, 0x3a5  # offset +0x3a5
.equ field_3a9, 0x3a9  # offset +0x3a9
.equ field_3ad, 0x3ad  # offset +0x3ad
.equ field_3b1, 0x3b1  # offset +0x3b1
.equ field_3b3, 0x3b3  # offset +0x3b3
.equ field_3b5, 0x3b5  # offset +0x3b5

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_004b7229, .text + (0x004b7229 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004b777d - 0x401000
.globl FUN_004b777d
FUN_004b777d:
    # block 0x004b777d: entry, 16 instruction(s), ends with je to 0x004b77cd (forward)
    push ebp                                     # 004b777d
    {load} mov ebp, esp                          # 004b777e
    sub esp, 0x1c                                # 004b7780
    push esi                                     # 004b7783
    push edi                                     # 004b7784
    mov dword ptr [ebp - local_14], ecx          # 004b7785
    movsx eax, word ptr [ebp + arg_8]            # 004b7788
    imul eax, eax, 0x8d                          # 004b778c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004b7792
    mov dword ptr [ebp - local_4], ecx           # 004b7798
    movsx edx, word ptr [ebp + arg_8]            # 004b779b
    imul edx, edx, 0x8d                          # 004b779f
    mov eax, dword ptr [edx + 0x5bb632]          # 004b77a5
    mov dword ptr [ebp - local_18], eax          # 004b77ab
    cmp dword ptr [ebp - local_18], 0x0          # 004b77ae
    je.d8 L_004b77cd                             # 004b77b2
    # block 0x004b77b4: entered by fall-through of je at 0x004b77b2, 2 instruction(s), ends with je to 0x004b79b8 (forward)
    cmp dword ptr [ebp - local_18], 0x1          # 004b77b4
    je.d32 L_004b79b8                            # 004b77b8
    # block 0x004b77be: entered by fall-through of je at 0x004b77b8, 2 instruction(s), ends with je to 0x004b7b7b (forward)
    cmp dword ptr [ebp - local_18], 0x2          # 004b77be
    je.d32 L_004b7b7b                            # 004b77c2
    # block 0x004b77c8: entered by fall-through of je at 0x004b77c2, 1 instruction(s), ends with forward jump to 0x004b7dd5
    jmp.d32 L_004b7dd5                           # 004b77c8
L_004b77cd:
    # block 0x004b77cd: entered by je at 0x004b77b2, 79 instruction(s), calls FUN_004d39f9, ends with jne to 0x004b7923 (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004b77cd
    mov byte ptr [ecx + field_35], 0x1           # 004b77d0
    mov edx, dword ptr [ebp - local_14]          # 004b77d4
    mov byte ptr [edx + field_3b], 0x0           # 004b77d7
    mov dword ptr [0x5bb1ca], 0x1                # 004b77db
    mov eax, dword ptr [ebp - local_14]          # 004b77e5
    mov cx, word ptr [ebp + arg_8]               # 004b77e8
    mov word ptr [eax + field_21], cx            # 004b77ec
    mov edx, dword ptr [ebp - local_14]          # 004b77f0
    mov byte ptr [edx + field_36], 0x0           # 004b77f3
    mov eax, dword ptr [ebp - local_14]          # 004b77f7
    mov ecx, dword ptr [ebp - local_4]           # 004b77fa
    mov dx, word ptr [ecx + field_27]            # 004b77fd
    mov word ptr [eax + field_31], dx            # 004b7801
    mov eax, dword ptr [ebp - local_14]          # 004b7805
    mov ecx, dword ptr [ebp - local_4]           # 004b7808
    mov dx, word ptr [ecx + field_29]            # 004b780b
    mov word ptr [eax + field_33], dx            # 004b780f
    mov eax, dword ptr [ebp - local_14]          # 004b7813
    mov byte ptr [eax + field_1c], 0x1           # 004b7816
    call FUN_004d39f9                            # 004b781a
    mov ecx, dword ptr [ebp - local_14]          # 004b781f
    mov word ptr [ecx + field_2f], ax            # 004b7822
    mov edx, dword ptr [ebp - local_14]          # 004b7826
    movsx eax, word ptr [edx + field_2f]         # 004b7829
    imul eax, eax, 0x4a                          # 004b782d
    mov dword ptr [eax + 0x5d1591], 0xa          # 004b7830
    mov ecx, dword ptr [ebp - local_14]          # 004b783a
    movsx edx, word ptr [ecx + field_2f]         # 004b783d
    imul edx, edx, 0x4a                          # 004b7841
    mov dword ptr [edx + 0x5d1595], 0x4b7ded     # 004b7844
    mov eax, dword ptr [ebp - local_14]          # 004b784e
    movsx ecx, word ptr [eax + field_2f]         # 004b7851
    imul ecx, ecx, 0x4a                          # 004b7855
    mov edx, dword ptr [ebp - local_14]          # 004b7858
    mov eax, dword ptr [edx + field_1d]          # 004b785b
    mov dword ptr [ecx + 0x5d1599], eax          # 004b785e
    mov ecx, dword ptr [ebp - local_14]          # 004b7864
    movsx edx, word ptr [ecx + field_2f]         # 004b7867
    imul edx, edx, 0x4a                          # 004b786b
    mov dword ptr [edx + 0x5d159d], 0x0          # 004b786e
    mov eax, dword ptr [ebp - local_14]          # 004b7878
    movsx ecx, word ptr [eax + field_2f]         # 004b787b
    imul ecx, ecx, 0x4a                          # 004b787f
    mov dword ptr [ecx + 0x5d15a1], 0x0          # 004b7882
    mov edx, dword ptr [ebp - local_14]          # 004b788c
    movsx eax, word ptr [edx + field_2f]         # 004b788f
    imul eax, eax, 0x4a                          # 004b7893
    mov dword ptr [eax + 0x5d15a5], 0x1          # 004b7896
    mov ecx, dword ptr [ebp - local_14]          # 004b78a0
    movsx edx, word ptr [ecx + field_2f]         # 004b78a3
    imul edx, edx, 0x4a                          # 004b78a7
    mov dword ptr [edx + 0x5d15a9], 0x1          # 004b78aa
    mov eax, dword ptr [ebp - local_14]          # 004b78b4
    movsx ecx, word ptr [eax + field_2f]         # 004b78b7
    imul ecx, ecx, 0x4a                          # 004b78bb
    mov word ptr [ecx + 0x5d15ad], 0x0           # 004b78be
    mov edi, 0x551c6c                            # 004b78c7
    mov edx, dword ptr [ebp - local_14]          # 004b78cc
    movsx eax, word ptr [edx + field_2f]         # 004b78cf
    imul eax, eax, 0x4a                          # 004b78d3
    add eax, 0x5d15b3                            # 004b78d6
    {load} mov edx, eax                          # 004b78db
    or ecx, -0x1                                 # 004b78dd
    {load} xor eax, eax                          # 004b78e0
    repne scasb al, byte ptr es:[edi]            # 004b78e2
    not ecx                                      # 004b78e4
    {load} sub edi, ecx                          # 004b78e6
    {load} mov esi, edi                          # 004b78e8
    {load} mov eax, ecx                          # 004b78ea
    {load} mov edi, edx                          # 004b78ec
    shr ecx, 0x2                                 # 004b78ee
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b78f1
    {load} mov ecx, eax                          # 004b78f3
    and ecx, 0x3                                 # 004b78f5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004b78f8
    mov ecx, dword ptr [ebp - local_14]          # 004b78fa
    cmp dword ptr [ecx + field_1d], 0x0          # 004b78fd
    jne.d8 L_004b7923                            # 004b7901
    # block 0x004b7903: entered by fall-through of jne at 0x004b7901, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004b7923
    push 0x551c84                                # 004b7903
    push 0x6                                     # 004b7908
    mov edx, dword ptr [ebp - local_4]           # 004b790a
    push edx                                     # 004b790d
    push 0x551ca0                                # 004b790e
    mov ecx, 0x5cf659                            # 004b7913
    call FUN_004c2790                            # 004b7918
    mov ecx, dword ptr [ebp - local_14]          # 004b791d
    mov dword ptr [ecx + field_1d], eax          # 004b7920
L_004b7923:
    # block 0x004b7923: entered by jne at 0x004b7901, 13 instruction(s), ends with je to 0x004b7966 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004b7923
    movsx eax, word ptr [edx + field_2f]         # 004b7926
    imul eax, eax, 0x4a                          # 004b792a
    mov ecx, dword ptr [ebp - local_14]          # 004b792d
    mov edx, dword ptr [ecx + field_1d]          # 004b7930
    mov dword ptr [eax + 0x5d1599], edx          # 004b7933
    mov edi, 0x551ca8                            # 004b7939
    mov esi, dword ptr [ebp - local_4]           # 004b793e
    add esi, 0x2ef                               # 004b7941
    mov ecx, 0x9                                 # 004b7947
    {load} xor eax, eax                          # 004b794c
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b794e
    je.d8 L_004b7966                             # 004b7950
    # block 0x004b7952: entered by fall-through of je at 0x004b7950, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b7966
    mov ecx, dword ptr [ebp - local_4]           # 004b7952
    add ecx, 0x2ef                               # 004b7955
    push ecx                                     # 004b795b
    mov ecx, 0x5c3a67                            # 004b795c
    call FUN_004fb77a                            # 004b7961
L_004b7966:
    # block 0x004b7966: entered by je at 0x004b7950, 7 instruction(s), ends with je to 0x004b7992 (forward)
    mov edi, 0x551cb4                            # 004b7966
    mov esi, dword ptr [ebp - local_4]           # 004b796b
    add esi, 0x320                               # 004b796e
    mov ecx, 0x9                                 # 004b7974
    {load} xor edx, edx                          # 004b7979
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b797b
    je.d8 L_004b7992                             # 004b797d
    # block 0x004b797f: entered by fall-through of je at 0x004b797d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b7992
    mov eax, dword ptr [ebp - local_4]           # 004b797f
    add eax, 0x320                               # 004b7982
    push eax                                     # 004b7987
    mov ecx, 0x5c3a67                            # 004b7988
    call FUN_004fb77a                            # 004b798d
L_004b7992:
    # block 0x004b7992: entered by je at 0x004b797d, 7 instruction(s), ends with forward jump to 0x004b7dd5
    mov ecx, dword ptr [ebp - local_14]          # 004b7992
    mov dword ptr [ecx + field_25], 0x0          # 004b7995
    mov edx, dword ptr [ebp - local_14]          # 004b799c
    movsx eax, word ptr [edx + field_21]         # 004b799f
    imul eax, eax, 0x8d                          # 004b79a3
    mov dword ptr [eax + 0x5bb632], 0x1          # 004b79a9
    jmp.d32 L_004b7dd5                           # 004b79b3
L_004b79b8:
    # block 0x004b79b8: entered by je at 0x004b77b8, 5 instruction(s), ends with je to 0x004b79dc (forward)
    mov ecx, dword ptr [ebp - local_14]          # 004b79b8
    mov edx, dword ptr [ecx + field_25]          # 004b79bb
    mov dword ptr [ebp - local_1c], edx          # 004b79be
    cmp dword ptr [ebp - local_1c], 0x0          # 004b79c1
    je.d8 L_004b79dc                             # 004b79c5
    # block 0x004b79c7: entered by fall-through of je at 0x004b79c5, 2 instruction(s), ends with je to 0x004b7a37 (forward)
    cmp dword ptr [ebp - local_1c], 0x1          # 004b79c7
    je.d8 L_004b7a37                             # 004b79cb
    # block 0x004b79cd: entered by fall-through of je at 0x004b79cb, 2 instruction(s), ends with je to 0x004b7a88 (forward)
    cmp dword ptr [ebp - local_1c], 0x2          # 004b79cd
    je.d32 L_004b7a88                            # 004b79d1
    # block 0x004b79d7: entered by fall-through of je at 0x004b79d1, 1 instruction(s), ends with forward jump to 0x004b7b76
    jmp.d32 L_004b7b76                           # 004b79d7
L_004b79dc:
    # block 0x004b79dc: entered by je at 0x004b79c5, 4 instruction(s), ends with je to 0x004b7a32 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b79dc
    movsx ecx, word ptr [eax + field_351]        # 004b79df
    cmp ecx, 0x270f                              # 004b79e6
    je.d8 L_004b7a32                             # 004b79ec
    # block 0x004b79ee: entered by fall-through of je at 0x004b79ec, 6 instruction(s), ends with jne to 0x004b7a32 (forward)
    mov edx, dword ptr [ebp - local_14]          # 004b79ee
    movsx eax, word ptr [edx + field_31]         # 004b79f1
    mov ecx, dword ptr [ebp - local_4]           # 004b79f5
    movsx edx, word ptr [ecx + field_2eb]        # 004b79f8
    {load} cmp eax, edx                          # 004b79ff
    jne.d8 L_004b7a32                            # 004b7a01
    # block 0x004b7a03: entered by fall-through of jne at 0x004b7a01, 6 instruction(s), ends with jne to 0x004b7a32 (forward)
    mov eax, dword ptr [ebp - local_14]          # 004b7a03
    movsx ecx, word ptr [eax + field_33]         # 004b7a06
    mov edx, dword ptr [ebp - local_4]           # 004b7a0a
    movsx eax, word ptr [edx + field_2ed]        # 004b7a0d
    {load} cmp ecx, eax                          # 004b7a14
    jne.d8 L_004b7a32                            # 004b7a16
    # block 0x004b7a18: entered by fall-through of jne at 0x004b7a16, 5 instruction(s), falls into the block at 0x004b7a32
    mov ecx, dword ptr [ebp - local_14]          # 004b7a18
    mov dword ptr [ecx + field_25], 0x1          # 004b7a1b
    mov edx, dword ptr [ebp - local_14]          # 004b7a22
    mov byte ptr [edx + field_3b], 0x1           # 004b7a25
    mov word ptr [0x5957c5], 0x1                 # 004b7a29
L_004b7a32:
    # block 0x004b7a32: entered by je at 0x004b79ec; jne at 0x004b7a01; jne at 0x004b7a16, 1 instruction(s), ends with forward jump to 0x004b7b76
    jmp.d32 L_004b7b76                           # 004b7a32
L_004b7a37:
    # block 0x004b7a37: entered by je at 0x004b79cb, 7 instruction(s), ends with je to 0x004b7a79 (forward)
    mov edi, 0x551cc0                            # 004b7a37
    mov esi, dword ptr [ebp - local_4]           # 004b7a3c
    add esi, 0x36c                               # 004b7a3f
    mov ecx, 0x9                                 # 004b7a45
    {load} xor eax, eax                          # 004b7a4a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b7a4c
    je.d8 L_004b7a79                             # 004b7a4e
    # block 0x004b7a50: entered by fall-through of je at 0x004b7a4e, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004b7a79
    mov ecx, dword ptr [ebp - local_4]           # 004b7a50
    add ecx, 0x36c                               # 004b7a53
    push ecx                                     # 004b7a59
    mov ecx, 0x5c3a67                            # 004b7a5a
    call FUN_004fb77a                            # 004b7a5f
    mov edx, dword ptr [ebp - local_4]           # 004b7a64
    mov ax, word ptr [edx + field_38d]           # 004b7a67
    push eax                                     # 004b7a6e
    mov ecx, 0x5c3a67                            # 004b7a6f
    call FUN_004fb2e3                            # 004b7a74
L_004b7a79:
    # block 0x004b7a79: entered by je at 0x004b7a4e, 3 instruction(s), ends with forward jump to 0x004b7b76
    mov ecx, dword ptr [ebp - local_14]          # 004b7a79
    mov dword ptr [ecx + field_25], 0x2          # 004b7a7c
    jmp.d32 L_004b7b76                           # 004b7a83
L_004b7a88:
    # block 0x004b7a88: entered by je at 0x004b79d1, 5 instruction(s), ends with je to 0x004b7b2e (forward)
    mov edx, dword ptr [ebp - local_14]          # 004b7a88
    {load} xor eax, eax                          # 004b7a8b
    mov al, byte ptr [edx + field_3b]            # 004b7a8d
    test eax, eax                                # 004b7a90
    je.d32 L_004b7b2e                            # 004b7a92
    # block 0x004b7a98: entered by fall-through of je at 0x004b7a92, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b7afc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b7a98
    movsx edx, word ptr [ecx + field_38d]        # 004b7a9b
    mov dword ptr [ebp - local_8], edx           # 004b7aa2
    mov eax, dword ptr [ebp - local_8]           # 004b7aa5
    push eax                                     # 004b7aa8
    mov ecx, 0x5cf1eb                            # 004b7aa9
    call FUN_004f6334                            # 004b7aae
    test eax, eax                                # 004b7ab3
    jne.d8 L_004b7afc                            # 004b7ab5
    # block 0x004b7ab7: entered by fall-through of jne at 0x004b7ab5, 7 instruction(s), ends with je to 0x004b7afc (forward)
    mov edi, 0x551ccc                            # 004b7ab7
    mov esi, dword ptr [ebp - local_4]           # 004b7abc
    add esi, 0x36c                               # 004b7abf
    mov ecx, 0x9                                 # 004b7ac5
    {load} xor edx, edx                          # 004b7aca
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b7acc
    je.d8 L_004b7afc                             # 004b7ace
    # block 0x004b7ad0: entered by fall-through of je at 0x004b7ace, 10 instruction(s), calls FUN_004fba69, ends with forward jump to 0x004b7b2c
    mov eax, dword ptr [ebp - local_4]           # 004b7ad0
    add eax, 0x36c                               # 004b7ad3
    push eax                                     # 004b7ad8
    mov ecx, 0x5c3a67                            # 004b7ad9
    call FUN_004fba69                            # 004b7ade
    mov ecx, dword ptr [ebp - local_14]          # 004b7ae3
    movsx edx, word ptr [ecx + field_21]         # 004b7ae6
    imul edx, edx, 0x8d                          # 004b7aea
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b7af0
    jmp.d8 L_004b7b2c                            # 004b7afa
L_004b7afc:
    # block 0x004b7afc: entered by jne at 0x004b7ab5; je at 0x004b7ace, 7 instruction(s), ends with jne to 0x004b7b2c (forward)
    mov edi, 0x551cd8                            # 004b7afc
    mov esi, dword ptr [ebp - local_4]           # 004b7b01
    add esi, 0x36c                               # 004b7b04
    mov ecx, 0x9                                 # 004b7b0a
    {load} xor eax, eax                          # 004b7b0f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b7b11
    jne.d8 L_004b7b2c                            # 004b7b13
    # block 0x004b7b15: entered by fall-through of jne at 0x004b7b13, 4 instruction(s), falls into the block at 0x004b7b2c
    mov ecx, dword ptr [ebp - local_14]          # 004b7b15
    movsx edx, word ptr [ecx + field_21]         # 004b7b18
    imul edx, edx, 0x8d                          # 004b7b1c
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b7b22
L_004b7b2c:
    # block 0x004b7b2c: entered by jmp at 0x004b7afa; jne at 0x004b7b13, 1 instruction(s), ends with forward jump to 0x004b7b76
    jmp.d8 L_004b7b76                            # 004b7b2c
L_004b7b2e:
    # block 0x004b7b2e: entered by je at 0x004b7a92, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b7b76 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b7b2e
    movsx ecx, word ptr [eax + field_310]        # 004b7b31
    mov dword ptr [ebp - local_c], ecx           # 004b7b38
    mov edx, dword ptr [ebp - local_c]           # 004b7b3b
    push edx                                     # 004b7b3e
    mov ecx, 0x5cf1eb                            # 004b7b3f
    call FUN_004f6334                            # 004b7b44
    test eax, eax                                # 004b7b49
    jne.d8 L_004b7b76                            # 004b7b4b
    # block 0x004b7b4d: entered by fall-through of jne at 0x004b7b4b, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004b7b76 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b7b4d
    movsx ecx, word ptr [eax + field_341]        # 004b7b50
    mov dword ptr [ebp - local_10], ecx          # 004b7b57
    mov edx, dword ptr [ebp - local_10]          # 004b7b5a
    push edx                                     # 004b7b5d
    mov ecx, 0x5cf1eb                            # 004b7b5e
    call FUN_004f6334                            # 004b7b63
    test eax, eax                                # 004b7b68
    jne.d8 L_004b7b76                            # 004b7b6a
    # block 0x004b7b6c: entered by fall-through of jne at 0x004b7b6a, 2 instruction(s), falls into the block at 0x004b7b76
    mov eax, dword ptr [ebp - local_14]          # 004b7b6c
    mov dword ptr [eax + field_25], 0x0          # 004b7b6f
L_004b7b76:
    # block 0x004b7b76: entered by jmp at 0x004b79d7; jmp at 0x004b7a32; jmp at 0x004b7a83; jmp at 0x004b7b2c; more, 1 instruction(s), ends with forward jump to 0x004b7dd5
    jmp.d32 L_004b7dd5                           # 004b7b76
L_004b7b7b:
    # block 0x004b7b7b: entered by je at 0x004b77c2, 10 instruction(s), ends with je to 0x004b7bb8 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 004b7b7b
    mov ecx, dword ptr [ebp - local_14]          # 004b7b85
    mov byte ptr [ecx + field_35], 0x0           # 004b7b88
    mov edi, 0x551ce4                            # 004b7b8c
    mov esi, dword ptr [ebp - local_4]           # 004b7b91
    add esi, 0x2ef                               # 004b7b94
    mov ecx, 0x9                                 # 004b7b9a
    {load} xor edx, edx                          # 004b7b9f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b7ba1
    je.d8 L_004b7bb8                             # 004b7ba3
    # block 0x004b7ba5: entered by fall-through of je at 0x004b7ba3, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004b7bb8
    mov eax, dword ptr [ebp - local_4]           # 004b7ba5
    add eax, 0x2ef                               # 004b7ba8
    push eax                                     # 004b7bad
    mov ecx, 0x5c3a67                            # 004b7bae
    call FUN_004fba69                            # 004b7bb3
L_004b7bb8:
    # block 0x004b7bb8: entered by je at 0x004b7ba3, 7 instruction(s), ends with je to 0x004b7be4 (forward)
    mov edi, 0x551cf0                            # 004b7bb8
    mov esi, dword ptr [ebp - local_4]           # 004b7bbd
    add esi, 0x320                               # 004b7bc0
    mov ecx, 0x9                                 # 004b7bc6
    {load} xor edx, edx                          # 004b7bcb
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b7bcd
    je.d8 L_004b7be4                             # 004b7bcf
    # block 0x004b7bd1: entered by fall-through of je at 0x004b7bcf, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004b7be4
    mov eax, dword ptr [ebp - local_4]           # 004b7bd1
    add eax, 0x320                               # 004b7bd4
    push eax                                     # 004b7bd9
    mov ecx, 0x5c3a67                            # 004b7bda
    call FUN_004fba69                            # 004b7bdf
L_004b7be4:
    # block 0x004b7be4: entered by je at 0x004b7bcf, 6 instruction(s), ends with je to 0x004b7ce0 (forward)
    mov dword ptr [0x5d1a8f], 0x0                # 004b7be4
    mov ecx, dword ptr [ebp - local_14]          # 004b7bee
    {load} xor edx, edx                          # 004b7bf1
    mov dl, byte ptr [ecx + field_36]            # 004b7bf3
    test edx, edx                                # 004b7bf6
    je.d32 L_004b7ce0                            # 004b7bf8
    # block 0x004b7bfe: entered by fall-through of je at 0x004b7bf8, 4 instruction(s), ends with je to 0x004b7cb0 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b7bfe
    movsx ecx, word ptr [eax + field_39d]        # 004b7c01
    cmp ecx, 0x270f                              # 004b7c08
    je.d32 L_004b7cb0                            # 004b7c0e
    # block 0x004b7c14: entered by fall-through of je at 0x004b7c0e, 25 instruction(s), ends with jne to 0x004b7c9c (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b7c14
    movsx eax, word ptr [edx + field_39d]        # 004b7c17
    mov dword ptr [0x5bb57b], eax                # 004b7c1e
    mov ecx, dword ptr [ebp - local_4]           # 004b7c23
    mov dx, word ptr [ecx + field_39f]           # 004b7c26
    mov word ptr [0x5bb599], dx                  # 004b7c2d
    mov eax, dword ptr [ebp - local_4]           # 004b7c34
    mov cx, word ptr [eax + field_3a1]           # 004b7c37
    mov word ptr [0x5bb595], cx                  # 004b7c3e
    mov edx, dword ptr [ebp - local_4]           # 004b7c45
    mov ax, word ptr [edx + field_3a3]           # 004b7c48
    mov word ptr [0x5c39ff], ax                  # 004b7c4f
    mov ecx, dword ptr [ebp - local_4]           # 004b7c55
    mov edx, dword ptr [ecx + field_3a5]         # 004b7c58
    mov dword ptr [0x5bb59b], edx                # 004b7c5e
    mov eax, dword ptr [ebp - local_4]           # 004b7c64
    mov ecx, dword ptr [eax + field_3a9]         # 004b7c67
    mov dword ptr [0x5bb59f], ecx                # 004b7c6d
    mov edx, dword ptr [ebp - local_4]           # 004b7c73
    mov eax, dword ptr [edx + field_3ad]         # 004b7c76
    mov dword ptr [0x5bb5a3], eax                # 004b7c7c
    mov ecx, dword ptr [ebp - local_4]           # 004b7c81
    movsx edx, word ptr [ecx + field_3b1]        # 004b7c84
    cmp edx, 0x1                                 # 004b7c8b
    jne.d8 L_004b7c9c                            # 004b7c8e
    # block 0x004b7c90: entered by fall-through of jne at 0x004b7c8e, 2 instruction(s), ends with forward jump to 0x004b7ca6
    mov dword ptr [0x5bb1ca], 0x0                # 004b7c90
    jmp.d8 L_004b7ca6                            # 004b7c9a
L_004b7c9c:
    # block 0x004b7c9c: entered by jne at 0x004b7c8e, 1 instruction(s), falls into the block at 0x004b7ca6
    mov dword ptr [0x5bb1ca], 0x1                # 004b7c9c
L_004b7ca6:
    # block 0x004b7ca6: entered by jmp at 0x004b7c9a, 1 instruction(s), falls into the block at 0x004b7cb0
    mov dword ptr [0x583999], 0x4                # 004b7ca6
L_004b7cb0:
    # block 0x004b7cb0: entered by je at 0x004b7c0e, 4 instruction(s), ends with je to 0x004b7cdb (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b7cb0
    movsx ecx, word ptr [eax + field_3b3]        # 004b7cb3
    cmp ecx, -0x1                                # 004b7cba
    je.d8 L_004b7cdb                             # 004b7cbd
    # block 0x004b7cbf: entered by fall-through of je at 0x004b7cbd, 6 instruction(s), falls into the block at 0x004b7cdb
    mov edx, dword ptr [ebp - local_4]           # 004b7cbf
    {load} xor eax, eax                          # 004b7cc2
    mov al, byte ptr [edx + field_3b5]           # 004b7cc4
    mov ecx, dword ptr [ebp - local_4]           # 004b7cca
    movsx edx, word ptr [ecx + field_3b3]        # 004b7ccd
    mov dword ptr [4*edx + 0x585801], eax        # 004b7cd4
L_004b7cdb:
    # block 0x004b7cdb: entered by je at 0x004b7cbd, 1 instruction(s), ends with forward jump to 0x004b7dbd
    jmp.d32 L_004b7dbd                           # 004b7cdb
L_004b7ce0:
    # block 0x004b7ce0: entered by je at 0x004b7bf8, 4 instruction(s), ends with je to 0x004b7d92 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b7ce0
    movsx ecx, word ptr [eax + field_351]        # 004b7ce3
    cmp ecx, 0x270f                              # 004b7cea
    je.d32 L_004b7d92                            # 004b7cf0
    # block 0x004b7cf6: entered by fall-through of je at 0x004b7cf0, 25 instruction(s), ends with jne to 0x004b7d7e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004b7cf6
    movsx eax, word ptr [edx + field_351]        # 004b7cf9
    mov dword ptr [0x5bb57b], eax                # 004b7d00
    mov ecx, dword ptr [ebp - local_4]           # 004b7d05
    mov dx, word ptr [ecx + field_353]           # 004b7d08
    mov word ptr [0x5bb599], dx                  # 004b7d0f
    mov eax, dword ptr [ebp - local_4]           # 004b7d16
    mov cx, word ptr [eax + field_355]           # 004b7d19
    mov word ptr [0x5bb595], cx                  # 004b7d20
    mov edx, dword ptr [ebp - local_4]           # 004b7d27
    mov ax, word ptr [edx + field_357]           # 004b7d2a
    mov word ptr [0x5c39ff], ax                  # 004b7d31
    mov ecx, dword ptr [ebp - local_4]           # 004b7d37
    mov edx, dword ptr [ecx + field_359]         # 004b7d3a
    mov dword ptr [0x5bb59b], edx                # 004b7d40
    mov eax, dword ptr [ebp - local_4]           # 004b7d46
    mov ecx, dword ptr [eax + field_35d]         # 004b7d49
    mov dword ptr [0x5bb59f], ecx                # 004b7d4f
    mov edx, dword ptr [ebp - local_4]           # 004b7d55
    mov eax, dword ptr [edx + field_361]         # 004b7d58
    mov dword ptr [0x5bb5a3], eax                # 004b7d5e
    mov ecx, dword ptr [ebp - local_4]           # 004b7d63
    movsx edx, word ptr [ecx + field_365]        # 004b7d66
    cmp edx, 0x1                                 # 004b7d6d
    jne.d8 L_004b7d7e                            # 004b7d70
    # block 0x004b7d72: entered by fall-through of jne at 0x004b7d70, 2 instruction(s), ends with forward jump to 0x004b7d88
    mov dword ptr [0x5bb1ca], 0x0                # 004b7d72
    jmp.d8 L_004b7d88                            # 004b7d7c
L_004b7d7e:
    # block 0x004b7d7e: entered by jne at 0x004b7d70, 1 instruction(s), falls into the block at 0x004b7d88
    mov dword ptr [0x5bb1ca], 0x1                # 004b7d7e
L_004b7d88:
    # block 0x004b7d88: entered by jmp at 0x004b7d7c, 1 instruction(s), falls into the block at 0x004b7d92
    mov dword ptr [0x583999], 0x4                # 004b7d88
L_004b7d92:
    # block 0x004b7d92: entered by je at 0x004b7cf0, 4 instruction(s), ends with je to 0x004b7dbd (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b7d92
    movsx ecx, word ptr [eax + field_367]        # 004b7d95
    cmp ecx, -0x1                                # 004b7d9c
    je.d8 L_004b7dbd                             # 004b7d9f
    # block 0x004b7da1: entered by fall-through of je at 0x004b7d9f, 6 instruction(s), falls into the block at 0x004b7dbd
    mov edx, dword ptr [ebp - local_4]           # 004b7da1
    {load} xor eax, eax                          # 004b7da4
    mov al, byte ptr [edx + field_369]           # 004b7da6
    mov ecx, dword ptr [ebp - local_4]           # 004b7dac
    movsx edx, word ptr [ecx + field_367]        # 004b7daf
    mov dword ptr [4*edx + 0x585801], eax        # 004b7db6
L_004b7dbd:
    # block 0x004b7dbd: entered by jmp at 0x004b7cdb; je at 0x004b7d9f, 7 instruction(s), calls FUN_0042ba3a, FUN_004b7229, falls into the block at 0x004b7dd5
    mov eax, dword ptr [ebp - local_14]          # 004b7dbd
    mov cx, word ptr [eax + field_21]            # 004b7dc0
    push ecx                                     # 004b7dc4
    call FUN_0042ba3a                            # 004b7dc5
    add esp, 0x4                                 # 004b7dca
    mov ecx, dword ptr [ebp - local_14]          # 004b7dcd
    call FUN_004b7229                            # 004b7dd0
L_004b7dd5:
    # block 0x004b7dd5: entered by jmp at 0x004b77c8; jmp at 0x004b79b3; jmp at 0x004b7b76, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004b7dd5
    pop esi                                      # 004b7dd6
    {load} mov esp, ebp                          # 004b7dd7
    pop ebp                                      # 004b7dd9
    ret 0x4                                      # 004b7dda

