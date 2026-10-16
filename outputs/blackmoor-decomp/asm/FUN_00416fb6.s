# FUN_00416fb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00416fb6
# extent:       0x00416fb6-0x00417b04 (2894 code bytes)
# span:         0x00416fb6-0x00417b04 (code 2894, tables 0, padding 0)
# sha256:       61d3d18cf89809adf2dde601b0a15299a360e2f747de61a32ac22c6cbcda4593
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00416fb6
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       33 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_114, local_118, local_11c, local_124, local_130, local_134, local_138, local_13c and 21 more
# fields:       [eax + n] field_1, field_4, field_8, field_c, field_23, field_29, field_51, field_59, field_571, field_573, field_577, field_57b and 3 more; [ecx + n] field_4, field_8, field_c, field_23, field_27, field_39, field_51, field_59, field_571, field_577, field_5c4, field_845; [edx + n] field_1, field_4, field_8, field_c, field_23, field_51, field_59, field_5d, field_571, field_577, field_57b
# callees:      calls FUN_0050d0bc, FUN_0050ca3e, FUN_0052139c, FUN_0050cd72, FUN_0041a102, FUN_0050d0a9, FUN_0050cf61, FUN_0051dc43, FUN_0041b6e2, FUN_0050cee4, FUN_004c7314, FUN_0041a216, FUN_0041a19c, FUN_0050ce2b, FUN_004c97b4, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 755 instruction(s), 33 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_124, 0x124  # offset -0x124
.equ local_130, 0x130  # offset -0x130
.equ local_134, 0x134  # offset -0x134
.equ local_138, 0x138  # offset -0x138
.equ local_13c, 0x13c  # offset -0x13c
.equ local_140, 0x140  # offset -0x140
.equ local_144, 0x144  # offset -0x144
.equ local_148, 0x148  # offset -0x148
.equ local_14c, 0x14c  # offset -0x14c
.equ local_14e, 0x14e  # offset -0x14e
.equ local_150, 0x150  # offset -0x150
.equ local_168, 0x168  # offset -0x168
.equ local_16c, 0x16c  # offset -0x16c
.equ local_170, 0x170  # offset -0x170
.equ local_174, 0x174  # offset -0x174
.equ local_178, 0x178  # offset -0x178
.equ local_17c, 0x17c  # offset -0x17c
.equ local_180, 0x180  # offset -0x180
.equ local_184, 0x184  # offset -0x184
.equ local_188, 0x188  # offset -0x188
.equ local_18c, 0x18c  # offset -0x18c
.equ local_18d, 0x18d  # offset -0x18d
.equ local_18e, 0x18e  # offset -0x18e
.equ local_194, 0x194  # offset -0x194
.equ local_198, 0x198  # offset -0x198
.equ local_19c, 0x19c  # offset -0x19c
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_23, 0x23  # offset +0x23
.equ field_27, 0x27  # offset +0x27
.equ field_29, 0x29  # offset +0x29
.equ field_39, 0x39  # offset +0x39
.equ field_51, 0x51  # offset +0x51
.equ field_59, 0x59  # offset +0x59
.equ field_5d, 0x5d  # offset +0x5d
.equ field_571, 0x571  # offset +0x571
.equ field_573, 0x573  # offset +0x573
.equ field_577, 0x577  # offset +0x577
.equ field_57b, 0x57b  # offset +0x57b
.equ field_57f, 0x57f  # offset +0x57f
.equ field_5c0, 0x5c0  # offset +0x5c0
.equ field_5c4, 0x5c4  # offset +0x5c4
.equ field_845, 0x845  # offset +0x845

