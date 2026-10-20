# FUN_004b8e92
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b8e92
# extent:       0x004b8e92-0x004b9a88 (3062 code bytes)
# span:         0x004b8e92-0x004b9a88 (code 3062, tables 0, padding 0)
# sha256:       59271b05b4690deddb54ae52fb29d774455030026a069cea7225b9d97a7bffda
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_typing_quiz_f5_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f5_runtime.h:22 says "0x4b8e92 the handler: a phase switch on the row phase dword"
# name-note:    Handler of the 0xf5 Typing Quiz Puzzle: a phase switch on the row phase dword.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_6, field_8, field_c, field_14, field_1c, field_34, field_6a, field_405, field_409, field_419, field_431 and 32 more; [ecx + n] field_4, field_6, field_8, field_c, field_14, field_20, field_6a, field_7d, field_40d, field_411, field_434, field_464 and 16 more; [edx + n] field_4, field_6, field_8, field_c, field_10, field_18, field_1c, field_6a, field_73, field_7d, field_173, field_415 and 17 more
# callees:      calls FUN_004e8d96, FUN_004d39f9, FUN_004c2790, FUN_004fb77a, FUN_004460d6, FUN_0044655e, FUN_00446532, KERNEL32.dll!GetTickCount, FUN_004462d3, FUN_00446598, FUN_00446548, FUN_004c924d, FUN_004b8783, FUN_004b832c, FUN_004b8d5e, FUN_004fb2e3 and 6 more
# track-n:      outputs/blackmoor-decomp/src/action_family_f5_runtime.c:phase0 (function ledger class candidate_port; also phase1, phase2; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 736 instruction(s), 43 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_34, 0x34  # offset +0x34
.equ field_6a, 0x6a  # offset +0x6a
.equ field_73, 0x73  # offset +0x73
.equ field_7d, 0x7d  # offset +0x7d
.equ field_173, 0x173  # offset +0x173
.equ field_405, 0x405  # offset +0x405
.equ field_409, 0x409  # offset +0x409
.equ field_40d, 0x40d  # offset +0x40d
.equ field_411, 0x411  # offset +0x411
.equ field_415, 0x415  # offset +0x415
.equ field_419, 0x419  # offset +0x419
.equ field_42d, 0x42d  # offset +0x42d
.equ field_431, 0x431  # offset +0x431
.equ field_433, 0x433  # offset +0x433
.equ field_434, 0x434  # offset +0x434
.equ field_45e, 0x45e  # offset +0x45e
.equ field_460, 0x460  # offset +0x460
.equ field_462, 0x462  # offset +0x462
.equ field_464, 0x464  # offset +0x464
.equ field_487, 0x487  # offset +0x487
.equ field_4b8, 0x4b8  # offset +0x4b8
.equ field_4f9, 0x4f9  # offset +0x4f9
.equ field_4fb, 0x4fb  # offset +0x4fb
.equ field_4fd, 0x4fd  # offset +0x4fd
.equ field_4ff, 0x4ff  # offset +0x4ff
.equ field_501, 0x501  # offset +0x501
.equ field_505, 0x505  # offset +0x505
.equ field_509, 0x509  # offset +0x509
.equ field_50d, 0x50d  # offset +0x50d
.equ field_50f, 0x50f  # offset +0x50f
.equ field_532, 0x532  # offset +0x532
.equ field_536, 0x536  # offset +0x536
.equ field_53a, 0x53a  # offset +0x53a
.equ field_53e, 0x53e  # offset +0x53e
.equ field_542, 0x542  # offset +0x542
.equ field_544, 0x544  # offset +0x544
.equ field_546, 0x546  # offset +0x546
.equ field_548, 0x548  # offset +0x548
.equ field_54a, 0x54a  # offset +0x54a
.equ field_54e, 0x54e  # offset +0x54e
.equ field_552, 0x552  # offset +0x552
.equ field_556, 0x556  # offset +0x556
.equ field_558, 0x558  # offset +0x558
.equ field_55a, 0x55a  # offset +0x55a
.equ field_60e, 0x60e  # offset +0x60e
.equ field_612, 0x612  # offset +0x612
.equ field_616, 0x616  # offset +0x616
.equ field_61a, 0x61a  # offset +0x61a
.equ field_61e, 0x61e  # offset +0x61e
.equ field_622, 0x622  # offset +0x622
.equ field_626, 0x626  # offset +0x626
.equ field_62a, 0x62a  # offset +0x62a
.equ field_62e, 0x62e  # offset +0x62e
.equ field_632, 0x632  # offset +0x632
.equ field_636, 0x636  # offset +0x636
.equ field_637, 0x637  # offset +0x637
.equ field_63b, 0x63b  # offset +0x63b
.equ field_63d, 0x63d  # offset +0x63d
.equ field_641, 0x641  # offset +0x641

