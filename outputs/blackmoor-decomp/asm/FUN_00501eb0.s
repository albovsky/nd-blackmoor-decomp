# FUN_00501eb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00501eb0
# extent:       0x00501eb0-0x00502293 (995 code bytes)
# span:         0x00501eb0-0x005022a0 (code 995, tables 0, padding 13)
# sha256:       f8ed3b841b08fe219a93fabb52ba8a8af80c1d2a514fe1cd38863cea7d34afea
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00501eb0
# arguments:    10 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28, arg_2c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_1f8, field_200, field_484, field_minus_400; [ecx + n] field_1f8; [edx + n] field_84, field_fc, field_138, field_204, field_484; [esp + n] stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_2c, stk_30, stk_34, stk_38, stk_3c and 15 more
# callees:      calls FUN_00502370, FUN_0050e19e, FUN_00501e90, FUN_005022a0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 290 instruction(s), 23 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_400, 0x400  # offset -0x400
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ stk_18, 0x18  # offset +0x18
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ stk_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28
.equ stk_28, 0x28  # offset +0x28
.equ stk_2c, 0x2c  # offset +0x2c
.equ arg_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ stk_34, 0x34  # offset +0x34
.equ stk_38, 0x38  # offset +0x38
.equ stk_3c, 0x3c  # offset +0x3c
.equ stk_40, 0x40  # offset +0x40
.equ stk_44, 0x44  # offset +0x44
.equ stk_48, 0x48  # offset +0x48
.equ stk_4c, 0x4c  # offset +0x4c
.equ stk_50, 0x50  # offset +0x50
.equ stk_54, 0x54  # offset +0x54
.equ stk_58, 0x58  # offset +0x58
.equ stk_5c, 0x5c  # offset +0x5c
.equ stk_60, 0x60  # offset +0x60
.equ stk_64, 0x64  # offset +0x64
.equ stk_68, 0x68  # offset +0x68
.equ stk_6c, 0x6c  # offset +0x6c
.equ stk_70, 0x70  # offset +0x70
.equ stk_74, 0x74  # offset +0x74
.equ stk_80, 0x80  # offset +0x80
.equ field_84, 0x84  # offset +0x84
.equ field_fc, 0xfc  # offset +0xfc
.equ field_138, 0x138  # offset +0x138
.equ field_1f8, 0x1f8  # offset +0x1f8
.equ field_200, 0x200  # offset +0x200
.equ field_204, 0x204  # offset +0x204
.equ field_484, 0x484  # offset +0x484

# --- external targets -----------------------------------------------
.set FUN_00501e90, .text + (0x00501e90 - 0x401000)
.set FUN_005022a0, .text + (0x005022a0 - 0x401000)
.set FUN_00502370, .text + (0x00502370 - 0x401000)
.set FUN_0050e19e, .text + (0x0050e19e - 0x401000)

.org 0x00501eb0 - 0x401000
.globl FUN_00501eb0
FUN_00501eb0:
    # block 0x00501eb0: entry, 15 instruction(s), ends with jle to 0x0050228c (forward)
    push ebp                                     # 00501eb0
    {load} mov ebp, esp                          # 00501eb1
    and esp, -0x8                                # 00501eb3
    sub esp, 0x6c                                # 00501eb6
    mov eax, dword ptr [ebp + arg_10]            # 00501eb9
    push ebx                                     # 00501ebc
    push esi                                     # 00501ebd
    push edi                                     # 00501ebe
    mov esi, dword ptr [eax]                     # 00501ebf
    mov eax, dword ptr [ebp + arg_14]            # 00501ec1
    mov dword ptr [esp + stk_54], esi            # 00501ec4
    mov dword ptr [esp + stk_50], 0x0            # 00501ec8
    mov ecx, dword ptr [eax + field_484]         # 00501ed0
    test ecx, ecx                                # 00501ed6
    jle.d32 L_0050228c                           # 00501ed8
    # block 0x00501ede: entered by fall-through of jle at 0x00501ed8, 7 instruction(s), falls into the block at 0x00501ef7
    mov ecx, dword ptr [ebp + arg_20]            # 00501ede
    mov edx, dword ptr [ebp + arg_1c]            # 00501ee1
    add eax, 0x888                               # 00501ee4
    {load} sub edx, ecx                          # 00501ee9
    mov dword ptr [esp + stk_1c], ecx            # 00501eeb
    mov dword ptr [esp + stk_18], eax            # 00501eef
    mov dword ptr [esp + stk_74], edx            # 00501ef3
