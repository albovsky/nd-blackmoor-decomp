# FUN_004a3f40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3f40
# extent:       0x004a3f40-0x004a42c0 (896 code bytes)
# span:         0x004a3f40-0x004a42c0 (code 896, tables 0, padding 0)
# sha256:       bc04fb3e4d529c7fa4413e6330b91a66a287f895b843c581c25f1dfd49258a15
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a3f40
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_4, field_8, field_c, field_260, field_26e, field_280, field_284, field_288, field_28c, field_413, field_470, field_650 and 1 more; [ecx + n] field_4, field_8, field_c, field_1e, field_21, field_22, field_278, field_290, field_6b3, field_6b7; [edx + n] field_4, field_8, field_c, field_21, field_22, field_276, field_6af
# callees:      calls FUN_004a3beb, FUN_004a42c0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 244 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_22, 0x22  # offset +0x22
.equ field_260, 0x260  # offset +0x260
.equ field_26e, 0x26e  # offset +0x26e
.equ field_276, 0x276  # offset +0x276
.equ field_278, 0x278  # offset +0x278
.equ field_280, 0x280  # offset +0x280
.equ field_284, 0x284  # offset +0x284
.equ field_288, 0x288  # offset +0x288
.equ field_28c, 0x28c  # offset +0x28c
.equ field_290, 0x290  # offset +0x290
.equ field_413, 0x413  # offset +0x413
.equ field_470, 0x470  # offset +0x470
.equ field_650, 0x650  # offset +0x650
.equ field_6af, 0x6af  # offset +0x6af
.equ field_6b3, 0x6b3  # offset +0x6b3
.equ field_6b7, 0x6b7  # offset +0x6b7
.equ field_6bb, 0x6bb  # offset +0x6bb

# --- external targets -----------------------------------------------
.set FUN_004a3beb, .text + (0x004a3beb - 0x401000)
.set FUN_004a42c0, .text + (0x004a42c0 - 0x401000)

.org 0x004a3f40 - 0x401000
.globl FUN_004a3f40
FUN_004a3f40:
    # block 0x004a3f40: entry, 7 instruction(s), ends with je to 0x004a42b8 (forward)
    push ebp                                     # 004a3f40
    {load} mov ebp, esp                          # 004a3f41
    sub esp, 0x10                                # 004a3f43
    mov dword ptr [ebp - local_10], ecx          # 004a3f46
    mov eax, dword ptr [ebp - local_10]          # 004a3f49
    cmp dword ptr [eax + field_26e], 0x0         # 004a3f4c
    je.d32 L_004a42b8                            # 004a3f53
    # block 0x004a3f59: entered by fall-through of je at 0x004a3f53, 28 instruction(s), ends with je to 0x004a40cb (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004a3f59
    movsx edx, word ptr [ecx + field_1e]         # 004a3f5c
    imul edx, edx, 0x8d                          # 004a3f60
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004a3f66
    mov dword ptr [ebp - local_4], eax           # 004a3f6c
    mov ecx, dword ptr [ebp - local_10]          # 004a3f6f
    mov word ptr [ecx + field_278], 0xffff       # 004a3f72
    mov edx, dword ptr [ebp - local_10]          # 004a3f7b
    mov word ptr [edx + field_276], 0xffff       # 004a3f7e
    mov eax, dword ptr [ebp - local_10]          # 004a3f87
    mov ecx, dword ptr [ebp + arg_10]            # 004a3f8a
    mov edx, dword ptr [ecx + field_4]           # 004a3f8d
    mov dword ptr [eax + field_284], edx         # 004a3f90
    mov eax, dword ptr [ebp - local_10]          # 004a3f96
    mov ecx, dword ptr [ebp + arg_10]            # 004a3f99
    mov edx, dword ptr [ecx + field_c]           # 004a3f9c
    mov dword ptr [eax + field_28c], edx         # 004a3f9f
    mov eax, dword ptr [ebp - local_10]          # 004a3fa5
    mov ecx, dword ptr [ebp + arg_10]            # 004a3fa8
    mov edx, dword ptr [ecx]                     # 004a3fab
    mov dword ptr [eax + field_280], edx         # 004a3fad
    mov eax, dword ptr [ebp - local_10]          # 004a3fb3
    mov ecx, dword ptr [ebp + arg_10]            # 004a3fb6
    mov edx, dword ptr [ecx + field_8]           # 004a3fb9
    mov dword ptr [eax + field_288], edx         # 004a3fbc
    mov eax, dword ptr [ebp - local_10]          # 004a3fc2
    cmp dword ptr [eax + field_260], 0x0         # 004a3fc5
    je.d32 L_004a40cb                            # 004a3fcc
    # block 0x004a3fd2: entered by fall-through of je at 0x004a3fcc, 4 instruction(s), calls FUN_004a3beb, ends with forward jump to 0x004a3fec
    mov ecx, dword ptr [ebp - local_10]          # 004a3fd2
    call FUN_004a3beb                            # 004a3fd5
    mov dword ptr [ebp - local_c], 0x0           # 004a3fda
    jmp.d8 L_004a3fec                            # 004a3fe1
