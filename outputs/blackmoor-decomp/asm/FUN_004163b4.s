# FUN_004163b4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004163b4
# extent:       0x004163b4-0x00416af3 (1855 code bytes)
# span:         0x004163b4-0x00416af3 (code 1855, tables 0, padding 0)
# sha256:       d8efde26283e625b441671496a8e6450d8bdb89fe1c050ab895ee59c857ad0c3
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004163b4
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_104, local_108, local_10c, local_110, local_114, local_118, local_11c, local_120, local_124, local_128
# fields:       [eax + n] field_4, field_10, field_15, field_17, field_208, field_20c, field_210, field_212, field_214, field_218, field_21a, field_21c and 4 more; [ecx + n] field_4, field_c, field_208, field_20c, field_212, field_214, field_21a, field_21c, field_21e, field_222, field_226, field_22a and 3 more; [edx + n] field_17, field_19, field_1b, field_1c, field_20, field_208, field_20c, field_210, field_212, field_214, field_218, field_21c and 6 more
# callees:      calls FUN_0050cd72, FUN_00449d90, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4, FUN_00414ceb, FUN_004bf315, FUN_004bf3b8, FUN_004264e8, FUN_004bee5f, FUN_0050ce04, FUN_004bef11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 464 instruction(s), 16 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_104, 0x104  # offset -0x104
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_15, 0x15  # offset +0x15
.equ field_17, 0x17  # offset +0x17
.equ field_19, 0x19  # offset +0x19
.equ field_1b, 0x1b  # offset +0x1b
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_208, 0x208  # offset +0x208
.equ field_20c, 0x20c  # offset +0x20c
.equ field_210, 0x210  # offset +0x210
.equ field_212, 0x212  # offset +0x212
.equ field_214, 0x214  # offset +0x214
.equ field_218, 0x218  # offset +0x218
.equ field_21a, 0x21a  # offset +0x21a
.equ field_21c, 0x21c  # offset +0x21c
.equ field_21e, 0x21e  # offset +0x21e
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_22a, 0x22a  # offset +0x22a
.equ field_22e, 0x22e  # offset +0x22e
.equ field_2a2, 0x2a2  # offset +0x2a2
.equ field_2a4, 0x2a4  # offset +0x2a4