L_00501ef7:
    # block 0x00501ef7: entered by jl at 0x00502286, 5 instruction(s), ends with jne to 0x00501f15 (forward)
    mov ecx, dword ptr [eax - field_minus_400]   # 00501ef7
    mov edx, dword ptr [ebp + arg_28]            # 00501efd
    shl ecx, 0x2                                 # 00501f00
    cmp dword ptr [ecx + edx], 0x0               # 00501f03
    jne.d8 L_00501f15                            # 00501f07
    # block 0x00501f09: entered by fall-through of jne at 0x00501f07, 3 instruction(s), ends with je to 0x00502260 (forward)
    mov edi, dword ptr [eax]                     # 00501f09
    cmp dword ptr [edx + 4*edi], 0x0             # 00501f0b
    je.d32 L_00502260                            # 00501f0f
L_00501f15:
    # block 0x00501f15: entered by jne at 0x00501f07; fall-through of je at 0x00501f0f, 29 instruction(s), ends with je to 0x00501f8d (forward)
    mov eax, dword ptr [eax]                     # 00501f15
    mov edx, dword ptr [ebp + arg_18]            # 00501f17
    shl eax, 0x2                                 # 00501f1a
    mov ebx, dword ptr [ecx + edx]               # 00501f1d
    mov edi, dword ptr [eax + edx]               # 00501f20
    mov edx, dword ptr [esp + stk_54]            # 00501f23
    mov dword ptr [esp + stk_60], ebx            # 00501f27
    mov dword ptr [esp + stk_40], edi            # 00501f2b
    lea ebx, [ebx + 4*edx]                       # 00501f2f
    lea edx, [edi + 4*edx]                       # 00501f32
    mov dword ptr [esp + stk_64], edx            # 00501f35
    mov edx, dword ptr [ebp + arg_24]            # 00501f39
    mov dword ptr [esp + stk_28], ebx            # 00501f3c
    mov ebx, dword ptr [ecx + edx]               # 00501f40
    mov eax, dword ptr [eax + edx]               # 00501f43
    mov edx, dword ptr [ebp + arg_c]             # 00501f46
    mov dword ptr [esp + stk_5c], ebx            # 00501f49
    mov ebx, dword ptr [ebp + arg_8]             # 00501f4d
    mov dword ptr [esp + stk_58], eax            # 00501f50
    mov eax, dword ptr [edx + 4*ebx + field_fc]  # 00501f54
    fld qword ptr [8*eax + 0x566518]             # 00501f5b
    mov eax, dword ptr [edx + 4*ebx + field_138] # 00501f62
    fstp dword ptr [esp + stk_34]                # 00501f69
    fld qword ptr [8*eax + 0x566518]             # 00501f6d
    mov eax, dword ptr [ebp + arg_10]            # 00501f74
    fstp dword ptr [esp + stk_30]                # 00501f77
    mov eax, dword ptr [eax + field_4]           # 00501f7b
    cmp dword ptr [eax + field_1f8], 0x0         # 00501f7e
    je.d8 L_00501f8d                             # 00501f85
    # block 0x00501f87: entered by fall-through of je at 0x00501f85, 1 instruction(s), falls into the block at 0x00501f8d
    mov esi, dword ptr [eax + field_200]         # 00501f87
L_00501f8d:
    # block 0x00501f8d: entered by je at 0x00501f85, 18 instruction(s), ends with jle to 0x0050225c (forward)
    mov eax, dword ptr [eax]                     # 00501f8d
    mov dword ptr [esp + stk_10], esi            # 00501f8f
    lea eax, [eax + 2*eax]                       # 00501f93
    lea esi, [ebx + 4*eax]                       # 00501f96
    {load} add eax, esi                          # 00501f99
    mov edx, dword ptr [edx + 4*eax + field_84]  # 00501f9b
    mov eax, dword ptr [ebp + arg_28]            # 00501fa2
    mov dword ptr [esp + stk_48], edx            # 00501fa5
    mov dword ptr [ecx + eax], 0x1               # 00501fa9
    mov ecx, dword ptr [esp + stk_18]            # 00501fb0
    mov edx, dword ptr [ecx]                     # 00501fb4
    mov dword ptr [eax + 4*edx], 0x1             # 00501fb6
    mov eax, dword ptr [ebp + arg_10]            # 00501fbd
    {load} xor edx, edx                          # 00501fc0
    mov esi, dword ptr [eax]                     # 00501fc2
    mov dword ptr [esp + stk_4c], edx            # 00501fc4
    test esi, esi                                # 00501fc8
    jle.d32 L_0050225c                           # 00501fca
    # block 0x00501fd0: entered by fall-through of jle at 0x00501fca, 2 instruction(s), falls into the block at 0x00501fd6
    {load} xor ecx, ecx                          # 00501fd0
    mov dword ptr [esp + stk_2c], ecx            # 00501fd2
