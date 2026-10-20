# FUN_004e8e78
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e8e78
# extent:       0x004e8e78-0x004e94a9 (1585 code bytes)
# span:         0x004e8e78-0x004e94a9 (code 1585, tables 0, padding 0)
# sha256:       6bf1f75ca5cb3d5d11d9633d02ef57915a87f2453f48253feda12440dc5c9c3a
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_inventory_view_click_branch
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_view_runtime.h:186 says "One left click (0x4e8dc8 -> 0x4e8e78)."; src/blackmoor_app.mm:3573 says "A left button down or double click: 0x4e8dc8 -> 0x4e8e78 with the hot item of the"
# name-note:    Left-click branch of the inventory view, reached from 0x4e8dc8 with the hot item.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       13 ebp-relative slot(s): local_5, local_7, local_b, local_d, local_f, local_11, local_13, local_34, local_38, local_3c, local_40, local_7c and 1 more
# fields:       [eax + n] field_56, field_710, field_74e, field_77e, field_6b1c, field_7011, field_8256; [ecx + n] field_56, field_77, field_69d, field_70e, field_780, field_6b1c, field_8286; [edi + n] field_minus_1; [edx + n] field_74e, field_780, field_6b1c
# callees:      calls FUN_004ea269, FUN_004f6334, FUN_00423259, FUN_004fb77a, FUN_004fb2e3, FUN_0050cd50, FUN_00448d11, FUN_004ea06c, FUN_004e7d04, FUN_004e9e84
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 436 instruction(s), 31 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_5, 0x5  # offset -0x5
.equ local_7, 0x7  # offset -0x7
.equ local_b, 0xb  # offset -0xb
.equ local_d, 0xd  # offset -0xd
.equ local_f, 0xf  # offset -0xf
.equ local_11, 0x11  # offset -0x11
.equ local_13, 0x13  # offset -0x13
.equ local_34, 0x34  # offset -0x34
.equ local_38, 0x38  # offset -0x38
.equ local_3c, 0x3c  # offset -0x3c
.equ local_40, 0x40  # offset -0x40
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ field_56, 0x56  # offset +0x56
.equ field_77, 0x77  # offset +0x77
.equ field_69d, 0x69d  # offset +0x69d
.equ field_70e, 0x70e  # offset +0x70e
.equ field_710, 0x710  # offset +0x710
.equ field_74e, 0x74e  # offset +0x74e
.equ field_77e, 0x77e  # offset +0x77e
.equ field_780, 0x780  # offset +0x780
.equ field_6b1c, 0x6b1c  # offset +0x6b1c
.equ field_7011, 0x7011  # offset +0x7011
.equ field_8256, 0x8256  # offset +0x8256
.equ field_8286, 0x8286  # offset +0x8286