L_004a3fe3:
    # block 0x004a3fe3: entered by jmp at 0x004a40c1, 3 instruction(s), falls into the block at 0x004a3fec
    mov ecx, dword ptr [ebp - local_c]           # 004a3fe3
    add ecx, 0x1                                 # 004a3fe6
    mov dword ptr [ebp - local_c], ecx           # 004a3fe9
L_004a3fec:
    # block 0x004a3fec: entered by jmp at 0x004a3fe1, 4 instruction(s), ends with jge to 0x004a40c6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a3fec
    movsx eax, byte ptr [edx + field_22]         # 004a3fef
    cmp dword ptr [ebp - local_c], eax           # 004a3ff3
    jge.d32 L_004a40c6                           # 004a3ff6
    # block 0x004a3ffc: entered by fall-through of jge at 0x004a3ff6, 2 instruction(s), ends with forward jump to 0x004a400e
    mov dword ptr [ebp - local_8], 0x0           # 004a3ffc
    jmp.d8 L_004a400e                            # 004a4003
L_004a4005:
    # block 0x004a4005: entered by jmp at 0x004a40bc, 3 instruction(s), falls into the block at 0x004a400e
    mov ecx, dword ptr [ebp - local_8]           # 004a4005
    add ecx, 0x1                                 # 004a4008
    mov dword ptr [ebp - local_8], ecx           # 004a400b