L_00501fd6:
    # block 0x00501fd6: entered by jl at 0x00502256, 4 instruction(s), ends with jle to 0x00502131 (forward)
    mov eax, dword ptr [esp + stk_10]            # 00501fd6
    mov dword ptr [esp + stk_14], 0x0            # 00501fda
    test eax, eax                                # 00501fe2
    jle.d32 L_00502131                           # 00501fe4
    # block 0x00501fea: entered by fall-through of jle at 0x00501fe4, 21 instruction(s), ends with forward jump to 0x00502037
    mov eax, dword ptr [esp + stk_58]            # 00501fea
    mov dword ptr [esp + stk_20], ecx            # 00501fee
    lea esi, [ecx + edi]                         # 00501ff2
    mov ecx, dword ptr [esp + stk_5c]            # 00501ff5
    mov ebx, dword ptr [esp + stk_28]            # 00501ff9
    {load} sub eax, ecx                          # 00501ffd
    mov dword ptr [esp + stk_70], eax            # 00501fff
    {load} mov eax, ecx                          # 00502003
    mov ecx, dword ptr [esp + stk_64]            # 00502005
    mov dword ptr [esp + stk_24], edx            # 00502009
    mov edx, dword ptr [esp + stk_60]            # 0050200d
    {load} sub eax, edi                          # 00502011
    mov dword ptr [esp + stk_6c], eax            # 00502013
    mov eax, dword ptr [esp + stk_10]            # 00502017
    {load} sub edx, edi                          # 0050201b
    {load} sub ebx, edi                          # 0050201d
    {load} sub ecx, edi                          # 0050201f
    mov dword ptr [esp + stk_68], edx            # 00502021
    mov dword ptr [esp + stk_38], ecx            # 00502025
    mov dword ptr [esp + stk_44], eax            # 00502029
    jmp.d8 L_00502037                            # 0050202d
L_0050202f:
    # block 0x0050202f: entered by jne at 0x0050212b, 2 instruction(s), falls into the block at 0x00502037
    mov ecx, dword ptr [esp + stk_38]            # 0050202f
    mov edx, dword ptr [esp + stk_68]            # 00502033
L_00502037:
    # block 0x00502037: entered by jmp at 0x0050202d, 3 instruction(s), ends with jge to 0x0050221d (forward)
    mov eax, dword ptr [esp + stk_24]            # 00502037
    cmp eax, dword ptr [ebp + arg_2c]            # 0050203b
    jge.d32 L_0050221d                           # 0050203e
    # block 0x00502044: entered by fall-through of jge at 0x0050203e, 2 instruction(s), ends with jl to 0x0050206d (forward)
    cmp eax, dword ptr [esp + stk_48]            # 00502044
    jl.d8 L_0050206d                             # 00502048
    # block 0x0050204a: entered by fall-through of jl at 0x00502048, 7 instruction(s), ends with jne to 0x0050206d (forward)
    fld dword ptr [edx + esi]                    # 0050204a
    fabs                                         # 0050204d
    fld dword ptr [esp + stk_30]                 # 0050204f
    fcompp                                       # 00502053
    fnstsw ax                                    # 00502055
    test ah, 0x41                                # 00502057
    jne.d8 L_0050206d                            # 0050205a
    # block 0x0050205c: entered by fall-through of jne at 0x0050205a, 7 instruction(s), ends with je to 0x0050209c (forward)
    fld dword ptr [esi]                          # 0050205c
    fabs                                         # 0050205e
    fld dword ptr [esp + stk_30]                 # 00502060
    fcompp                                       # 00502064
    fnstsw ax                                    # 00502066
    test ah, 0x41                                # 00502068
    je.d8 L_0050209c                             # 0050206b