# --- external targets -----------------------------------------------
.set FUN_00414ceb, .text + (0x00414ceb - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_00449d90, .text + (0x00449d90 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bee5f, .text + (0x004bee5f - 0x401000)
.set FUN_004bef11, .text + (0x004bef11 - 0x401000)
.set FUN_004bf315, .text + (0x004bf315 - 0x401000)
.set FUN_004bf3b8, .text + (0x004bf3b8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004163b4 - 0x401000
.globl FUN_004163b4
FUN_004163b4:
    # block 0x004163b4: entry, 26 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x00416451 (forward)
    push ebp                                     # 004163b4
    {load} mov ebp, esp                          # 004163b5
    sub esp, 0x128                               # 004163b7
    push esi                                     # 004163bd
    push edi                                     # 004163be
    mov dword ptr [ebp - local_10c], ecx         # 004163bf
    mov eax, dword ptr [ebp + arg_8]             # 004163c5
    mov dword ptr [eax + field_20c], 0xffffffff  # 004163c8
    mov ecx, dword ptr [ebp + arg_8]             # 004163d2
    mov word ptr [ecx + field_2a2], 0x1          # 004163d5
    push 0x541f84                                # 004163de
    mov edx, dword ptr [ebp + arg_8]             # 004163e3
    add edx, 0x151                               # 004163e6
    push edx                                     # 004163ec
    push 0x639eb5                                # 004163ed
    push 0x639dae                                # 004163f2
    lea eax, [ebp - local_104]                   # 004163f7
    push eax                                     # 004163fd
    call FUN_0050cd72                            # 004163fe
    add esp, 0x14                                # 00416403
    lea ecx, [ebp - local_104]                   # 00416406
    push ecx                                     # 0041640c
    call FUN_00449d90                            # 0041640d
    add esp, 0x4                                 # 00416412
    test eax, eax                                # 00416415
    je.d8 L_00416451                             # 00416417
    # block 0x00416419: entered by fall-through of je at 0x00416417, 19 instruction(s), ends with forward jump to 0x004164c2
    lea edi, [ebp - local_104]                   # 00416419
    mov edx, dword ptr [ebp + arg_8]             # 0041641f
    add edx, 0x4d                                # 00416422
    or ecx, -0x1                                 # 00416425
    {load} xor eax, eax                          # 00416428
    repne scasb al, byte ptr es:[edi]            # 0041642a
    not ecx                                      # 0041642c
    {load} sub edi, ecx                          # 0041642e
    {load} mov esi, edi                          # 00416430
    {load} mov eax, ecx                          # 00416432
    {load} mov edi, edx                          # 00416434
    shr ecx, 0x2                                 # 00416436
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00416439
    {load} mov ecx, eax                          # 0041643b
    and ecx, 0x3                                 # 0041643d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416440
    mov ecx, dword ptr [ebp + arg_8]             # 00416442
    mov dword ptr [ecx + field_20c], 0x1         # 00416445
    jmp.d8 L_004164c2                            # 0041644f
L_00416451:
    # block 0x00416451: entered by je at 0x00416417, 16 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x004164c2 (forward)
    push 0x541f8c                                # 00416451
    mov edx, dword ptr [ebp + arg_8]             # 00416456
    add edx, 0x151                               # 00416459
    push edx                                     # 0041645f
    push 0x639fb9                                # 00416460
    push 0x639dab                                # 00416465
    lea eax, [ebp - local_104]                   # 0041646a
    push eax                                     # 00416470
    call FUN_0050cd72                            # 00416471
    add esp, 0x14                                # 00416476
    lea ecx, [ebp - local_104]                   # 00416479
    push ecx                                     # 0041647f
    call FUN_00449d90                            # 00416480
    add esp, 0x4                                 # 00416485
    test eax, eax                                # 00416488
    je.d8 L_004164c2                             # 0041648a
    # block 0x0041648c: entered by fall-through of je at 0x0041648a, 18 instruction(s), falls into the block at 0x004164c2
    lea edi, [ebp - local_104]                   # 0041648c
    mov edx, dword ptr [ebp + arg_8]             # 00416492
    add edx, 0x4d                                # 00416495
    or ecx, -0x1                                 # 00416498
    {load} xor eax, eax                          # 0041649b
    repne scasb al, byte ptr es:[edi]            # 0041649d
    not ecx                                      # 0041649f
    {load} sub edi, ecx                          # 004164a1
    {load} mov esi, edi                          # 004164a3
    {load} mov eax, ecx                          # 004164a5
    {load} mov edi, edx                          # 004164a7
    shr ecx, 0x2                                 # 004164a9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004164ac
    {load} mov ecx, eax                          # 004164ae
    and ecx, 0x3                                 # 004164b0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004164b3
    mov ecx, dword ptr [ebp + arg_8]             # 004164b5
    mov dword ptr [ecx + field_20c], 0x1         # 004164b8
L_004164c2:
    # block 0x004164c2: entered by jmp at 0x0041644f; je at 0x0041648a, 3 instruction(s), ends with jne to 0x004165b7 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004164c2
    cmp dword ptr [edx + field_20c], -0x1        # 004164c5
    jne.d32 L_004165b7                           # 004164cc
    # block 0x004164d2: entered by fall-through of jne at 0x004164cc, 16 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x00416546 (forward)
    push 0x541f94                                # 004164d2
    mov eax, dword ptr [ebp + arg_8]             # 004164d7
    add eax, 0x151                               # 004164da
    push eax                                     # 004164df
    push 0x639eb5                                # 004164e0
    push 0x639dae                                # 004164e5
    lea ecx, [ebp - local_104]                   # 004164ea
    push ecx                                     # 004164f0
    call FUN_0050cd72                            # 004164f1
    add esp, 0x14                                # 004164f6
    lea edx, [ebp - local_104]                   # 004164f9
    push edx                                     # 004164ff
    call FUN_00449d90                            # 00416500
    add esp, 0x4                                 # 00416505
    test eax, eax                                # 00416508
    je.d8 L_00416546                             # 0041650a
    # block 0x0041650c: entered by fall-through of je at 0x0041650a, 20 instruction(s), ends with forward jump to 0x004165b7
    lea edi, [ebp - local_104]                   # 0041650c
    mov eax, dword ptr [ebp + arg_8]             # 00416512
    add eax, 0x4d                                # 00416515
    {load} mov edx, eax                          # 00416518
    or ecx, -0x1                                 # 0041651a
    {load} xor eax, eax                          # 0041651d
    repne scasb al, byte ptr es:[edi]            # 0041651f
    not ecx                                      # 00416521
    {load} sub edi, ecx                          # 00416523
    {load} mov esi, edi                          # 00416525
    {load} mov eax, ecx                          # 00416527
    {load} mov edi, edx                          # 00416529
    shr ecx, 0x2                                 # 0041652b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041652e
    {load} mov ecx, eax                          # 00416530
    and ecx, 0x3                                 # 00416532
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00416535
    mov ecx, dword ptr [ebp + arg_8]             # 00416537
    mov dword ptr [ecx + field_20c], 0x0         # 0041653a
    jmp.d8 L_004165b7                            # 00416544
L_00416546:
    # block 0x00416546: entered by je at 0x0041650a, 16 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x004165b7 (forward)
    push 0x541f9c                                # 00416546
    mov edx, dword ptr [ebp + arg_8]             # 0041654b
    add edx, 0x151                               # 0041654e
    push edx                                     # 00416554
    push 0x639fb9                                # 00416555
    push 0x639dab                                # 0041655a
    lea eax, [ebp - local_104]                   # 0041655f
    push eax                                     # 00416565
    call FUN_0050cd72                            # 00416566
    add esp, 0x14                                # 0041656b
    lea ecx, [ebp - local_104]                   # 0041656e
    push ecx                                     # 00416574
    call FUN_00449d90                            # 00416575
    add esp, 0x4                                 # 0041657a
    test eax, eax                                # 0041657d
    je.d8 L_004165b7                             # 0041657f
    # block 0x00416581: entered by fall-through of je at 0x0041657f, 18 instruction(s), falls into the block at 0x004165b7
    lea edi, [ebp - local_104]                   # 00416581
    mov edx, dword ptr [ebp + arg_8]             # 00416587
    add edx, 0x4d                                # 0041658a
    or ecx, -0x1                                 # 0041658d
    {load} xor eax, eax                          # 00416590
    repne scasb al, byte ptr es:[edi]            # 00416592
    not ecx                                      # 00416594
    {load} sub edi, ecx                          # 00416596
    {load} mov esi, edi                          # 00416598
    {load} mov eax, ecx                          # 0041659a
    {load} mov edi, edx                          # 0041659c
    shr ecx, 0x2                                 # 0041659e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004165a1
    {load} mov ecx, eax                          # 004165a3
    and ecx, 0x3                                 # 004165a5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004165a8
    mov ecx, dword ptr [ebp + arg_8]             # 004165aa
    mov dword ptr [ecx + field_20c], 0x0         # 004165ad
L_004165b7:
    # block 0x004165b7: entered by jne at 0x004164cc; jmp at 0x00416544; je at 0x0041657f, 3 instruction(s), ends with jne to 0x0041661f (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004165b7
    cmp dword ptr [edx + field_20c], -0x1        # 004165ba
    jne.d8 L_0041661f                            # 004165c1
    # block 0x004165c3: entered by fall-through of jne at 0x004165c1, 14 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x00416604 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 004165c3
    add eax, 0x151                               # 004165c6
    push eax                                     # 004165cb
    push 0x541fa4                                # 004165cc
    push 0x63888b                                # 004165d1
    call FUN_0050ca3e                            # 004165d6
    add esp, 0xc                                 # 004165db
    push 0x0                                     # 004165de
    push 0x0                                     # 004165e0
    push 0x63888b                                # 004165e2
    call FUN_0052139c                            # 004165e7
    movsx ecx, word ptr [0x63a4cd]               # 004165ec
    test ecx, ecx                                # 004165f3
    je.d8 L_00416604                             # 004165f5
    # block 0x004165f7: entered by fall-through of je at 0x004165f5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00416604
    push 0x63888b                                # 004165f7
    call FUN_0044a2b7                            # 004165fc
    add esp, 0x4                                 # 00416601
L_00416604:
    # block 0x00416604: entered by je at 0x004165f5, 5 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x00416aeb
    mov dword ptr [0x63a58a], 0x4                # 00416604
    mov ecx, 0x5cf659                            # 0041660e
    call FUN_004c97b4                            # 00416613
    {load} xor eax, eax                          # 00416618
    jmp.d32 L_00416aeb                           # 0041661a
L_0041661f:
    # block 0x0041661f: entered by jne at 0x004165c1, 5 instruction(s), ends with je to 0x0041674e (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0041661f
    mov eax, dword ptr [edx + field_20c]         # 00416622
    mov dword ptr [ebp - local_110], eax         # 00416628
    cmp dword ptr [ebp - local_110], 0x1         # 0041662e
    je.d32 L_0041674e                            # 00416635
    # block 0x0041663b: entered by fall-through of je at 0x00416635, 65 instruction(s), calls FUN_00414ceb, ends with forward jump to 0x00416a3f
    mov ecx, dword ptr [ebp + arg_8]             # 0041663b
    push ecx                                     # 0041663e
    mov ecx, dword ptr [ebp - local_10c]         # 0041663f
    call FUN_00414ceb                            # 00416645
    mov edx, dword ptr [ebp + arg_8]             # 0041664a
    mov word ptr [edx + field_210], 0x0          # 0041664d
    mov eax, dword ptr [ebp + arg_8]             # 00416656
    movsx ecx, word ptr [eax + field_15]         # 00416659
    mov edx, dword ptr [ebp + arg_8]             # 0041665d
    mov dword ptr [edx + field_214], ecx         # 00416660
    mov eax, dword ptr [ebp + arg_8]             # 00416666
    mov ecx, dword ptr [eax + field_214]         # 00416669
    sub ecx, 0x1                                 # 0041666f
    mov edx, dword ptr [ebp + arg_8]             # 00416672
    mov word ptr [edx + field_212], cx           # 00416675
    mov eax, dword ptr [ebp + arg_8]             # 0041667c
    mov dword ptr [eax + field_222], 0x0         # 0041667f
    mov ecx, dword ptr [ebp + arg_8]             # 00416689
    mov dword ptr [ecx + field_21e], 0x0         # 0041668c
    mov edx, dword ptr [ebp + arg_8]             # 00416696
    movsx eax, word ptr [edx + field_19]         # 00416699
    mov ecx, dword ptr [ebp + arg_8]             # 0041669d
    mov edx, dword ptr [ecx + field_222]         # 004166a0
    lea eax, [edx + eax - field_minus_1]         # 004166a6
    mov ecx, dword ptr [ebp + arg_8]             # 004166aa
    mov dword ptr [ecx + field_22a], eax         # 004166ad
    mov edx, dword ptr [ebp + arg_8]             # 004166b3
    movsx eax, word ptr [edx + field_17]         # 004166b6
    mov ecx, dword ptr [ebp + arg_8]             # 004166ba
    mov edx, dword ptr [ecx + field_21e]         # 004166bd
    lea eax, [edx + eax - field_minus_1]         # 004166c3
    mov ecx, dword ptr [ebp + arg_8]             # 004166c7
    mov dword ptr [ecx + field_226], eax         # 004166ca
    mov edx, dword ptr [ebp + arg_8]             # 004166d0
    mov eax, dword ptr [ebp + arg_8]             # 004166d3
    mov cx, word ptr [eax + field_17]            # 004166d6
    mov word ptr [edx + field_218], cx           # 004166da
    mov edx, dword ptr [ebp + arg_8]             # 004166e1
    movsx ecx, word ptr [edx + field_218]        # 004166e4
    mov edx, dword ptr [ebp + arg_8]             # 004166eb
    {load} xor eax, eax                          # 004166ee
    mov al, byte ptr [edx + field_1b]            # 004166f0
    cdq                                          # 004166f3
    and edx, 0x7                                 # 004166f4
    {load} add eax, edx                          # 004166f7
    sar eax, 0x3                                 # 004166f9
    imul ecx, eax                                # 004166fc
    mov eax, dword ptr [ebp + arg_8]             # 004166ff
    mov word ptr [eax + field_21a], cx           # 00416702
    mov ecx, dword ptr [ebp + arg_8]             # 00416709
    mov edx, dword ptr [ebp + arg_8]             # 0041670c
    mov ax, word ptr [edx + field_19]            # 0041670f
    mov word ptr [ecx + field_21c], ax           # 00416713
    mov ecx, dword ptr [ebp + arg_8]             # 0041671a
    mov edx, dword ptr [ebp + arg_8]             # 0041671d
    mov eax, dword ptr [edx + field_1c]          # 00416720
    mov dword ptr [ecx + field_22e], eax         # 00416723
    mov ecx, dword ptr [ebp + arg_8]             # 00416729
    movsx edx, word ptr [ecx + field_21a]        # 0041672c
    mov eax, dword ptr [ebp + arg_8]             # 00416733
    movsx ecx, word ptr [eax + field_21c]        # 00416736
    imul edx, ecx                                # 0041673d
    mov eax, dword ptr [ebp + arg_8]             # 00416740
    mov dword ptr [eax + field_2a4], edx         # 00416743
    jmp.d32 L_00416a3f                           # 00416749
L_0041674e:
    # block 0x0041674e: entered by je at 0x00416635, 11 instruction(s), calls FUN_004bf315, ends with jne to 0x004167dc (forward)
    push 0x0                                     # 0041674e
    mov ecx, dword ptr [ebp + arg_8]             # 00416750
    add ecx, 0x4d                                # 00416753
    push ecx                                     # 00416756
    mov ecx, 0x6201f9                            # 00416757
    call FUN_004bf315                            # 0041675c
    mov edx, dword ptr [ebp + arg_8]             # 00416761
    mov dword ptr [edx + field_208], eax         # 00416764
    mov eax, dword ptr [ebp + arg_8]             # 0041676a
    cmp dword ptr [eax + field_208], 0x0         # 0041676d
    jne.d8 L_004167dc                            # 00416774
    # block 0x00416776: entered by fall-through of jne at 0x00416774, 3 instruction(s), ends with je to 0x0041679b (forward)
    movsx ecx, word ptr [0x63a4cd]               # 00416776
    test ecx, ecx                                # 0041677d
    je.d8 L_0041679b                             # 0041677f
    # block 0x00416781: entered by fall-through of je at 0x0041677f, 8 instruction(s), calls FUN_004bf3b8, FUN_0044a2b7, falls into the block at 0x0041679b
    mov edx, dword ptr [ebp + arg_8]             # 00416781
    add edx, 0x4d                                # 00416784
    push edx                                     # 00416787
    mov ecx, 0x6201f9                            # 00416788
    call FUN_004bf3b8                            # 0041678d
    push eax                                     # 00416792
    call FUN_0044a2b7                            # 00416793
    add esp, 0x4                                 # 00416798
L_0041679b:
    # block 0x0041679b: entered by je at 0x0041677f, 14 instruction(s), calls FUN_004bf3b8, FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00416aeb
    mov eax, dword ptr [ebp + arg_8]             # 0041679b
    add eax, 0x4d                                # 0041679e
    push eax                                     # 004167a1
    mov ecx, 0x6201f9                            # 004167a2
    call FUN_004bf3b8                            # 004167a7
    push eax                                     # 004167ac
    mov ecx, 0x583979                            # 004167ad
    call FUN_004264e8                            # 004167b2
    mov dword ptr [0x5bb20c], 0x1                # 004167b7
    mov dword ptr [0x63a58a], 0x4                # 004167c1
    mov ecx, 0x5cf659                            # 004167cb
    call FUN_004c97b4                            # 004167d0
    {load} xor eax, eax                          # 004167d5
    jmp.d32 L_00416aeb                           # 004167d7
L_004167dc:
    # block 0x004167dc: entered by jne at 0x00416774, 9 instruction(s), calls FUN_004bee5f, ends with je to 0x0041680b (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004167dc
    mov edx, dword ptr [ecx + field_208]         # 004167df
    push edx                                     # 004167e5
    mov ecx, 0x6201f9                            # 004167e6
    call FUN_004bee5f                            # 004167eb
    mov dword ptr [ebp - local_108], eax         # 004167f0
    mov eax, dword ptr [ebp + arg_8]             # 004167f6
    cmp dword ptr [eax + field_208], 0x0         # 004167f9
    je.d8 L_0041680b                             # 00416800
    # block 0x00416802: entered by fall-through of je at 0x00416800, 2 instruction(s), ends with jne to 0x00416870 (forward)
    cmp dword ptr [ebp - local_108], 0x0         # 00416802
    jne.d8 L_00416870                            # 00416809
L_0041680b:
    # block 0x0041680b: entered by je at 0x00416800; fall-through of jne at 0x00416809, 10 instruction(s), calls FUN_0050ca3e, ends with je to 0x0041683c (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 0041680b
    add ecx, 0x4d                                # 0041680e
    push ecx                                     # 00416811
    push 0x541ff8                                # 00416812
    push 0x63888b                                # 00416817
    call FUN_0050ca3e                            # 0041681c
    add esp, 0xc                                 # 00416821
    movsx edx, word ptr [0x63a4cd]               # 00416824
    test edx, edx                                # 0041682b
    je.d8 L_0041683c                             # 0041682d
    # block 0x0041682f: entered by fall-through of je at 0x0041682d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0041683c
    push 0x63888b                                # 0041682f
    call FUN_0044a2b7                            # 00416834
    add esp, 0x4                                 # 00416839
L_0041683c:
    # block 0x0041683c: entered by je at 0x0041682d, 9 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00416aeb
    push 0x63888b                                # 0041683c
    mov ecx, 0x583979                            # 00416841
    call FUN_004264e8                            # 00416846
    mov dword ptr [0x5bb20c], 0x1                # 0041684b
    mov dword ptr [0x63a58a], 0x4                # 00416855
    mov ecx, 0x5cf659                            # 0041685f
    call FUN_004c97b4                            # 00416864
    {load} xor eax, eax                          # 00416869
    jmp.d32 L_00416aeb                           # 0041686b
L_00416870:
    # block 0x00416870: entered by jne at 0x00416809, 73 instruction(s), calls FUN_0050ce04, FUN_004bef11, ends with je to 0x00416a3f (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00416870
    mov word ptr [eax + field_210], 0x0          # 00416873
    mov ecx, dword ptr [ebp + arg_8]             # 0041687c
    mov edx, dword ptr [ebp - local_108]         # 0041687f
    mov eax, dword ptr [edx + field_20]          # 00416885
    mov dword ptr [ecx + field_214], eax         # 00416888
    mov ecx, dword ptr [ebp + arg_8]             # 0041688e
    mov edx, dword ptr [ecx + field_214]         # 00416891
    sub edx, 0x1                                 # 00416897
    mov eax, dword ptr [ebp + arg_8]             # 0041689a
    mov word ptr [eax + field_212], dx           # 0041689d
    mov ecx, dword ptr [ebp + arg_8]             # 004168a4
    mov dword ptr [ecx + field_222], 0x0         # 004168a7
    mov edx, dword ptr [ebp + arg_8]             # 004168b1
    mov dword ptr [edx + field_21e], 0x0         # 004168b4
    mov eax, dword ptr [ebp - local_108]         # 004168be
    mov ecx, dword ptr [eax + field_4]           # 004168c4
    sub ecx, 0x1                                 # 004168c7
    mov edx, dword ptr [ebp + arg_8]             # 004168ca
    mov dword ptr [edx + field_22a], ecx         # 004168cd
    mov eax, dword ptr [ebp - local_108]         # 004168d3
    mov ecx, dword ptr [eax]                     # 004168d9
    sub ecx, 0x1                                 # 004168db
    mov edx, dword ptr [ebp + arg_8]             # 004168de
    mov dword ptr [edx + field_226], ecx         # 004168e1
    mov eax, dword ptr [ebp + arg_8]             # 004168e7
    mov ecx, dword ptr [ebp - local_108]         # 004168ea
    mov dx, word ptr [ecx]                       # 004168f0
    mov word ptr [eax + field_218], dx           # 004168f3
    mov eax, dword ptr [ebp + arg_8]             # 004168fa
    mov ecx, dword ptr [ebp - local_108]         # 004168fd
    mov dx, word ptr [ecx + field_4]             # 00416903
    mov word ptr [eax + field_21c], dx           # 00416907
    movsx eax, word ptr [0x639895]               # 0041690e
    mov ecx, dword ptr [ebp - local_108]         # 00416915
    mov edx, dword ptr [ecx]                     # 0041691b
    imul edx, eax                                # 0041691d
    mov eax, dword ptr [ebp + arg_8]             # 00416920
    mov word ptr [eax + field_21a], dx           # 00416923
    mov ecx, dword ptr [ebp - local_108]         # 0041692a
    mov edx, dword ptr [ecx + field_c]           # 00416930
    mov dword ptr [ebp - local_118], edx         # 00416933
    mov dword ptr [ebp - local_114], 0x0         # 00416939
    fild qword ptr [ebp - local_118]             # 00416943
    fstp dword ptr [ebp - local_11c]             # 00416949
    mov eax, dword ptr [ebp - local_108]         # 0041694f
    mov ecx, dword ptr [eax + field_10]          # 00416955
    mov dword ptr [ebp - local_124], ecx         # 00416958
    mov dword ptr [ebp - local_120], 0x0         # 0041695e
    fild qword ptr [ebp - local_124]             # 00416968
    fstp dword ptr [ebp - local_128]             # 0041696e
    fld dword ptr [ebp - local_11c]              # 00416974
    fdiv dword ptr [ebp - local_128]             # 0041697a
    fdivr qword ptr [0x52c598]                   # 00416980
    fmul qword ptr [0x52c590]                    # 00416986
    call FUN_0050ce04                            # 0041698c
    mov edx, dword ptr [ebp + arg_8]             # 00416991
    mov dword ptr [edx + field_22e], eax         # 00416994
    mov eax, dword ptr [ebp + arg_8]             # 0041699a
    movsx ecx, word ptr [eax + field_21a]        # 0041699d
    mov edx, dword ptr [ebp + arg_8]             # 004169a4
    movsx eax, word ptr [edx + field_21c]        # 004169a7
    imul ecx, eax                                # 004169ae
    mov edx, dword ptr [ebp + arg_8]             # 004169b1
    mov dword ptr [edx + field_2a4], ecx         # 004169b4
    push 0x0                                     # 004169ba
    mov eax, dword ptr [ebp + arg_8]             # 004169bc
    mov ecx, dword ptr [eax + field_208]         # 004169bf
    push ecx                                     # 004169c5
    mov ecx, 0x6201f9                            # 004169c6
    call FUN_004bef11                            # 004169cb
    test eax, eax                                # 004169d0
    je.d8 L_00416a3f                             # 004169d2
    # block 0x004169d4: entered by fall-through of je at 0x004169d2, 11 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, ends with je to 0x00416a0b (forward)
    push 0x0                                     # 004169d4
    mov ecx, 0x6201f9                            # 004169d6
    call FUN_004bf3b8                            # 004169db
    push eax                                     # 004169e0
    push 0x542048                                # 004169e1
    push 0x63888b                                # 004169e6
    call FUN_0050ca3e                            # 004169eb
    add esp, 0xc                                 # 004169f0
    movsx edx, word ptr [0x63a4cd]               # 004169f3
    test edx, edx                                # 004169fa
    je.d8 L_00416a0b                             # 004169fc
    # block 0x004169fe: entered by fall-through of je at 0x004169fc, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00416a0b
    push 0x63888b                                # 004169fe
    call FUN_0044a2b7                            # 00416a03
    add esp, 0x4                                 # 00416a08
L_00416a0b:
    # block 0x00416a0b: entered by je at 0x004169fc, 9 instruction(s), calls FUN_004264e8, FUN_004c97b4, ends with forward jump to 0x00416aeb
    push 0x63888b                                # 00416a0b
    mov ecx, 0x583979                            # 00416a10
    call FUN_004264e8                            # 00416a15
    mov dword ptr [0x5bb20c], 0x1                # 00416a1a
    mov dword ptr [0x63a58a], 0x4                # 00416a24
    mov ecx, 0x5cf659                            # 00416a2e
    call FUN_004c97b4                            # 00416a33
    {load} xor eax, eax                          # 00416a38
    jmp.d32 L_00416aeb                           # 00416a3a
L_00416a3f:
    # block 0x00416a3f: entered by jmp at 0x00416749; je at 0x004169d2, 3 instruction(s), ends with je to 0x00416ae6 (forward)
    movsx eax, word ptr [0x63a4cd]               # 00416a3f
    test eax, eax                                # 00416a46
    je.d32 L_00416ae6                            # 00416a48
    # block 0x00416a4e: entered by fall-through of je at 0x00416a48, 43 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00416ae6
    mov ecx, dword ptr [ebp + arg_8]             # 00416a4e
    mov edx, dword ptr [ecx + field_2a4]         # 00416a51
    push edx                                     # 00416a57
    mov eax, dword ptr [ebp + arg_8]             # 00416a58
    movsx ecx, word ptr [eax + field_21c]        # 00416a5b
    push ecx                                     # 00416a62
    mov edx, dword ptr [ebp + arg_8]             # 00416a63
    movsx eax, word ptr [edx + field_218]        # 00416a66
    push eax                                     # 00416a6d
    mov ecx, dword ptr [ebp + arg_8]             # 00416a6e
    mov edx, dword ptr [ecx + field_226]         # 00416a71
    push edx                                     # 00416a77
    mov eax, dword ptr [ebp + arg_8]             # 00416a78
    mov ecx, dword ptr [eax + field_22a]         # 00416a7b
    push ecx                                     # 00416a81
    mov edx, dword ptr [ebp + arg_8]             # 00416a82
    mov eax, dword ptr [edx + field_21e]         # 00416a85
    push eax                                     # 00416a8b
    mov ecx, dword ptr [ebp + arg_8]             # 00416a8c
    mov edx, dword ptr [ecx + field_222]         # 00416a8f
    push edx                                     # 00416a95
    mov eax, dword ptr [ebp + arg_8]             # 00416a96
    mov ecx, dword ptr [eax + field_22e]         # 00416a99
    push ecx                                     # 00416a9f
    mov edx, dword ptr [ebp + arg_8]             # 00416aa0
    mov eax, dword ptr [edx + field_214]         # 00416aa3
    push eax                                     # 00416aa9
    mov ecx, dword ptr [ebp + arg_8]             # 00416aaa
    movsx edx, word ptr [ecx + field_212]        # 00416aad
    push edx                                     # 00416ab4
    mov eax, dword ptr [ebp + arg_8]             # 00416ab5
    movsx ecx, word ptr [eax + field_210]        # 00416ab8
    push ecx                                     # 00416abf
    mov edx, dword ptr [ebp + arg_8]             # 00416ac0
    add edx, 0x4d                                # 00416ac3
    push edx                                     # 00416ac6
    push 0x542064                                # 00416ac7
    push 0x63888b                                # 00416acc
    call FUN_0050ca3e                            # 00416ad1
    add esp, 0x38                                # 00416ad6
    push 0x63888b                                # 00416ad9
    call FUN_0044a2b7                            # 00416ade
    add esp, 0x4                                 # 00416ae3
L_00416ae6:
    # block 0x00416ae6: entered by je at 0x00416a48, 1 instruction(s), falls into the block at 0x00416aeb
    mov eax, 0x1                                 # 00416ae6
L_00416aeb:
    # block 0x00416aeb: entered by jmp at 0x0041661a; jmp at 0x004167d7; jmp at 0x0041686b; jmp at 0x00416a3a, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 00416aeb
    pop esi                                      # 00416aec
    {load} mov esp, ebp                          # 00416aed
    pop ebp                                      # 00416aef
    ret 0x4                                      # 00416af0