L_004a400e:
    # block 0x004a400e: entered by jmp at 0x004a4003, 4 instruction(s), ends with jge to 0x004a40c1 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a400e
    movsx eax, byte ptr [edx + field_21]         # 004a4011
    cmp dword ptr [ebp - local_8], eax           # 004a4015
    jge.d32 L_004a40c1                           # 004a4018
    # block 0x004a401e: entered by fall-through of jge at 0x004a4018, 9 instruction(s), ends with jl to 0x004a40bc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a401e
    mov edx, dword ptr [ebp - local_c]           # 004a4022
    imul edx, edx, 0x60                          # 004a4025
    mov eax, dword ptr [ebp - local_10]          # 004a4028
    lea edx, [eax + edx + field_650]             # 004a402b
    mov eax, dword ptr [ebp - local_8]           # 004a4032
    shl eax, 0x4                                 # 004a4035
    cmp ecx, dword ptr [edx + eax + field_4]     # 004a4038
    jl.d8 L_004a40bc                             # 004a403c
    # block 0x004a403e: entered by fall-through of jl at 0x004a403c, 9 instruction(s), ends with jg to 0x004a40bc (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a403e
    mov edx, dword ptr [ebp - local_c]           # 004a4042
    imul edx, edx, 0x60                          # 004a4045
    mov eax, dword ptr [ebp - local_10]          # 004a4048
    lea edx, [eax + edx + field_650]             # 004a404b
    mov eax, dword ptr [ebp - local_8]           # 004a4052
    shl eax, 0x4                                 # 004a4055
    cmp ecx, dword ptr [edx + eax + field_c]     # 004a4058
    jg.d8 L_004a40bc                             # 004a405c
    # block 0x004a405e: entered by fall-through of jg at 0x004a405c, 9 instruction(s), ends with jl to 0x004a40bc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a405e
    mov edx, dword ptr [ebp - local_c]           # 004a4062
    imul edx, edx, 0x60                          # 004a4065
    mov eax, dword ptr [ebp - local_10]          # 004a4068
    lea edx, [eax + edx + field_650]             # 004a406b
    mov eax, dword ptr [ebp - local_8]           # 004a4072
    shl eax, 0x4                                 # 004a4075
    cmp ecx, dword ptr [edx + eax]               # 004a4078
    jl.d8 L_004a40bc                             # 004a407b
    # block 0x004a407d: entered by fall-through of jl at 0x004a407b, 9 instruction(s), ends with jg to 0x004a40bc (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a407d
    mov edx, dword ptr [ebp - local_c]           # 004a4081
    imul edx, edx, 0x60                          # 004a4084
    mov eax, dword ptr [ebp - local_10]          # 004a4087
    lea edx, [eax + edx + field_650]             # 004a408a
    mov eax, dword ptr [ebp - local_8]           # 004a4091
    shl eax, 0x4                                 # 004a4094
    cmp ecx, dword ptr [edx + eax + field_8]     # 004a4097
    jg.d8 L_004a40bc                             # 004a409b
    # block 0x004a409d: entered by fall-through of jg at 0x004a409b, 9 instruction(s), calls FUN_004a42c0, ends with forward jump to 0x004a42ba
    mov ecx, dword ptr [ebp - local_c]           # 004a409d
    push ecx                                     # 004a40a0
    mov edx, dword ptr [ebp - local_8]           # 004a40a1
    push edx                                     # 004a40a4
    push 0x274d                                  # 004a40a5
    mov ecx, dword ptr [ebp - local_10]          # 004a40aa
    call FUN_004a42c0                            # 004a40ad
    mov eax, 0x1                                 # 004a40b2
    jmp.d32 L_004a42ba                           # 004a40b7
L_004a40bc:
    # block 0x004a40bc: entered by jl at 0x004a403c; jg at 0x004a405c; jl at 0x004a407b; jg at 0x004a409b, 1 instruction(s), ends with backward jump to 0x004a4005
    jmp.d32 L_004a4005                           # 004a40bc
L_004a40c1:
    # block 0x004a40c1: entered by jge at 0x004a4018, 1 instruction(s), ends with backward jump to 0x004a3fe3
    jmp.d32 L_004a3fe3                           # 004a40c1
L_004a40c6:
    # block 0x004a40c6: entered by jge at 0x004a3ff6, 1 instruction(s), ends with forward jump to 0x004a42b8
    jmp.d32 L_004a42b8                           # 004a40c6
L_004a40cb:
    # block 0x004a40cb: entered by je at 0x004a3fcc, 2 instruction(s), ends with forward jump to 0x004a40dd
    mov dword ptr [ebp - local_c], 0x0           # 004a40cb
    jmp.d8 L_004a40dd                            # 004a40d2
L_004a40d4:
    # block 0x004a40d4: entered by jmp at 0x004a425f, 3 instruction(s), falls into the block at 0x004a40dd
    mov eax, dword ptr [ebp - local_c]           # 004a40d4
    add eax, 0x1                                 # 004a40d7
    mov dword ptr [ebp - local_c], eax           # 004a40da