L_0050206d:
    # block 0x0050206d: entered by jl at 0x00502048; jne at 0x0050205a; fall-through of je at 0x0050206b, 8 instruction(s), ends with jne to 0x00502201 (forward)
    fld dword ptr [edx + esi]                    # 0050206d
    fst dword ptr [esp + stk_3c]                 # 00502070
    fabs                                         # 00502074
    fld dword ptr [esp + stk_34]                 # 00502076
    fcompp                                       # 0050207a
    fnstsw ax                                    # 0050207c
    test ah, 0x41                                # 0050207e
    jne.d32 L_00502201                           # 00502081
    # block 0x00502087: entered by fall-through of jne at 0x00502081, 7 instruction(s), ends with jne to 0x00502201 (forward)
    fld dword ptr [esi]                          # 00502087
    fabs                                         # 00502089
    fld dword ptr [esp + stk_34]                 # 0050208b
    fcompp                                       # 0050208f
    fnstsw ax                                    # 00502091
    test ah, 0x41                                # 00502093
    jne.d32 L_00502201                           # 00502096
L_0050209c:
    # block 0x0050209c: entered by je at 0x0050206b; fall-through of jne at 0x00502096, 29 instruction(s), calls FUN_00502370, FUN_0050e19e, ends with je to 0x00502107 (forward)
    mov ecx, dword ptr [esp + stk_6c]            # 0050209c
    mov edx, dword ptr [esp + stk_38]            # 005020a0
    {load} add edx, esi                          # 005020a4
    lea edi, [ebx + esi]                         # 005020a6
    lea eax, [ecx + esi]                         # 005020a9
    mov ecx, dword ptr [esp + stk_70]            # 005020ac
    push edx                                     # 005020b0
    push edi                                     # 005020b1
    mov edx, dword ptr [eax + ecx]               # 005020b2
    mov eax, dword ptr [eax]                     # 005020b5
    mov ecx, dword ptr [esp + stk_24]            # 005020b7
    push edx                                     # 005020bb
    mov edx, dword ptr [esp + stk_80]            # 005020bc
    push eax                                     # 005020c3
    mov eax, dword ptr [ecx + edx]               # 005020c4
    mov ecx, dword ptr [esp + stk_30]            # 005020c7
    mov edx, dword ptr [eax + ecx]               # 005020cb
    push edx                                     # 005020ce
    call FUN_00502370                            # 005020cf
    fld dword ptr [edi]                          # 005020d4
    fadd dword ptr [0x52cd14]                    # 005020d6
    add esp, 0xc                                 # 005020dc
    fstp qword ptr [esp]                         # 005020df
    call FUN_0050e19e                            # 005020e2
    fcomp qword ptr [0x52c7b0]                   # 005020e7
    add esp, 0x8                                 # 005020ed
    fnstsw ax                                    # 005020f0
    test ah, 0x40                                # 005020f2
    je.d8 L_00502107                             # 005020f5
    # block 0x005020f7: entered by fall-through of je at 0x005020f5, 6 instruction(s), falls into the block at 0x00502107
    fld dword ptr [edi]                          # 005020f7
    fld st(0)                                    # 005020f9
    fmul st, st(1)                               # 005020fb
    fadd dword ptr [esp + stk_14]                # 005020fd
    fstp dword ptr [esp + stk_14]                # 00502101
    fstp st(0)                                   # 00502105
L_00502107:
    # block 0x00502107: entered by je at 0x005020f5, 1 instruction(s), falls into the block at 0x0050210b
    mov edi, dword ptr [esp + stk_40]            # 00502107
L_0050210b:
    # block 0x0050210b: entered by jmp at 0x00502218; jmp at 0x0050222b, 11 instruction(s), ends with jne to 0x0050202f (backward)
    mov eax, dword ptr [esp + stk_20]            # 0050210b
    mov ecx, dword ptr [esp + stk_24]            # 0050210f
    add eax, 0x4                                 # 00502113
    add esi, 0x4                                 # 00502116
    mov dword ptr [esp + stk_20], eax            # 00502119
    mov eax, dword ptr [esp + stk_44]            # 0050211d
    inc ecx                                      # 00502121
    dec eax                                      # 00502122
    mov dword ptr [esp + stk_24], ecx            # 00502123
    mov dword ptr [esp + stk_44], eax            # 00502127
    jne.d32 L_0050202f                           # 0050212b