# --- external targets -----------------------------------------------
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_00445f53, .text + (0x00445f53 - 0x401000)
.set FUN_00445fc5, .text + (0x00445fc5 - 0x401000)
.set FUN_004460d6, .text + (0x004460d6 - 0x401000)
.set FUN_004462d3, .text + (0x004462d3 - 0x401000)
.set FUN_00446532, .text + (0x00446532 - 0x401000)
.set FUN_00446548, .text + (0x00446548 - 0x401000)
.set FUN_0044655e, .text + (0x0044655e - 0x401000)
.set FUN_00446598, .text + (0x00446598 - 0x401000)
.set FUN_004b7ff4, .text + (0x004b7ff4 - 0x401000)
.set FUN_004b832c, .text + (0x004b832c - 0x401000)
.set FUN_004b844d, .text + (0x004b844d - 0x401000)
.set FUN_004b8783, .text + (0x004b8783 - 0x401000)
.set FUN_004b8d5e, .text + (0x004b8d5e - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c924d, .text + (0x004c924d - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004b8e92 - 0x401000
.globl FUN_004b8e92
FUN_004b8e92:
    # block 0x004b8e92: entry, 17 instruction(s), ends with je to 0x004b8ee5 (forward)
    push ebp                                     # 004b8e92
    {load} mov ebp, esp                          # 004b8e93
    sub esp, 0x10                                # 004b8e95
    push esi                                     # 004b8e98
    push edi                                     # 004b8e99
    mov dword ptr [ebp - local_8], ecx           # 004b8e9a
    movsx eax, word ptr [ebp + arg_8]            # 004b8e9d
    imul eax, eax, 0x8d                          # 004b8ea1
    mov ecx, dword ptr [ebp - local_8]           # 004b8ea7
    mov edx, dword ptr [eax + 0x5bb5e5]          # 004b8eaa
    mov dword ptr [ecx + field_8], edx           # 004b8eb0
    movsx eax, word ptr [ebp + arg_8]            # 004b8eb3
    imul eax, eax, 0x8d                          # 004b8eb7
    mov ecx, dword ptr [eax + 0x5bb632]          # 004b8ebd
    mov dword ptr [ebp - local_c], ecx           # 004b8ec3
    cmp dword ptr [ebp - local_c], 0x0           # 004b8ec6
    je.d8 L_004b8ee5                             # 004b8eca
    # block 0x004b8ecc: entered by fall-through of je at 0x004b8eca, 2 instruction(s), ends with je to 0x004b942f (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004b8ecc
    je.d32 L_004b942f                            # 004b8ed0
    # block 0x004b8ed6: entered by fall-through of je at 0x004b8ed0, 2 instruction(s), ends with je to 0x004b9784 (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 004b8ed6
    je.d32 L_004b9784                            # 004b8eda
    # block 0x004b8ee0: entered by fall-through of je at 0x004b8eda, 1 instruction(s), ends with forward jump to 0x004b9a80
    jmp.d32 L_004b9a80                           # 004b8ee0
L_004b8ee5:
    # block 0x004b8ee5: entered by je at 0x004b8eca, 64 instruction(s), calls FUN_004e8d96, FUN_004d39f9, ends with jne to 0x004b9017 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b8ee5
    mov ax, word ptr [ebp + arg_8]               # 004b8ee8
    mov word ptr [edx + field_6], ax             # 004b8eec
    mov ecx, dword ptr [ebp - local_8]           # 004b8ef0
    mov dword ptr [ecx + field_14], 0x1          # 004b8ef3
    mov dword ptr [0x5bb1ca], 0x1                # 004b8efa
    mov ecx, 0x571442                            # 004b8f04
    call FUN_004e8d96                            # 004b8f09
    call FUN_004d39f9                            # 004b8f0e
    mov edx, dword ptr [ebp - local_8]           # 004b8f13
    mov word ptr [edx + field_4], ax             # 004b8f16
    mov eax, dword ptr [ebp - local_8]           # 004b8f1a
    movsx ecx, word ptr [eax + field_4]          # 004b8f1d
    imul ecx, ecx, 0x4a                          # 004b8f21
    mov dword ptr [ecx + 0x5d1591], 0xa          # 004b8f24
    mov edx, dword ptr [ebp - local_8]           # 004b8f2e
    movsx eax, word ptr [edx + field_4]          # 004b8f31
    imul eax, eax, 0x4a                          # 004b8f35
    mov dword ptr [eax + 0x5d1595], 0x4b9a88     # 004b8f38
    mov ecx, dword ptr [ebp - local_8]           # 004b8f42
    movsx edx, word ptr [ecx + field_4]          # 004b8f45
    imul edx, edx, 0x4a                          # 004b8f49
    mov dword ptr [edx + 0x5d1599], 0x0          # 004b8f4c
    mov eax, dword ptr [ebp - local_8]           # 004b8f56
    movsx ecx, word ptr [eax + field_4]          # 004b8f59
    imul ecx, ecx, 0x4a                          # 004b8f5d
    mov dword ptr [ecx + 0x5d159d], 0x0          # 004b8f60
    mov edx, dword ptr [ebp - local_8]           # 004b8f6a
    movsx eax, word ptr [edx + field_4]          # 004b8f6d
    imul eax, eax, 0x4a                          # 004b8f71
    mov dword ptr [eax + 0x5d15a1], 0x0          # 004b8f74
    mov ecx, dword ptr [ebp - local_8]           # 004b8f7e
    movsx edx, word ptr [ecx + field_4]          # 004b8f81
    imul edx, edx, 0x4a                          # 004b8f85
    mov dword ptr [edx + 0x5d15a5], 0x1          # 004b8f88
    mov eax, dword ptr [ebp - local_8]           # 004b8f92
    movsx ecx, word ptr [eax + field_4]          # 004b8f95
    imul ecx, ecx, 0x4a                          # 004b8f99
    mov dword ptr [ecx + 0x5d15a9], 0x1          # 004b8f9c
    mov edx, dword ptr [ebp - local_8]           # 004b8fa6
    movsx eax, word ptr [edx + field_4]          # 004b8fa9
    imul eax, eax, 0x4a                          # 004b8fad
    mov word ptr [eax + 0x5d15ad], 0x0           # 004b8fb0
    mov edi, 0x551db0                            # 004b8fb9
    mov ecx, dword ptr [ebp - local_8]           # 004b8fbe
    movsx edx, word ptr [ecx + field_4]          # 004b8fc1
    imul edx, edx, 0x4a                          # 004b8fc5
    add edx, 0x5d15b3                            # 004b8fc8
    or ecx, -0x1                                 # 004b8fce
    {load} xor eax, eax                          # 004b8fd1
    repne scasb al, byte ptr es:[edi]            # 004b8fd3
    not ecx                                      # 004b8fd5
    {load} sub edi, ecx                          # 004b8fd7
    {load} mov esi, edi                          # 004b8fd9
    {load} mov eax, ecx                          # 004b8fdb
    {load} mov edi, edx                          # 004b8fdd
    shr ecx, 0x2                                 # 004b8fdf
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b8fe2
    {load} mov ecx, eax                          # 004b8fe4
    and ecx, 0x3                                 # 004b8fe6
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004b8fe9
    mov ecx, dword ptr [ebp - local_8]           # 004b8feb
    cmp dword ptr [ecx + field_c], 0x0           # 004b8fee
    jne.d8 L_004b9017                            # 004b8ff2
    # block 0x004b8ff4: entered by fall-through of jne at 0x004b8ff2, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x004b9017
    push 0x551dcc                                # 004b8ff4
    push 0x6                                     # 004b8ff9
    mov edx, dword ptr [ebp - local_8]           # 004b8ffb
    mov eax, dword ptr [edx + field_8]           # 004b8ffe
    push eax                                     # 004b9001
    push 0x551dec                                # 004b9002
    mov ecx, 0x5cf659                            # 004b9007
    call FUN_004c2790                            # 004b900c
    mov ecx, dword ptr [ebp - local_8]           # 004b9011
    mov dword ptr [ecx + field_c], eax           # 004b9014
L_004b9017:
    # block 0x004b9017: entered by jne at 0x004b8ff2, 14 instruction(s), ends with je to 0x004b9060 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b9017
    movsx eax, word ptr [edx + field_4]          # 004b901a
    imul eax, eax, 0x4a                          # 004b901e
    mov ecx, dword ptr [ebp - local_8]           # 004b9021
    mov edx, dword ptr [ecx + field_c]           # 004b9024
    mov dword ptr [eax + 0x5d1599], edx          # 004b9027
    mov edi, 0x551df4                            # 004b902d
    mov eax, dword ptr [ebp - local_8]           # 004b9032
    mov esi, dword ptr [eax + field_8]           # 004b9035
    add esi, 0x466                               # 004b9038
    mov ecx, 0x9                                 # 004b903e
    {load} xor edx, edx                          # 004b9043
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b9045
    je.d8 L_004b9060                             # 004b9047
    # block 0x004b9049: entered by fall-through of je at 0x004b9047, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b9060
    mov eax, dword ptr [ebp - local_8]           # 004b9049
    mov ecx, dword ptr [eax + field_8]           # 004b904c
    add ecx, 0x466                               # 004b904f
    push ecx                                     # 004b9055
    mov ecx, 0x5c3a67                            # 004b9056
    call FUN_004fb77a                            # 004b905b
L_004b9060:
    # block 0x004b9060: entered by je at 0x004b9047, 8 instruction(s), ends with je to 0x004b9093 (forward)
    mov edi, 0x551e00                            # 004b9060
    mov edx, dword ptr [ebp - local_8]           # 004b9065
    mov esi, dword ptr [edx + field_8]           # 004b9068
    add esi, 0x497                               # 004b906b
    mov ecx, 0x9                                 # 004b9071
    {load} xor eax, eax                          # 004b9076
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b9078
    je.d8 L_004b9093                             # 004b907a
    # block 0x004b907c: entered by fall-through of je at 0x004b907a, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b9093
    mov ecx, dword ptr [ebp - local_8]           # 004b907c
    mov edx, dword ptr [ecx + field_8]           # 004b907f
    add edx, 0x497                               # 004b9082
    push edx                                     # 004b9088
    mov ecx, 0x5c3a67                            # 004b9089
    call FUN_004fb77a                            # 004b908e
L_004b9093:
    # block 0x004b9093: entered by je at 0x004b907a, 8 instruction(s), ends with je to 0x004b90c6 (forward)
    mov edi, 0x551e0c                            # 004b9093
    mov eax, dword ptr [ebp - local_8]           # 004b9098
    mov esi, dword ptr [eax + field_8]           # 004b909b
    add esi, 0x4c8                               # 004b909e
    mov ecx, 0x9                                 # 004b90a4
    {load} xor edx, edx                          # 004b90a9
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b90ab
    je.d8 L_004b90c6                             # 004b90ad
    # block 0x004b90af: entered by fall-through of je at 0x004b90ad, 6 instruction(s), calls FUN_004fb77a, falls into the block at 0x004b90c6
    mov eax, dword ptr [ebp - local_8]           # 004b90af
    mov ecx, dword ptr [eax + field_8]           # 004b90b2
    add ecx, 0x4c8                               # 004b90b5
    push ecx                                     # 004b90bb
    mov ecx, 0x5c3a67                            # 004b90bc
    call FUN_004fb77a                            # 004b90c1
L_004b90c6:
    # block 0x004b90c6: entered by je at 0x004b90ad, 139 instruction(s), calls FUN_004d39f9, FUN_004460d6, FUN_0044655e, FUN_00446532, KERNEL32.dll!GetTickCount, FUN_004462d3, ..., ends with jle to 0x004b9392 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b90c6
    mov dword ptr [edx + field_552], 0x0         # 004b90c9
    mov eax, dword ptr [ebp - local_8]           # 004b90d3
    mov dword ptr [eax + field_54e], 0x0         # 004b90d6
    mov ecx, dword ptr [ebp - local_8]           # 004b90e0
    mov esi, dword ptr [ecx + field_8]           # 004b90e3
    add esi, 0x2b5                               # 004b90e6
    mov edi, dword ptr [ebp - local_8]           # 004b90ec
    add edi, 0x496                               # 004b90ef
    mov ecx, 0x28                                # 004b90f5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b90fa
    mov edx, dword ptr [ebp - local_8]           # 004b90fc
    mov eax, dword ptr [edx + field_8]           # 004b90ff
    mov ecx, dword ptr [ebp - local_8]           # 004b9102
    mov edx, dword ptr [eax + field_405]         # 004b9105
    mov dword ptr [ecx + field_536], edx         # 004b910b
    mov eax, dword ptr [eax + field_409]         # 004b9111
    mov dword ptr [ecx + field_53a], eax         # 004b9117
    mov ecx, dword ptr [ebp - local_8]           # 004b911d
    mov edx, dword ptr [ecx + field_8]           # 004b9120
    mov eax, dword ptr [ebp - local_8]           # 004b9123
    mov ecx, dword ptr [edx + field_415]         # 004b9126
    mov dword ptr [eax + field_53e], ecx         # 004b912c
    mov edx, dword ptr [ebp - local_8]           # 004b9132
    mov eax, dword ptr [ebp - local_8]           # 004b9135
    mov ecx, dword ptr [eax + field_c]           # 004b9138
    mov dword ptr [edx + field_542], ecx         # 004b913b
    call FUN_004d39f9                            # 004b9141
    movsx edx, ax                                # 004b9146
    mov eax, dword ptr [ebp - local_8]           # 004b9149
    mov dword ptr [eax + field_546], edx         # 004b914c
    mov ecx, dword ptr [ebp - local_8]           # 004b9152
    mov dword ptr [ecx + field_54a], 0xa         # 004b9155
    mov edx, dword ptr [ebp - local_8]           # 004b915f
    mov eax, dword ptr [edx + field_536]         # 004b9162
    add eax, dword ptr [0x583186]                # 004b9168
    mov ecx, dword ptr [ebp - local_8]           # 004b916e
    mov dword ptr [ecx + field_536], eax         # 004b9171
    mov edx, dword ptr [ebp - local_8]           # 004b9177
    mov eax, dword ptr [edx + field_53a]         # 004b917a
    add eax, dword ptr [0x58318a]                # 004b9180
    mov ecx, dword ptr [ebp - local_8]           # 004b9186
    mov dword ptr [ecx + field_53a], eax         # 004b9189
    mov edx, dword ptr [ebp - local_8]           # 004b918f
    add edx, 0x496                               # 004b9192
    push edx                                     # 004b9198
    mov ecx, 0x638603                            # 004b9199
    call FUN_004460d6                            # 004b919e
    mov eax, dword ptr [ebp - local_8]           # 004b91a3
    mov ecx, dword ptr [eax + field_552]         # 004b91a6
    push ecx                                     # 004b91ac
    mov ecx, 0x638603                            # 004b91ad
    call FUN_0044655e                            # 004b91b2
    push 0x1                                     # 004b91b7
    mov ecx, 0x638603                            # 004b91b9
    call FUN_00446532                            # 004b91be
    call dword ptr [0x52a23c]                    # 004b91c3
    mov edx, dword ptr [ebp - local_8]           # 004b91c9
    mov dword ptr [edx + field_62e], eax         # 004b91cc
    mov eax, dword ptr [ebp - local_8]           # 004b91d2
    mov dword ptr [eax + field_632], 0x0         # 004b91d5
    mov ecx, dword ptr [ebp - local_8]           # 004b91df
    mov dword ptr [ecx + field_626], 0x0         # 004b91e2
    mov edx, dword ptr [ebp - local_8]           # 004b91ec
    mov dword ptr [edx + field_62a], 0x0         # 004b91ef
    mov eax, dword ptr [ebp - local_8]           # 004b91f9
    mov esi, dword ptr [eax + field_8]           # 004b91fc
    add esi, 0x355                               # 004b91ff
    mov edi, dword ptr [ebp - local_8]           # 004b9205
    add edi, 0x55e                               # 004b9208
    mov ecx, 0x28                                # 004b920e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b9213
    mov ecx, dword ptr [ebp - local_8]           # 004b9215
    mov edx, dword ptr [ecx + field_8]           # 004b9218
    add edx, 0x3f5                               # 004b921b
    mov eax, dword ptr [ebp - local_8]           # 004b9221
    add eax, 0x5fe                               # 004b9224
    mov ecx, dword ptr [edx]                     # 004b9229
    mov dword ptr [eax], ecx                     # 004b922b
    mov ecx, dword ptr [edx + field_4]           # 004b922d
    mov dword ptr [eax + field_4], ecx           # 004b9230
    mov ecx, dword ptr [edx + field_8]           # 004b9233
    mov dword ptr [eax + field_8], ecx           # 004b9236
    mov edx, dword ptr [edx + field_c]           # 004b9239
    mov dword ptr [eax + field_c], edx           # 004b923c
    mov eax, dword ptr [ebp - local_8]           # 004b923f
    mov ecx, dword ptr [eax + field_8]           # 004b9242
    mov edx, dword ptr [ebp - local_8]           # 004b9245
    mov eax, dword ptr [ecx + field_40d]         # 004b9248
    mov dword ptr [edx + field_60e], eax         # 004b924e
    mov ecx, dword ptr [ecx + field_411]         # 004b9254
    mov dword ptr [edx + field_612], ecx         # 004b925a
    mov edx, dword ptr [ebp - local_8]           # 004b9260
    mov eax, dword ptr [edx + field_8]           # 004b9263
    mov ecx, dword ptr [ebp - local_8]           # 004b9266
    mov edx, dword ptr [eax + field_419]         # 004b9269
    mov dword ptr [ecx + field_616], edx         # 004b926f
    mov eax, dword ptr [ebp - local_8]           # 004b9275
    mov ecx, dword ptr [ebp - local_8]           # 004b9278
    mov edx, dword ptr [ecx + field_c]           # 004b927b
    mov dword ptr [eax + field_61a], edx         # 004b927e
    call FUN_004d39f9                            # 004b9284
    movsx eax, ax                                # 004b9289
    mov ecx, dword ptr [ebp - local_8]           # 004b928c
    mov dword ptr [ecx + field_61e], eax         # 004b928f
    mov edx, dword ptr [ebp - local_8]           # 004b9295
    mov dword ptr [edx + field_622], 0xa         # 004b9298
    mov eax, dword ptr [ebp - local_8]           # 004b92a2
    mov ecx, dword ptr [eax + field_60e]         # 004b92a5
    add ecx, dword ptr [0x583186]                # 004b92ab
    mov edx, dword ptr [ebp - local_8]           # 004b92b1
    mov dword ptr [edx + field_60e], ecx         # 004b92b4
    mov eax, dword ptr [ebp - local_8]           # 004b92ba
    mov ecx, dword ptr [eax + field_612]         # 004b92bd
    add ecx, dword ptr [0x58318a]                # 004b92c3
    mov edx, dword ptr [ebp - local_8]           # 004b92c9
    mov dword ptr [edx + field_612], ecx         # 004b92cc
    mov eax, dword ptr [ebp - local_8]           # 004b92d2
    add eax, 0x55e                               # 004b92d5
    push eax                                     # 004b92da
    mov ecx, 0x638603                            # 004b92db
    call FUN_004462d3                            # 004b92e0
    mov ecx, dword ptr [ebp - local_8]           # 004b92e5
    mov edx, dword ptr [ecx + field_62a]         # 004b92e8
    push edx                                     # 004b92ee
    mov eax, dword ptr [ebp - local_8]           # 004b92ef
    mov ecx, dword ptr [eax + field_626]         # 004b92f2
    push ecx                                     # 004b92f8
    mov ecx, 0x638603                            # 004b92f9
    call FUN_00446598                            # 004b92fe
    push 0x1                                     # 004b9303
    mov ecx, 0x638603                            # 004b9305
    call FUN_00446548                            # 004b930a
    mov dword ptr [0x5a4c0a], 0x1                # 004b930f
    mov edx, dword ptr [ebp - local_8]           # 004b9319
    mov eax, dword ptr [edx + field_8]           # 004b931c
    movsx ecx, word ptr [eax + field_462]        # 004b931f
    test ecx, ecx                                # 004b9326
    jle.d8 L_004b9392                            # 004b9328
    # block 0x004b932a: entered by fall-through of jle at 0x004b9328, 3 instruction(s), ends with jle to 0x004b9392 (forward)
    movsx edx, word ptr [0x5a4c0e]               # 004b932a
    test edx, edx                                # 004b9331
    jle.d8 L_004b9392                            # 004b9333
    # block 0x004b9335: entered by fall-through of jle at 0x004b9333, 17 instruction(s), ends with jg to 0x004b9390 (forward)
    movsx eax, word ptr [0x5a4c0e]               # 004b9335
    mov ecx, dword ptr [ebp - local_8]           # 004b933c
    mov edx, dword ptr [ecx + field_8]           # 004b933f
    movsx ecx, word ptr [edx + field_462]        # 004b9342
    imul eax, ecx                                # 004b9349
    cdq                                          # 004b934c
    mov ecx, 0x64                                # 004b934d
    idiv ecx                                     # 004b9352
    mov edx, dword ptr [ebp - local_8]           # 004b9354
    mov word ptr [edx + field_641], ax           # 004b9357
    mov eax, dword ptr [ebp - local_8]           # 004b935e
    movsx ecx, word ptr [eax + field_641]        # 004b9361
    mov edx, dword ptr [ebp - local_8]           # 004b9368
    mov eax, dword ptr [edx + field_8]           # 004b936b
    movsx edx, word ptr [eax + field_464]        # 004b936e
    {load} cmp ecx, edx                          # 004b9375
    jg.d8 L_004b9390                             # 004b9377
    # block 0x004b9379: entered by fall-through of jg at 0x004b9377, 5 instruction(s), falls into the block at 0x004b9390
    mov eax, dword ptr [ebp - local_8]           # 004b9379
    mov ecx, dword ptr [eax + field_8]           # 004b937c
    mov edx, dword ptr [ebp - local_8]           # 004b937f
    mov ax, word ptr [ecx + field_464]           # 004b9382
    mov word ptr [edx + field_641], ax           # 004b9389
L_004b9390:
    # block 0x004b9390: entered by jg at 0x004b9377, 1 instruction(s), ends with forward jump to 0x004b93a9
    jmp.d8 L_004b93a9                            # 004b9390
L_004b9392:
    # block 0x004b9392: entered by jle at 0x004b9328; jle at 0x004b9333, 5 instruction(s), falls into the block at 0x004b93a9
    mov ecx, dword ptr [ebp - local_8]           # 004b9392
    mov edx, dword ptr [ecx + field_8]           # 004b9395
    mov eax, dword ptr [ebp - local_8]           # 004b9398
    mov cx, word ptr [edx + field_460]           # 004b939b
    mov word ptr [eax + field_641], cx           # 004b93a2
L_004b93a9:
    # block 0x004b93a9: entered by jmp at 0x004b9390, 17 instruction(s), calls FUN_004c924d, FUN_004b8783, ends with je to 0x004b93fe (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b93a9
    mov dword ptr [edx + field_10], 0x0          # 004b93ac
    mov eax, dword ptr [ebp - local_8]           # 004b93b3
    movsx ecx, word ptr [eax + field_6]          # 004b93b6
    imul ecx, ecx, 0x8d                          # 004b93ba
    mov dword ptr [ecx + 0x5bb632], 0x1          # 004b93c0
    push 0xa                                     # 004b93ca
    mov ecx, 0x5cf659                            # 004b93cc
    call FUN_004c924d                            # 004b93d1
    mov ecx, dword ptr [ebp - local_8]           # 004b93d6
    call FUN_004b8783                            # 004b93d9
    mov edx, dword ptr [ebp - local_8]           # 004b93de
    mov eax, dword ptr [edx + field_8]           # 004b93e1
    {load} xor ecx, ecx                          # 004b93e4
    mov cl, byte ptr [eax + field_433]           # 004b93e6
    test ecx, ecx                                # 004b93ec
    je.d8 L_004b93fe                             # 004b93ee
    # block 0x004b93f0: entered by fall-through of je at 0x004b93ee, 3 instruction(s), ends with forward jump to 0x004b942a
    mov edx, dword ptr [ebp - local_8]           # 004b93f0
    mov word ptr [edx + field_63b], 0x100        # 004b93f3
    jmp.d8 L_004b942a                            # 004b93fc
L_004b93fe:
    # block 0x004b93fe: entered by je at 0x004b93ee, 6 instruction(s), ends with jne to 0x004b941e (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b93fe
    mov ecx, dword ptr [eax + field_8]           # 004b9401
    {load} xor edx, edx                          # 004b9404
    mov dl, byte ptr [ecx + field_434]           # 004b9406
    test edx, edx                                # 004b940c
    jne.d8 L_004b941e                            # 004b940e
    # block 0x004b9410: entered by fall-through of jne at 0x004b940e, 3 instruction(s), ends with forward jump to 0x004b942a
    mov eax, dword ptr [ebp - local_8]           # 004b9410
    mov word ptr [eax + field_63b], 0x7b         # 004b9413
    jmp.d8 L_004b942a                            # 004b941c
L_004b941e:
    # block 0x004b941e: entered by jne at 0x004b940e, 2 instruction(s), falls into the block at 0x004b942a
    mov ecx, dword ptr [ebp - local_8]           # 004b941e
    mov word ptr [ecx + field_63b], 0x7f         # 004b9421
L_004b942a:
    # block 0x004b942a: entered by jmp at 0x004b93fc; jmp at 0x004b941c, 1 instruction(s), ends with forward jump to 0x004b9a80
    jmp.d32 L_004b9a80                           # 004b942a
L_004b942f:
    # block 0x004b942f: entered by je at 0x004b8ed0, 5 instruction(s), ends with je to 0x004b9457 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b942f
    mov eax, dword ptr [edx + field_10]          # 004b9432
    mov dword ptr [ebp - local_10], eax          # 004b9435
    cmp dword ptr [ebp - local_10], 0x0          # 004b9438
    je.d8 L_004b9457                             # 004b943c
    # block 0x004b943e: entered by fall-through of je at 0x004b943c, 2 instruction(s), ends with je to 0x004b9660 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 004b943e
    je.d32 L_004b9660                            # 004b9442
    # block 0x004b9448: entered by fall-through of je at 0x004b9442, 2 instruction(s), ends with je to 0x004b9729 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 004b9448
    je.d32 L_004b9729                            # 004b944c
    # block 0x004b9452: entered by fall-through of je at 0x004b944c, 1 instruction(s), ends with forward jump to 0x004b977f
    jmp.d32 L_004b977f                           # 004b9452
L_004b9457:
    # block 0x004b9457: entered by je at 0x004b943c, 7 instruction(s), calls FUN_004b832c, FUN_004b8d5e, ends with je to 0x004b9653 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b9457
    call FUN_004b832c                            # 004b945a
    mov ecx, dword ptr [ebp - local_8]           # 004b945f
    call FUN_004b8d5e                            # 004b9462
    mov ecx, dword ptr [ebp - local_8]           # 004b9467
    cmp dword ptr [ecx + field_637], 0x0         # 004b946a
    je.d32 L_004b9653                            # 004b9471
    # block 0x004b9477: entered by fall-through of je at 0x004b9471, 2 instruction(s), ends with forward jump to 0x004b948b
    mov word ptr [ebp - local_4], 0x0            # 004b9477
    jmp.d8 L_004b948b                            # 004b947d
L_004b947f:
    # block 0x004b947f: entered by jmp at 0x004b961d, 3 instruction(s), falls into the block at 0x004b948b
    mov dx, word ptr [ebp - local_4]             # 004b947f
    add dx, 0x1                                  # 004b9483
    mov word ptr [ebp - local_4], dx             # 004b9487
L_004b948b:
    # block 0x004b948b: entered by jmp at 0x004b947d, 6 instruction(s), ends with jge to 0x004b9622 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b948b
    mov ecx, dword ptr [ebp - local_8]           # 004b948f
    mov edx, dword ptr [ecx + field_8]           # 004b9492
    movsx ecx, word ptr [edx + field_173]        # 004b9495
    {load} cmp eax, ecx                          # 004b949c
    jge.d32 L_004b9622                           # 004b949e
    # block 0x004b94a4: entered by fall-through of jge at 0x004b949e, 6 instruction(s), ends with jne to 0x004b9583 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b94a4
    mov eax, dword ptr [edx + field_8]           # 004b94a7
    {load} xor ecx, ecx                          # 004b94aa
    mov cl, byte ptr [eax + field_431]           # 004b94ac
    test ecx, ecx                                # 004b94b2
    jne.d32 L_004b9583                           # 004b94b4
    # block 0x004b94ba: entered by fall-through of jne at 0x004b94b4, 9 instruction(s), ends with je to 0x004b9583 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b94ba
    imul edx, edx, 0x37                          # 004b94be
    mov eax, dword ptr [ebp - local_8]           # 004b94c1
    {load} xor ecx, ecx                          # 004b94c4
    mov cl, byte ptr [eax + edx + field_6a]      # 004b94c6
    mov edx, dword ptr [ebp - local_8]           # 004b94ca
    movsx eax, byte ptr [edx + field_636]        # 004b94cd
    {load} cmp ecx, eax                          # 004b94d4
    je.d32 L_004b9583                            # 004b94d6
    # block 0x004b94dc: entered by fall-through of je at 0x004b94d6, 4 instruction(s), ends with jl to 0x004b9583 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b94dc
    movsx edx, byte ptr [ecx + field_636]        # 004b94df
    cmp edx, 0x41                                # 004b94e6
    jl.d32 L_004b9583                            # 004b94e9
    # block 0x004b94ef: entered by fall-through of jl at 0x004b94e9, 7 instruction(s), ends with jl to 0x004b953d (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b94ef
    imul eax, eax, 0x37                          # 004b94f3
    mov ecx, dword ptr [ebp - local_8]           # 004b94f6
    {load} xor edx, edx                          # 004b94f9
    mov dl, byte ptr [ecx + eax + field_6a]      # 004b94fb
    cmp edx, 0x61                                # 004b94ff
    jl.d8 L_004b953d                             # 004b9502
    # block 0x004b9504: entered by fall-through of jl at 0x004b9502, 10 instruction(s), ends with jne to 0x004b953d (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b9504
    imul eax, eax, 0x37                          # 004b9508
    mov ecx, dword ptr [ebp - local_8]           # 004b950b
    {load} xor edx, edx                          # 004b950e
    mov dl, byte ptr [ecx + eax + field_6a]      # 004b9510
    mov eax, dword ptr [ebp - local_8]           # 004b9514
    movsx ecx, byte ptr [eax + field_636]        # 004b9517
    add ecx, 0x20                                # 004b951e
    {load} cmp edx, ecx                          # 004b9521
    jne.d8 L_004b953d                            # 004b9523
    # block 0x004b9525: entered by fall-through of jne at 0x004b9523, 6 instruction(s), ends with forward jump to 0x004b9583
    mov edx, dword ptr [ebp - local_8]           # 004b9525
    movsx eax, byte ptr [edx + field_636]        # 004b9528
    add eax, 0x20                                # 004b952f
    mov ecx, dword ptr [ebp - local_8]           # 004b9532
    mov byte ptr [ecx + field_636], al           # 004b9535
    jmp.d8 L_004b9583                            # 004b953b
L_004b953d:
    # block 0x004b953d: entered by jl at 0x004b9502; jne at 0x004b9523, 4 instruction(s), ends with jl to 0x004b9583 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b953d
    movsx eax, byte ptr [edx + field_636]        # 004b9540
    cmp eax, 0x61                                # 004b9547
    jl.d8 L_004b9583                             # 004b954a
    # block 0x004b954c: entered by fall-through of jl at 0x004b954a, 10 instruction(s), ends with jne to 0x004b9583 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 004b954c
    imul ecx, ecx, 0x37                          # 004b9550
    mov edx, dword ptr [ebp - local_8]           # 004b9553
    {load} xor eax, eax                          # 004b9556
    mov al, byte ptr [edx + ecx + field_6a]      # 004b9558
    mov ecx, dword ptr [ebp - local_8]           # 004b955c
    movsx edx, byte ptr [ecx + field_636]        # 004b955f
    sub edx, 0x20                                # 004b9566
    {load} cmp eax, edx                          # 004b9569
    jne.d8 L_004b9583                            # 004b956b
    # block 0x004b956d: entered by fall-through of jne at 0x004b956b, 5 instruction(s), falls into the block at 0x004b9583
    mov eax, dword ptr [ebp - local_8]           # 004b956d
    movsx ecx, byte ptr [eax + field_636]        # 004b9570
    sub ecx, 0x20                                # 004b9577
    mov edx, dword ptr [ebp - local_8]           # 004b957a
    mov byte ptr [edx + field_636], cl           # 004b957d
L_004b9583:
    # block 0x004b9583: entered by jne at 0x004b94b4; je at 0x004b94d6; jl at 0x004b94e9; jmp at 0x004b953b; more, 5 instruction(s), ends with jne to 0x004b961d (forward)
    movsx eax, word ptr [ebp - local_4]          # 004b9583
    imul eax, eax, 0x37                          # 004b9587
    mov ecx, dword ptr [ebp - local_8]           # 004b958a
    cmp dword ptr [ecx + eax + field_7d], 0x1    # 004b958d
    jne.d32 L_004b961d                           # 004b9592
    # block 0x004b9598: entered by fall-through of jne at 0x004b9592, 9 instruction(s), ends with jne to 0x004b961d (forward)
    movsx edx, word ptr [ebp - local_4]          # 004b9598
    imul edx, edx, 0x37                          # 004b959c
    mov eax, dword ptr [ebp - local_8]           # 004b959f
    {load} xor ecx, ecx                          # 004b95a2
    mov cl, byte ptr [eax + edx + field_6a]      # 004b95a4
    mov edx, dword ptr [ebp - local_8]           # 004b95a8
    movsx eax, byte ptr [edx + field_636]        # 004b95ab
    {load} cmp ecx, eax                          # 004b95b2
    jne.d8 L_004b961d                            # 004b95b4
    # block 0x004b95b6: entered by fall-through of jne at 0x004b95b4, 24 instruction(s), calls FUN_004fb2e3, KERNEL32.dll!GetTickCount, ends with forward jump to 0x004b9622
    movsx ecx, word ptr [ebp - local_4]          # 004b95b6
    imul ecx, ecx, 0x37                          # 004b95ba
    mov edx, dword ptr [ebp - local_8]           # 004b95bd
    mov dword ptr [edx + ecx + field_7d], 0x2    # 004b95c0
    mov eax, dword ptr [ebp - local_8]           # 004b95c8
    mov ecx, dword ptr [eax + field_54e]         # 004b95cb
    add ecx, 0x1                                 # 004b95d1
    mov edx, dword ptr [ebp - local_8]           # 004b95d4
    mov dword ptr [edx + field_54e], ecx         # 004b95d7
    mov eax, dword ptr [ebp - local_8]           # 004b95dd
    mov ecx, dword ptr [eax + field_8]           # 004b95e0
    mov dx, word ptr [ecx + field_487]           # 004b95e3
    push edx                                     # 004b95ea
    mov ecx, 0x5c3a67                            # 004b95eb
    call FUN_004fb2e3                            # 004b95f0
    call dword ptr [0x52a23c]                    # 004b95f5
    add eax, 0x3e8                               # 004b95fb
    movsx ecx, word ptr [ebp - local_4]          # 004b9600
    imul ecx, ecx, 0x37                          # 004b9604
    mov edx, dword ptr [ebp - local_8]           # 004b9607
    mov dword ptr [edx + ecx + field_73], eax    # 004b960a
    mov eax, dword ptr [ebp - local_8]           # 004b960e
    mov dword ptr [eax + field_637], 0x0         # 004b9611
    jmp.d8 L_004b9622                            # 004b961b
L_004b961d:
    # block 0x004b961d: entered by jne at 0x004b9592; jne at 0x004b95b4, 1 instruction(s), ends with backward jump to 0x004b947f
    jmp.d32 L_004b947f                           # 004b961d
L_004b9622:
    # block 0x004b9622: entered by jge at 0x004b949e; jmp at 0x004b961b, 3 instruction(s), ends with je to 0x004b9653 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b9622
    cmp dword ptr [ecx + field_637], 0x0         # 004b9625
    je.d8 L_004b9653                             # 004b962c
    # block 0x004b962e: entered by fall-through of je at 0x004b962c, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004b9653
    mov edx, dword ptr [ebp - local_8]           # 004b962e
    mov dword ptr [edx + field_637], 0x0         # 004b9631
    mov eax, dword ptr [ebp - local_8]           # 004b963b
    mov ecx, dword ptr [eax + field_8]           # 004b963e
    mov dx, word ptr [ecx + field_4b8]           # 004b9641
    push edx                                     # 004b9648
    mov ecx, 0x5c3a67                            # 004b9649
    call FUN_004fb2e3                            # 004b964e
L_004b9653:
    # block 0x004b9653: entered by je at 0x004b9471; je at 0x004b962c, 3 instruction(s), calls FUN_004b844d, ends with forward jump to 0x004b977f
    mov ecx, dword ptr [ebp - local_8]           # 004b9653
    call FUN_004b844d                            # 004b9656
    jmp.d32 L_004b977f                           # 004b965b
L_004b9660:
    # block 0x004b9660: entered by je at 0x004b9442, 17 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jl to 0x004b9705 (forward)
    call dword ptr [0x52a23c]                    # 004b9660
    mov ecx, dword ptr [ebp - local_8]           # 004b9666
    mov edx, dword ptr [ecx + field_8]           # 004b9669
    add eax, dword ptr [edx + field_42d]         # 004b966c
    mov ecx, dword ptr [ebp - local_8]           # 004b9672
    mov dword ptr [ecx + field_63d], eax         # 004b9675
    mov edx, dword ptr [ebp - local_8]           # 004b967b
    mov dword ptr [edx + field_10], 0x2          # 004b967e
    mov eax, dword ptr [ebp - local_8]           # 004b9685
    mov dword ptr [eax + field_34], 0x1          # 004b9688
    mov ecx, dword ptr [ebp - local_8]           # 004b968f
    mov dword ptr [ecx + field_20], 0x1          # 004b9692
    mov edx, dword ptr [ebp - local_8]           # 004b9699
    movsx eax, word ptr [edx + field_641]        # 004b969c
    mov ecx, dword ptr [ebp - local_8]           # 004b96a3
    cmp dword ptr [ecx + field_552], eax         # 004b96a6
    jl.d8 L_004b9705                             # 004b96ac
    # block 0x004b96ae: entered by fall-through of jl at 0x004b96ac, 10 instruction(s), ends with je to 0x004b9703 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b96ae
    mov dword ptr [edx + field_18], 0x1          # 004b96b1
    mov edi, 0x551e18                            # 004b96b8
    mov eax, dword ptr [ebp - local_8]           # 004b96bd
    mov esi, dword ptr [eax + field_8]           # 004b96c0
    add esi, 0x511                               # 004b96c3
    mov ecx, 0x9                                 # 004b96c9
    {load} xor edx, edx                          # 004b96ce
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b96d0
    je.d8 L_004b9703                             # 004b96d2
    # block 0x004b96d4: entered by fall-through of je at 0x004b96d2, 12 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004b9703
    mov eax, dword ptr [ebp - local_8]           # 004b96d4
    mov ecx, dword ptr [eax + field_8]           # 004b96d7
    add ecx, 0x511                               # 004b96da
    push ecx                                     # 004b96e0
    mov ecx, 0x5c3a67                            # 004b96e1
    call FUN_004fb77a                            # 004b96e6
    mov edx, dword ptr [ebp - local_8]           # 004b96eb
    mov eax, dword ptr [edx + field_8]           # 004b96ee
    mov cx, word ptr [eax + field_532]           # 004b96f1
    push ecx                                     # 004b96f8
    mov ecx, 0x5c3a67                            # 004b96f9
    call FUN_004fb2e3                            # 004b96fe
L_004b9703:
    # block 0x004b9703: entered by je at 0x004b96d2, 1 instruction(s), ends with forward jump to 0x004b9727
    jmp.d8 L_004b9727                            # 004b9703
L_004b9705:
    # block 0x004b9705: entered by jl at 0x004b96ac, 6 instruction(s), ends with jl to 0x004b9727 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b9705
    mov eax, dword ptr [edx + field_8]           # 004b9708
    movsx ecx, word ptr [eax + field_45e]        # 004b970b
    mov edx, dword ptr [ebp - local_8]           # 004b9712
    cmp dword ptr [edx + field_552], ecx         # 004b9715
    jl.d8 L_004b9727                             # 004b971b
    # block 0x004b971d: entered by fall-through of jl at 0x004b971b, 2 instruction(s), falls into the block at 0x004b9727
    mov eax, dword ptr [ebp - local_8]           # 004b971d
    mov dword ptr [eax + field_1c], 0x1          # 004b9720
L_004b9727:
    # block 0x004b9727: entered by jmp at 0x004b9703; jl at 0x004b971b, 1 instruction(s), ends with forward jump to 0x004b977f
    jmp.d8 L_004b977f                            # 004b9727
L_004b9729:
    # block 0x004b9729: entered by je at 0x004b944c, 4 instruction(s), calls KERNEL32.dll!GetTickCount, ends with jb to 0x004b977f (forward)
    call dword ptr [0x52a23c]                    # 004b9729
    mov ecx, dword ptr [ebp - local_8]           # 004b972f
    cmp eax, dword ptr [ecx + field_63d]         # 004b9732
    jb.d8 L_004b977f                             # 004b9738
    # block 0x004b973a: entered by fall-through of jb at 0x004b9738, 13 instruction(s), calls FUN_00445f53, FUN_00445fc5, falls into the block at 0x004b977f
    mov edx, dword ptr [ebp - local_8]           # 004b973a
    mov ax, word ptr [edx + field_552]           # 004b973d
    mov word ptr [0x5a4c0e], ax                  # 004b9744
    mov ecx, dword ptr [ebp - local_8]           # 004b974a
    movsx edx, word ptr [ecx + field_6]          # 004b974d
    imul edx, edx, 0x8d                          # 004b9751
    mov dword ptr [edx + 0x5bb632], 0x2          # 004b9757
    mov ecx, 0x638603                            # 004b9761
    call FUN_00445f53                            # 004b9766
    mov ecx, 0x638603                            # 004b976b
    call FUN_00445fc5                            # 004b9770
    mov eax, dword ptr [ebp - local_8]           # 004b9775
    mov dword ptr [eax + field_14], 0x0          # 004b9778
L_004b977f:
    # block 0x004b977f: entered by jmp at 0x004b9452; jmp at 0x004b965b; jmp at 0x004b9727; jb at 0x004b9738, 1 instruction(s), ends with forward jump to 0x004b9a80
    jmp.d32 L_004b9a80                           # 004b977f
L_004b9784:
    # block 0x004b9784: entered by je at 0x004b8eda, 8 instruction(s), ends with je to 0x004b97b7 (forward)
    mov edi, 0x551e24                            # 004b9784
    mov ecx, dword ptr [ebp - local_8]           # 004b9789
    mov esi, dword ptr [ecx + field_8]           # 004b978c
    add esi, 0x466                               # 004b978f
    mov ecx, 0x9                                 # 004b9795
    {load} xor edx, edx                          # 004b979a
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b979c
    je.d8 L_004b97b7                             # 004b979e
    # block 0x004b97a0: entered by fall-through of je at 0x004b979e, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004b97b7
    mov eax, dword ptr [ebp - local_8]           # 004b97a0
    mov ecx, dword ptr [eax + field_8]           # 004b97a3
    add ecx, 0x466                               # 004b97a6
    push ecx                                     # 004b97ac
    mov ecx, 0x5c3a67                            # 004b97ad
    call FUN_004fba69                            # 004b97b2
L_004b97b7:
    # block 0x004b97b7: entered by je at 0x004b979e, 8 instruction(s), ends with je to 0x004b97ea (forward)
    mov edi, 0x551e30                            # 004b97b7
    mov edx, dword ptr [ebp - local_8]           # 004b97bc
    mov esi, dword ptr [edx + field_8]           # 004b97bf
    add esi, 0x497                               # 004b97c2
    mov ecx, 0x9                                 # 004b97c8
    {load} xor eax, eax                          # 004b97cd
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b97cf
    je.d8 L_004b97ea                             # 004b97d1
    # block 0x004b97d3: entered by fall-through of je at 0x004b97d1, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004b97ea
    mov ecx, dword ptr [ebp - local_8]           # 004b97d3
    mov edx, dword ptr [ecx + field_8]           # 004b97d6
    add edx, 0x497                               # 004b97d9
    push edx                                     # 004b97df
    mov ecx, 0x5c3a67                            # 004b97e0
    call FUN_004fba69                            # 004b97e5
L_004b97ea:
    # block 0x004b97ea: entered by je at 0x004b97d1, 8 instruction(s), ends with je to 0x004b981d (forward)
    mov edi, 0x551e3c                            # 004b97ea
    mov eax, dword ptr [ebp - local_8]           # 004b97ef
    mov esi, dword ptr [eax + field_8]           # 004b97f2
    add esi, 0x4c8                               # 004b97f5
    mov ecx, 0x9                                 # 004b97fb
    {load} xor edx, edx                          # 004b9800
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b9802
    je.d8 L_004b981d                             # 004b9804
    # block 0x004b9806: entered by fall-through of je at 0x004b9804, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004b981d
    mov eax, dword ptr [ebp - local_8]           # 004b9806
    mov ecx, dword ptr [eax + field_8]           # 004b9809
    add ecx, 0x4c8                               # 004b980c
    push ecx                                     # 004b9812
    mov ecx, 0x5c3a67                            # 004b9813
    call FUN_004fba69                            # 004b9818
L_004b981d:
    # block 0x004b981d: entered by je at 0x004b9804, 3 instruction(s), ends with je to 0x004b9952 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b981d
    cmp dword ptr [edx + field_18], 0x0          # 004b9820
    je.d32 L_004b9952                            # 004b9824
    # block 0x004b982a: entered by fall-through of je at 0x004b9824, 8 instruction(s), ends with je to 0x004b985d (forward)
    mov edi, 0x551e48                            # 004b982a
    mov eax, dword ptr [ebp - local_8]           # 004b982f
    mov esi, dword ptr [eax + field_8]           # 004b9832
    add esi, 0x511                               # 004b9835
    mov ecx, 0x9                                 # 004b983b
    {load} xor edx, edx                          # 004b9840
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004b9842
    je.d8 L_004b985d                             # 004b9844
    # block 0x004b9846: entered by fall-through of je at 0x004b9844, 6 instruction(s), calls FUN_004fba69, falls into the block at 0x004b985d
    mov eax, dword ptr [ebp - local_8]           # 004b9846
    mov ecx, dword ptr [eax + field_8]           # 004b9849
    add ecx, 0x511                               # 004b984c
    push ecx                                     # 004b9852
    mov ecx, 0x5c3a67                            # 004b9853
    call FUN_004fba69                            # 004b9858
L_004b985d:
    # block 0x004b985d: entered by je at 0x004b9844, 5 instruction(s), ends with je to 0x004b9923 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b985d
    mov eax, dword ptr [edx + field_8]           # 004b9860
    movsx ecx, word ptr [eax + field_4f9]        # 004b9863
    cmp ecx, 0x270f                              # 004b986a
    je.d32 L_004b9923                            # 004b9870
    # block 0x004b9876: entered by fall-through of je at 0x004b9870, 33 instruction(s), ends with jne to 0x004b9919 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b9876
    mov eax, dword ptr [edx + field_8]           # 004b9879
    movsx ecx, word ptr [eax + field_4f9]        # 004b987c
    mov dword ptr [0x5bb57b], ecx                # 004b9883
    mov edx, dword ptr [ebp - local_8]           # 004b9889
    mov eax, dword ptr [edx + field_8]           # 004b988c
    mov cx, word ptr [eax + field_4fb]           # 004b988f
    mov word ptr [0x5bb599], cx                  # 004b9896
    mov edx, dword ptr [ebp - local_8]           # 004b989d
    mov eax, dword ptr [edx + field_8]           # 004b98a0
    mov cx, word ptr [eax + field_4fd]           # 004b98a3
    mov word ptr [0x5bb595], cx                  # 004b98aa
    mov edx, dword ptr [ebp - local_8]           # 004b98b1
    mov eax, dword ptr [edx + field_8]           # 004b98b4
    mov cx, word ptr [eax + field_4ff]           # 004b98b7
    mov word ptr [0x5c39ff], cx                  # 004b98be
    mov edx, dword ptr [ebp - local_8]           # 004b98c5
    mov eax, dword ptr [edx + field_8]           # 004b98c8
    mov ecx, dword ptr [eax + field_501]         # 004b98cb
    mov dword ptr [0x5bb59b], ecx                # 004b98d1
    mov edx, dword ptr [ebp - local_8]           # 004b98d7
    mov eax, dword ptr [edx + field_8]           # 004b98da
    mov ecx, dword ptr [eax + field_505]         # 004b98dd
    mov dword ptr [0x5bb59f], ecx                # 004b98e3
    mov edx, dword ptr [ebp - local_8]           # 004b98e9
    mov eax, dword ptr [edx + field_8]           # 004b98ec
    mov ecx, dword ptr [eax + field_509]         # 004b98ef
    mov dword ptr [0x5bb5a3], ecx                # 004b98f5
    mov edx, dword ptr [ebp - local_8]           # 004b98fb
    mov eax, dword ptr [edx + field_8]           # 004b98fe
    movsx ecx, word ptr [eax + field_50d]        # 004b9901
    cmp ecx, 0x1                                 # 004b9908
    jne.d8 L_004b9919                            # 004b990b
    # block 0x004b990d: entered by fall-through of jne at 0x004b990b, 2 instruction(s), ends with forward jump to 0x004b9923
    mov dword ptr [0x5bb1ca], 0x0                # 004b990d
    jmp.d8 L_004b9923                            # 004b9917
L_004b9919:
    # block 0x004b9919: entered by jne at 0x004b990b, 1 instruction(s), falls into the block at 0x004b9923
    mov dword ptr [0x5bb1ca], 0x1                # 004b9919
L_004b9923:
    # block 0x004b9923: entered by je at 0x004b9870; jmp at 0x004b9917, 5 instruction(s), ends with je to 0x004b994d (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b9923
    mov eax, dword ptr [edx + field_8]           # 004b9926
    movsx ecx, word ptr [eax + field_50f]        # 004b9929
    cmp ecx, -0x1                                # 004b9930
    je.d8 L_004b994d                             # 004b9933
    # block 0x004b9935: entered by fall-through of je at 0x004b9933, 4 instruction(s), falls into the block at 0x004b994d
    mov edx, dword ptr [ebp - local_8]           # 004b9935
    mov eax, dword ptr [edx + field_8]           # 004b9938
    movsx ecx, word ptr [eax + field_50f]        # 004b993b
    mov dword ptr [4*ecx + 0x585801], 0x1        # 004b9942
L_004b994d:
    # block 0x004b994d: entered by je at 0x004b9933, 1 instruction(s), ends with forward jump to 0x004b9a5e
    jmp.d32 L_004b9a5e                           # 004b994d
L_004b9952:
    # block 0x004b9952: entered by je at 0x004b9824, 33 instruction(s), ends with jne to 0x004b99f5 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b9952
    mov eax, dword ptr [edx + field_8]           # 004b9955
    movsx ecx, word ptr [eax + field_542]        # 004b9958
    mov dword ptr [0x5bb57b], ecx                # 004b995f
    mov edx, dword ptr [ebp - local_8]           # 004b9965
    mov eax, dword ptr [edx + field_8]           # 004b9968
    mov cx, word ptr [eax + field_544]           # 004b996b
    mov word ptr [0x5bb599], cx                  # 004b9972
    mov edx, dword ptr [ebp - local_8]           # 004b9979
    mov eax, dword ptr [edx + field_8]           # 004b997c
    mov cx, word ptr [eax + field_546]           # 004b997f
    mov word ptr [0x5bb595], cx                  # 004b9986
    mov edx, dword ptr [ebp - local_8]           # 004b998d
    mov eax, dword ptr [edx + field_8]           # 004b9990
    mov cx, word ptr [eax + field_548]           # 004b9993
    mov word ptr [0x5c39ff], cx                  # 004b999a
    mov edx, dword ptr [ebp - local_8]           # 004b99a1
    mov eax, dword ptr [edx + field_8]           # 004b99a4
    mov ecx, dword ptr [eax + field_54a]         # 004b99a7
    mov dword ptr [0x5bb59b], ecx                # 004b99ad
    mov edx, dword ptr [ebp - local_8]           # 004b99b3
    mov eax, dword ptr [edx + field_8]           # 004b99b6
    mov ecx, dword ptr [eax + field_54e]         # 004b99b9
    mov dword ptr [0x5bb59f], ecx                # 004b99bf
    mov edx, dword ptr [ebp - local_8]           # 004b99c5
    mov eax, dword ptr [edx + field_8]           # 004b99c8
    mov ecx, dword ptr [eax + field_552]         # 004b99cb
    mov dword ptr [0x5bb5a3], ecx                # 004b99d1
    mov edx, dword ptr [ebp - local_8]           # 004b99d7
    mov eax, dword ptr [edx + field_8]           # 004b99da
    movsx ecx, word ptr [eax + field_556]        # 004b99dd
    cmp ecx, 0x1                                 # 004b99e4
    jne.d8 L_004b99f5                            # 004b99e7
    # block 0x004b99e9: entered by fall-through of jne at 0x004b99e7, 2 instruction(s), ends with forward jump to 0x004b99ff
    mov dword ptr [0x5bb1ca], 0x0                # 004b99e9
    jmp.d8 L_004b99ff                            # 004b99f3
L_004b99f5:
    # block 0x004b99f5: entered by jne at 0x004b99e7, 1 instruction(s), falls into the block at 0x004b99ff
    mov dword ptr [0x5bb1ca], 0x1                # 004b99f5
L_004b99ff:
    # block 0x004b99ff: entered by jmp at 0x004b99f3, 3 instruction(s), ends with je to 0x004b9a34 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004b99ff
    cmp dword ptr [edx + field_1c], 0x0          # 004b9a02
    je.d8 L_004b9a34                             # 004b9a06
    # block 0x004b9a08: entered by fall-through of je at 0x004b9a06, 5 instruction(s), ends with je to 0x004b9a34 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b9a08
    mov ecx, dword ptr [eax + field_8]           # 004b9a0b
    movsx edx, word ptr [ecx + field_558]        # 004b9a0e
    cmp edx, -0x1                                # 004b9a15
    je.d8 L_004b9a34                             # 004b9a18
    # block 0x004b9a1a: entered by fall-through of je at 0x004b9a18, 5 instruction(s), ends with forward jump to 0x004b9a5e
    mov eax, dword ptr [ebp - local_8]           # 004b9a1a
    mov ecx, dword ptr [eax + field_8]           # 004b9a1d
    movsx edx, word ptr [ecx + field_558]        # 004b9a20
    mov dword ptr [4*edx + 0x585801], 0x1        # 004b9a27
    jmp.d8 L_004b9a5e                            # 004b9a32
L_004b9a34:
    # block 0x004b9a34: entered by je at 0x004b9a06; je at 0x004b9a18, 5 instruction(s), ends with je to 0x004b9a5e (forward)
    mov eax, dword ptr [ebp - local_8]           # 004b9a34
    mov ecx, dword ptr [eax + field_8]           # 004b9a37
    movsx edx, word ptr [ecx + field_55a]        # 004b9a3a
    cmp edx, -0x1                                # 004b9a41
    je.d8 L_004b9a5e                             # 004b9a44
    # block 0x004b9a46: entered by fall-through of je at 0x004b9a44, 4 instruction(s), falls into the block at 0x004b9a5e
    mov eax, dword ptr [ebp - local_8]           # 004b9a46
    mov ecx, dword ptr [eax + field_8]           # 004b9a49
    movsx edx, word ptr [ecx + field_55a]        # 004b9a4c
    mov dword ptr [4*edx + 0x585801], 0x1        # 004b9a53
L_004b9a5e:
    # block 0x004b9a5e: entered by jmp at 0x004b994d; jmp at 0x004b9a32; je at 0x004b9a44, 8 instruction(s), calls FUN_0042ba3a, FUN_004b7ff4, falls into the block at 0x004b9a80
    mov dword ptr [0x583999], 0x4                # 004b9a5e
    mov eax, dword ptr [ebp - local_8]           # 004b9a68
    mov cx, word ptr [eax + field_6]             # 004b9a6b
    push ecx                                     # 004b9a6f
    call FUN_0042ba3a                            # 004b9a70
    add esp, 0x4                                 # 004b9a75
    mov ecx, dword ptr [ebp - local_8]           # 004b9a78
    call FUN_004b7ff4                            # 004b9a7b
L_004b9a80:
    # block 0x004b9a80: entered by jmp at 0x004b8ee0; jmp at 0x004b942a; jmp at 0x004b977f, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 004b9a80
    pop esi                                      # 004b9a81
    {load} mov esp, ebp                          # 004b9a82
    pop ebp                                      # 004b9a84
    ret 0x4                                      # 004b9a85