L_004a40dd:
    # block 0x004a40dd: entered by jmp at 0x004a40d2, 4 instruction(s), ends with jge to 0x004a4264 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a40dd
    movsx edx, byte ptr [ecx + field_22]         # 004a40e0
    cmp dword ptr [ebp - local_c], edx           # 004a40e4
    jge.d32 L_004a4264                           # 004a40e7
    # block 0x004a40ed: entered by fall-through of jge at 0x004a40e7, 2 instruction(s), ends with forward jump to 0x004a40ff
    mov dword ptr [ebp - local_8], 0x0           # 004a40ed
    jmp.d8 L_004a40ff                            # 004a40f4
L_004a40f6:
    # block 0x004a40f6: entered by jmp at 0x004a425a, 3 instruction(s), falls into the block at 0x004a40ff
    mov eax, dword ptr [ebp - local_8]           # 004a40f6
    add eax, 0x1                                 # 004a40f9
    mov dword ptr [ebp - local_8], eax           # 004a40fc
L_004a40ff:
    # block 0x004a40ff: entered by jmp at 0x004a40f4, 4 instruction(s), ends with jge to 0x004a425f (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a40ff
    movsx edx, byte ptr [ecx + field_21]         # 004a4102
    cmp dword ptr [ebp - local_8], edx           # 004a4106
    jge.d32 L_004a425f                           # 004a4109
    # block 0x004a410f: entered by fall-through of jge at 0x004a4109, 4 instruction(s), ends with je to 0x004a41bf (forward)
    mov eax, dword ptr [ebp - local_4]           # 004a410f
    movsx ecx, word ptr [eax + field_413]        # 004a4112
    test ecx, ecx                                # 004a4119
    je.d32 L_004a41bf                            # 004a411b
    # block 0x004a4121: entered by fall-through of je at 0x004a411b, 9 instruction(s), ends with jl to 0x004a41bf (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a4121
    mov eax, dword ptr [ebp - local_c]           # 004a4125
    imul eax, eax, 0x60                          # 004a4128
    mov ecx, dword ptr [ebp - local_10]          # 004a412b
    lea eax, [ecx + eax + field_290]             # 004a412e
    mov ecx, dword ptr [ebp - local_8]           # 004a4135
    shl ecx, 0x4                                 # 004a4138
    cmp edx, dword ptr [eax + ecx + field_4]     # 004a413b
    jl.d8 L_004a41bf                             # 004a413f
    # block 0x004a4141: entered by fall-through of jl at 0x004a413f, 9 instruction(s), ends with jg to 0x004a41bf (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a4141
    mov eax, dword ptr [ebp - local_c]           # 004a4145
    imul eax, eax, 0x60                          # 004a4148
    mov ecx, dword ptr [ebp - local_10]          # 004a414b
    lea eax, [ecx + eax + field_290]             # 004a414e
    mov ecx, dword ptr [ebp - local_8]           # 004a4155
    shl ecx, 0x4                                 # 004a4158
    cmp edx, dword ptr [eax + ecx + field_c]     # 004a415b
    jg.d8 L_004a41bf                             # 004a415f
    # block 0x004a4161: entered by fall-through of jg at 0x004a415f, 9 instruction(s), ends with jl to 0x004a41bf (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a4161
    mov eax, dword ptr [ebp - local_c]           # 004a4165
    imul eax, eax, 0x60                          # 004a4168
    mov ecx, dword ptr [ebp - local_10]          # 004a416b
    lea eax, [ecx + eax + field_290]             # 004a416e
    mov ecx, dword ptr [ebp - local_8]           # 004a4175
    shl ecx, 0x4                                 # 004a4178
    cmp edx, dword ptr [eax + ecx]               # 004a417b
    jl.d8 L_004a41bf                             # 004a417e
    # block 0x004a4180: entered by fall-through of jl at 0x004a417e, 9 instruction(s), ends with jg to 0x004a41bf (forward)
    movsx edx, word ptr [ebp + arg_8]            # 004a4180
    mov eax, dword ptr [ebp - local_c]           # 004a4184
    imul eax, eax, 0x60                          # 004a4187
    mov ecx, dword ptr [ebp - local_10]          # 004a418a
    lea eax, [ecx + eax + field_290]             # 004a418d
    mov ecx, dword ptr [ebp - local_8]           # 004a4194
    shl ecx, 0x4                                 # 004a4197
    cmp edx, dword ptr [eax + ecx + field_8]     # 004a419a
    jg.d8 L_004a41bf                             # 004a419e
    # block 0x004a41a0: entered by fall-through of jg at 0x004a419e, 9 instruction(s), calls FUN_004a42c0, ends with forward jump to 0x004a42ba
    mov edx, dword ptr [ebp - local_c]           # 004a41a0
    push edx                                     # 004a41a3
    mov eax, dword ptr [ebp - local_8]           # 004a41a4
    push eax                                     # 004a41a7
    push 0x274e                                  # 004a41a8
    mov ecx, dword ptr [ebp - local_10]          # 004a41ad
    call FUN_004a42c0                            # 004a41b0
    mov eax, 0x1                                 # 004a41b5
    jmp.d32 L_004a42ba                           # 004a41ba