L_00502131:
    # block 0x00502131: entered by jle at 0x00501fe4; fall-through of jne at 0x0050212b, 5 instruction(s), ends with je to 0x00502230 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00502131
    mov ecx, dword ptr [eax + field_4]           # 00502134
    mov eax, dword ptr [ecx + field_1f8]         # 00502137
    test eax, eax                                # 0050213d
    je.d32 L_00502230                            # 0050213f
    # block 0x00502145: entered by fall-through of je at 0x0050213f, 4 instruction(s), ends with jle to 0x00502234 (forward)
    mov ecx, dword ptr [esp + stk_10]            # 00502145
    mov dword ptr [esp + stk_44], 0x0            # 00502149
    test ecx, ecx                                # 00502151
    jle.d32 L_00502234                           # 00502153
    # block 0x00502159: entered by fall-through of jle at 0x00502153, 2 instruction(s), falls into the block at 0x00502161
    mov edx, dword ptr [esp + stk_2c]            # 00502159
    mov dword ptr [esp + stk_24], edx            # 0050215d
L_00502161:
    # block 0x00502161: entered by jl at 0x005021f9, 7 instruction(s), ends with jne to 0x00502234 (forward)
    mov eax, dword ptr [ebp + arg_10]            # 00502161
    fld dword ptr [esp + stk_14]                 # 00502164
    mov edx, dword ptr [eax + field_4]           # 00502168
    fcomp qword ptr [edx + field_204]            # 0050216b
    fnstsw ax                                    # 00502171
    test ah, 0x1                                 # 00502173
    jne.d32 L_00502234                           # 00502176
    # block 0x0050217c: entered by fall-through of jne at 0x00502176, 7 instruction(s), ends with jge to 0x005021df (forward)
    mov eax, dword ptr [esp + stk_1c]            # 0050217c
    mov edx, dword ptr [esp + stk_24]            # 00502180
    mov ecx, dword ptr [eax]                     # 00502184
    mov eax, dword ptr [ebp + arg_2c]            # 00502186
    mov ebx, dword ptr [edx + ecx]               # 00502189
    {load} cmp ebx, eax                          # 0050218c
    jge.d8 L_005021df                            # 0050218e
    # block 0x00502190: entered by fall-through of jge at 0x0050218e, 2 instruction(s), ends with jl to 0x005021df (forward)
    cmp ebx, dword ptr [esp + stk_48]            # 00502190
    jl.d8 L_005021df                             # 00502194
    # block 0x00502196: entered by fall-through of jl at 0x00502194, 11 instruction(s), calls FUN_0050e19e, ends with je to 0x005021df (forward)
    mov eax, dword ptr [esp + stk_28]            # 00502196
    sub esp, 0x8                                 # 0050219a
    fld dword ptr [eax + 4*ebx]                  # 0050219d
    fadd dword ptr [0x52cd14]                    # 005021a0
    fstp qword ptr [esp]                         # 005021a6
    call FUN_0050e19e                            # 005021a9
    fcomp qword ptr [0x52c7b0]                   # 005021ae
    add esp, 0x8                                 # 005021b4
    fnstsw ax                                    # 005021b7
    test ah, 0x40                                # 005021b9
    je.d8 L_005021df                             # 005021bc
    # block 0x005021be: entered by fall-through of je at 0x005021bc, 9 instruction(s), calls FUN_00501e90, falls into the block at 0x005021df
    mov esi, dword ptr [esp + stk_28]            # 005021be
    mov ecx, dword ptr [esi + 4*ebx]             # 005021c2
    push ecx                                     # 005021c5
    call FUN_00501e90                            # 005021c6
    fstp dword ptr [esi + 4*ebx]                 # 005021cb
    fld dword ptr [esp + stk_18]                 # 005021ce
    fsub dword ptr [0x52cbf4]                    # 005021d2
    add esp, 0x4                                 # 005021d8
    fstp dword ptr [esp + stk_14]                # 005021db