# --- external targets -----------------------------------------------
.set FUN_0041a102, .text + (0x0041a102 - 0x401000)
.set FUN_0041a19c, .text + (0x0041a19c - 0x401000)
.set FUN_0041a216, .text + (0x0041a216 - 0x401000)
.set FUN_0041b6e2, .text + (0x0041b6e2 - 0x401000)
.set FUN_004c7314, .text + (0x004c7314 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d0bc, .text + (0x0050d0bc - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00416fb6 - 0x401000
.globl FUN_00416fb6
FUN_00416fb6:
    # block 0x00416fb6: entry, 15 instruction(s), calls FUN_0050d0bc, ends with jne to 0x0041701d (forward)
    push ebp                                     # 00416fb6
    {load} mov ebp, esp                          # 00416fb7
    sub esp, 0x19c                               # 00416fb9
    push esi                                     # 00416fbf
    push edi                                     # 00416fc0
    mov dword ptr [ebp - local_180], ecx         # 00416fc1
    mov dword ptr [ebp - local_4], 0x0           # 00416fc7
    mov eax, dword ptr [ebp + arg_c]             # 00416fce
    push eax                                     # 00416fd1
    call FUN_0050d0bc                            # 00416fd2
    add esp, 0x4                                 # 00416fd7
    mov dword ptr [ebp + arg_c], eax             # 00416fda
    mov ecx, dword ptr [ebp + arg_10]            # 00416fdd
    cmp dword ptr [ecx], 0x0                     # 00416fe0
    jne.d8 L_0041701d                            # 00416fe3
    # block 0x00416fe5: entered by fall-through of jne at 0x00416fe3, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417afa
    mov edx, dword ptr [ebp + arg_c]             # 00416fe5
    push edx                                     # 00416fe8
    push 0x542108                                # 00416fe9
    mov eax, dword ptr [ebp - local_180]         # 00416fee
    add eax, 0x31f                               # 00416ff4
    push eax                                     # 00416ff9
    call FUN_0050ca3e                            # 00416ffa
    add esp, 0xc                                 # 00416fff
    push 0x0                                     # 00417002
    push 0x0                                     # 00417004
    mov ecx, dword ptr [ebp - local_180]         # 00417006
    add ecx, 0x31f                               # 0041700c
    push ecx                                     # 00417012
    call FUN_0052139c                            # 00417013
    jmp.d32 L_00417afa                           # 00417018
L_0041701d:
    # block 0x0041701d: entered by jne at 0x00416fe3, 2 instruction(s), ends with je to 0x004173ef (forward)
    cmp dword ptr [0x5bb1fe], 0x0                # 0041701d
    je.d32 L_004173ef                            # 00417024
    # block 0x0041702a: entered by fall-through of je at 0x00417024, 20 instruction(s), calls FUN_0050cd72, FUN_0041a102, ends with je to 0x004173ef (forward)
    push 0x542184                                # 0041702a
    mov edx, dword ptr [ebp + arg_c]             # 0041702f
    push edx                                     # 00417032
    mov eax, dword ptr [ebp - local_180]         # 00417033
    add eax, 0x1f                                # 00417039
    push eax                                     # 0041703c
    mov ecx, dword ptr [ebp - local_180]         # 0041703d
    add ecx, 0x1c                                # 00417043
    push ecx                                     # 00417046
    lea edx, [ebp - local_114]                   # 00417047
    push edx                                     # 0041704d
    call FUN_0050cd72                            # 0041704e
    add esp, 0x14                                # 00417053
    lea eax, [ebp - local_114]                   # 00417056
    push eax                                     # 0041705c
    mov ecx, dword ptr [ebp - local_180]         # 0041705d
    call FUN_0041a102                            # 00417063
    movsx ecx, ax                                # 00417068
    test ecx, ecx                                # 0041706b
    je.d32 L_004173ef                            # 0041706d
    # block 0x00417073: entered by fall-through of je at 0x0041706d, 16 instruction(s), calls FUN_0050d0a9, FUN_0050cf61, ends with je to 0x004170e1 (forward)
    push 0x54218c                                # 00417073
    lea edx, [ebp - local_114]                   # 00417078
    push edx                                     # 0041707e
    call FUN_0050d0a9                            # 0041707f
    add esp, 0x8                                 # 00417084
    mov dword ptr [ebp - local_8], eax           # 00417087
    mov eax, dword ptr [ebp - local_8]           # 0041708a
    push eax                                     # 0041708d
    push 0x1                                     # 0041708e
    push 0x51                                    # 00417090
    lea ecx, [ebp - local_168]                   # 00417092
    push ecx                                     # 00417098
    call FUN_0050cf61                            # 00417099
    add esp, 0x10                                # 0041709e
    cmp eax, 0x1                                 # 004170a1
    je.d8 L_004170e1                             # 004170a4
    # block 0x004170a6: entered by fall-through of je at 0x004170a4, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417af8
    lea edx, [ebp - local_114]                   # 004170a6
    push edx                                     # 004170ac
    push 0x542190                                # 004170ad
    mov eax, dword ptr [ebp - local_180]         # 004170b2
    add eax, 0x31f                               # 004170b8
    push eax                                     # 004170bd
    call FUN_0050ca3e                            # 004170be
    add esp, 0xc                                 # 004170c3
    push 0x0                                     # 004170c6
    push 0x0                                     # 004170c8
    mov ecx, dword ptr [ebp - local_180]         # 004170ca
    add ecx, 0x31f                               # 004170d0
    push ecx                                     # 004170d6
    call FUN_0052139c                            # 004170d7
    jmp.d32 L_00417af8                           # 004170dc
L_004170e1:
    # block 0x004170e1: entered by je at 0x004170a4, 6 instruction(s), ends with jne to 0x00417118 (forward)
    mov edi, 0x5421bc                            # 004170e1
    lea esi, [ebp - local_168]                   # 004170e6
    mov ecx, 0x14                                # 004170ec
    {load} xor edx, edx                          # 004170f1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004170f3
    jne.d8 L_00417118                            # 004170f5
    # block 0x004170f7: entered by fall-through of jne at 0x004170f5, 4 instruction(s), ends with jne to 0x00417118 (forward)
    mov eax, dword ptr [ebp - local_150]         # 004170f7
    and eax, 0xffff                              # 004170fd
    cmp eax, 0x2                                 # 00417102
    jne.d8 L_00417118                            # 00417105
    # block 0x00417107: entered by fall-through of jne at 0x00417105, 4 instruction(s), ends with je to 0x0041712b (forward)
    mov ecx, dword ptr [ebp - local_14e]         # 00417107
    and ecx, 0xffff                              # 0041710d
    cmp ecx, 0x1                                 # 00417113
    je.d8 L_0041712b                             # 00417116
L_00417118:
    # block 0x00417118: entered by jne at 0x004170f5; jne at 0x00417105; fall-through of je at 0x00417116, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00417af6
    push 0x0                                     # 00417118
    push 0x0                                     # 0041711a
    push 0x5421d0                                # 0041711c
    call FUN_0052139c                            # 00417121
    jmp.d32 L_00417af6                           # 00417126
L_0041712b:
    # block 0x0041712b: entered by je at 0x00417116, 24 instruction(s), ends with je to 0x004171a4 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 0041712b
    add edx, 0x35                                # 0041712e
    mov eax, dword ptr [ebp - local_14c]         # 00417131
    mov dword ptr [edx], eax                     # 00417137
    mov ecx, dword ptr [ebp - local_148]         # 00417139
    mov dword ptr [edx + field_4], ecx           # 0041713f
    mov eax, dword ptr [ebp - local_144]         # 00417142
    mov dword ptr [edx + field_8], eax           # 00417148
    mov ecx, dword ptr [ebp - local_140]         # 0041714b
    mov dword ptr [edx + field_c], ecx           # 00417151
    mov edx, dword ptr [ebp + arg_10]            # 00417154
    add edx, 0x45                                # 00417157
    mov eax, dword ptr [ebp - local_13c]         # 0041715a
    mov dword ptr [edx], eax                     # 00417160
    mov ecx, dword ptr [ebp - local_138]         # 00417162
    mov dword ptr [edx + field_4], ecx           # 00417168
    mov eax, dword ptr [ebp - local_134]         # 0041716b
    mov dword ptr [edx + field_8], eax           # 00417171
    mov ecx, dword ptr [ebp - local_130]         # 00417174
    mov dword ptr [edx + field_c], ecx           # 0041717a
    mov dl, byte ptr [ebp - local_118]           # 0041717d
    mov byte ptr [ebp - local_184], dl           # 00417183
    cmp byte ptr [ebp - local_184], 0x2          # 00417189
    je.d8 L_004171a4                             # 00417190
    # block 0x00417192: entered by fall-through of je at 0x00417190, 2 instruction(s), ends with je to 0x004172dc (forward)
    cmp byte ptr [ebp - local_184], 0x3          # 00417192
    je.d32 L_004172dc                            # 00417199
    # block 0x0041719f: entered by fall-through of je at 0x00417199, 1 instruction(s), ends with forward jump to 0x004173ef
    jmp.d32 L_004173ef                           # 0041719f
L_004171a4:
    # block 0x004171a4: entered by je at 0x00417190, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x004171db (forward)
    mov eax, dword ptr [ebp - local_11c]         # 004171a4
    push eax                                     # 004171aa
    call FUN_0051dc43                            # 004171ab
    add esp, 0x4                                 # 004171b0
    mov dword ptr [ebp - local_16c], eax         # 004171b3
    mov ecx, dword ptr [ebp - local_16c]         # 004171b9
    mov dword ptr [ebp - local_4], ecx           # 004171bf
    cmp dword ptr [ebp - local_4], 0x0           # 004171c2
    jne.d8 L_004171db                            # 004171c6
    # block 0x004171c8: entered by fall-through of jne at 0x004171c6, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00417af4
    push 0x0                                     # 004171c8
    push 0x0                                     # 004171ca
    push 0x542208                                # 004171cc
    call FUN_0052139c                            # 004171d1
    jmp.d32 L_00417af4                           # 004171d6
L_004171db:
    # block 0x004171db: entered by jne at 0x004171c6, 4 instruction(s), ends with je to 0x00417232 (forward)
    mov edx, dword ptr [ebp + arg_10]            # 004171db
    mov eax, dword ptr [edx + field_23]          # 004171de
    cmp eax, dword ptr [ebp - local_124]         # 004171e1
    je.d8 L_00417232                             # 004171e7
    # block 0x004171e9: entered by fall-through of je at 0x004171e7, 20 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417af2
    lea ecx, [ebp - local_114]                   # 004171e9
    push ecx                                     # 004171ef
    mov edx, dword ptr [ebp - local_124]         # 004171f0
    push edx                                     # 004171f6
    mov eax, dword ptr [ebp + arg_10]            # 004171f7
    mov ecx, dword ptr [eax + field_23]          # 004171fa
    push ecx                                     # 004171fd
    push 0x54223c                                # 004171fe
    mov edx, dword ptr [ebp - local_180]         # 00417203
    add edx, 0x31f                               # 00417209
    push edx                                     # 0041720f
    call FUN_0050ca3e                            # 00417210
    add esp, 0x14                                # 00417215
    push 0x0                                     # 00417218
    push 0x0                                     # 0041721a
    mov eax, dword ptr [ebp - local_180]         # 0041721c
    add eax, 0x31f                               # 00417222
    push eax                                     # 00417227
    call FUN_0052139c                            # 00417228
    jmp.d32 L_00417af2                           # 0041722d
L_00417232:
    # block 0x00417232: entered by je at 0x004171e7, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x0041728b (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00417232
    push ecx                                     # 00417235
    push 0x1                                     # 00417236
    mov edx, dword ptr [ebp - local_11c]         # 00417238
    push edx                                     # 0041723e
    mov eax, dword ptr [ebp - local_4]           # 0041723f
    push eax                                     # 00417242
    call FUN_0050cf61                            # 00417243
    add esp, 0x10                                # 00417248
    cmp eax, 0x1                                 # 0041724b
    je.d8 L_0041728b                             # 0041724e
    # block 0x00417250: entered by fall-through of je at 0x0041724e, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417af0
    lea ecx, [ebp - local_114]                   # 00417250
    push ecx                                     # 00417256
    push 0x542274                                # 00417257
    mov edx, dword ptr [ebp - local_180]         # 0041725c
    add edx, 0x31f                               # 00417262
    push edx                                     # 00417268
    call FUN_0050ca3e                            # 00417269
    add esp, 0xc                                 # 0041726e
    push 0x0                                     # 00417271
    push 0x0                                     # 00417273
    mov eax, dword ptr [ebp - local_180]         # 00417275
    add eax, 0x31f                               # 0041727b
    push eax                                     # 00417280
    call FUN_0052139c                            # 00417281
    jmp.d32 L_00417af0                           # 00417286
L_0041728b:
    # block 0x0041728b: entered by je at 0x0041724e, 24 instruction(s), calls FUN_0041b6e2, FUN_0050cee4, FUN_004c7314, ends with forward jump to 0x00417aee
    mov ecx, dword ptr [ebp - local_124]         # 0041728b
    push ecx                                     # 00417291
    mov edx, dword ptr [ebp - local_11c]         # 00417292
    push edx                                     # 00417298
    mov eax, dword ptr [ebp + arg_10]            # 00417299
    mov ecx, dword ptr [eax]                     # 0041729c
    push ecx                                     # 0041729e
    mov edx, dword ptr [ebp - local_4]           # 0041729f
    push edx                                     # 004172a2
    mov ecx, dword ptr [ebp - local_180]         # 004172a3
    add ecx, 0x51f                               # 004172a9
    call FUN_0041b6e2                            # 004172af
    mov eax, dword ptr [ebp - local_8]           # 004172b4
    push eax                                     # 004172b7
    call FUN_0050cee4                            # 004172b8
    add esp, 0x4                                 # 004172bd
    mov ecx, dword ptr [ebp - local_124]         # 004172c0
    push ecx                                     # 004172c6
    mov edx, dword ptr [ebp + arg_10]            # 004172c7
    mov eax, dword ptr [edx]                     # 004172ca
    push eax                                     # 004172cc
    mov ecx, 0x5cf659                            # 004172cd
    call FUN_004c7314                            # 004172d2
    jmp.d32 L_00417aee                           # 004172d7
L_004172dc:
    # block 0x004172dc: entered by je at 0x00417199, 9 instruction(s), calls FUN_0051dc43, ends with jne to 0x00417313 (forward)
    mov ecx, dword ptr [ebp - local_11c]         # 004172dc
    push ecx                                     # 004172e2
    call FUN_0051dc43                            # 004172e3
    add esp, 0x4                                 # 004172e8
    mov dword ptr [ebp - local_170], eax         # 004172eb
    mov edx, dword ptr [ebp - local_170]         # 004172f1
    mov dword ptr [ebp - local_4], edx           # 004172f7
    cmp dword ptr [ebp - local_4], 0x0           # 004172fa
    jne.d8 L_00417313                            # 004172fe
    # block 0x00417300: entered by fall-through of jne at 0x004172fe, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00417aec
    push 0x0                                     # 00417300
    push 0x0                                     # 00417302
    push 0x542294                                # 00417304
    call FUN_0052139c                            # 00417309
    jmp.d32 L_00417aec                           # 0041730e
L_00417313:
    # block 0x00417313: entered by jne at 0x004172fe, 4 instruction(s), ends with je to 0x0041735c (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00417313
    mov ecx, dword ptr [eax + field_23]          # 00417316
    cmp ecx, dword ptr [ebp - local_124]         # 00417319
    je.d8 L_0041735c                             # 0041731f
    # block 0x00417321: entered by fall-through of je at 0x0041731f, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417aea
    lea edx, [ebp - local_114]                   # 00417321
    push edx                                     # 00417327
    push 0x5422c8                                # 00417328
    mov eax, dword ptr [ebp - local_180]         # 0041732d
    add eax, 0x31f                               # 00417333
    push eax                                     # 00417338
    call FUN_0050ca3e                            # 00417339
    add esp, 0xc                                 # 0041733e
    push 0x0                                     # 00417341
    push 0x0                                     # 00417343
    mov ecx, dword ptr [ebp - local_180]         # 00417345
    add ecx, 0x31f                               # 0041734b
    push ecx                                     # 00417351
    call FUN_0052139c                            # 00417352
    jmp.d32 L_00417aea                           # 00417357
L_0041735c:
    # block 0x0041735c: entered by je at 0x0041731f, 11 instruction(s), calls FUN_0050cf61, ends with je to 0x004173b5 (forward)
    mov edx, dword ptr [ebp - local_8]           # 0041735c
    push edx                                     # 0041735f
    push 0x1                                     # 00417360
    mov eax, dword ptr [ebp - local_11c]         # 00417362
    push eax                                     # 00417368
    mov ecx, dword ptr [ebp - local_4]           # 00417369
    push ecx                                     # 0041736c
    call FUN_0050cf61                            # 0041736d
    add esp, 0x10                                # 00417372
    cmp eax, 0x1                                 # 00417375
    je.d8 L_004173b5                             # 00417378
    # block 0x0041737a: entered by fall-through of je at 0x00417378, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ae8
    lea edx, [ebp - local_114]                   # 0041737a
    push edx                                     # 00417380
    push 0x5422f8                                # 00417381
    mov eax, dword ptr [ebp - local_180]         # 00417386
    add eax, 0x31f                               # 0041738c
    push eax                                     # 00417391
    call FUN_0050ca3e                            # 00417392
    add esp, 0xc                                 # 00417397
    push 0x0                                     # 0041739a
    push 0x0                                     # 0041739c
    mov ecx, dword ptr [ebp - local_180]         # 0041739e
    add ecx, 0x31f                               # 004173a4
    push ecx                                     # 004173aa
    call FUN_0052139c                            # 004173ab
    jmp.d32 L_00417ae8                           # 004173b0
L_004173b5:
    # block 0x004173b5: entered by je at 0x00417378, 17 instruction(s), calls FUN_0041b6e2, FUN_0050cee4, ends with forward jump to 0x00417ae6
    mov edx, dword ptr [ebp - local_124]         # 004173b5
    push edx                                     # 004173bb
    mov eax, dword ptr [ebp - local_11c]         # 004173bc
    push eax                                     # 004173c2
    mov ecx, dword ptr [ebp + arg_10]            # 004173c3
    mov edx, dword ptr [ecx]                     # 004173c6
    push edx                                     # 004173c8
    mov eax, dword ptr [ebp - local_4]           # 004173c9
    push eax                                     # 004173cc
    mov ecx, dword ptr [ebp - local_180]         # 004173cd
    add ecx, 0x51f                               # 004173d3
    call FUN_0041b6e2                            # 004173d9
    mov ecx, dword ptr [ebp - local_8]           # 004173de
    push ecx                                     # 004173e1
    call FUN_0050cee4                            # 004173e2
    add esp, 0x4                                 # 004173e7
    jmp.d32 L_00417ae6                           # 004173ea
L_004173ef:
    # block 0x004173ef: entered by je at 0x00417024; je at 0x0041706d; jmp at 0x0041719f, 10 instruction(s), calls FUN_0041a216, ends with jne to 0x00417455 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004173ef
    push edx                                     # 004173f2
    mov ecx, dword ptr [ebp - local_180]         # 004173f3
    call FUN_0041a216                            # 004173f9
    mov ecx, dword ptr [ebp - local_180]         # 004173fe
    mov word ptr [ecx + field_571], ax           # 00417404
    mov edx, dword ptr [ebp - local_180]         # 0041740b
    movsx eax, word ptr [edx + field_571]        # 00417411
    cmp eax, -0x1                                # 00417418
    jne.d8 L_00417455                            # 0041741b
    # block 0x0041741d: entered by fall-through of jne at 0x0041741b, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ae4
    mov ecx, dword ptr [ebp + arg_8]             # 0041741d
    push ecx                                     # 00417420
    push 0x542318                                # 00417421
    mov edx, dword ptr [ebp - local_180]         # 00417426
    add edx, 0x31f                               # 0041742c
    push edx                                     # 00417432
    call FUN_0050ca3e                            # 00417433
    add esp, 0xc                                 # 00417438
    push 0x0                                     # 0041743b
    push 0x0                                     # 0041743d
    mov eax, dword ptr [ebp - local_180]         # 0041743f
    add eax, 0x31f                               # 00417445
    push eax                                     # 0041744a
    call FUN_0052139c                            # 0041744b
    jmp.d32 L_00417ae4                           # 00417450
L_00417455:
    # block 0x00417455: entered by jne at 0x0041741b, 34 instruction(s), calls FUN_0041a19c, ends with jne to 0x00417545 (forward)
    mov ecx, dword ptr [ebp - local_180]         # 00417455
    movsx edx, word ptr [ecx + field_571]        # 0041745b
    imul edx, edx, 0x84d                         # 00417462
    mov eax, dword ptr [ebp - local_180]         # 00417468
    lea ecx, [eax + edx + field_57f]             # 0041746e
    mov edx, dword ptr [ebp - local_180]         # 00417475
    mov dword ptr [edx + field_57b], ecx         # 0041747b
    mov eax, dword ptr [ebp - local_180]         # 00417481
    movsx ecx, word ptr [eax + field_571]        # 00417487
    imul ecx, ecx, 0x84d                         # 0041748e
    mov edx, dword ptr [ebp - local_180]         # 00417494
    mov eax, dword ptr [ebp - local_180]         # 0041749a
    mov ecx, dword ptr [eax + ecx + field_5c0]   # 004174a0
    mov dword ptr [edx + field_577], ecx         # 004174a7
    mov edx, dword ptr [ebp - local_180]         # 004174ad
    movsx eax, word ptr [edx + field_571]        # 004174b3
    imul eax, eax, 0x84d                         # 004174ba
    mov ecx, dword ptr [ebp - local_180]         # 004174c0
    lea edx, [ecx + eax + field_5c4]             # 004174c6
    mov eax, dword ptr [ebp - local_180]         # 004174cd
    mov dword ptr [eax + field_573], edx         # 004174d3
    mov ecx, dword ptr [ebp + arg_c]             # 004174d9
    push ecx                                     # 004174dc
    mov ecx, dword ptr [ebp - local_180]         # 004174dd
    call FUN_0041a19c                            # 004174e3
    mov word ptr [ebp - local_c], ax             # 004174e8
    movsx edx, word ptr [ebp - local_c]          # 004174ec
    mov eax, dword ptr [ebp - local_180]         # 004174f0
    mov ecx, dword ptr [eax + field_573]         # 004174f6
    mov dx, word ptr [ecx + 2*edx]               # 004174fc
    mov word ptr [ebp - local_10], dx            # 00417500
    movsx eax, word ptr [ebp - local_10]         # 00417504
    cmp eax, -0x1                                # 00417508
    jne.d8 L_00417545                            # 0041750b
    # block 0x0041750d: entered by fall-through of jne at 0x0041750b, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ae2
    mov ecx, dword ptr [ebp + arg_c]             # 0041750d
    push ecx                                     # 00417510
    push 0x542354                                # 00417511
    mov edx, dword ptr [ebp - local_180]         # 00417516
    add edx, 0x31f                               # 0041751c
    push edx                                     # 00417522
    call FUN_0050ca3e                            # 00417523
    add esp, 0xc                                 # 00417528
    push 0x0                                     # 0041752b
    push 0x0                                     # 0041752d
    mov eax, dword ptr [ebp - local_180]         # 0041752f
    add eax, 0x31f                               # 00417535
    push eax                                     # 0041753a
    call FUN_0052139c                            # 0041753b
    jmp.d32 L_00417ae2                           # 00417540
L_00417545:
    # block 0x00417545: entered by jne at 0x0041750b; jmp at 0x00417655, 3 instruction(s), ends with je to 0x0041765a (forward)
    mov ecx, 0x1                                 # 00417545
    test ecx, ecx                                # 0041754a
    je.d32 L_0041765a                            # 0041754c
    # block 0x00417552: entered by fall-through of je at 0x0041754c, 8 instruction(s), falls into the block at 0x00417576
    mov edx, dword ptr [ebp + arg_c]             # 00417552
    mov dword ptr [ebp - local_188], edx         # 00417555
    movsx eax, word ptr [ebp - local_10]         # 0041755b
    imul eax, eax, 0x5e                          # 0041755f
    mov ecx, dword ptr [ebp - local_180]         # 00417562
    mov edx, dword ptr [ecx + field_577]         # 00417568
    {load} add edx, eax                          # 0041756e
    mov dword ptr [ebp - local_18c], edx         # 00417570
L_00417576:
    # block 0x00417576: entered by jne at 0x004175c6, 6 instruction(s), ends with jne to 0x004175d4 (forward)
    mov eax, dword ptr [ebp - local_18c]         # 00417576
    mov cl, byte ptr [eax]                       # 0041757c
    mov byte ptr [ebp - local_18d], cl           # 0041757e
    mov edx, dword ptr [ebp - local_188]         # 00417584
    cmp cl, byte ptr [edx]                       # 0041758a
    jne.d8 L_004175d4                            # 0041758c
    # block 0x0041758e: entered by fall-through of jne at 0x0041758c, 2 instruction(s), ends with je to 0x004175c8 (forward)
    cmp byte ptr [ebp - local_18d], 0x0          # 0041758e
    je.d8 L_004175c8                             # 00417595
    # block 0x00417597: entered by fall-through of je at 0x00417595, 6 instruction(s), ends with jne to 0x004175d4 (forward)
    mov eax, dword ptr [ebp - local_18c]         # 00417597
    mov cl, byte ptr [eax + field_1]             # 0041759d
    mov byte ptr [ebp - local_18e], cl           # 004175a0
    mov edx, dword ptr [ebp - local_188]         # 004175a6
    cmp cl, byte ptr [edx + field_1]             # 004175ac
    jne.d8 L_004175d4                            # 004175af
    # block 0x004175b1: entered by fall-through of jne at 0x004175af, 4 instruction(s), ends with jne to 0x00417576 (backward)
    add dword ptr [ebp - local_18c], 0x2         # 004175b1
    add dword ptr [ebp - local_188], 0x2         # 004175b8
    cmp byte ptr [ebp - local_18e], 0x0          # 004175bf
    jne.d8 L_00417576                            # 004175c6
L_004175c8:
    # block 0x004175c8: entered by je at 0x00417595; fall-through of jne at 0x004175c6, 2 instruction(s), ends with forward jump to 0x004175df
    mov dword ptr [ebp - local_194], 0x0         # 004175c8
    jmp.d8 L_004175df                            # 004175d2
L_004175d4:
    # block 0x004175d4: entered by jne at 0x0041758c; jne at 0x004175af, 3 instruction(s), falls into the block at 0x004175df
    {load} sbb eax, eax                          # 004175d4
    sbb eax, -0x1                                # 004175d6
    mov dword ptr [ebp - local_194], eax         # 004175d9
L_004175df:
    # block 0x004175df: entered by jmp at 0x004175d2, 4 instruction(s), ends with je to 0x00417653 (forward)
    mov ecx, dword ptr [ebp - local_194]         # 004175df
    mov dword ptr [ebp - local_198], ecx         # 004175e5
    cmp dword ptr [ebp - local_198], 0x0         # 004175eb
    je.d8 L_00417653                             # 004175f2
    # block 0x004175f4: entered by fall-through of je at 0x004175f2, 9 instruction(s), ends with jne to 0x00417651 (forward)
    movsx edx, word ptr [ebp - local_10]         # 004175f4
    imul edx, edx, 0x5e                          # 004175f8
    mov eax, dword ptr [ebp - local_180]         # 004175fb
    mov ecx, dword ptr [eax + field_577]         # 00417601
    mov dx, word ptr [ecx + edx + field_27]      # 00417607
    mov word ptr [ebp - local_10], dx            # 0041760c
    movsx eax, word ptr [ebp - local_10]         # 00417610
    cmp eax, -0x1                                # 00417614
    jne.d8 L_00417651                            # 00417617
    # block 0x00417619: entered by fall-through of jne at 0x00417617, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ae0
    mov ecx, dword ptr [ebp + arg_c]             # 00417619
    push ecx                                     # 0041761c
    push 0x542384                                # 0041761d
    mov edx, dword ptr [ebp - local_180]         # 00417622
    add edx, 0x31f                               # 00417628
    push edx                                     # 0041762e
    call FUN_0050ca3e                            # 0041762f
    add esp, 0xc                                 # 00417634
    push 0x0                                     # 00417637
    push 0x0                                     # 00417639
    mov eax, dword ptr [ebp - local_180]         # 0041763b
    add eax, 0x31f                               # 00417641
    push eax                                     # 00417646
    call FUN_0052139c                            # 00417647
    jmp.d32 L_00417ae0                           # 0041764c
L_00417651:
    # block 0x00417651: entered by jne at 0x00417617, 1 instruction(s), ends with forward jump to 0x00417655
    jmp.d8 L_00417655                            # 00417651
L_00417653:
    # block 0x00417653: entered by je at 0x004175f2, 1 instruction(s), ends with forward jump to 0x0041765a
    jmp.d8 L_0041765a                            # 00417653
L_00417655:
    # block 0x00417655: entered by jmp at 0x00417651, 1 instruction(s), ends with backward jump to 0x00417545
    jmp.d32 L_00417545                           # 00417655
L_0041765a:
    # block 0x0041765a: entered by je at 0x0041754c; jmp at 0x00417653, 38 instruction(s), ends with je to 0x004176f8 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 0041765a
    imul ecx, ecx, 0x5e                          # 0041765e
    mov edx, dword ptr [ebp - local_180]         # 00417661
    mov eax, dword ptr [edx + field_577]         # 00417667
    lea ecx, [eax + ecx + field_29]              # 0041766d
    mov edx, dword ptr [ebp + arg_10]            # 00417671
    add edx, 0x35                                # 00417674
    mov eax, dword ptr [ecx]                     # 00417677
    mov dword ptr [edx], eax                     # 00417679
    mov eax, dword ptr [ecx + field_4]           # 0041767b
    mov dword ptr [edx + field_4], eax           # 0041767e
    mov eax, dword ptr [ecx + field_8]           # 00417681
    mov dword ptr [edx + field_8], eax           # 00417684
    mov ecx, dword ptr [ecx + field_c]           # 00417687
    mov dword ptr [edx + field_c], ecx           # 0041768a
    movsx edx, word ptr [ebp - local_10]         # 0041768d
    imul edx, edx, 0x5e                          # 00417691
    mov eax, dword ptr [ebp - local_180]         # 00417694
    mov ecx, dword ptr [eax + field_577]         # 0041769a
    lea edx, [ecx + edx + field_39]              # 004176a0
    mov eax, dword ptr [ebp + arg_10]            # 004176a4
    add eax, 0x45                                # 004176a7
    mov ecx, dword ptr [edx]                     # 004176aa
    mov dword ptr [eax], ecx                     # 004176ac
    mov ecx, dword ptr [edx + field_4]           # 004176ae
    mov dword ptr [eax + field_4], ecx           # 004176b1
    mov ecx, dword ptr [edx + field_8]           # 004176b4
    mov dword ptr [eax + field_8], ecx           # 004176b7
    mov edx, dword ptr [edx + field_c]           # 004176ba
    mov dword ptr [eax + field_c], edx           # 004176bd
    movsx eax, word ptr [ebp - local_10]         # 004176c0
    imul eax, eax, 0x5e                          # 004176c4
    mov ecx, dword ptr [ebp - local_180]         # 004176c7
    mov edx, dword ptr [ecx + field_577]         # 004176cd
    mov al, byte ptr [edx + eax + field_5d]      # 004176d3
    mov byte ptr [ebp - local_19c], al           # 004176d7
    cmp byte ptr [ebp - local_19c], 0x2          # 004176dd
    je.d8 L_004176f8                             # 004176e4
    # block 0x004176e6: entered by fall-through of je at 0x004176e4, 2 instruction(s), ends with je to 0x004178eb (forward)
    cmp byte ptr [ebp - local_19c], 0x3          # 004176e6
    je.d32 L_004178eb                            # 004176ed
    # block 0x004176f3: entered by fall-through of je at 0x004176ed, 1 instruction(s), ends with forward jump to 0x00417a95
    jmp.d32 L_00417a95                           # 004176f3
L_004176f8:
    # block 0x004176f8: entered by je at 0x004176e4, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00417740 (forward)
    movsx ecx, word ptr [ebp - local_10]         # 004176f8
    imul ecx, ecx, 0x5e                          # 004176fc
    mov edx, dword ptr [ebp - local_180]         # 004176ff
    mov eax, dword ptr [edx + field_577]         # 00417705
    mov ecx, dword ptr [eax + ecx + field_59]    # 0041770b
    push ecx                                     # 0041770f
    call FUN_0051dc43                            # 00417710
    add esp, 0x4                                 # 00417715
    mov dword ptr [ebp - local_174], eax         # 00417718
    mov edx, dword ptr [ebp - local_174]         # 0041771e
    mov dword ptr [ebp - local_4], edx           # 00417724
    cmp dword ptr [ebp - local_4], 0x0           # 00417727
    jne.d8 L_00417740                            # 0041772b
    # block 0x0041772d: entered by fall-through of jne at 0x0041772b, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00417ade
    push 0x0                                     # 0041772d
    push 0x0                                     # 0041772f
    push 0x5423b4                                # 00417731
    call FUN_0052139c                            # 00417736
    jmp.d32 L_00417ade                           # 0041773b
L_00417740:
    # block 0x00417740: entered by jne at 0x0041772b, 8 instruction(s), ends with je to 0x004177b6 (forward)
    movsx eax, word ptr [ebp - local_10]         # 00417740
    imul eax, eax, 0x5e                          # 00417744
    mov ecx, dword ptr [ebp - local_180]         # 00417747
    mov edx, dword ptr [ecx + field_577]         # 0041774d
    mov ecx, dword ptr [ebp + arg_10]            # 00417753
    mov ecx, dword ptr [ecx + field_23]          # 00417756
    cmp ecx, dword ptr [edx + eax + field_51]    # 00417759
    je.d8 L_004177b6                             # 0041775d
    # block 0x0041775f: entered by fall-through of je at 0x0041775d, 24 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417adc
    mov edx, dword ptr [ebp + arg_8]             # 0041775f
    push edx                                     # 00417762
    movsx eax, word ptr [ebp - local_10]         # 00417763
    imul eax, eax, 0x5e                          # 00417767
    mov ecx, dword ptr [ebp - local_180]         # 0041776a
    mov edx, dword ptr [ecx + field_577]         # 00417770
    mov eax, dword ptr [edx + eax + field_51]    # 00417776
    push eax                                     # 0041777a
    mov ecx, dword ptr [ebp + arg_10]            # 0041777b
    mov edx, dword ptr [ecx + field_23]          # 0041777e
    push edx                                     # 00417781
    push 0x5423e8                                # 00417782
    mov eax, dword ptr [ebp - local_180]         # 00417787
    add eax, 0x31f                               # 0041778d
    push eax                                     # 00417792
    call FUN_0050ca3e                            # 00417793
    add esp, 0x14                                # 00417798
    push 0x0                                     # 0041779b
    push 0x0                                     # 0041779d
    mov ecx, dword ptr [ebp - local_180]         # 0041779f
    add ecx, 0x31f                               # 004177a5
    push ecx                                     # 004177ab
    call FUN_0052139c                            # 004177ac
    jmp.d32 L_00417adc                           # 004177b1
L_004177b6:
    # block 0x004177b6: entered by je at 0x0041775d, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00417873 (forward)
    push 0x0                                     # 004177b6
    movsx edx, word ptr [ebp - local_10]         # 004177b8
    imul edx, edx, 0x5e                          # 004177bc
    mov eax, dword ptr [ebp - local_180]         # 004177bf
    mov ecx, dword ptr [eax + field_577]         # 004177c5
    mov edx, dword ptr [ecx + edx + field_23]    # 004177cb
    push edx                                     # 004177cf
    mov eax, dword ptr [ebp - local_180]         # 004177d0
    mov ecx, dword ptr [eax + field_57b]         # 004177d6
    mov edx, dword ptr [ecx + field_845]         # 004177dc
    push edx                                     # 004177e2
    call FUN_0050ce2b                            # 004177e3
    add esp, 0xc                                 # 004177e8
    mov eax, dword ptr [ebp - local_180]         # 004177eb
    mov ecx, dword ptr [eax + field_57b]         # 004177f1
    mov edx, dword ptr [ecx + field_845]         # 004177f7
    push edx                                     # 004177fd
    push 0x1                                     # 004177fe
    movsx eax, word ptr [ebp - local_10]         # 00417800
    imul eax, eax, 0x5e                          # 00417804
    mov ecx, dword ptr [ebp - local_180]         # 00417807
    mov edx, dword ptr [ecx + field_577]         # 0041780d
    mov eax, dword ptr [edx + eax + field_59]    # 00417813
    push eax                                     # 00417817
    mov ecx, dword ptr [ebp - local_4]           # 00417818
    push ecx                                     # 0041781b
    call FUN_0050cf61                            # 0041781c
    add esp, 0x10                                # 00417821
    cmp eax, 0x1                                 # 00417824
    je.d8 L_00417873                             # 00417827
    # block 0x00417829: entered by fall-through of je at 0x00417827, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ada
    movsx edx, word ptr [ebp - local_10]         # 00417829
    imul edx, edx, 0x5e                          # 0041782d
    mov eax, dword ptr [ebp - local_180]         # 00417830
    mov ecx, dword ptr [eax + field_577]         # 00417836
    {load} add ecx, edx                          # 0041783c
    push ecx                                     # 0041783e
    push 0x542420                                # 0041783f
    mov edx, dword ptr [ebp - local_180]         # 00417844
    add edx, 0x31f                               # 0041784a
    push edx                                     # 00417850
    call FUN_0050ca3e                            # 00417851
    add esp, 0xc                                 # 00417856
    push 0x0                                     # 00417859
    push 0x0                                     # 0041785b
    mov eax, dword ptr [ebp - local_180]         # 0041785d
    add eax, 0x31f                               # 00417863
    push eax                                     # 00417868
    call FUN_0052139c                            # 00417869
    jmp.d32 L_00417ada                           # 0041786e
L_00417873:
    # block 0x00417873: entered by je at 0x00417827, 32 instruction(s), calls FUN_0041b6e2, FUN_004c7314, ends with forward jump to 0x00417ad8
    movsx ecx, word ptr [ebp - local_10]         # 00417873
    imul ecx, ecx, 0x5e                          # 00417877
    mov edx, dword ptr [ebp - local_180]         # 0041787a
    mov eax, dword ptr [edx + field_577]         # 00417880
    mov ecx, dword ptr [eax + ecx + field_51]    # 00417886
    push ecx                                     # 0041788a
    movsx edx, word ptr [ebp - local_10]         # 0041788b
    imul edx, edx, 0x5e                          # 0041788f
    mov eax, dword ptr [ebp - local_180]         # 00417892
    mov ecx, dword ptr [eax + field_577]         # 00417898
    mov edx, dword ptr [ecx + edx + field_59]    # 0041789e
    push edx                                     # 004178a2
    mov eax, dword ptr [ebp + arg_10]            # 004178a3
    mov ecx, dword ptr [eax]                     # 004178a6
    push ecx                                     # 004178a8
    mov edx, dword ptr [ebp - local_4]           # 004178a9
    push edx                                     # 004178ac
    mov ecx, dword ptr [ebp - local_180]         # 004178ad
    add ecx, 0x51f                               # 004178b3
    call FUN_0041b6e2                            # 004178b9
    movsx eax, word ptr [ebp - local_10]         # 004178be
    imul eax, eax, 0x5e                          # 004178c2
    mov ecx, dword ptr [ebp - local_180]         # 004178c5
    mov edx, dword ptr [ecx + field_577]         # 004178cb
    mov eax, dword ptr [edx + eax + field_51]    # 004178d1
    push eax                                     # 004178d5
    mov ecx, dword ptr [ebp + arg_10]            # 004178d6
    mov edx, dword ptr [ecx]                     # 004178d9
    push edx                                     # 004178db
    mov ecx, 0x5cf659                            # 004178dc
    call FUN_004c7314                            # 004178e1
    jmp.d32 L_00417ad8                           # 004178e6
L_004178eb:
    # block 0x004178eb: entered by je at 0x004176ed, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x00417933 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004178eb
    imul eax, eax, 0x5e                          # 004178ef
    mov ecx, dword ptr [ebp - local_180]         # 004178f2
    mov edx, dword ptr [ecx + field_577]         # 004178f8
    mov eax, dword ptr [edx + eax + field_59]    # 004178fe
    push eax                                     # 00417902
    call FUN_0051dc43                            # 00417903
    add esp, 0x4                                 # 00417908
    mov dword ptr [ebp - local_178], eax         # 0041790b
    mov ecx, dword ptr [ebp - local_178]         # 00417911
    mov dword ptr [ebp - local_4], ecx           # 00417917
    cmp dword ptr [ebp - local_4], 0x0           # 0041791a
    jne.d8 L_00417933                            # 0041791e
    # block 0x00417920: entered by fall-through of jne at 0x0041791e, 5 instruction(s), calls FUN_0052139c, ends with forward jump to 0x00417ad6
    push 0x0                                     # 00417920
    push 0x0                                     # 00417922
    push 0x542444                                # 00417924
    call FUN_0052139c                            # 00417929
    jmp.d32 L_00417ad6                           # 0041792e
L_00417933:
    # block 0x00417933: entered by jne at 0x0041791e, 8 instruction(s), ends with je to 0x0041798a (forward)
    movsx edx, word ptr [ebp - local_10]         # 00417933
    imul edx, edx, 0x5e                          # 00417937
    mov eax, dword ptr [ebp - local_180]         # 0041793a
    mov ecx, dword ptr [eax + field_577]         # 00417940
    mov eax, dword ptr [ebp + arg_10]            # 00417946
    mov eax, dword ptr [eax + field_23]          # 00417949
    cmp eax, dword ptr [ecx + edx + field_51]    # 0041794c
    je.d8 L_0041798a                             # 00417950
    # block 0x00417952: entered by fall-through of je at 0x00417950, 15 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ad4
    mov ecx, dword ptr [ebp + arg_8]             # 00417952
    push ecx                                     # 00417955
    push 0x542478                                # 00417956
    mov edx, dword ptr [ebp - local_180]         # 0041795b
    add edx, 0x31f                               # 00417961
    push edx                                     # 00417967
    call FUN_0050ca3e                            # 00417968
    add esp, 0xc                                 # 0041796d
    push 0x0                                     # 00417970
    push 0x0                                     # 00417972
    mov eax, dword ptr [ebp - local_180]         # 00417974
    add eax, 0x31f                               # 0041797a
    push eax                                     # 0041797f
    call FUN_0052139c                            # 00417980
    jmp.d32 L_00417ad4                           # 00417985
L_0041798a:
    # block 0x0041798a: entered by je at 0x00417950, 30 instruction(s), calls FUN_0050ce2b, FUN_0050cf61, ends with je to 0x00417a48 (forward)
    push 0x0                                     # 0041798a
    movsx ecx, word ptr [ebp - local_10]         # 0041798c
    imul ecx, ecx, 0x5e                          # 00417990
    mov edx, dword ptr [ebp - local_180]         # 00417993
    mov eax, dword ptr [edx + field_577]         # 00417999
    mov ecx, dword ptr [eax + ecx + field_23]    # 0041799f
    push ecx                                     # 004179a3
    mov edx, dword ptr [ebp - local_180]         # 004179a4
    mov eax, dword ptr [edx + field_57b]         # 004179aa
    mov ecx, dword ptr [eax + field_845]         # 004179b0
    push ecx                                     # 004179b6
    call FUN_0050ce2b                            # 004179b7
    add esp, 0xc                                 # 004179bc
    mov edx, dword ptr [ebp - local_180]         # 004179bf
    mov eax, dword ptr [edx + field_57b]         # 004179c5
    mov ecx, dword ptr [eax + field_845]         # 004179cb
    push ecx                                     # 004179d1
    push 0x1                                     # 004179d2
    movsx edx, word ptr [ebp - local_10]         # 004179d4
    imul edx, edx, 0x5e                          # 004179d8
    mov eax, dword ptr [ebp - local_180]         # 004179db
    mov ecx, dword ptr [eax + field_577]         # 004179e1
    mov edx, dword ptr [ecx + edx + field_59]    # 004179e7
    push edx                                     # 004179eb
    mov eax, dword ptr [ebp - local_4]           # 004179ec
    push eax                                     # 004179ef
    call FUN_0050cf61                            # 004179f0
    add esp, 0x10                                # 004179f5
    cmp eax, 0x1                                 # 004179f8
    je.d8 L_00417a48                             # 004179fb
    # block 0x004179fd: entered by fall-through of je at 0x004179fb, 19 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00417ad2
    movsx ecx, word ptr [ebp - local_10]         # 004179fd
    imul ecx, ecx, 0x5e                          # 00417a01
    mov edx, dword ptr [ebp - local_180]         # 00417a04
    mov eax, dword ptr [edx + field_577]         # 00417a0a
    {load} add eax, ecx                          # 00417a10
    push eax                                     # 00417a12
    push 0x5424a8                                # 00417a13
    mov ecx, dword ptr [ebp - local_180]         # 00417a18
    add ecx, 0x31f                               # 00417a1e
    push ecx                                     # 00417a24
    call FUN_0050ca3e                            # 00417a25
    add esp, 0xc                                 # 00417a2a
    push 0x0                                     # 00417a2d
    push 0x0                                     # 00417a2f
    mov edx, dword ptr [ebp - local_180]         # 00417a31
    add edx, 0x31f                               # 00417a37
    push edx                                     # 00417a3d
    call FUN_0052139c                            # 00417a3e
    jmp.d32 L_00417ad2                           # 00417a43
L_00417a48:
    # block 0x00417a48: entered by je at 0x004179fb, 21 instruction(s), calls FUN_0041b6e2, ends with forward jump to 0x00417ad0
    movsx eax, word ptr [ebp - local_10]         # 00417a48
    imul eax, eax, 0x5e                          # 00417a4c
    mov ecx, dword ptr [ebp - local_180]         # 00417a4f
    mov edx, dword ptr [ecx + field_577]         # 00417a55
    mov eax, dword ptr [edx + eax + field_51]    # 00417a5b
    push eax                                     # 00417a5f
    movsx ecx, word ptr [ebp - local_10]         # 00417a60
    imul ecx, ecx, 0x5e                          # 00417a64
    mov edx, dword ptr [ebp - local_180]         # 00417a67
    mov eax, dword ptr [edx + field_577]         # 00417a6d
    mov ecx, dword ptr [eax + ecx + field_59]    # 00417a73
    push ecx                                     # 00417a77
    mov edx, dword ptr [ebp + arg_10]            # 00417a78
    mov eax, dword ptr [edx]                     # 00417a7b
    push eax                                     # 00417a7d
    mov ecx, dword ptr [ebp - local_4]           # 00417a7e
    push ecx                                     # 00417a81
    mov ecx, dword ptr [ebp - local_180]         # 00417a82
    add ecx, 0x51f                               # 00417a88
    call FUN_0041b6e2                            # 00417a8e
    jmp.d8 L_00417ad0                            # 00417a93
L_00417a95:
    # block 0x00417a95: entered by jmp at 0x004176f3; jmp at 0x00417ad2; jmp at 0x00417ad4; jmp at 0x00417ad6; more, 3 instruction(s), calls FUN_004c97b4, falls into the block at 0x00417aa9
    mov dword ptr [0x63a58a], 0x3                # 00417a95
    mov ecx, 0x5cf659                            # 00417a9f
    call FUN_004c97b4                            # 00417aa4
L_00417aa9:
    # block 0x00417aa9: entered by jmp at 0x00417ad0; jmp at 0x00417ad8; jmp at 0x00417ae6; jmp at 0x00417aee, 2 instruction(s), ends with je to 0x00417ace (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 00417aa9
    je.d8 L_00417ace                             # 00417aad
    # block 0x00417aaf: entered by fall-through of je at 0x00417aad, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00417ace
    mov edx, dword ptr [ebp - local_4]           # 00417aaf
    mov dword ptr [ebp - local_17c], edx         # 00417ab2
    mov eax, dword ptr [ebp - local_17c]         # 00417ab8
    push eax                                     # 00417abe
    call FUN_0051dc6c                            # 00417abf
    add esp, 0x4                                 # 00417ac4
    mov dword ptr [ebp - local_4], 0x0           # 00417ac7
L_00417ace:
    # block 0x00417ace: entered by je at 0x00417aad, 1 instruction(s), ends with forward jump to 0x00417afc
    jmp.d8 L_00417afc                            # 00417ace
L_00417ad0:
    # block 0x00417ad0: entered by jmp at 0x00417a93, 1 instruction(s), ends with backward jump to 0x00417aa9
    jmp.d8 L_00417aa9                            # 00417ad0
L_00417ad2:
    # block 0x00417ad2: entered by jmp at 0x00417a43, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ad2
L_00417ad4:
    # block 0x00417ad4: entered by jmp at 0x00417985, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ad4
L_00417ad6:
    # block 0x00417ad6: entered by jmp at 0x0041792e, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ad6
L_00417ad8:
    # block 0x00417ad8: entered by jmp at 0x004178e6, 1 instruction(s), ends with backward jump to 0x00417aa9
    jmp.d8 L_00417aa9                            # 00417ad8
L_00417ada:
    # block 0x00417ada: entered by jmp at 0x0041786e, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ada
L_00417adc:
    # block 0x00417adc: entered by jmp at 0x004177b1, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417adc
L_00417ade:
    # block 0x00417ade: entered by jmp at 0x0041773b, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ade
L_00417ae0:
    # block 0x00417ae0: entered by jmp at 0x0041764c, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ae0
L_00417ae2:
    # block 0x00417ae2: entered by jmp at 0x00417540, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ae2
L_00417ae4:
    # block 0x00417ae4: entered by jmp at 0x00417450, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ae4
L_00417ae6:
    # block 0x00417ae6: entered by jmp at 0x004173ea, 1 instruction(s), ends with backward jump to 0x00417aa9
    jmp.d8 L_00417aa9                            # 00417ae6
L_00417ae8:
    # block 0x00417ae8: entered by jmp at 0x004173b0, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417ae8
L_00417aea:
    # block 0x00417aea: entered by jmp at 0x00417357, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417aea
L_00417aec:
    # block 0x00417aec: entered by jmp at 0x0041730e, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417aec
L_00417aee:
    # block 0x00417aee: entered by jmp at 0x004172d7, 1 instruction(s), ends with backward jump to 0x00417aa9
    jmp.d8 L_00417aa9                            # 00417aee
L_00417af0:
    # block 0x00417af0: entered by jmp at 0x00417286, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417af0
L_00417af2:
    # block 0x00417af2: entered by jmp at 0x0041722d, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417af2
L_00417af4:
    # block 0x00417af4: entered by jmp at 0x004171d6, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417af4
L_00417af6:
    # block 0x00417af6: entered by jmp at 0x00417126, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417af6
L_00417af8:
    # block 0x00417af8: entered by jmp at 0x004170dc, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417af8
L_00417afa:
    # block 0x00417afa: entered by jmp at 0x00417018, 1 instruction(s), ends with backward jump to 0x00417a95
    jmp.d8 L_00417a95                            # 00417afa
L_00417afc:
    # block 0x00417afc: entered by jmp at 0x00417ace, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00417afc
    pop esi                                      # 00417afd
    {load} mov esp, ebp                          # 00417afe
    pop ebp                                      # 00417b00
    ret 0xc                                      # 00417b01

