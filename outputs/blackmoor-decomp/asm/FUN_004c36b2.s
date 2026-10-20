# FUN_004c36b2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c36b2
# extent:       0x004c36b2-0x004c3c5d (1451 code bytes)
# span:         0x004c36b2-0x004c3c5d (code 1451, tables 0, padding 0)
# sha256:       3be3810a997ed70ad255cbc074570cf923de2644215f7569375f44d51619cdf1
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_screen_file_94_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_94_runtime.h:11 says "Handler 0x4c36b2 (thiscall on the"; src/blackmoor_app.mm:11543 says "handler 0x4c36b2: three phases, a screen file"
# name-note:    Handler of raw 0x94 "make a screen file" (AT_MAKE_SCREEN_FILE), three phases.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       32 ebp-relative slot(s): local_4, local_5c, local_70, local_80, local_84, local_88, local_8b, local_8c, local_8e, local_90, local_92, local_94 and 20 more
# fields:       [eax + n] field_21, field_25, field_2d, field_31; [ecx + n] field_8, field_21; [edx + n] field_8, field_21, field_25, field_29, field_2d
# callees:      calls FUN_004d36ed, FUN_0051dc43, FUN_0044a2b7, FUN_004c4067, FUN_0043f04b, FUN_004c4202, FUN_004c334f, FUN_0050cd72, FUN_0050d0a9, FUN_0050e493, FUN_004c7481, FUN_0050cee4, FUN_0051dc6c, FUN_0042ba3a
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 314 instruction(s), 19 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_5c, 0x5c  # offset -0x5c
.equ local_70, 0x70  # offset -0x70
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8b, 0x8b  # offset -0x8b
.equ local_8c, 0x8c  # offset -0x8c
.equ local_8e, 0x8e  # offset -0x8e
.equ local_90, 0x90  # offset -0x90
.equ local_92, 0x92  # offset -0x92
.equ local_94, 0x94  # offset -0x94
.equ local_95, 0x95  # offset -0x95
.equ local_97, 0x97  # offset -0x97
.equ local_99, 0x99  # offset -0x99
.equ local_9a, 0x9a  # offset -0x9a
.equ local_9b, 0x9b  # offset -0x9b
.equ local_9c, 0x9c  # offset -0x9c
.equ local_a0, 0xa0  # offset -0xa0
.equ local_a4, 0xa4  # offset -0xa4
.equ local_a8, 0xa8  # offset -0xa8
.equ local_ac, 0xac  # offset -0xac
.equ local_b0, 0xb0  # offset -0xb0
.equ local_b4, 0xb4  # offset -0xb4
.equ local_b8, 0xb8  # offset -0xb8
.equ local_bc, 0xbc  # offset -0xbc
.equ local_c0, 0xc0  # offset -0xc0
.equ local_c4, 0xc4  # offset -0xc4
.equ local_c8, 0xc8  # offset -0xc8
.equ local_cc, 0xcc  # offset -0xcc
.equ local_d0, 0xd0  # offset -0xd0
.equ local_d4, 0xd4  # offset -0xd4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_2d, 0x2d  # offset +0x2d
.equ field_31, 0x31  # offset +0x31

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0043f04b, .text + (0x0043f04b - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c334f, .text + (0x004c334f - 0x401000)
.set FUN_004c4067, .text + (0x004c4067 - 0x401000)
.set FUN_004c4202, .text + (0x004c4202 - 0x401000)
.set FUN_004c7481, .text + (0x004c7481 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c36b2 - 0x401000
.globl FUN_004c36b2
FUN_004c36b2:
    # block 0x004c36b2: entry, 17 instruction(s), ends with je to 0x004c371d (forward)
    push ebp                                     # 004c36b2
    {load} mov ebp, esp                          # 004c36b3
    sub esp, 0xd4                                # 004c36b5
    push esi                                     # 004c36bb
    push edi                                     # 004c36bc
    mov dword ptr [ebp - local_d0], ecx          # 004c36bd
    movsx eax, word ptr [ebp + arg_8]            # 004c36c3
    imul eax, eax, 0x8d                          # 004c36c7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004c36cd
    mov dword ptr [ebp - local_a0], ecx          # 004c36d3
    mov dword ptr [ebp - local_84], 0x1          # 004c36d9
    movsx edx, word ptr [ebp + arg_8]            # 004c36e3
    imul edx, edx, 0x8d                          # 004c36e7
    mov eax, dword ptr [edx + 0x5bb632]          # 004c36ed
    mov dword ptr [ebp - local_d4], eax          # 004c36f3
    cmp dword ptr [ebp - local_d4], 0x0          # 004c36f9
    je.d8 L_004c371d                             # 004c3700
    # block 0x004c3702: entered by fall-through of je at 0x004c3700, 2 instruction(s), ends with je to 0x004c374f (forward)
    cmp dword ptr [ebp - local_d4], 0x2          # 004c3702
    je.d8 L_004c374f                             # 004c3709
    # block 0x004c370b: entered by fall-through of je at 0x004c3709, 2 instruction(s), ends with je to 0x004c3c37 (forward)
    cmp dword ptr [ebp - local_d4], 0x3          # 004c370b
    je.d32 L_004c3c37                            # 004c3712
    # block 0x004c3718: entered by fall-through of je at 0x004c3712, 1 instruction(s), ends with forward jump to 0x004c3c44
    jmp.d32 L_004c3c44                           # 004c3718
L_004c371d:
    # block 0x004c371d: entered by je at 0x004c3700, 7 instruction(s), calls FUN_004d36ed, ends with forward jump to 0x004c3c44
    mov dword ptr [0x5839a9], 0x1                # 004c371d
    call FUN_004d36ed                            # 004c3727
    movsx ecx, word ptr [ebp + arg_8]            # 004c372c
    imul ecx, ecx, 0x8d                          # 004c3730
    mov dword ptr [ecx + 0x5bb632], 0x2          # 004c3736
    mov dword ptr [ebp - local_a4], 0x0          # 004c3740
    jmp.d32 L_004c3c44                           # 004c374a
L_004c374f:
    # block 0x004c374f: entered by je at 0x004c3709, 4 instruction(s), ends with jg to 0x004c3773 (forward)
    movsx edx, word ptr [0x63988d]               # 004c374f
    mov eax, dword ptr [ebp - local_a0]          # 004c3756
    cmp dword ptr [eax + field_2d], edx          # 004c375c
    jg.d8 L_004c3773                             # 004c375f
    # block 0x004c3761: entered by fall-through of jg at 0x004c375f, 4 instruction(s), ends with jle to 0x004c3778 (forward)
    movsx ecx, word ptr [0x63988b]               # 004c3761
    mov edx, dword ptr [ebp - local_a0]          # 004c3768
    cmp dword ptr [edx + field_29], ecx          # 004c376e
    jle.d8 L_004c3778                            # 004c3771
L_004c3773:
    # block 0x004c3773: entered by jg at 0x004c375f; fall-through of jle at 0x004c3771, 1 instruction(s), ends with forward jump to 0x004c3c55
    jmp.d32 L_004c3c55                           # 004c3773
L_004c3778:
    # block 0x004c3778: entered by jle at 0x004c3771, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c37de (forward)
    mov dword ptr [ebp - local_b0], 0x0          # 004c3778
    movsx eax, word ptr [0x63988b]               # 004c3782
    movsx ecx, word ptr [0x63988d]               # 004c3789
    imul eax, ecx                                # 004c3790
    movsx edx, word ptr [0x639895]               # 004c3793
    imul eax, edx                                # 004c379a
    push eax                                     # 004c379d
    call FUN_0051dc43                            # 004c379e
    add esp, 0x4                                 # 004c37a3
    mov dword ptr [ebp - local_c0], eax          # 004c37a6
    mov eax, dword ptr [ebp - local_c0]          # 004c37ac
    mov dword ptr [ebp - local_b0], eax          # 004c37b2
    cmp dword ptr [ebp - local_b0], 0x0          # 004c37b8
    jne.d8 L_004c37de                            # 004c37bf
    # block 0x004c37c1: entered by fall-through of jne at 0x004c37bf, 3 instruction(s), ends with je to 0x004c37d9 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004c37c1
    test ecx, ecx                                # 004c37c8
    je.d8 L_004c37d9                             # 004c37ca
    # block 0x004c37cc: entered by fall-through of je at 0x004c37ca, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c37d9
    push 0x554120                                # 004c37cc
    call FUN_0044a2b7                            # 004c37d1
    add esp, 0x4                                 # 004c37d6
L_004c37d9:
    # block 0x004c37d9: entered by je at 0x004c37ca, 1 instruction(s), ends with forward jump to 0x004c3c50
    jmp.d32 L_004c3c50                           # 004c37d9
L_004c37de:
    # block 0x004c37de: entered by jne at 0x004c37bf, 23 instruction(s), calls FUN_0051dc43, ends with jne to 0x004c3870 (forward)
    mov dword ptr [ebp - local_b8], 0x0          # 004c37de
    mov edx, dword ptr [ebp - local_a0]          # 004c37e8
    mov eax, dword ptr [ebp - local_a0]          # 004c37ee
    mov ecx, dword ptr [edx + field_29]          # 004c37f4
    sub ecx, dword ptr [eax + field_21]          # 004c37f7
    mov dword ptr [ebp - local_bc], ecx          # 004c37fa
    mov edx, dword ptr [ebp - local_a0]          # 004c3800
    mov eax, dword ptr [ebp - local_a0]          # 004c3806
    mov ecx, dword ptr [edx + field_2d]          # 004c380c
    sub ecx, dword ptr [eax + field_25]          # 004c380f
    mov dword ptr [ebp - local_a8], ecx          # 004c3812
    mov edx, dword ptr [ebp - local_bc]          # 004c3818
    imul edx, dword ptr [ebp - local_a8]         # 004c381e
    movsx eax, word ptr [0x639895]               # 004c3825
    imul edx, eax                                # 004c382c
    push edx                                     # 004c382f
    call FUN_0051dc43                            # 004c3830
    add esp, 0x4                                 # 004c3835
    mov dword ptr [ebp - local_c4], eax          # 004c3838
    mov ecx, dword ptr [ebp - local_c4]          # 004c383e
    mov dword ptr [ebp - local_b8], ecx          # 004c3844
    cmp dword ptr [ebp - local_b8], 0x0          # 004c384a
    jne.d8 L_004c3870                            # 004c3851
    # block 0x004c3853: entered by fall-through of jne at 0x004c3851, 3 instruction(s), ends with je to 0x004c386b (forward)
    movsx edx, word ptr [0x63a4cd]               # 004c3853
    test edx, edx                                # 004c385a
    je.d8 L_004c386b                             # 004c385c
    # block 0x004c385e: entered by fall-through of je at 0x004c385c, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c386b
    push 0x55415c                                # 004c385e
    call FUN_0044a2b7                            # 004c3863
    add esp, 0x4                                 # 004c3868
L_004c386b:
    # block 0x004c386b: entered by je at 0x004c385c, 1 instruction(s), ends with forward jump to 0x004c3c4b
    jmp.d32 L_004c3c4b                           # 004c386b
L_004c3870:
    # block 0x004c3870: entered by jne at 0x004c3851, 38 instruction(s), calls FUN_004c4067, FUN_0043f04b, FUN_004c4202, ends with jl to 0x004c3917 (forward)
    push 0x10                                    # 004c3870
    push 0x55419c                                # 004c3872
    lea eax, [ebp - local_80]                    # 004c3877
    push eax                                     # 004c387a
    push 0x0                                     # 004c387b
    mov ecx, dword ptr [ebp - local_d0]          # 004c387d
    mov edx, dword ptr [ecx + field_8]           # 004c3883
    push edx                                     # 004c3886
    mov ecx, dword ptr [ebp - local_d0]          # 004c3887
    call FUN_004c4067                            # 004c388d
    movsx eax, word ptr [0x639895]               # 004c3892
    mov ecx, dword ptr [ebp - local_a0]          # 004c3899
    imul eax, dword ptr [ecx + field_21]         # 004c389f
    mov dword ptr [ebp - local_4], eax           # 004c38a3
    mov edx, dword ptr [ebp - local_70]          # 004c38a6
    push edx                                     # 004c38a9
    movsx eax, word ptr [0x63988b]               # 004c38aa
    movsx ecx, word ptr [0x639895]               # 004c38b1
    imul eax, ecx                                # 004c38b8
    push eax                                     # 004c38bb
    movsx edx, word ptr [0x63988d]               # 004c38bc
    push edx                                     # 004c38c3
    mov eax, dword ptr [ebp - local_5c]          # 004c38c4
    push eax                                     # 004c38c7
    mov ecx, dword ptr [ebp - local_b0]          # 004c38c8
    push ecx                                     # 004c38ce
    mov ecx, 0x5d2f2d                            # 004c38cf
    call FUN_0043f04b                            # 004c38d4
    push 0x5541d0                                # 004c38d9
    push 0x0                                     # 004c38de
    mov edx, dword ptr [ebp - local_d0]          # 004c38e0
    mov eax, dword ptr [edx + field_8]           # 004c38e6
    push eax                                     # 004c38e9
    mov ecx, dword ptr [ebp - local_d0]          # 004c38ea
    call FUN_004c4202                            # 004c38f0
    movsx ecx, word ptr [0x63988b]               # 004c38f5
    cmp dword ptr [ebp - local_bc], ecx          # 004c38fc
    jl.d8 L_004c3917                             # 004c3902
    # block 0x004c3904: entered by fall-through of jl at 0x004c3902, 3 instruction(s), ends with jge to 0x004c39ec (forward)
    movsx edx, word ptr [0x63988d]               # 004c3904
    cmp dword ptr [ebp - local_a8], edx          # 004c390b
    jge.d32 L_004c39ec                           # 004c3911
L_004c3917:
    # block 0x004c3917: entered by jl at 0x004c3902; fall-through of jge at 0x004c3911, 14 instruction(s), ends with forward jump to 0x004c3970
    movsx eax, word ptr [0x639895]               # 004c3917
    movsx ecx, word ptr [0x63988b]               # 004c391e
    mov edx, dword ptr [ebp - local_a0]          # 004c3925
    imul ecx, dword ptr [edx + field_25]         # 004c392b
    mov edx, dword ptr [ebp - local_a0]          # 004c392f
    add ecx, dword ptr [edx + field_21]          # 004c3935
    imul eax, ecx                                # 004c3938
    mov ecx, dword ptr [ebp - local_b0]          # 004c393b
    {load} add ecx, eax                          # 004c3941
    mov dword ptr [ebp - local_ac], ecx          # 004c3943
    mov edx, dword ptr [ebp - local_b8]          # 004c3949
    mov dword ptr [ebp - local_88], edx          # 004c394f
    mov dword ptr [ebp - local_b4], 0x0          # 004c3955
    jmp.d8 L_004c3970                            # 004c395f
L_004c3961:
    # block 0x004c3961: entered by jmp at 0x004c39e5, 3 instruction(s), falls into the block at 0x004c3970
    mov eax, dword ptr [ebp - local_b4]          # 004c3961
    add eax, 0x1                                 # 004c3967
    mov dword ptr [ebp - local_b4], eax          # 004c396a
L_004c3970:
    # block 0x004c3970: entered by jmp at 0x004c395f, 3 instruction(s), ends with jge to 0x004c39ea (forward)
    mov ecx, dword ptr [ebp - local_b4]          # 004c3970
    cmp ecx, dword ptr [ebp - local_a8]          # 004c3976
    jge.d8 L_004c39ea                            # 004c397c
    # block 0x004c397e: entered by fall-through of jge at 0x004c397c, 24 instruction(s), ends with backward jump to 0x004c3961
    movsx edx, word ptr [0x639895]               # 004c397e
    mov ecx, dword ptr [ebp - local_bc]          # 004c3985
    imul ecx, edx                                # 004c398b
    mov esi, dword ptr [ebp - local_ac]          # 004c398e
    mov edi, dword ptr [ebp - local_88]          # 004c3994
    {load} mov eax, ecx                          # 004c399a
    shr ecx, 0x2                                 # 004c399c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c399f
    {load} mov ecx, eax                          # 004c39a1
    and ecx, 0x3                                 # 004c39a3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c39a6
    movsx ecx, word ptr [0x63988b]               # 004c39a8
    movsx edx, word ptr [0x639895]               # 004c39af
    imul ecx, edx                                # 004c39b6
    mov eax, dword ptr [ebp - local_ac]          # 004c39b9
    {load} add eax, ecx                          # 004c39bf
    mov dword ptr [ebp - local_ac], eax          # 004c39c1
    movsx ecx, word ptr [0x639895]               # 004c39c7
    mov edx, dword ptr [ebp - local_bc]          # 004c39ce
    imul edx, ecx                                # 004c39d4
    mov eax, dword ptr [ebp - local_88]          # 004c39d7
    {load} add eax, edx                          # 004c39dd
    mov dword ptr [ebp - local_88], eax          # 004c39df
    jmp.d32 L_004c3961                           # 004c39e5
L_004c39ea:
    # block 0x004c39ea: entered by jge at 0x004c397c, 1 instruction(s), ends with forward jump to 0x004c3a21
    jmp.d8 L_004c3a21                            # 004c39ea
L_004c39ec:
    # block 0x004c39ec: entered by jge at 0x004c3911, 13 instruction(s), falls into the block at 0x004c3a21
    movsx ecx, word ptr [0x63988b]               # 004c39ec
    movsx edx, word ptr [0x63988d]               # 004c39f3
    imul ecx, edx                                # 004c39fa
    movsx eax, word ptr [0x639895]               # 004c39fd
    imul ecx, eax                                # 004c3a04
    mov esi, dword ptr [ebp - local_b0]          # 004c3a07
    mov edi, dword ptr [ebp - local_b8]          # 004c3a0d
    {load} mov edx, ecx                          # 004c3a13
    shr ecx, 0x2                                 # 004c3a15
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004c3a18
    {load} mov ecx, edx                          # 004c3a1a
    and ecx, 0x3                                 # 004c3a1c
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004c3a1f
L_004c3a21:
    # block 0x004c3a21: entered by jmp at 0x004c39ea, 5 instruction(s), ends with jne to 0x004c3a78 (forward)
    mov eax, dword ptr [ebp - local_a0]          # 004c3a21
    {load} xor ecx, ecx                          # 004c3a27
    mov cl, byte ptr [eax + field_31]            # 004c3a29
    test ecx, ecx                                # 004c3a2c
    jne.d8 L_004c3a78                            # 004c3a2e
    # block 0x004c3a30: entered by fall-through of jne at 0x004c3a2e, 12 instruction(s), calls FUN_004c334f, ends with jne to 0x004c3a73 (forward)
    mov edx, dword ptr [ebp - local_a0]          # 004c3a30
    push edx                                     # 004c3a36
    mov eax, dword ptr [ebp - local_a8]          # 004c3a37
    push eax                                     # 004c3a3d
    mov ecx, dword ptr [ebp - local_bc]          # 004c3a3e
    push ecx                                     # 004c3a44
    mov edx, dword ptr [ebp - local_b8]          # 004c3a45
    push edx                                     # 004c3a4b
    mov ecx, dword ptr [ebp - local_d0]          # 004c3a4c
    call FUN_004c334f                            # 004c3a52
    test eax, eax                                # 004c3a57
    jne.d8 L_004c3a73                            # 004c3a59
    # block 0x004c3a5b: entered by fall-through of jne at 0x004c3a59, 3 instruction(s), ends with je to 0x004c3a73 (forward)
    movsx eax, word ptr [0x63a4cd]               # 004c3a5b
    test eax, eax                                # 004c3a62
    je.d8 L_004c3a73                             # 004c3a64
    # block 0x004c3a66: entered by fall-through of je at 0x004c3a64, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c3a73
    push 0x554204                                # 004c3a66
    call FUN_0044a2b7                            # 004c3a6b
    add esp, 0x4                                 # 004c3a70
L_004c3a73:
    # block 0x004c3a73: entered by jne at 0x004c3a59; je at 0x004c3a64, 1 instruction(s), ends with forward jump to 0x004c3bbb
    jmp.d32 L_004c3bbb                           # 004c3a73
L_004c3a78:
    # block 0x004c3a78: entered by jne at 0x004c3a2e, 30 instruction(s), calls FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004c3b2f (forward)
    mov byte ptr [ebp - local_9c], 0x0           # 004c3a78
    mov byte ptr [ebp - local_9b], 0x0           # 004c3a7f
    mov byte ptr [ebp - local_9a], 0x2           # 004c3a86
    mov word ptr [ebp - local_99], 0x0           # 004c3a8d
    mov word ptr [ebp - local_97], 0x0           # 004c3a96
    mov byte ptr [ebp - local_95], 0x0           # 004c3a9f
    mov word ptr [ebp - local_94], 0x0           # 004c3aa6
    mov word ptr [ebp - local_92], 0x0           # 004c3aaf
    mov cx, word ptr [ebp - local_bc]            # 004c3ab8
    mov word ptr [ebp - local_90], cx            # 004c3abf
    mov dx, word ptr [ebp - local_a8]            # 004c3ac6
    mov word ptr [ebp - local_8e], dx            # 004c3acd
    mov al, byte ptr [0x639893]                  # 004c3ad4
    mov byte ptr [ebp - local_8c], al            # 004c3ad9
    mov byte ptr [ebp - local_8b], 0x20          # 004c3adf
    push 0x554238                                # 004c3ae6
    mov ecx, dword ptr [ebp - local_a0]          # 004c3aeb
    push ecx                                     # 004c3af1
    push 0x639aa2                                # 004c3af2
    push 0x639a9f                                # 004c3af7
    push 0x63888b                                # 004c3afc
    call FUN_0050cd72                            # 004c3b01
    add esp, 0x14                                # 004c3b06
    push 0x554240                                # 004c3b09
    push 0x63888b                                # 004c3b0e
    call FUN_0050d0a9                            # 004c3b13
    add esp, 0x8                                 # 004c3b18
    mov dword ptr [ebp - local_a4], eax          # 004c3b1b
    cmp dword ptr [ebp - local_a4], 0x0          # 004c3b21
    jne.d8 L_004c3b2f                            # 004c3b28
    # block 0x004c3b2a: entered by fall-through of jne at 0x004c3b28, 1 instruction(s), ends with forward jump to 0x004c3c46
    jmp.d32 L_004c3c46                           # 004c3b2a
L_004c3b2f:
    # block 0x004c3b2f: entered by jne at 0x004c3b28, 31 instruction(s), calls FUN_0050e493, FUN_004c7481, ends with je to 0x004c3bbb (forward)
    mov eax, dword ptr [ebp - local_a4]          # 004c3b2f
    push eax                                     # 004c3b35
    push 0x1                                     # 004c3b36
    push 0x12                                    # 004c3b38
    lea ecx, [ebp - local_9c]                    # 004c3b3a
    push ecx                                     # 004c3b40
    call FUN_0050e493                            # 004c3b41
    add esp, 0x10                                # 004c3b46
    mov edx, dword ptr [ebp - local_bc]          # 004c3b49
    imul edx, dword ptr [ebp - local_a8]         # 004c3b4f
    movsx eax, word ptr [0x639895]               # 004c3b56
    imul edx, eax                                # 004c3b5d
    push edx                                     # 004c3b60
    mov ecx, dword ptr [ebp - local_b8]          # 004c3b61
    push ecx                                     # 004c3b67
    mov ecx, dword ptr [ebp - local_d0]          # 004c3b68
    call FUN_004c7481                            # 004c3b6e
    mov edx, dword ptr [ebp - local_a4]          # 004c3b73
    push edx                                     # 004c3b79
    push 0x1                                     # 004c3b7a
    mov eax, dword ptr [ebp - local_bc]          # 004c3b7c
    imul eax, dword ptr [ebp - local_a8]         # 004c3b82
    movsx ecx, word ptr [0x639895]               # 004c3b89
    imul eax, ecx                                # 004c3b90
    push eax                                     # 004c3b93
    mov edx, dword ptr [ebp - local_b8]          # 004c3b94
    push edx                                     # 004c3b9a
    call FUN_0050e493                            # 004c3b9b
    add esp, 0x10                                # 004c3ba0
    cmp dword ptr [ebp - local_a4], 0x0          # 004c3ba3
    je.d8 L_004c3bbb                             # 004c3baa
    # block 0x004c3bac: entered by fall-through of je at 0x004c3baa, 4 instruction(s), calls FUN_0050cee4, falls into the block at 0x004c3bbb
    mov eax, dword ptr [ebp - local_a4]          # 004c3bac
    push eax                                     # 004c3bb2
    call FUN_0050cee4                            # 004c3bb3
    add esp, 0x4                                 # 004c3bb8
L_004c3bbb:
    # block 0x004c3bbb: entered by jmp at 0x004c3a73; je at 0x004c3baa; jmp at 0x004c3c46; jmp at 0x004c3c4b; more, 2 instruction(s), ends with je to 0x004c3be9 (forward)
    cmp dword ptr [ebp - local_b0], 0x0          # 004c3bbb
    je.d8 L_004c3be9                             # 004c3bc2
    # block 0x004c3bc4: entered by fall-through of je at 0x004c3bc2, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c3be9
    mov ecx, dword ptr [ebp - local_b0]          # 004c3bc4
    mov dword ptr [ebp - local_c8], ecx          # 004c3bca
    mov edx, dword ptr [ebp - local_c8]          # 004c3bd0
    push edx                                     # 004c3bd6
    call FUN_0051dc6c                            # 004c3bd7
    add esp, 0x4                                 # 004c3bdc
    mov dword ptr [ebp - local_b0], 0x0          # 004c3bdf
L_004c3be9:
    # block 0x004c3be9: entered by je at 0x004c3bc2, 2 instruction(s), ends with je to 0x004c3c17 (forward)
    cmp dword ptr [ebp - local_b8], 0x0          # 004c3be9
    je.d8 L_004c3c17                             # 004c3bf0
    # block 0x004c3bf2: entered by fall-through of je at 0x004c3bf0, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c3c17
    mov eax, dword ptr [ebp - local_b8]          # 004c3bf2
    mov dword ptr [ebp - local_cc], eax          # 004c3bf8
    mov ecx, dword ptr [ebp - local_cc]          # 004c3bfe
    push ecx                                     # 004c3c04
    call FUN_0051dc6c                            # 004c3c05
    add esp, 0x4                                 # 004c3c0a
    mov dword ptr [ebp - local_b8], 0x0          # 004c3c0d
L_004c3c17:
    # block 0x004c3c17: entered by je at 0x004c3bf0, 5 instruction(s), ends with forward jump to 0x004c3c44
    mov dword ptr [0x5839a9], 0x0                # 004c3c17
    movsx edx, word ptr [ebp + arg_8]            # 004c3c21
    imul edx, edx, 0x8d                          # 004c3c25
    mov dword ptr [edx + 0x5bb632], 0x3          # 004c3c2b
    jmp.d8 L_004c3c44                            # 004c3c35
L_004c3c37:
    # block 0x004c3c37: entered by je at 0x004c3712, 4 instruction(s), calls FUN_0042ba3a, falls into the block at 0x004c3c44
    mov ax, word ptr [ebp + arg_8]               # 004c3c37
    push eax                                     # 004c3c3b
    call FUN_0042ba3a                            # 004c3c3c
    add esp, 0x4                                 # 004c3c41
L_004c3c44:
    # block 0x004c3c44: entered by jmp at 0x004c3718; jmp at 0x004c374a; jmp at 0x004c3c35, 1 instruction(s), ends with forward jump to 0x004c3c55
    jmp.d8 L_004c3c55                            # 004c3c44
L_004c3c46:
    # block 0x004c3c46: entered by jmp at 0x004c3b2a, 1 instruction(s), ends with backward jump to 0x004c3bbb
    jmp.d32 L_004c3bbb                           # 004c3c46
L_004c3c4b:
    # block 0x004c3c4b: entered by jmp at 0x004c386b, 1 instruction(s), ends with backward jump to 0x004c3bbb
    jmp.d32 L_004c3bbb                           # 004c3c4b
L_004c3c50:
    # block 0x004c3c50: entered by jmp at 0x004c37d9, 1 instruction(s), ends with backward jump to 0x004c3bbb
    jmp.d32 L_004c3bbb                           # 004c3c50
L_004c3c55:
    # block 0x004c3c55: entered by jmp at 0x004c3773; jmp at 0x004c3c44, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004c3c55
    pop esi                                      # 004c3c56
    {load} mov esp, ebp                          # 004c3c57
    pop ebp                                      # 004c3c59
    ret 0x4                                      # 004c3c5a

