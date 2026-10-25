# FUN_0045764a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045764a
# extent:       0x0045764a-0x00457bc8 (1406 code bytes)
# span:         0x0045764a-0x00457bc8 (code 1406, tables 0, padding 0)
# sha256:       d495fcde6077ecd9c33bebbca8570949a419e43e756c748ec2865377ccf2cf2a
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045764a
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_1c, field_1e, field_28, field_2a, field_2c, field_30, field_3e, field_22e, field_236, field_254, field_25a, field_266 and 1 more; [ecx + n] field_1c, field_1e, field_20, field_24, field_28, field_30, field_32, field_3a, field_22c, field_232, field_23e, field_252 and 3 more; [edx + n] field_1c, field_1e, field_23, field_24, field_28, field_36, field_22a, field_230, field_23a, field_252, field_256, field_25e and 1 more
# callees:      calls FUN_004e8d96, FUN_00456dc8, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, KERNEL32.dll!GetTickCount, FUN_004570c4, FUN_004fba69, FUN_0042ba3a, FUN_00456d2e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 339 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_23, 0x23  # offset +0x23
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22c, 0x22c  # offset +0x22c
.equ field_22e, 0x22e  # offset +0x22e
.equ field_230, 0x230  # offset +0x230
.equ field_232, 0x232  # offset +0x232
.equ field_236, 0x236  # offset +0x236
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23e, 0x23e  # offset +0x23e
.equ field_252, 0x252  # offset +0x252
.equ field_254, 0x254  # offset +0x254
.equ field_256, 0x256  # offset +0x256
.equ field_258, 0x258  # offset +0x258
.equ field_25a, 0x25a  # offset +0x25a
.equ field_25e, 0x25e  # offset +0x25e
.equ field_262, 0x262  # offset +0x262
.equ field_266, 0x266  # offset +0x266
.equ field_268, 0x268  # offset +0x268
.equ field_26a, 0x26a  # offset +0x26a

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00456d2e, .text + (0x00456d2e - 0x401000)
.set FUN_00456dc8, .text + (0x00456dc8 - 0x401000)
.set FUN_004570c4, .text + (0x004570c4 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x0045764a - 0x401000
.globl FUN_0045764a
FUN_0045764a:
    # block 0x0045764a: entry, 16 instruction(s), ends with je to 0x0045769a (forward)
    push ebp                                     # 0045764a
    {load} mov ebp, esp                          # 0045764b
    sub esp, 0x10                                # 0045764d
    push esi                                     # 00457650
    push edi                                     # 00457651
    mov dword ptr [ebp - local_8], ecx           # 00457652
    movsx eax, word ptr [ebp + arg_8]            # 00457655
    imul eax, eax, 0x8d                          # 00457659
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0045765f
    mov dword ptr [ebp - local_4], ecx           # 00457665
    movsx edx, word ptr [ebp + arg_8]            # 00457668
    imul edx, edx, 0x8d                          # 0045766c
    mov eax, dword ptr [edx + 0x5bb632]          # 00457672
    mov dword ptr [ebp - local_c], eax           # 00457678
    cmp dword ptr [ebp - local_c], 0x0           # 0045767b
    je.d8 L_0045769a                             # 0045767f
    # block 0x00457681: entered by fall-through of je at 0x0045767f, 2 instruction(s), ends with je to 0x004578b0 (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 00457681
    je.d32 L_004578b0                            # 00457685
    # block 0x0045768b: entered by fall-through of je at 0x00457685, 2 instruction(s), ends with je to 0x0045798e (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 0045768b
    je.d32 L_0045798e                            # 0045768f
    # block 0x00457695: entered by fall-through of je at 0x0045768f, 1 instruction(s), ends with forward jump to 0x00457bc0
    jmp.d32 L_00457bc0                           # 00457695
L_0045769a:
    # block 0x0045769a: entered by je at 0x0045767f, 79 instruction(s), calls FUN_004e8d96, FUN_00456dc8, FUN_004d39f9, ends with jne to 0x00457810 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0045769a
    mov dx, word ptr [ebp + arg_8]               # 0045769d
    mov word ptr [ecx + field_1e], dx            # 004576a1
    mov eax, dword ptr [ebp - local_8]           # 004576a5
    mov dword ptr [eax + field_3e], 0x1          # 004576a8
    mov dword ptr [0x5bb1ca], 0x1                # 004576af
    mov ecx, 0x571442                            # 004576b9
    call FUN_004e8d96                            # 004576be
    mov ecx, dword ptr [ebp - local_8]           # 004576c3
    mov dword ptr [ecx + field_3a], 0x0          # 004576c6
    mov edx, dword ptr [ebp - local_8]           # 004576cd
    mov word ptr [edx + field_28], 0x0           # 004576d0
    mov eax, dword ptr [ebp - local_8]           # 004576d6
    mov word ptr [eax + field_2a], 0x0           # 004576d9
    mov ecx, dword ptr [ebp - local_8]           # 004576df
    call FUN_00456dc8                            # 004576e2
    mov ecx, dword ptr [ebp - local_8]           # 004576e7
    mov dword ptr [ecx + field_24], 0x0          # 004576ea
    mov edx, dword ptr [ebp - local_8]           # 004576f1
    movsx eax, word ptr [edx + field_1e]         # 004576f4
    imul eax, eax, 0x8d                          # 004576f8
    mov dword ptr [eax + 0x5bb632], 0x1          # 004576fe
    call FUN_004d39f9                            # 00457708
    mov ecx, dword ptr [ebp - local_8]           # 0045770d
    mov word ptr [ecx + field_1c], ax            # 00457710
    mov edx, dword ptr [ebp - local_8]           # 00457714
    movsx eax, word ptr [edx + field_1c]         # 00457717
    imul eax, eax, 0x4a                          # 0045771b
    mov dword ptr [eax + 0x5d1591], 0xa          # 0045771e
    mov ecx, dword ptr [ebp - local_8]           # 00457728
    movsx edx, word ptr [ecx + field_1c]         # 0045772b
    imul edx, edx, 0x4a                          # 0045772f
    mov dword ptr [edx + 0x5d1595], 0x457bd8     # 00457732
    mov eax, dword ptr [ebp - local_8]           # 0045773c
    movsx ecx, word ptr [eax + field_1c]         # 0045773f
    imul ecx, ecx, 0x4a                          # 00457743
    mov dword ptr [ecx + 0x5d1599], 0x0          # 00457746
    mov edx, dword ptr [ebp - local_8]           # 00457750
    movsx eax, word ptr [edx + field_1c]         # 00457753
    imul eax, eax, 0x4a                          # 00457757
    mov dword ptr [eax + 0x5d159d], 0x0          # 0045775a
    mov ecx, dword ptr [ebp - local_8]           # 00457764
    movsx edx, word ptr [ecx + field_1c]         # 00457767
    imul edx, edx, 0x4a                          # 0045776b
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0045776e
    mov eax, dword ptr [ebp - local_8]           # 00457778
    movsx ecx, word ptr [eax + field_1c]         # 0045777b
    imul ecx, ecx, 0x4a                          # 0045777f
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00457782
    mov edx, dword ptr [ebp - local_8]           # 0045778c
    movsx eax, word ptr [edx + field_1c]         # 0045778f
    imul eax, eax, 0x4a                          # 00457793
    mov dword ptr [eax + 0x5d15a9], 0x1          # 00457796
    mov ecx, dword ptr [ebp - local_8]           # 004577a0
    movsx edx, word ptr [ecx + field_1c]         # 004577a3
    imul edx, edx, 0x4a                          # 004577a7
    mov word ptr [edx + 0x5d15ad], 0x0           # 004577aa
    mov edi, 0x54a3b4                            # 004577b3
    mov eax, dword ptr [ebp - local_8]           # 004577b8
    movsx ecx, word ptr [eax + field_1c]         # 004577bb
    imul ecx, ecx, 0x4a                          # 004577bf
    add ecx, 0x5d15b3                            # 004577c2
    {load} mov edx, ecx                          # 004577c8
    or ecx, -0x1                                 # 004577ca
    {load} xor eax, eax                          # 004577cd
    repne scasb al, byte ptr es:[edi]            # 004577cf
    not ecx                                      # 004577d1
    {load} sub edi, ecx                          # 004577d3
    {load} mov esi, edi                          # 004577d5
    {load} mov eax, ecx                          # 004577d7
    {load} mov edi, edx                          # 004577d9
    shr ecx, 0x2                                 # 004577db
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004577de
    {load} mov ecx, eax                          # 004577e0
    and ecx, 0x3                                 # 004577e2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004577e5
    mov ecx, dword ptr [ebp - local_8]           # 004577e7
    cmp dword ptr [ecx + field_20], 0x0          # 004577ea
    jne.d8 L_00457810                            # 004577ee
    # block 0x004577f0: entered by fall-through of jne at 0x004577ee, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x00457810
    push 0x54a3cc                                # 004577f0
    push 0x6                                     # 004577f5
    mov edx, dword ptr [ebp - local_4]           # 004577f7
    push edx                                     # 004577fa
    push 0x54a3e4                                # 004577fb
    mov ecx, 0x5cf659                            # 00457800
    call FUN_004c2790                            # 00457805
    mov ecx, dword ptr [ebp - local_8]           # 0045780a
    mov dword ptr [ecx + field_20], eax          # 0045780d
L_00457810:
    # block 0x00457810: entered by jne at 0x004577ee, 13 instruction(s), ends with je to 0x00457853 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00457810
    movsx eax, word ptr [edx + field_1c]         # 00457813
    imul eax, eax, 0x4a                          # 00457817
    mov ecx, dword ptr [ebp - local_8]           # 0045781a
    mov edx, dword ptr [ecx + field_20]          # 0045781d
    mov dword ptr [eax + 0x5d1599], edx          # 00457820
    mov edi, 0x54a3ec                            # 00457826
    mov esi, dword ptr [ebp - local_4]           # 0045782b
    add esi, 0x197                               # 0045782e
    mov ecx, 0x9                                 # 00457834
    {load} xor eax, eax                          # 00457839
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045783b
    je.d8 L_00457853                             # 0045783d
    # block 0x0045783f: entered by fall-through of je at 0x0045783d, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x00457853
    mov ecx, dword ptr [ebp - local_4]           # 0045783f
    add ecx, 0x197                               # 00457842
    push ecx                                     # 00457848
    mov ecx, 0x5c3a67                            # 00457849
    call FUN_004fb77a                            # 0045784e
L_00457853:
    # block 0x00457853: entered by je at 0x0045783d, 7 instruction(s), ends with je to 0x0045787f (forward)
    mov edi, 0x54a3f8                            # 00457853
    mov esi, dword ptr [ebp - local_4]           # 00457858
    add esi, 0x1c8                               # 0045785b
    mov ecx, 0x9                                 # 00457861
    {load} xor edx, edx                          # 00457866
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00457868
    je.d8 L_0045787f                             # 0045786a
    # block 0x0045786c: entered by fall-through of je at 0x0045786a, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x0045787f
    mov eax, dword ptr [ebp - local_4]           # 0045786c
    add eax, 0x1c8                               # 0045786f
    push eax                                     # 00457874
    mov ecx, 0x5c3a67                            # 00457875
    call FUN_004fb77a                            # 0045787a
L_0045787f:
    # block 0x0045787f: entered by je at 0x0045786a, 7 instruction(s), ends with je to 0x004578ab (forward)
    mov edi, 0x54a404                            # 0045787f
    mov esi, dword ptr [ebp - local_4]           # 00457884
    add esi, 0x1f9                               # 00457887
    mov ecx, 0x9                                 # 0045788d
    {load} xor edx, edx                          # 00457892
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00457894
    je.d8 L_004578ab                             # 00457896
    # block 0x00457898: entered by fall-through of je at 0x00457896, 5 instruction(s), calls FUN_004fb77a, falls into the block at 0x004578ab
    mov eax, dword ptr [ebp - local_4]           # 00457898
    add eax, 0x1f9                               # 0045789b
    push eax                                     # 004578a0
    mov ecx, 0x5c3a67                            # 004578a1
    call FUN_004fb77a                            # 004578a6
L_004578ab:
    # block 0x004578ab: entered by je at 0x00457896, 1 instruction(s), ends with forward jump to 0x00457bc0
    jmp.d32 L_00457bc0                           # 004578ab
L_004578b0:
    # block 0x004578b0: entered by je at 0x00457685, 5 instruction(s), ends with je to 0x004578ce (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004578b0
    mov edx, dword ptr [ecx + field_24]          # 004578b3
    mov dword ptr [ebp - local_10], edx          # 004578b6
    cmp dword ptr [ebp - local_10], 0x0          # 004578b9
    je.d8 L_004578ce                             # 004578bd
    # block 0x004578bf: entered by fall-through of je at 0x004578bd, 2 instruction(s), ends with je to 0x0045796a (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004578bf
    je.d32 L_0045796a                            # 004578c3
    # block 0x004578c9: entered by fall-through of je at 0x004578c3, 1 instruction(s), ends with forward jump to 0x00457989
    jmp.d32 L_00457989                           # 004578c9
L_004578ce:
    # block 0x004578ce: entered by je at 0x004578bd, 3 instruction(s), ends with je to 0x00457968 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004578ce
    cmp dword ptr [eax + field_2c], 0x0          # 004578d1
    je.d32 L_00457968                            # 004578d5
    # block 0x004578db: entered by fall-through of je at 0x004578d5, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jbe to 0x00457968 (forward)
    call dword ptr [0x52a23c]                    # 004578db
    mov ecx, dword ptr [ebp - local_8]           # 004578e1
    cmp eax, dword ptr [ecx + field_32]          # 004578e4
    jbe.d8 L_00457968                            # 004578e7
    # block 0x004578e9: entered by fall-through of jbe at 0x004578e7, 6 instruction(s), ends with jne to 0x0045790a (forward)
    mov edx, dword ptr [ebp - local_8]           # 004578e9
    mov dword ptr [edx + field_36], 0x0          # 004578ec
    mov eax, dword ptr [ebp - local_8]           # 004578f3
    movsx ecx, word ptr [eax + field_30]         # 004578f6
    test ecx, ecx                                # 004578fa
    jne.d8 L_0045790a                            # 004578fc
    # block 0x004578fe: entered by fall-through of jne at 0x004578fc, 3 instruction(s), ends with forward jump to 0x00457968
    mov edx, dword ptr [ebp - local_8]           # 004578fe
    mov dword ptr [edx + field_24], 0x1          # 00457901
    jmp.d8 L_00457968                            # 00457908
L_0045790a:
    # block 0x0045790a: entered by jne at 0x004578fc, 4 instruction(s), ends with jne to 0x00457935 (forward)
    mov eax, dword ptr [ebp - local_8]           # 0045790a
    movsx ecx, word ptr [eax + field_30]         # 0045790d
    cmp ecx, 0x1                                 # 00457911
    jne.d8 L_00457935                            # 00457914
    # block 0x00457916: entered by fall-through of jne at 0x00457914, 4 instruction(s), ends with jle to 0x00457933 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00457916
    movsx eax, word ptr [edx + field_28]         # 00457919
    test eax, eax                                # 0045791d
    jle.d8 L_00457933                            # 0045791f
    # block 0x00457921: entered by fall-through of jle at 0x0045791f, 5 instruction(s), falls into the block at 0x00457933
    mov ecx, dword ptr [ebp - local_8]           # 00457921
    mov dx, word ptr [ecx + field_28]            # 00457924
    sub dx, 0x1                                  # 00457928
    mov eax, dword ptr [ebp - local_8]           # 0045792c
    mov word ptr [eax + field_28], dx            # 0045792f
L_00457933:
    # block 0x00457933: entered by jle at 0x0045791f, 1 instruction(s), ends with forward jump to 0x00457968
    jmp.d8 L_00457968                            # 00457933
L_00457935:
    # block 0x00457935: entered by jne at 0x00457914, 4 instruction(s), ends with jne to 0x00457968 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00457935
    movsx edx, word ptr [ecx + field_30]         # 00457938
    cmp edx, 0x2                                 # 0045793c
    jne.d8 L_00457968                            # 0045793f
    # block 0x00457941: entered by fall-through of jne at 0x0045793f, 7 instruction(s), ends with jge to 0x00457968 (forward)
    mov eax, dword ptr [ebp - local_8]           # 00457941
    movsx ecx, word ptr [eax + field_28]         # 00457944
    mov edx, dword ptr [ebp - local_4]           # 00457948
    movsx eax, word ptr [edx + field_23]         # 0045794b
    sub eax, 0x1                                 # 0045794f
    {load} cmp ecx, eax                          # 00457952
    jge.d8 L_00457968                            # 00457954
    # block 0x00457956: entered by fall-through of jge at 0x00457954, 5 instruction(s), falls into the block at 0x00457968
    mov ecx, dword ptr [ebp - local_8]           # 00457956
    mov dx, word ptr [ecx + field_28]            # 00457959
    add dx, 0x1                                  # 0045795d
    mov eax, dword ptr [ebp - local_8]           # 00457961
    mov word ptr [eax + field_28], dx            # 00457964
L_00457968:
    # block 0x00457968: entered by je at 0x004578d5; jbe at 0x004578e7; jmp at 0x00457908; jmp at 0x00457933; more, 1 instruction(s), ends with forward jump to 0x00457989
    jmp.d8 L_00457989                            # 00457968
L_0045796a:
    # block 0x0045796a: entered by je at 0x004578c3, 6 instruction(s), calls FUN_004570c4, falls into the block at 0x00457989
    mov ecx, dword ptr [ebp - local_8]           # 0045796a
    call FUN_004570c4                            # 0045796d
    mov ecx, dword ptr [ebp - local_8]           # 00457972
    movsx edx, word ptr [ecx + field_1e]         # 00457975
    imul edx, edx, 0x8d                          # 00457979
    mov dword ptr [edx + 0x5bb632], 0x2          # 0045797f
L_00457989:
    # block 0x00457989: entered by jmp at 0x004578c9; jmp at 0x00457968, 1 instruction(s), ends with forward jump to 0x00457bc0
    jmp.d32 L_00457bc0                           # 00457989
L_0045798e:
    # block 0x0045798e: entered by je at 0x0045768f, 8 instruction(s), ends with je to 0x004579c5 (forward)
    mov dword ptr [0x5bb1ca], 0x1                # 0045798e
    mov edi, 0x54a410                            # 00457998
    mov esi, dword ptr [ebp - local_4]           # 0045799d
    add esi, 0x197                               # 004579a0
    mov ecx, 0x9                                 # 004579a6
    {load} xor eax, eax                          # 004579ab
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004579ad
    je.d8 L_004579c5                             # 004579af
    # block 0x004579b1: entered by fall-through of je at 0x004579af, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004579c5
    mov ecx, dword ptr [ebp - local_4]           # 004579b1
    add ecx, 0x197                               # 004579b4
    push ecx                                     # 004579ba
    mov ecx, 0x5c3a67                            # 004579bb
    call FUN_004fba69                            # 004579c0
L_004579c5:
    # block 0x004579c5: entered by je at 0x004579af, 7 instruction(s), ends with je to 0x004579f1 (forward)
    mov edi, 0x54a41c                            # 004579c5
    mov esi, dword ptr [ebp - local_4]           # 004579ca
    add esi, 0x1c8                               # 004579cd
    mov ecx, 0x9                                 # 004579d3
    {load} xor edx, edx                          # 004579d8
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004579da
    je.d8 L_004579f1                             # 004579dc
    # block 0x004579de: entered by fall-through of je at 0x004579dc, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x004579f1
    mov eax, dword ptr [ebp - local_4]           # 004579de
    add eax, 0x1c8                               # 004579e1
    push eax                                     # 004579e6
    mov ecx, 0x5c3a67                            # 004579e7
    call FUN_004fba69                            # 004579ec
L_004579f1:
    # block 0x004579f1: entered by je at 0x004579dc, 7 instruction(s), ends with je to 0x00457a1d (forward)
    mov edi, 0x54a428                            # 004579f1
    mov esi, dword ptr [ebp - local_4]           # 004579f6
    add esi, 0x1f9                               # 004579f9
    mov ecx, 0x9                                 # 004579ff
    {load} xor edx, edx                          # 00457a04
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00457a06
    je.d8 L_00457a1d                             # 00457a08
    # block 0x00457a0a: entered by fall-through of je at 0x00457a08, 5 instruction(s), calls FUN_004fba69, falls into the block at 0x00457a1d
    mov eax, dword ptr [ebp - local_4]           # 00457a0a
    add eax, 0x1f9                               # 00457a0d
    push eax                                     # 00457a12
    mov ecx, 0x5c3a67                            # 00457a13
    call FUN_004fba69                            # 00457a18
L_00457a1d:
    # block 0x00457a1d: entered by je at 0x00457a08, 3 instruction(s), ends with je to 0x00457b0c (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00457a1d
    cmp dword ptr [ecx + field_3a], 0x0          # 00457a20
    je.d32 L_00457b0c                            # 00457a24
    # block 0x00457a2a: entered by fall-through of je at 0x00457a24, 4 instruction(s), ends with je to 0x00457adc (forward)
    mov edx, dword ptr [ebp - local_4]           # 00457a2a
    movsx eax, word ptr [edx + field_252]        # 00457a2d
    cmp eax, 0x270f                              # 00457a34
    je.d32 L_00457adc                            # 00457a39
    # block 0x00457a3f: entered by fall-through of je at 0x00457a39, 25 instruction(s), ends with jne to 0x00457ac8 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00457a3f
    movsx edx, word ptr [ecx + field_252]        # 00457a42
    mov dword ptr [0x5bb57b], edx                # 00457a49
    mov eax, dword ptr [ebp - local_4]           # 00457a4f
    mov cx, word ptr [eax + field_254]           # 00457a52
    mov word ptr [0x5bb599], cx                  # 00457a59
    mov edx, dword ptr [ebp - local_4]           # 00457a60
    mov ax, word ptr [edx + field_256]           # 00457a63
    mov word ptr [0x5bb595], ax                  # 00457a6a
    mov ecx, dword ptr [ebp - local_4]           # 00457a70
    mov dx, word ptr [ecx + field_258]           # 00457a73
    mov word ptr [0x5c39ff], dx                  # 00457a7a
    mov eax, dword ptr [ebp - local_4]           # 00457a81
    mov ecx, dword ptr [eax + field_25a]         # 00457a84
    mov dword ptr [0x5bb59b], ecx                # 00457a8a
    mov edx, dword ptr [ebp - local_4]           # 00457a90
    mov eax, dword ptr [edx + field_25e]         # 00457a93
    mov dword ptr [0x5bb59f], eax                # 00457a99
    mov ecx, dword ptr [ebp - local_4]           # 00457a9e
    mov edx, dword ptr [ecx + field_262]         # 00457aa1
    mov dword ptr [0x5bb5a3], edx                # 00457aa7
    mov eax, dword ptr [ebp - local_4]           # 00457aad
    movsx ecx, word ptr [eax + field_266]        # 00457ab0
    cmp ecx, 0x1                                 # 00457ab7
    jne.d8 L_00457ac8                            # 00457aba
    # block 0x00457abc: entered by fall-through of jne at 0x00457aba, 2 instruction(s), ends with forward jump to 0x00457ad2
    mov dword ptr [0x5bb1ca], 0x0                # 00457abc
    jmp.d8 L_00457ad2                            # 00457ac6
L_00457ac8:
    # block 0x00457ac8: entered by jne at 0x00457aba, 1 instruction(s), falls into the block at 0x00457ad2
    mov dword ptr [0x5bb1ca], 0x1                # 00457ac8
L_00457ad2:
    # block 0x00457ad2: entered by jmp at 0x00457ac6, 1 instruction(s), falls into the block at 0x00457adc
    mov dword ptr [0x583999], 0x4                # 00457ad2
L_00457adc:
    # block 0x00457adc: entered by je at 0x00457a39, 4 instruction(s), ends with je to 0x00457b07 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00457adc
    movsx eax, word ptr [edx + field_268]        # 00457adf
    cmp eax, -0x1                                # 00457ae6
    je.d8 L_00457b07                             # 00457ae9
    # block 0x00457aeb: entered by fall-through of je at 0x00457ae9, 6 instruction(s), falls into the block at 0x00457b07
    mov ecx, dword ptr [ebp - local_4]           # 00457aeb
    {load} xor edx, edx                          # 00457aee
    mov dl, byte ptr [ecx + field_26a]           # 00457af0
    mov eax, dword ptr [ebp - local_4]           # 00457af6
    movsx ecx, word ptr [eax + field_268]        # 00457af9
    mov dword ptr [4*ecx + 0x585801], edx        # 00457b00
L_00457b07:
    # block 0x00457b07: entered by je at 0x00457ae9, 1 instruction(s), ends with forward jump to 0x00457ba8
    jmp.d32 L_00457ba8                           # 00457b07
L_00457b0c:
    # block 0x00457b0c: entered by je at 0x00457a24, 25 instruction(s), ends with jne to 0x00457b94 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00457b0c
    movsx eax, word ptr [edx + field_22a]        # 00457b0f
    mov dword ptr [0x5bb57b], eax                # 00457b16
    mov ecx, dword ptr [ebp - local_4]           # 00457b1b
    mov dx, word ptr [ecx + field_22c]           # 00457b1e
    mov word ptr [0x5bb599], dx                  # 00457b25
    mov eax, dword ptr [ebp - local_4]           # 00457b2c
    mov cx, word ptr [eax + field_22e]           # 00457b2f
    mov word ptr [0x5bb595], cx                  # 00457b36
    mov edx, dword ptr [ebp - local_4]           # 00457b3d
    mov ax, word ptr [edx + field_230]           # 00457b40
    mov word ptr [0x5c39ff], ax                  # 00457b47
    mov ecx, dword ptr [ebp - local_4]           # 00457b4d
    mov edx, dword ptr [ecx + field_232]         # 00457b50
    mov dword ptr [0x5bb59b], edx                # 00457b56
    mov eax, dword ptr [ebp - local_4]           # 00457b5c
    mov ecx, dword ptr [eax + field_236]         # 00457b5f
    mov dword ptr [0x5bb59f], ecx                # 00457b65
    mov edx, dword ptr [ebp - local_4]           # 00457b6b
    mov eax, dword ptr [edx + field_23a]         # 00457b6e
    mov dword ptr [0x5bb5a3], eax                # 00457b74
    mov ecx, dword ptr [ebp - local_4]           # 00457b79
    movsx edx, word ptr [ecx + field_23e]        # 00457b7c
    cmp edx, 0x1                                 # 00457b83
    jne.d8 L_00457b94                            # 00457b86
    # block 0x00457b88: entered by fall-through of jne at 0x00457b86, 2 instruction(s), ends with forward jump to 0x00457b9e
    mov dword ptr [0x5bb1ca], 0x0                # 00457b88
    jmp.d8 L_00457b9e                            # 00457b92
L_00457b94:
    # block 0x00457b94: entered by jne at 0x00457b86, 1 instruction(s), falls into the block at 0x00457b9e
    mov dword ptr [0x5bb1ca], 0x1                # 00457b94
L_00457b9e:
    # block 0x00457b9e: entered by jmp at 0x00457b92, 1 instruction(s), falls into the block at 0x00457ba8
    mov dword ptr [0x583999], 0x4                # 00457b9e
L_00457ba8:
    # block 0x00457ba8: entered by jmp at 0x00457b07, 7 instruction(s), calls FUN_0042ba3a, FUN_00456d2e, falls into the block at 0x00457bc0
    mov eax, dword ptr [ebp - local_8]           # 00457ba8
    mov cx, word ptr [eax + field_1e]            # 00457bab
    push ecx                                     # 00457baf
    call FUN_0042ba3a                            # 00457bb0
    add esp, 0x4                                 # 00457bb5
    mov ecx, dword ptr [ebp - local_8]           # 00457bb8
    call FUN_00456d2e                            # 00457bbb
L_00457bc0:
    # block 0x00457bc0: entered by jmp at 0x00457695; jmp at 0x004578ab; jmp at 0x00457989, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00457bc0
    pop esi                                      # 00457bc1
    {load} mov esp, ebp                          # 00457bc2
    pop ebp                                      # 00457bc4
    ret 0x4                                      # 00457bc5

