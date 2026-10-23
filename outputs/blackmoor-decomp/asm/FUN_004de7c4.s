# FUN_004de7c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de7c4
# extent:       0x004de7c4-0x004deed7 (1811 code bytes)
# span:         0x004de7c4-0x004deed7 (code 1811, tables 0, padding 0)
# sha256:       1cbc7a4573b1dbab91830423d74f7245c685ff5740ca2e725ccb4ea6bd0ec8a9
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de7c4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_399, field_3a3, field_72c, field_738, field_minus_1; [ecx + n] field_391, field_39d, field_3a5, field_3a9, field_72c, field_738, field_73c, field_minus_1; [edx + n] field_11b, field_11d, field_395, field_3a1, field_72c, field_730, field_734, field_738, field_740
# callees:      calls FUN_00425fc0, FUN_004dad60, FUN_0043da93, FUN_004c2790, FUN_004dae88, FUN_004daeb5, FUN_0043dbd5, FUN_004e1db3, FUN_004eeb23, FUN_0050ce04, FUN_004ef4f0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 385 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_4, 0x4  # offset +0x4
.equ field_11b, 0x11b  # offset +0x11b
.equ field_11d, 0x11d  # offset +0x11d
.equ field_391, 0x391  # offset +0x391
.equ field_395, 0x395  # offset +0x395
.equ field_399, 0x399  # offset +0x399
.equ field_39d, 0x39d  # offset +0x39d
.equ field_3a1, 0x3a1  # offset +0x3a1
.equ field_3a3, 0x3a3  # offset +0x3a3
.equ field_3a5, 0x3a5  # offset +0x3a5
.equ field_3a9, 0x3a9  # offset +0x3a9
.equ field_72c, 0x72c  # offset +0x72c
.equ field_730, 0x730  # offset +0x730
.equ field_734, 0x734  # offset +0x734
.equ field_738, 0x738  # offset +0x738
.equ field_73c, 0x73c  # offset +0x73c
.equ field_740, 0x740  # offset +0x740

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_0043da93, .text + (0x0043da93 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)
.set FUN_004e1db3, .text + (0x004e1db3 - 0x401000)
.set FUN_004eeb23, .text + (0x004eeb23 - 0x401000)
.set FUN_004ef4f0, .text + (0x004ef4f0 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004de7c4 - 0x401000
.globl FUN_004de7c4
FUN_004de7c4:
    # block 0x004de7c4: entry, 10 instruction(s), ends with je to 0x004de7e6 (forward)
    push ebp                                     # 004de7c4
    {load} mov ebp, esp                          # 004de7c5
    sub esp, 0x28                                # 004de7c7
    push esi                                     # 004de7ca
    push edi                                     # 004de7cb
    mov dword ptr [ebp - local_10], ecx          # 004de7cc
    {load} xor eax, eax                          # 004de7cf
    mov al, byte ptr [0x58320d]                  # 004de7d1
    test eax, eax                                # 004de7d6
    je.d8 L_004de7e6                             # 004de7d8
    # block 0x004de7da: entered by fall-through of je at 0x004de7d8, 2 instruction(s), calls FUN_00425fc0, falls into the block at 0x004de7e6
    mov byte ptr [0x58320d], 0x0                 # 004de7da
    call FUN_00425fc0                            # 004de7e1
L_004de7e6:
    # block 0x004de7e6: entered by je at 0x004de7d8, 19 instruction(s), calls FUN_004dad60, ends with forward jump to 0x004de867
    mov ecx, 0x5830a6                            # 004de7e6
    call FUN_004dad60                            # 004de7eb
    mov ecx, dword ptr [ebp - local_10]          # 004de7f0
    mov dword ptr [ecx + field_391], 0x0         # 004de7f3
    mov edx, dword ptr [ebp - local_10]          # 004de7fd
    mov dword ptr [edx + field_395], 0x0         # 004de800
    mov eax, dword ptr [ebp - local_10]          # 004de80a
    mov dword ptr [eax + field_399], 0x0         # 004de80d
    mov ecx, dword ptr [ebp - local_10]          # 004de817
    mov dword ptr [ecx + field_39d], 0x0         # 004de81a
    mov edx, dword ptr [ebp - local_10]          # 004de824
    mov word ptr [edx + field_3a1], 0xffff       # 004de827
    mov eax, dword ptr [ebp - local_10]          # 004de830
    mov word ptr [eax + field_3a3], 0xffff       # 004de833
    mov ecx, dword ptr [ebp - local_10]          # 004de83c
    mov dword ptr [ecx + field_3a5], 0x0         # 004de83f
    mov dword ptr [0x5830de], 0x0                # 004de849
    mov word ptr [ebp - local_4], 0x0            # 004de853
    jmp.d8 L_004de867                            # 004de859
L_004de85b:
    # block 0x004de85b: entered by jmp at 0x004de8a5, 3 instruction(s), falls into the block at 0x004de867
    mov dx, word ptr [ebp - local_4]             # 004de85b
    add dx, 0x1                                  # 004de85f
    mov word ptr [ebp - local_4], dx             # 004de863
L_004de867:
    # block 0x004de867: entered by jmp at 0x004de859, 3 instruction(s), ends with jge to 0x004de8a7 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004de867
    cmp eax, 0x3                                 # 004de86b
    jge.d8 L_004de8a7                            # 004de86e
    # block 0x004de870: entered by fall-through of jge at 0x004de86e, 13 instruction(s), ends with backward jump to 0x004de85b
    movsx ecx, word ptr [ebp - local_4]          # 004de870
    imul ecx, ecx, 0x6                           # 004de874
    mov edx, dword ptr [ebp - local_10]          # 004de877
    movsx eax, word ptr [edx + ecx + field_11d]  # 004de87a
    movsx ecx, word ptr [ebp - local_4]          # 004de882
    imul ecx, ecx, 0x6                           # 004de886
    mov edx, dword ptr [ebp - local_10]          # 004de889
    movsx ecx, word ptr [edx + ecx + field_11b]  # 004de88c
    {load} sub eax, ecx                          # 004de894
    movsx edx, word ptr [ebp - local_4]          # 004de896
    mov ecx, dword ptr [ebp - local_10]          # 004de89a
    mov word ptr [ecx + 2*edx + field_3a9], ax   # 004de89d
    jmp.d8 L_004de85b                            # 004de8a5
L_004de8a7:
    # block 0x004de8a7: entered by jge at 0x004de86e, 4 instruction(s), calls FUN_0043da93, ends with jne to 0x004de8e1 (forward)
    call FUN_0043da93                            # 004de8a7
    mov dword ptr [0x5d17f5], 0x0                # 004de8ac
    cmp dword ptr [0x5d03b7], 0x0                # 004de8b6
    jne.d8 L_004de8e1                            # 004de8bd
    # block 0x004de8bf: entered by fall-through of jne at 0x004de8bd, 9 instruction(s), calls FUN_004c2790, falls into the block at 0x004de8e1
    push 0x55b900                                # 004de8bf
    push 0x6                                     # 004de8c4
    mov edx, dword ptr [ebp - local_10]          # 004de8c6
    add edx, 0x4                                 # 004de8c9
    push edx                                     # 004de8cc
    push 0x55b918                                # 004de8cd
    mov ecx, 0x5cf659                            # 004de8d2
    call FUN_004c2790                            # 004de8d7
    mov dword ptr [0x5d03b7], eax                # 004de8dc
L_004de8e1:
    # block 0x004de8e1: entered by jne at 0x004de8bd, 2 instruction(s), ends with jne to 0x004de90a (forward)
    cmp dword ptr [0x5d0377], 0x0                # 004de8e1
    jne.d8 L_004de90a                            # 004de8e8
    # block 0x004de8ea: entered by fall-through of jne at 0x004de8e8, 7 instruction(s), calls FUN_004c2790, falls into the block at 0x004de90a
    push 0x55b920                                # 004de8ea
    push 0x6                                     # 004de8ef
    push 0x5b06aa                                # 004de8f1
    push 0x55b934                                # 004de8f6
    mov ecx, 0x5cf659                            # 004de8fb
    call FUN_004c2790                            # 004de900
    mov dword ptr [0x5d0377], eax                # 004de905
L_004de90a:
    # block 0x004de90a: entered by jne at 0x004de8e8, 232 instruction(s), calls FUN_004dae88, FUN_004daeb5, FUN_0043dbd5, ends with je to 0x004deec7 (forward)
    mov dword ptr [0x5b44f0], 0x4                # 004de90a
    mov dword ptr [0x5b44f4], 0x1                # 004de914
    push 0x0                                     # 004de91e
    push 0x0                                     # 004de920
    mov ecx, 0x5830a6                            # 004de922
    call FUN_004dae88                            # 004de927
    lea eax, [ebp - local_c]                     # 004de92c
    push eax                                     # 004de92f
    mov ecx, 0x5830a6                            # 004de930
    call FUN_004daeb5                            # 004de935
    mov ecx, dword ptr [eax]                     # 004de93a
    mov edx, dword ptr [eax + field_4]           # 004de93c
    mov dword ptr [0x5830e2], ecx                # 004de93f
    mov dword ptr [0x5830e6], edx                # 004de945
    mov eax, dword ptr [0x5830e2]                # 004de94b
    mov dword ptr [0x5830ea], eax                # 004de950
    mov ecx, dword ptr [0x5830e6]                # 004de955
    mov dword ptr [0x5830ee], ecx                # 004de95b
    mov edx, dword ptr [0x5830e6]                # 004de961
    mov dword ptr [0x583106], edx                # 004de967
    mov eax, dword ptr [0x583106]                # 004de96d
    mov dword ptr [0x5830f6], eax                # 004de972
    mov ecx, dword ptr [0x5b44f4]                # 004de977
    shl ecx, 0x2                                 # 004de97d
    mov edx, dword ptr [0x5b44f0]                # 004de980
    movsx eax, word ptr [ecx + 8*edx + 0x5b3792] # 004de986
    mov ecx, dword ptr [0x5830e6]                # 004de98e
    lea edx, [ecx + eax - field_minus_1]         # 004de994
    mov dword ptr [0x58310e], edx                # 004de998
    mov eax, dword ptr [0x58310e]                # 004de99e
    mov dword ptr [0x5830fe], eax                # 004de9a3
    mov ecx, dword ptr [0x5830e2]                # 004de9a8
    mov dword ptr [0x583102], ecx                # 004de9ae
    mov edx, dword ptr [0x583102]                # 004de9b4
    mov dword ptr [0x5830f2], edx                # 004de9ba
    mov eax, dword ptr [0x5b44f4]                # 004de9c0
    shl eax, 0x2                                 # 004de9c5
    mov ecx, dword ptr [0x5b44f0]                # 004de9c8
    movsx edx, word ptr [eax + 8*ecx + 0x5b3790] # 004de9ce
    mov eax, dword ptr [0x5830e2]                # 004de9d6
    lea ecx, [eax + edx - field_minus_1]         # 004de9db
    mov dword ptr [0x58310a], ecx                # 004de9df
    mov edx, dword ptr [0x58310a]                # 004de9e5
    mov dword ptr [0x5830fa], edx                # 004de9eb
    mov dword ptr [0x5d2811], 0x1                # 004de9f1
    mov dword ptr [0x5d2815], 0x4e01fb           # 004de9fb
    mov eax, dword ptr [0x5d03b7]                # 004dea05
    mov dword ptr [0x5d2819], eax                # 004dea0a
    mov ecx, dword ptr [ebp - local_10]          # 004dea0f
    add ecx, 0x29                                # 004dea12
    mov dword ptr [0x5d281d], ecx                # 004dea15
    mov edx, dword ptr [ebp - local_10]          # 004dea1b
    add edx, 0x29                                # 004dea1e
    mov dword ptr [0x5d2821], edx                # 004dea21
    mov dword ptr [0x5d2825], 0x1                # 004dea27
    mov dword ptr [0x5d2829], 0x1                # 004dea31
    mov word ptr [0x5d282d], 0x0                 # 004dea3b
    mov edi, 0x55b93c                            # 004dea44
    mov edx, 0x5d2833                            # 004dea49
    or ecx, -0x1                                 # 004dea4e
    {load} xor eax, eax                          # 004dea51
    repne scasb al, byte ptr es:[edi]            # 004dea53
    not ecx                                      # 004dea55
    {load} sub edi, ecx                          # 004dea57
    {load} mov esi, edi                          # 004dea59
    {load} mov eax, ecx                          # 004dea5b
    {load} mov edi, edx                          # 004dea5d
    shr ecx, 0x2                                 # 004dea5f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dea62
    {load} mov ecx, eax                          # 004dea64
    and ecx, 0x3                                 # 004dea66
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dea69
    mov dword ptr [0x5d285b], 0x14               # 004dea6b
    mov dword ptr [0x5d285f], 0x0                # 004dea75
    mov ecx, dword ptr [0x5d0377]                # 004dea7f
    mov dword ptr [0x5d2863], ecx                # 004dea85
    mov edx, dword ptr [0x5b44f0]                # 004dea8b
    shl edx, 0x5                                 # 004dea91
    mov eax, dword ptr [0x5b44f4]                # 004dea94
    shl eax, 0x4                                 # 004dea99
    lea ecx, [edx + eax + 0x5b160c]              # 004dea9c
    mov dword ptr [0x5d2867], ecx                # 004deaa3
    mov dword ptr [0x5d286b], 0x583102           # 004deaa9
    mov dword ptr [0x5d286f], 0x1                # 004deab3
    mov dword ptr [0x5d2873], 0x1                # 004deabd
    mov word ptr [0x5d2877], 0x2                 # 004deac7
    mov edi, 0x55b948                            # 004dead0
    mov edx, 0x5d287d                            # 004dead5
    or ecx, -0x1                                 # 004deada
    {load} xor eax, eax                          # 004deadd
    repne scasb al, byte ptr es:[edi]            # 004deadf
    not ecx                                      # 004deae1
    {load} sub edi, ecx                          # 004deae3
    {load} mov esi, edi                          # 004deae5
    {load} mov eax, ecx                          # 004deae7
    {load} mov edi, edx                          # 004deae9
    shr ecx, 0x2                                 # 004deaeb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004deaee
    {load} mov ecx, eax                          # 004deaf0
    and ecx, 0x3                                 # 004deaf2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004deaf5
    mov dword ptr [0x5d28a5], 0x2                # 004deaf7
    mov dword ptr [0x5d28a9], 0x0                # 004deb01
    mov ecx, dword ptr [0x5d03b7]                # 004deb0b
    mov dword ptr [0x5d28ad], ecx                # 004deb11
    mov dword ptr [0x5d28b1], 0x5830f2           # 004deb17
    mov dword ptr [0x5d28b5], 0x5830f2           # 004deb21
    mov dword ptr [0x5d28b9], 0x0                # 004deb2b
    mov dword ptr [0x5d28bd], 0x1                # 004deb35
    mov word ptr [0x5d28c1], 0x1                 # 004deb3f
    mov edi, 0x55b958                            # 004deb48
    mov edx, 0x5d28c7                            # 004deb4d
    or ecx, -0x1                                 # 004deb52
    {load} xor eax, eax                          # 004deb55
    repne scasb al, byte ptr es:[edi]            # 004deb57
    not ecx                                      # 004deb59
    {load} sub edi, ecx                          # 004deb5b
    {load} mov esi, edi                          # 004deb5d
    {load} mov eax, ecx                          # 004deb5f
    {load} mov edi, edx                          # 004deb61
    shr ecx, 0x2                                 # 004deb63
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004deb66
    {load} mov ecx, eax                          # 004deb68
    and ecx, 0x3                                 # 004deb6a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004deb6d
    mov dword ptr [0x5d28ef], 0x8                # 004deb6f
    mov dword ptr [0x5d28f3], 0x4e023b           # 004deb79
    mov ecx, dword ptr [0x5d03b7]                # 004deb83
    mov dword ptr [0x5d28f7], ecx                # 004deb89
    mov dword ptr [0x5d28fb], 0x0                # 004deb8f
    mov dword ptr [0x5d28ff], 0x0                # 004deb99
    mov dword ptr [0x5d2903], 0x1                # 004deba3
    mov dword ptr [0x5d2907], 0x1                # 004debad
    mov word ptr [0x5d290b], 0x0                 # 004debb7
    mov edi, 0x55b968                            # 004debc0
    mov edx, 0x5d2911                            # 004debc5
    or ecx, -0x1                                 # 004debca
    {load} xor eax, eax                          # 004debcd
    repne scasb al, byte ptr es:[edi]            # 004debcf
    not ecx                                      # 004debd1
    {load} sub edi, ecx                          # 004debd3
    {load} mov esi, edi                          # 004debd5
    {load} mov eax, ecx                          # 004debd7
    {load} mov edi, edx                          # 004debd9
    shr ecx, 0x2                                 # 004debdb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004debde
    {load} mov ecx, eax                          # 004debe0
    and ecx, 0x3                                 # 004debe2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004debe5
    mov dword ptr [0x5d2983], 0x4                # 004debe7
    mov dword ptr [0x5d2987], 0x4e0377           # 004debf1
    mov ecx, dword ptr [0x5d03b7]                # 004debfb
    mov dword ptr [0x5d298b], ecx                # 004dec01
    mov dword ptr [0x5d298f], 0x0                # 004dec07
    mov dword ptr [0x5d2993], 0x0                # 004dec11
    mov dword ptr [0x5d2997], 0x0                # 004dec1b
    mov dword ptr [0x5d299b], 0x1                # 004dec25
    mov word ptr [0x5d299f], 0x0                 # 004dec2f
    mov edi, 0x55b97c                            # 004dec38
    mov edx, 0x5d29a5                            # 004dec3d
    or ecx, -0x1                                 # 004dec42
    {load} xor eax, eax                          # 004dec45
    repne scasb al, byte ptr es:[edi]            # 004dec47
    not ecx                                      # 004dec49
    {load} sub edi, ecx                          # 004dec4b
    {load} mov esi, edi                          # 004dec4d
    {load} mov eax, ecx                          # 004dec4f
    {load} mov edi, edx                          # 004dec51
    shr ecx, 0x2                                 # 004dec53
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dec56
    {load} mov ecx, eax                          # 004dec58
    and ecx, 0x3                                 # 004dec5a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dec5d
    mov dword ptr [0x5d2939], 0x3                # 004dec5f
    mov dword ptr [0x5d293d], 0x0                # 004dec69
    mov ecx, dword ptr [0x5d03b7]                # 004dec73
    mov dword ptr [0x5d2941], ecx                # 004dec79
    mov edx, dword ptr [ebp - local_10]          # 004dec7f
    add edx, 0x39                                # 004dec82
    mov dword ptr [0x5d2945], edx                # 004dec85
    mov eax, dword ptr [ebp - local_10]          # 004dec8b
    add eax, 0x39                                # 004dec8e
    mov dword ptr [0x5d2949], eax                # 004dec91
    mov dword ptr [0x5d294d], 0x1                # 004dec96
    mov dword ptr [0x5d2951], 0x1                # 004deca0
    mov word ptr [0x5d2955], 0x1                 # 004decaa
    mov edi, 0x55b990                            # 004decb3
    mov edx, 0x5d295b                            # 004decb8
    or ecx, -0x1                                 # 004decbd
    {load} xor eax, eax                          # 004decc0
    repne scasb al, byte ptr es:[edi]            # 004decc2
    not ecx                                      # 004decc4
    {load} sub edi, ecx                          # 004decc6
    {load} mov esi, edi                          # 004decc8
    {load} mov eax, ecx                          # 004decca
    {load} mov edi, edx                          # 004deccc
    shr ecx, 0x2                                 # 004decce
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004decd1
    {load} mov ecx, eax                          # 004decd3
    and ecx, 0x3                                 # 004decd5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004decd8
    mov dword ptr [0x5d29cd], 0x10               # 004decda
    mov dword ptr [0x5d29d1], 0x4e01b3           # 004dece4
    mov ecx, dword ptr [0x5d03b7]                # 004decee
    mov dword ptr [0x5d29d5], ecx                # 004decf4
    mov dword ptr [0x5d29d9], 0x0                # 004decfa
    mov dword ptr [0x5d29dd], 0x0                # 004ded04
    mov dword ptr [0x5d29e1], 0x1                # 004ded0e
    mov dword ptr [0x5d29e5], 0x1                # 004ded18
    mov word ptr [0x5d29e9], 0x1                 # 004ded22
    mov edi, 0x55b9a4                            # 004ded2b
    mov edx, 0x5d29ef                            # 004ded30
    or ecx, -0x1                                 # 004ded35
    {load} xor eax, eax                          # 004ded38
    repne scasb al, byte ptr es:[edi]            # 004ded3a
    not ecx                                      # 004ded3c
    {load} sub edi, ecx                          # 004ded3e
    {load} mov esi, edi                          # 004ded40
    {load} mov eax, ecx                          # 004ded42
    {load} mov edi, edx                          # 004ded44
    shr ecx, 0x2                                 # 004ded46
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ded49
    {load} mov ecx, eax                          # 004ded4b
    and ecx, 0x3                                 # 004ded4d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ded50
    call FUN_0043dbd5                            # 004ded52
    mov ecx, dword ptr [ebp - local_10]          # 004ded57
    mov dword ptr [ecx + field_73c], 0x0         # 004ded5a
    mov edx, dword ptr [ebp - local_10]          # 004ded64
    mov dword ptr [edx + field_740], 0x0         # 004ded67
    cmp dword ptr [0x5d02ab], 0x0                # 004ded71
    je.d32 L_004deec7                            # 004ded78
    # block 0x004ded7e: entered by fall-through of je at 0x004ded78, 15 instruction(s), calls FUN_004e1db3, FUN_004eeb23, ends with jne to 0x004dedcd (forward)
    mov eax, dword ptr [ebp - local_10]          # 004ded7e
    add eax, 0x1d8                               # 004ded81
    push eax                                     # 004ded86
    mov ecx, dword ptr [ebp - local_10]          # 004ded87
    add ecx, 0x3ef                               # 004ded8a
    call FUN_004e1db3                            # 004ded90
    mov ecx, dword ptr [ebp - local_10]          # 004ded95
    add ecx, 0x2c7                               # 004ded98
    push ecx                                     # 004ded9e
    mov ecx, dword ptr [ebp - local_10]          # 004ded9f
    add ecx, 0x57e                               # 004deda2
    call FUN_004eeb23                            # 004deda8
    mov edx, dword ptr [0x5d02bb]                # 004dedad
    cmp edx, dword ptr [0x5d02b7]                # 004dedb3
    jne.d8 L_004dedcd                            # 004dedb9
    # block 0x004dedbb: entered by fall-through of jne at 0x004dedb9, 3 instruction(s), ends with forward jump to 0x004dee8b
    mov eax, dword ptr [ebp - local_10]          # 004dedbb
    mov dword ptr [eax + field_72c], 0x32        # 004dedbe
    jmp.d32 L_004dee8b                           # 004dedc8
L_004dedcd:
    # block 0x004dedcd: entered by jne at 0x004dedb9, 3 instruction(s), ends with jge to 0x004dee2d (forward)
    mov ecx, dword ptr [0x5d02bb]                # 004dedcd
    cmp ecx, dword ptr [0x5d02b7]                # 004dedd3
    jge.d8 L_004dee2d                            # 004dedd9
    # block 0x004deddb: entered by fall-through of jge at 0x004dedd9, 19 instruction(s), calls FUN_0050ce04, ends with forward jump to 0x004dee8b
    fild dword ptr [0x5d02b7]                    # 004deddb
    fstp dword ptr [ebp - local_14]              # 004dede1
    fild dword ptr [0x5d02bb]                    # 004dede4
    fstp dword ptr [ebp - local_18]              # 004dedea
    fld dword ptr [ebp - local_14]               # 004deded
    fsub dword ptr [ebp - local_18]              # 004dedf0
    fild dword ptr [0x5d02c3]                    # 004dedf3
    fstp dword ptr [ebp - local_1c]              # 004dedf9
    fdiv dword ptr [ebp - local_1c]              # 004dedfc
    mov edx, dword ptr [ebp - local_10]          # 004dedff
    fstp dword ptr [edx + field_738]             # 004dee02
    mov eax, dword ptr [ebp - local_10]          # 004dee08
    fld dword ptr [0x52e4d4]                     # 004dee0b
    fmul dword ptr [eax + field_738]             # 004dee11
    fsubr dword ptr [0x52e4d4]                   # 004dee17
    call FUN_0050ce04                            # 004dee1d
    mov ecx, dword ptr [ebp - local_10]          # 004dee22
    mov dword ptr [ecx + field_72c], eax         # 004dee25
    jmp.d8 L_004dee8b                            # 004dee2b
L_004dee2d:
    # block 0x004dee2d: entered by jge at 0x004dedd9, 3 instruction(s), ends with jle to 0x004dee8b (forward)
    mov edx, dword ptr [0x5d02bb]                # 004dee2d
    cmp edx, dword ptr [0x5d02b7]                # 004dee33
    jle.d8 L_004dee8b                            # 004dee39
    # block 0x004dee3b: entered by fall-through of jle at 0x004dee39, 18 instruction(s), calls FUN_0050ce04, falls into the block at 0x004dee8b
    fild dword ptr [0x5d02bb]                    # 004dee3b
    fstp dword ptr [ebp - local_20]              # 004dee41
    fild dword ptr [0x5d02b7]                    # 004dee44
    fstp dword ptr [ebp - local_24]              # 004dee4a
    fld dword ptr [ebp - local_20]               # 004dee4d
    fsub dword ptr [ebp - local_24]              # 004dee50
    fild dword ptr [0x5d02c7]                    # 004dee53
    fstp dword ptr [ebp - local_28]              # 004dee59
    fdiv dword ptr [ebp - local_28]              # 004dee5c
    mov eax, dword ptr [ebp - local_10]          # 004dee5f
    fstp dword ptr [eax + field_738]             # 004dee62
    mov ecx, dword ptr [ebp - local_10]          # 004dee68
    fld dword ptr [0x52e4d4]                     # 004dee6b
    fmul dword ptr [ecx + field_738]             # 004dee71
    fadd dword ptr [0x52e4d4]                    # 004dee77
    call FUN_0050ce04                            # 004dee7d
    mov edx, dword ptr [ebp - local_10]          # 004dee82
    mov dword ptr [edx + field_72c], eax         # 004dee85
L_004dee8b:
    # block 0x004dee8b: entered by jmp at 0x004dedc8; jmp at 0x004dee2b; jle at 0x004dee39, 14 instruction(s), calls FUN_004ef4f0, falls into the block at 0x004deec7
    mov eax, dword ptr [ebp - local_10]          # 004dee8b
    mov ecx, dword ptr [eax + field_72c]         # 004dee8e
    push ecx                                     # 004dee94
    mov ecx, dword ptr [ebp - local_10]          # 004dee95
    add ecx, 0x57e                               # 004dee98
    call FUN_004ef4f0                            # 004dee9e
    mov edx, dword ptr [ebp - local_10]          # 004deea3
    mov eax, dword ptr [ebp - local_10]          # 004deea6
    mov ecx, dword ptr [eax + field_72c]         # 004deea9
    mov dword ptr [edx + field_734], ecx         # 004deeaf
    mov edx, dword ptr [ebp - local_10]          # 004deeb5
    mov eax, dword ptr [ebp - local_10]          # 004deeb8
    mov ecx, dword ptr [eax + field_72c]         # 004deebb
    mov dword ptr [edx + field_730], ecx         # 004deec1
L_004deec7:
    # block 0x004deec7: entered by je at 0x004ded78, 6 instruction(s), ends with ret
    mov dword ptr [0x583995], 0x1                # 004deec7
    pop edi                                      # 004deed1
    pop esi                                      # 004deed2
    {load} mov esp, ebp                          # 004deed3
    pop ebp                                      # 004deed5
    ret                                          # 004deed6