L_005021df:
    # block 0x005021df: entered by jge at 0x0050218e; jl at 0x00502194; je at 0x005021bc, 9 instruction(s), ends with jl to 0x00502161 (backward)
    mov eax, dword ptr [esp + stk_44]            # 005021df
    mov esi, dword ptr [esp + stk_24]            # 005021e3
    mov ecx, dword ptr [esp + stk_10]            # 005021e7
    inc eax                                      # 005021eb
    add esi, 0x4                                 # 005021ec
    {load} cmp eax, ecx                          # 005021ef
    mov dword ptr [esp + stk_44], eax            # 005021f1
    mov dword ptr [esp + stk_24], esi            # 005021f5
    jl.d32 L_00502161                            # 005021f9
    # block 0x005021ff: entered by fall-through of jl at 0x005021f9, 1 instruction(s), ends with forward jump to 0x00502234
    jmp.d8 L_00502234                            # 005021ff
L_00502201:
    # block 0x00502201: entered by jne at 0x00502081; jne at 0x00502096, 11 instruction(s), calls FUN_005022a0, ends with backward jump to 0x0050210b
    mov edx, dword ptr [esp + stk_3c]            # 00502201
    {load} add ecx, esi                          # 00502205
    push ecx                                     # 00502207
    mov ecx, dword ptr [esi]                     # 00502208
    lea eax, [ebx + esi]                         # 0050220a
    push eax                                     # 0050220d
    push ecx                                     # 0050220e
    push edx                                     # 0050220f
    call FUN_005022a0                            # 00502210
    add esp, 0x10                                # 00502215
    jmp.d32 L_0050210b                           # 00502218
L_0050221d:
    # block 0x0050221d: entered by jge at 0x0050203e, 3 instruction(s), ends with backward jump to 0x0050210b
    mov dword ptr [ebx + esi], 0x0               # 0050221d
    mov dword ptr [ecx + esi], 0x0               # 00502224
    jmp.d32 L_0050210b                           # 0050222b
L_00502230:
    # block 0x00502230: entered by je at 0x0050213f, 1 instruction(s), falls into the block at 0x00502234
    mov ecx, dword ptr [esp + stk_10]            # 00502230
L_00502234:
    # block 0x00502234: entered by jle at 0x00502153; jne at 0x00502176; jmp at 0x005021ff, 11 instruction(s), ends with jl to 0x00501fd6 (backward)
    mov edx, dword ptr [esp + stk_4c]            # 00502234
    lea eax, [4*ecx]                             # 00502238
    {load} add edx, ecx                          # 0050223f
    mov ecx, dword ptr [esp + stk_2c]            # 00502241
    {load} add ecx, eax                          # 00502245
    mov eax, dword ptr [ebp + arg_10]            # 00502247
    mov dword ptr [esp + stk_4c], edx            # 0050224a
    mov dword ptr [esp + stk_2c], ecx            # 0050224e
    mov esi, dword ptr [eax]                     # 00502252
    {load} cmp edx, esi                          # 00502254
    jl.d32 L_00501fd6                            # 00502256
L_0050225c:
    # block 0x0050225c: entered by jle at 0x00501fca; fall-through of jl at 0x00502256, 1 instruction(s), falls into the block at 0x00502260
    mov eax, dword ptr [esp + stk_18]            # 0050225c
L_00502260:
    # block 0x00502260: entered by je at 0x00501f0f, 12 instruction(s), ends with jl to 0x00501ef7 (backward)
    mov edx, dword ptr [ebp + arg_14]            # 00502260
    mov ecx, dword ptr [esp + stk_50]            # 00502263
    mov ebx, dword ptr [esp + stk_1c]            # 00502267
    inc ecx                                      # 0050226b
    mov edi, dword ptr [edx + field_484]         # 0050226c
    add eax, 0x4                                 # 00502272
    add ebx, 0x4                                 # 00502275
    {load} cmp ecx, edi                          # 00502278
    mov dword ptr [esp + stk_50], ecx            # 0050227a
    mov dword ptr [esp + stk_18], eax            # 0050227e
    mov dword ptr [esp + stk_1c], ebx            # 00502282
    jl.d32 L_00501ef7                            # 00502286
L_0050228c:
    # block 0x0050228c: entered by jle at 0x00501ed8; fall-through of jl at 0x00502286, 6 instruction(s), ends with ret
    pop edi                                      # 0050228c
    pop esi                                      # 0050228d
    pop ebx                                      # 0050228e
    {load} mov esp, ebp                          # 0050228f
    pop ebp                                      # 00502291
    ret                                          # 00502292

# --- data items (not part of the function) -------------------------
.org 0x00502293 - 0x401000
PAD_00502293:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