L_004a41bf:
    # block 0x004a41bf: entered by je at 0x004a411b; jl at 0x004a413f; jg at 0x004a415f; jl at 0x004a417e; jg at 0x004a419e, 9 instruction(s), ends with jl to 0x004a425a (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a41bf
    mov edx, dword ptr [ebp - local_c]           # 004a41c3
    imul edx, edx, 0x60                          # 004a41c6
    mov eax, dword ptr [ebp - local_10]          # 004a41c9
    lea edx, [eax + edx + field_470]             # 004a41cc
    mov eax, dword ptr [ebp - local_8]           # 004a41d3
    shl eax, 0x4                                 # 004a41d6
    cmp ecx, dword ptr [edx + eax + field_4]     # 004a41d9
    jl.d8 L_004a425a                             # 004a41dd
    # block 0x004a41df: entered by fall-through of jl at 0x004a41dd, 9 instruction(s), ends with jg to 0x004a425a (forward)
    movsx ecx, word ptr [ebp + arg_c]            # 004a41df
    mov edx, dword ptr [ebp - local_c]           # 004a41e3
    imul edx, edx, 0x60                          # 004a41e6
    mov eax, dword ptr [ebp - local_10]          # 004a41e9
    lea edx, [eax + edx + field_470]             # 004a41ec
    mov eax, dword ptr [ebp - local_8]           # 004a41f3
    shl eax, 0x4                                 # 004a41f6
    cmp ecx, dword ptr [edx + eax + field_c]     # 004a41f9
    jg.d8 L_004a425a                             # 004a41fd
    # block 0x004a41ff: entered by fall-through of jg at 0x004a41fd, 9 instruction(s), ends with jl to 0x004a425a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a41ff
    mov edx, dword ptr [ebp - local_c]           # 004a4203
    imul edx, edx, 0x60                          # 004a4206
    mov eax, dword ptr [ebp - local_10]          # 004a4209
    lea edx, [eax + edx + field_470]             # 004a420c
    mov eax, dword ptr [ebp - local_8]           # 004a4213
    shl eax, 0x4                                 # 004a4216
    cmp ecx, dword ptr [edx + eax]               # 004a4219
    jl.d8 L_004a425a                             # 004a421c
    # block 0x004a421e: entered by fall-through of jl at 0x004a421c, 9 instruction(s), ends with jg to 0x004a425a (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a421e
    mov edx, dword ptr [ebp - local_c]           # 004a4222
    imul edx, edx, 0x60                          # 004a4225
    mov eax, dword ptr [ebp - local_10]          # 004a4228
    lea edx, [eax + edx + field_470]             # 004a422b
    mov eax, dword ptr [ebp - local_8]           # 004a4232
    shl eax, 0x4                                 # 004a4235
    cmp ecx, dword ptr [edx + eax + field_8]     # 004a4238
    jg.d8 L_004a425a                             # 004a423c
    # block 0x004a423e: entered by fall-through of jg at 0x004a423c, 9 instruction(s), calls FUN_004a42c0, ends with forward jump to 0x004a42ba
    mov ecx, dword ptr [ebp - local_c]           # 004a423e
    push ecx                                     # 004a4241
    mov edx, dword ptr [ebp - local_8]           # 004a4242
    push edx                                     # 004a4245
    push 0x274c                                  # 004a4246
    mov ecx, dword ptr [ebp - local_10]          # 004a424b
    call FUN_004a42c0                            # 004a424e
    mov eax, 0x1                                 # 004a4253
    jmp.d8 L_004a42ba                            # 004a4258