# --- external targets -----------------------------------------------
.set FUN_00423259, .text + (0x00423259 - 0x401000)
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004e7d04, .text + (0x004e7d04 - 0x401000)
.set FUN_004e9e84, .text + (0x004e9e84 - 0x401000)
.set FUN_004ea06c, .text + (0x004ea06c - 0x401000)
.set FUN_004ea269, .text + (0x004ea269 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004e8e78 - 0x401000
.globl FUN_004e8e78
FUN_004e8e78:
    # block 0x004e8e78: entry, 10 instruction(s), ends with je to 0x004e8f2f (forward)
    push ebp                                     # 004e8e78
    {load} mov ebp, esp                          # 004e8e79
    sub esp, 0x80                                # 004e8e7b
    push esi                                     # 004e8e81
    push edi                                     # 004e8e82
    mov dword ptr [ebp - local_80], ecx          # 004e8e83
    mov dword ptr [ebp - local_38], 0x0          # 004e8e86
    mov eax, dword ptr [ebp - local_80]          # 004e8e8d
    cmp dword ptr [eax + field_6b1c], -0x1       # 004e8e90
    je.d32 L_004e8f2f                            # 004e8e97
    # block 0x004e8e9d: entered by fall-through of je at 0x004e8e97, 7 instruction(s), ends with jne to 0x004e8f2f (forward)
    mov ecx, dword ptr [ebp - local_80]          # 004e8e9d
    mov edx, dword ptr [ecx + field_6b1c]        # 004e8ea0
    imul edx, edx, 0x16d                         # 004e8ea6
    mov eax, dword ptr [ebp - local_80]          # 004e8eac
    movsx ecx, word ptr [eax + edx + field_77e]  # 004e8eaf
    cmp ecx, 0x3                                 # 004e8eb7
    jne.d8 L_004e8f2f                            # 004e8eba
    # block 0x004e8ebc: entered by fall-through of jne at 0x004e8eba, 7 instruction(s), ends with je to 0x004e8f2f (forward)
    mov edx, dword ptr [ebp - local_80]          # 004e8ebc
    mov eax, dword ptr [edx + field_6b1c]        # 004e8ebf
    imul eax, eax, 0x16d                         # 004e8ec5
    mov ecx, dword ptr [ebp - local_80]          # 004e8ecb
    movsx edx, word ptr [ecx + eax + field_780]  # 004e8ece
    test edx, edx                                # 004e8ed6
    je.d8 L_004e8f2f                             # 004e8ed8
    # block 0x004e8eda: entered by fall-through of je at 0x004e8ed8, 7 instruction(s), ends with je to 0x004e8f2f (forward)
    mov eax, dword ptr [ebp - local_80]          # 004e8eda
    mov ecx, dword ptr [eax + field_6b1c]        # 004e8edd
    imul ecx, ecx, 0x16d                         # 004e8ee3
    mov edx, dword ptr [ebp - local_80]          # 004e8ee9
    movsx eax, word ptr [edx + ecx + field_780]  # 004e8eec
    cmp eax, 0x270f                              # 004e8ef4
    je.d8 L_004e8f2f                             # 004e8ef9
    # block 0x004e8efb: entered by fall-through of je at 0x004e8ef9, 4 instruction(s), ends with jne to 0x004e8f2f (forward)
    mov ecx, dword ptr [ebp - local_80]          # 004e8efb
    mov edx, dword ptr [ecx + field_6b1c]        # 004e8efe
    cmp dword ptr [4*edx + 0x583ced], 0x0        # 004e8f04
    jne.d8 L_004e8f2f                            # 004e8f0c
    # block 0x004e8f0e: entered by fall-through of jne at 0x004e8f0c, 9 instruction(s), calls FUN_004ea269, ends with forward jump to 0x004e94a3
    push 0x1                                     # 004e8f0e
    push 0x1                                     # 004e8f10
    mov eax, dword ptr [ebp - local_80]          # 004e8f12
    mov cx, word ptr [eax + field_6b1c]          # 004e8f15
    push ecx                                     # 004e8f1c
    mov ecx, dword ptr [ebp - local_80]          # 004e8f1d
    call FUN_004ea269                            # 004e8f20
    mov eax, 0x1                                 # 004e8f25
    jmp.d32 L_004e94a3                           # 004e8f2a
L_004e8f2f:
    # block 0x004e8f2f: entered by je at 0x004e8e97; jne at 0x004e8eba; je at 0x004e8ed8; je at 0x004e8ef9; jne at 0x004e8f0c, 3 instruction(s), ends with je to 0x004e93da (forward)
    mov edx, dword ptr [ebp - local_80]          # 004e8f2f
    cmp dword ptr [edx + field_6b1c], -0x1       # 004e8f32
    je.d32 L_004e93da                            # 004e8f39
    # block 0x004e8f3f: entered by fall-through of je at 0x004e8f39, 4 instruction(s), ends with jne to 0x004e93da (forward)
    mov eax, dword ptr [ebp - local_80]          # 004e8f3f
    mov ecx, dword ptr [eax + field_6b1c]        # 004e8f42
    cmp dword ptr [4*ecx + 0x583ced], 0x1        # 004e8f48
    jne.d32 L_004e93da                           # 004e8f50
    # block 0x004e8f56: entered by fall-through of jne at 0x004e8f50, 4 instruction(s), ends with jne to 0x004e93da (forward)
    mov edx, dword ptr [ebp - local_80]          # 004e8f56
    mov eax, dword ptr [edx + field_6b1c]        # 004e8f59
    cmp dword ptr [4*eax + 0x583e05], 0x1        # 004e8f5f
    jne.d32 L_004e93da                           # 004e8f67
    # block 0x004e8f6d: entered by fall-through of jne at 0x004e8f67, 7 instruction(s), ends with je to 0x004e90c7 (forward)
    mov ecx, dword ptr [ebp - local_80]          # 004e8f6d
    mov edx, dword ptr [ecx + field_6b1c]        # 004e8f70
    imul edx, edx, 0x6e                          # 004e8f76
    {load} xor eax, eax                          # 004e8f79
    mov al, byte ptr [edx + 0x583f1f]            # 004e8f7b
    test eax, eax                                # 004e8f81
    je.d32 L_004e90c7                            # 004e8f83
    # block 0x004e8f89: entered by fall-through of je at 0x004e8f83, 9 instruction(s), ends with je to 0x004e90c2 (forward)
    mov edi, 0x55c63c                            # 004e8f89
    mov ecx, dword ptr [ebp - local_80]          # 004e8f8e
    mov esi, dword ptr [ecx + field_6b1c]        # 004e8f91
    imul esi, esi, 0x6e                          # 004e8f97
    add esi, 0x583f5c                            # 004e8f9a
    mov ecx, 0x9                                 # 004e8fa0
    {load} xor edx, edx                          # 004e8fa5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e8fa7
    je.d32 L_004e90c2                            # 004e8fa9
    # block 0x004e8faf: entered by fall-through of je at 0x004e8fa9, 5 instruction(s), calls FUN_004f6334, ends with jne to 0x004e90c2 (forward)
    push 0x11                                    # 004e8faf
    mov ecx, 0x5cf1eb                            # 004e8fb1
    call FUN_004f6334                            # 004e8fb6
    test eax, eax                                # 004e8fbb
    jne.d32 L_004e90c2                           # 004e8fbd
    # block 0x004e8fc3: entered by fall-through of jne at 0x004e8fbd, 2 instruction(s), ends with je to 0x004e9099 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004e8fc3
    je.d32 L_004e9099                            # 004e8fca
    # block 0x004e8fd0: entered by fall-through of je at 0x004e8fca, 10 instruction(s), calls FUN_00423259, ends with je to 0x004e9065 (forward)
    mov eax, dword ptr [ebp - local_80]          # 004e8fd0
    mov ecx, dword ptr [eax + field_6b1c]        # 004e8fd3
    imul ecx, ecx, 0x6e                          # 004e8fd9
    add ecx, 0x583f5c                            # 004e8fdc
    push ecx                                     # 004e8fe2
    mov ecx, 0x619a6b                            # 004e8fe3
    call FUN_00423259                            # 004e8fe8
    mov dword ptr [ebp - local_38], eax          # 004e8fed
    cmp dword ptr [ebp - local_38], 0x0          # 004e8ff0
    je.d8 L_004e9065                             # 004e8ff4
    # block 0x004e8ff6: entered by fall-through of je at 0x004e8ff4, 8 instruction(s), ends with ja to 0x004e902f (forward)
    mov edi, dword ptr [ebp - local_38]          # 004e8ff6
    or ecx, -0x1                                 # 004e8ff9
    {load} xor eax, eax                          # 004e8ffc
    repne scasb al, byte ptr es:[edi]            # 004e8ffe
    not ecx                                      # 004e9000
    add ecx, -0x1                                # 004e9002
    cmp ecx, 0x3c                                # 004e9005
    ja.d8 L_004e902f                             # 004e9008
    # block 0x004e900a: entered by fall-through of ja at 0x004e9008, 16 instruction(s), ends with forward jump to 0x004e9063
    mov edi, dword ptr [ebp - local_38]          # 004e900a
    lea edx, [ebp - local_7c]                    # 004e900d
    or ecx, -0x1                                 # 004e9010
    {load} xor eax, eax                          # 004e9013
    repne scasb al, byte ptr es:[edi]            # 004e9015
    not ecx                                      # 004e9017
    {load} sub edi, ecx                          # 004e9019
    {load} mov esi, edi                          # 004e901b
    {load} mov eax, ecx                          # 004e901d
    {load} mov edi, edx                          # 004e901f
    shr ecx, 0x2                                 # 004e9021
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e9024
    {load} mov ecx, eax                          # 004e9026
    and ecx, 0x3                                 # 004e9028
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e902b
    jmp.d8 L_004e9063                            # 004e902d
L_004e902f:
    # block 0x004e902f: entered by ja at 0x004e9008, 19 instruction(s), falls into the block at 0x004e9063
    mov ecx, dword ptr [ebp - local_80]          # 004e902f
    mov edx, dword ptr [ecx + field_6b1c]        # 004e9032
    imul edx, edx, 0x6e                          # 004e9038
    add edx, 0x583f20                            # 004e903b
    {load} mov edi, edx                          # 004e9041
    lea edx, [ebp - local_7c]                    # 004e9043
    or ecx, -0x1                                 # 004e9046
    {load} xor eax, eax                          # 004e9049
    repne scasb al, byte ptr es:[edi]            # 004e904b
    not ecx                                      # 004e904d
    {load} sub edi, ecx                          # 004e904f
    {load} mov esi, edi                          # 004e9051
    {load} mov eax, ecx                          # 004e9053
    {load} mov edi, edx                          # 004e9055
    shr ecx, 0x2                                 # 004e9057
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e905a
    {load} mov ecx, eax                          # 004e905c
    and ecx, 0x3                                 # 004e905e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e9061
L_004e9063:
    # block 0x004e9063: entered by jmp at 0x004e902d, 1 instruction(s), ends with forward jump to 0x004e9099
    jmp.d8 L_004e9099                            # 004e9063
L_004e9065:
    # block 0x004e9065: entered by je at 0x004e8ff4, 19 instruction(s), falls into the block at 0x004e9099
    mov ecx, dword ptr [ebp - local_80]          # 004e9065
    mov edx, dword ptr [ecx + field_6b1c]        # 004e9068
    imul edx, edx, 0x6e                          # 004e906e
    add edx, 0x583f20                            # 004e9071
    {load} mov edi, edx                          # 004e9077
    lea edx, [ebp - local_7c]                    # 004e9079
    or ecx, -0x1                                 # 004e907c
    {load} xor eax, eax                          # 004e907f
    repne scasb al, byte ptr es:[edi]            # 004e9081
    not ecx                                      # 004e9083
    {load} sub edi, ecx                          # 004e9085
    {load} mov esi, edi                          # 004e9087
    {load} mov eax, ecx                          # 004e9089
    {load} mov edi, edx                          # 004e908b
    shr ecx, 0x2                                 # 004e908d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e9090
    {load} mov ecx, eax                          # 004e9092
    and ecx, 0x3                                 # 004e9094
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e9097
L_004e9099:
    # block 0x004e9099: entered by je at 0x004e8fca; jmp at 0x004e9063, 10 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004e90c2
    mov ecx, dword ptr [ebp - local_80]          # 004e9099
    mov edx, dword ptr [ecx + field_6b1c]        # 004e909c
    imul edx, edx, 0x6e                          # 004e90a2
    add edx, 0x583f5c                            # 004e90a5
    push edx                                     # 004e90ab
    mov ecx, 0x5c3a67                            # 004e90ac
    call FUN_004fb77a                            # 004e90b1
    push 0x11                                    # 004e90b6
    mov ecx, 0x5c3a67                            # 004e90b8
    call FUN_004fb2e3                            # 004e90bd
L_004e90c2:
    # block 0x004e90c2: entered by je at 0x004e8fa9; jne at 0x004e8fbd, 1 instruction(s), ends with forward jump to 0x004e937a
    jmp.d32 L_004e937a                           # 004e90c2
L_004e90c7:
    # block 0x004e90c7: entered by je at 0x004e8f83, 1 instruction(s), falls into the block at 0x004e90ce
    mov dword ptr [ebp - local_3c], 0x1          # 004e90c7
L_004e90ce:
    # block 0x004e90ce: entered by jmp at 0x004e9143, 2 instruction(s), ends with jg to 0x004e9145 (forward)
    cmp dword ptr [ebp - local_3c], 0x2          # 004e90ce
    jg.d8 L_004e9145                             # 004e90d2
    # block 0x004e90d4: entered by fall-through of jg at 0x004e90d2, 13 instruction(s), ends with je to 0x004e9145 (forward)
    mov edi, 0x55c648                            # 004e90d4
    mov eax, dword ptr [ebp - local_80]          # 004e90d9
    mov ecx, dword ptr [eax + field_6b1c]        # 004e90dc
    imul ecx, ecx, 0x16d                         # 004e90e2
    mov edx, dword ptr [ebp - local_80]          # 004e90e8
    lea eax, [edx + ecx + field_74e]             # 004e90eb
    mov ecx, dword ptr [ebp - local_3c]          # 004e90f2
    imul ecx, ecx, 0x5d                          # 004e90f5
    lea esi, [eax + ecx + field_56]              # 004e90f8
    mov ecx, 0x9                                 # 004e90fc
    {load} xor edx, edx                          # 004e9101
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e9103
    je.d8 L_004e9145                             # 004e9105
    # block 0x004e9107: entered by fall-through of je at 0x004e9105, 13 instruction(s), ends with je to 0x004e9145 (forward)
    mov edi, 0x63a9f8                            # 004e9107
    mov eax, dword ptr [ebp - local_80]          # 004e910c
    mov ecx, dword ptr [eax + field_6b1c]        # 004e910f
    imul ecx, ecx, 0x16d                         # 004e9115
    mov edx, dword ptr [ebp - local_80]          # 004e911b
    lea eax, [edx + ecx + field_74e]             # 004e911e
    mov ecx, dword ptr [ebp - local_3c]          # 004e9125
    imul ecx, ecx, 0x5d                          # 004e9128
    lea esi, [eax + ecx + field_56]              # 004e912b
    mov ecx, 0x1                                 # 004e912f
    {load} xor edx, edx                          # 004e9134
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e9136
    je.d8 L_004e9145                             # 004e9138
    # block 0x004e913a: entered by fall-through of je at 0x004e9138, 4 instruction(s), ends with backward jump to 0x004e90ce
    mov eax, dword ptr [ebp - local_3c]          # 004e913a
    add eax, 0x1                                 # 004e913d
    mov dword ptr [ebp - local_3c], eax          # 004e9140
    jmp.d8 L_004e90ce                            # 004e9143
L_004e9145:
    # block 0x004e9145: entered by jg at 0x004e90d2; je at 0x004e9105; je at 0x004e9138, 17 instruction(s), calls FUN_0050cd50, ends with je to 0x004e937a (forward)
    call FUN_0050cd50                            # 004e9145
    cdq                                          # 004e914a
    idiv dword ptr [ebp - local_3c]              # 004e914b
    mov dword ptr [ebp - local_40], edx          # 004e914e
    mov edi, 0x55c654                            # 004e9151
    mov ecx, dword ptr [ebp - local_80]          # 004e9156
    mov edx, dword ptr [ecx + field_6b1c]        # 004e9159
    imul edx, edx, 0x16d                         # 004e915f
    mov eax, dword ptr [ebp - local_80]          # 004e9165
    lea ecx, [eax + edx + field_74e]             # 004e9168
    mov edx, dword ptr [ebp - local_40]          # 004e916f
    imul edx, edx, 0x5d                          # 004e9172
    lea esi, [ecx + edx + field_56]              # 004e9175
    mov ecx, 0x9                                 # 004e9179
    {load} xor eax, eax                          # 004e917e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e9180
    je.d32 L_004e937a                            # 004e9182
    # block 0x004e9188: entered by fall-through of je at 0x004e9182, 13 instruction(s), ends with je to 0x004e937a (forward)
    mov edi, 0x63a9fc                            # 004e9188
    mov ecx, dword ptr [ebp - local_80]          # 004e918d
    mov edx, dword ptr [ecx + field_6b1c]        # 004e9190
    imul edx, edx, 0x16d                         # 004e9196
    mov eax, dword ptr [ebp - local_80]          # 004e919c
    lea ecx, [eax + edx + field_74e]             # 004e919f
    mov edx, dword ptr [ebp - local_40]          # 004e91a6
    imul edx, edx, 0x5d                          # 004e91a9
    lea esi, [ecx + edx + field_56]              # 004e91ac
    mov ecx, 0x1                                 # 004e91b0
    {load} xor eax, eax                          # 004e91b5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004e91b7
    je.d32 L_004e937a                            # 004e91b9
    # block 0x004e91bf: entered by fall-through of je at 0x004e91b9, 5 instruction(s), calls FUN_004f6334, ends with jne to 0x004e937a (forward)
    push 0x11                                    # 004e91bf
    mov ecx, 0x5cf1eb                            # 004e91c1
    call FUN_004f6334                            # 004e91c6
    test eax, eax                                # 004e91cb
    jne.d32 L_004e937a                           # 004e91cd
    # block 0x004e91d3: entered by fall-through of jne at 0x004e91cd, 2 instruction(s), ends with je to 0x004e92e0 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004e91d3
    je.d32 L_004e92e0                            # 004e91da
    # block 0x004e91e0: entered by fall-through of je at 0x004e91da, 14 instruction(s), calls FUN_00423259, ends with je to 0x004e929b (forward)
    mov ecx, dword ptr [ebp - local_80]          # 004e91e0
    mov edx, dword ptr [ecx + field_6b1c]        # 004e91e3
    imul edx, edx, 0x16d                         # 004e91e9
    mov eax, dword ptr [ebp - local_80]          # 004e91ef
    lea ecx, [eax + edx + field_74e]             # 004e91f2
    mov edx, dword ptr [ebp - local_40]          # 004e91f9
    imul edx, edx, 0x5d                          # 004e91fc
    lea eax, [ecx + edx + field_56]              # 004e91ff
    push eax                                     # 004e9203
    mov ecx, 0x619a6b                            # 004e9204
    call FUN_00423259                            # 004e9209
    mov dword ptr [ebp - local_38], eax          # 004e920e
    cmp dword ptr [ebp - local_38], 0x0          # 004e9211
    je.d32 L_004e929b                            # 004e9215
    # block 0x004e921b: entered by fall-through of je at 0x004e9215, 8 instruction(s), ends with ja to 0x004e9254 (forward)
    mov edi, dword ptr [ebp - local_38]          # 004e921b
    or ecx, -0x1                                 # 004e921e
    {load} xor eax, eax                          # 004e9221
    repne scasb al, byte ptr es:[edi]            # 004e9223
    not ecx                                      # 004e9225
    add ecx, -0x1                                # 004e9227
    cmp ecx, 0x3c                                # 004e922a
    ja.d8 L_004e9254                             # 004e922d
    # block 0x004e922f: entered by fall-through of ja at 0x004e922d, 16 instruction(s), ends with forward jump to 0x004e9299
    mov edi, dword ptr [ebp - local_38]          # 004e922f
    lea edx, [ebp - local_7c]                    # 004e9232
    or ecx, -0x1                                 # 004e9235
    {load} xor eax, eax                          # 004e9238
    repne scasb al, byte ptr es:[edi]            # 004e923a
    not ecx                                      # 004e923c
    {load} sub edi, ecx                          # 004e923e
    {load} mov esi, edi                          # 004e9240
    {load} mov eax, ecx                          # 004e9242
    {load} mov edi, edx                          # 004e9244
    shr ecx, 0x2                                 # 004e9246
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e9249
    {load} mov ecx, eax                          # 004e924b
    and ecx, 0x3                                 # 004e924d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e9250
    jmp.d8 L_004e9299                            # 004e9252
L_004e9254:
    # block 0x004e9254: entered by ja at 0x004e922d, 23 instruction(s), falls into the block at 0x004e9299
    mov ecx, dword ptr [ebp - local_80]          # 004e9254
    mov edx, dword ptr [ecx + field_6b1c]        # 004e9257
    imul edx, edx, 0x16d                         # 004e925d
    mov eax, dword ptr [ebp - local_80]          # 004e9263
    lea ecx, [eax + edx + field_74e]             # 004e9266
    mov edx, dword ptr [ebp - local_40]          # 004e926d
    imul edx, edx, 0x5d                          # 004e9270
    lea eax, [ecx + edx + field_77]              # 004e9273
    {load} mov edi, eax                          # 004e9277
    lea edx, [ebp - local_7c]                    # 004e9279
    or ecx, -0x1                                 # 004e927c
    {load} xor eax, eax                          # 004e927f
    repne scasb al, byte ptr es:[edi]            # 004e9281
    not ecx                                      # 004e9283
    {load} sub edi, ecx                          # 004e9285
    {load} mov esi, edi                          # 004e9287
    {load} mov eax, ecx                          # 004e9289
    {load} mov edi, edx                          # 004e928b
    shr ecx, 0x2                                 # 004e928d
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e9290
    {load} mov ecx, eax                          # 004e9292
    and ecx, 0x3                                 # 004e9294
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e9297
L_004e9299:
    # block 0x004e9299: entered by jmp at 0x004e9252, 1 instruction(s), ends with forward jump to 0x004e92e0
    jmp.d8 L_004e92e0                            # 004e9299
L_004e929b:
    # block 0x004e929b: entered by je at 0x004e9215, 23 instruction(s), falls into the block at 0x004e92e0
    mov ecx, dword ptr [ebp - local_80]          # 004e929b
    mov edx, dword ptr [ecx + field_6b1c]        # 004e929e
    imul edx, edx, 0x16d                         # 004e92a4
    mov eax, dword ptr [ebp - local_80]          # 004e92aa
    lea ecx, [eax + edx + field_74e]             # 004e92ad
    mov edx, dword ptr [ebp - local_40]          # 004e92b4
    imul edx, edx, 0x5d                          # 004e92b7
    lea eax, [ecx + edx + field_77]              # 004e92ba
    {load} mov edi, eax                          # 004e92be
    lea edx, [ebp - local_7c]                    # 004e92c0
    or ecx, -0x1                                 # 004e92c3
    {load} xor eax, eax                          # 004e92c6
    repne scasb al, byte ptr es:[edi]            # 004e92c8
    not ecx                                      # 004e92ca
    {load} sub edi, ecx                          # 004e92cc
    {load} mov esi, edi                          # 004e92ce
    {load} mov eax, ecx                          # 004e92d0
    {load} mov edi, edx                          # 004e92d2
    shr ecx, 0x2                                 # 004e92d4
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e92d7
    {load} mov ecx, eax                          # 004e92d9
    and ecx, 0x3                                 # 004e92db
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e92de
L_004e92e0:
    # block 0x004e92e0: entered by je at 0x004e91da; jmp at 0x004e9299, 41 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, falls into the block at 0x004e937a
    mov ecx, dword ptr [ebp - local_80]          # 004e92e0
    mov edx, dword ptr [ecx + field_6b1c]        # 004e92e3
    imul edx, edx, 0x16d                         # 004e92e9
    mov eax, dword ptr [ebp - local_80]          # 004e92ef
    lea ecx, [eax + edx + field_74e]             # 004e92f2
    mov edx, dword ptr [ebp - local_40]          # 004e92f9
    imul edx, edx, 0x5d                          # 004e92fc
    lea eax, [ecx + edx + field_56]              # 004e92ff
    {load} mov edi, eax                          # 004e9303
    lea edx, [ebp - local_34]                    # 004e9305
    or ecx, -0x1                                 # 004e9308
    {load} xor eax, eax                          # 004e930b
    repne scasb al, byte ptr es:[edi]            # 004e930d
    not ecx                                      # 004e930f
    {load} sub edi, ecx                          # 004e9311
    {load} mov esi, edi                          # 004e9313
    {load} mov eax, ecx                          # 004e9315
    {load} mov edi, edx                          # 004e9317
    shr ecx, 0x2                                 # 004e9319
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e931c
    {load} mov ecx, eax                          # 004e931e
    and ecx, 0x3                                 # 004e9320
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004e9323
    mov word ptr [ebp - local_13], 0x11          # 004e9325
    mov word ptr [ebp - local_11], 0x1           # 004e932b
    mov word ptr [ebp - local_f], 0x1            # 004e9331
    mov word ptr [ebp - local_d], 0x1            # 004e9337
    mov dword ptr [ebp - local_b], 0x1           # 004e933d
    mov ecx, dword ptr [ebp - local_80]          # 004e9344
    mov dx, word ptr [ecx + field_70e]           # 004e9347
    mov word ptr [ebp - local_7], dx             # 004e934e
    mov eax, dword ptr [ebp - local_80]          # 004e9352
    mov cx, word ptr [eax + field_710]           # 004e9355
    mov word ptr [ebp - local_5], cx             # 004e935c
    lea edx, [ebp - local_34]                    # 004e9360
    push edx                                     # 004e9363
    mov ecx, 0x5c3a67                            # 004e9364
    call FUN_004fb77a                            # 004e9369
    push 0x11                                    # 004e936e
    mov ecx, 0x5c3a67                            # 004e9370
    call FUN_004fb2e3                            # 004e9375
L_004e937a:
    # block 0x004e937a: entered by jmp at 0x004e90c2; je at 0x004e9182; je at 0x004e91b9; jne at 0x004e91cd, 2 instruction(s), ends with je to 0x004e93d5 (forward)
    cmp dword ptr [0x5bb202], 0x0                # 004e937a
    je.d8 L_004e93d5                             # 004e9381
    # block 0x004e9383: entered by fall-through of je at 0x004e9381, 22 instruction(s), calls FUN_00448d11, falls into the block at 0x004e93d5
    lea edi, [ebp - local_7c]                    # 004e9383
    or ecx, -0x1                                 # 004e9386
    {load} xor eax, eax                          # 004e9389
    repne scasb al, byte ptr es:[edi]            # 004e938b
    mov eax, dword ptr [0x55c660]                # 004e938d
    mov dword ptr [edi - field_minus_1], eax     # 004e9392
    push 0x0                                     # 004e9395
    push -0x1                                    # 004e9397
    lea ecx, [ebp - local_7c]                    # 004e9399
    push ecx                                     # 004e939c
    mov edx, dword ptr [0x5d03b3]                # 004e939d
    push edx                                     # 004e93a3
    mov ecx, 0x619a05                            # 004e93a4
    call FUN_00448d11                            # 004e93a9
    mov eax, dword ptr [ebp - local_80]          # 004e93ae
    mov dword ptr [eax + field_8256], 0x1        # 004e93b1
    mov ecx, dword ptr [ebp - local_80]          # 004e93bb
    movsx edx, word ptr [ecx + field_69d]        # 004e93be
    mov eax, dword ptr [0x585d37]                # 004e93c5
    {load} add eax, edx                          # 004e93ca
    mov ecx, dword ptr [ebp - local_80]          # 004e93cc
    mov dword ptr [ecx + field_8286], eax        # 004e93cf
L_004e93d5:
    # block 0x004e93d5: entered by je at 0x004e9381, 1 instruction(s), ends with forward jump to 0x004e945c
    jmp.d32 L_004e945c                           # 004e93d5
L_004e93da:
    # block 0x004e93da: entered by je at 0x004e8f39; jne at 0x004e8f50; jne at 0x004e8f67, 2 instruction(s), ends with jne to 0x004e945c (forward)
    cmp dword ptr [0x5c39e5], 0x2717             # 004e93da
    jne.d8 L_004e945c                            # 004e93e4
    # block 0x004e93e6: entered by fall-through of jne at 0x004e93e4, 3 instruction(s), ends with je to 0x004e945c (forward)
    mov edx, dword ptr [ebp - local_80]          # 004e93e6
    cmp dword ptr [edx + field_6b1c], -0x1       # 004e93e9
    je.d8 L_004e945c                             # 004e93f0
    # block 0x004e93f2: entered by fall-through of je at 0x004e93f0, 4 instruction(s), ends with jne to 0x004e945c (forward)
    mov eax, dword ptr [ebp - local_80]          # 004e93f2
    mov ecx, dword ptr [eax + field_6b1c]        # 004e93f5
    cmp dword ptr [4*ecx + 0x583ced], 0x0        # 004e93fb
    jne.d8 L_004e945c                            # 004e9403
    # block 0x004e9405: entered by fall-through of jne at 0x004e9403, 3 instruction(s), ends with jne to 0x004e945c (forward)
    movsx edx, word ptr [0x583a29]               # 004e9405
    cmp edx, -0x1                                # 004e940c
    jne.d8 L_004e945c                            # 004e940f
    # block 0x004e9411: entered by fall-through of jne at 0x004e940f, 15 instruction(s), calls FUN_004ea06c, FUN_004fb2e3, ends with je to 0x004e9455 (forward)
    mov eax, dword ptr [ebp - local_80]          # 004e9411
    mov cx, word ptr [eax + field_6b1c]          # 004e9414
    mov word ptr [0x583a29], cx                  # 004e941b
    mov dx, word ptr [0x583a29]                  # 004e9422
    push edx                                     # 004e9429
    mov ecx, dword ptr [ebp - local_80]          # 004e942a
    call FUN_004ea06c                            # 004e942d
    push 0x17                                    # 004e9432
    mov ecx, 0x5c3a67                            # 004e9434
    call FUN_004fb2e3                            # 004e9439
    mov eax, dword ptr [ebp - local_80]          # 004e943e
    {load} xor ecx, ecx                          # 004e9441
    mov cl, byte ptr [eax + field_7011]          # 004e9443
    test ecx, ecx                                # 004e9449
    je.d8 L_004e9455                             # 004e944b
    # block 0x004e944d: entered by fall-through of je at 0x004e944b, 2 instruction(s), calls FUN_004e7d04, falls into the block at 0x004e9455
    mov ecx, dword ptr [ebp - local_80]          # 004e944d
    call FUN_004e7d04                            # 004e9450
L_004e9455:
    # block 0x004e9455: entered by je at 0x004e944b, 2 instruction(s), ends with forward jump to 0x004e94a3
    mov eax, 0x1                                 # 004e9455
    jmp.d8 L_004e94a3                            # 004e945a
L_004e945c:
    # block 0x004e945c: entered by jmp at 0x004e93d5; jne at 0x004e93e4; je at 0x004e93f0; jne at 0x004e9403; more, 2 instruction(s), ends with jne to 0x004e94a1 (forward)
    cmp dword ptr [0x5c39e5], 0x2718             # 004e945c
    jne.d8 L_004e94a1                            # 004e9466
    # block 0x004e9468: entered by fall-through of jne at 0x004e9466, 3 instruction(s), ends with je to 0x004e94a1 (forward)
    movsx edx, word ptr [0x583a29]               # 004e9468
    cmp edx, -0x1                                # 004e946f
    je.d8 L_004e94a1                             # 004e9472
    # block 0x004e9474: entered by fall-through of je at 0x004e9472, 11 instruction(s), calls FUN_004e9e84, FUN_004fb2e3, ends with forward jump to 0x004e94a3
    push 0x1                                     # 004e9474
    mov ax, word ptr [0x583a29]                  # 004e9476
    push eax                                     # 004e947c
    mov ecx, dword ptr [ebp - local_80]          # 004e947d
    call FUN_004e9e84                            # 004e9480
    mov word ptr [0x583a29], 0xffff              # 004e9485
    push 0x14                                    # 004e948e
    mov ecx, 0x5c3a67                            # 004e9490
    call FUN_004fb2e3                            # 004e9495
    mov eax, 0x1                                 # 004e949a
    jmp.d8 L_004e94a3                            # 004e949f
L_004e94a1:
    # block 0x004e94a1: entered by jne at 0x004e9466; je at 0x004e9472, 1 instruction(s), falls into the block at 0x004e94a3
    {load} xor eax, eax                          # 004e94a1
L_004e94a3:
    # block 0x004e94a3: entered by jmp at 0x004e8f2a; jmp at 0x004e945a; jmp at 0x004e949f, 5 instruction(s), ends with ret
    pop edi                                      # 004e94a3
    pop esi                                      # 004e94a4
    {load} mov esp, ebp                          # 004e94a5
    pop ebp                                      # 004e94a7
    ret                                          # 004e94a8