L_004a425a:
    # block 0x004a425a: entered by jl at 0x004a41dd; jg at 0x004a41fd; jl at 0x004a421c; jg at 0x004a423c, 1 instruction(s), ends with backward jump to 0x004a40f6
    jmp.d32 L_004a40f6                           # 004a425a
L_004a425f:
    # block 0x004a425f: entered by jge at 0x004a4109, 1 instruction(s), ends with backward jump to 0x004a40d4
    jmp.d32 L_004a40d4                           # 004a425f
L_004a4264:
    # block 0x004a4264: entered by jge at 0x004a40e7, 4 instruction(s), ends with jl to 0x004a42b8 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 004a4264
    mov ecx, dword ptr [ebp - local_4]           # 004a4268
    cmp eax, dword ptr [ecx + field_6b3]         # 004a426b
    jl.d8 L_004a42b8                             # 004a4271
    # block 0x004a4273: entered by fall-through of jl at 0x004a4271, 4 instruction(s), ends with jg to 0x004a42b8 (forward)
    movsx edx, word ptr [ebp + arg_c]            # 004a4273
    mov eax, dword ptr [ebp - local_4]           # 004a4277
    cmp edx, dword ptr [eax + field_6bb]         # 004a427a
    jg.d8 L_004a42b8                             # 004a4280
    # block 0x004a4282: entered by fall-through of jg at 0x004a4280, 4 instruction(s), ends with jl to 0x004a42b8 (forward)
    movsx ecx, word ptr [ebp + arg_8]            # 004a4282
    mov edx, dword ptr [ebp - local_4]           # 004a4286
    cmp ecx, dword ptr [edx + field_6af]         # 004a4289
    jl.d8 L_004a42b8                             # 004a428f
    # block 0x004a4291: entered by fall-through of jl at 0x004a428f, 4 instruction(s), ends with jg to 0x004a42b8 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 004a4291
    mov ecx, dword ptr [ebp - local_4]           # 004a4295
    cmp eax, dword ptr [ecx + field_6b7]         # 004a4298
    jg.d8 L_004a42b8                             # 004a429e
    # block 0x004a42a0: entered by fall-through of jg at 0x004a429e, 7 instruction(s), calls FUN_004a42c0, ends with forward jump to 0x004a42ba
    push 0x0                                     # 004a42a0
    push 0x0                                     # 004a42a2
    push 0x274f                                  # 004a42a4
    mov ecx, dword ptr [ebp - local_10]          # 004a42a9
    call FUN_004a42c0                            # 004a42ac
    mov eax, 0x1                                 # 004a42b1
    jmp.d8 L_004a42ba                            # 004a42b6
L_004a42b8:
    # block 0x004a42b8: entered by je at 0x004a3f53; jmp at 0x004a40c6; jl at 0x004a4271; jg at 0x004a4280; more, 1 instruction(s), falls into the block at 0x004a42ba
    {load} xor eax, eax                          # 004a42b8
L_004a42ba:
    # block 0x004a42ba: entered by jmp at 0x004a40b7; jmp at 0x004a41ba; jmp at 0x004a4258; jmp at 0x004a42b6, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004a42ba
    pop ebp                                      # 004a42bc
    ret 0xc                                      # 004a42bd

