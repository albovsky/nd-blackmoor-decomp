# FUN_004fef70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fef70
# extent:       0x004fef70-0x004ff2f0 (896 code bytes)
# span:         0x004fef70-0x004ff2f0 (code 896, tables 0, padding 0)
# sha256:       22410ea9947225bfe235ba0f724bd1fd0186d64b1cda907788222a44c22a9c90
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fef70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8; [ebp + n] field_4, field_1c, field_minus_100; [ebx + n] field_4, field_8, field_c, field_10, field_14, field_24, field_28, field_30, field_64; [edi + n] field_4, field_8, field_c, field_10, field_14, field_20, field_2c, field_30, field_34, field_38; [edx + n] field_4, field_8; [esi + n] field_4, field_8, field_10, field_14, field_18, field_1c, field_420, field_620, field_720, field_b20, field_b24, field_b34; [esp + n] stk_8, stk_10, stk_14, stk_18, stk_1c, stk_20, stk_24, stk_28, stk_30
# callees:      calls FUN_0050e97e, FUN_004ff2f0, FUN_005053a0, FUN_005051f0, FUN_00504fc0, FUN_00502970, FUN_004ffc50, FUN_005029d0, FUN_005028f0, FUN_0050ea90; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 306 instruction(s), 15 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_100, 0x100  # offset -0x100
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ stk_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ stk_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ stk_20, 0x20  # offset +0x20
.equ stk_24, 0x24  # offset +0x24
.equ field_24, 0x24  # offset +0x24
.equ stk_28, 0x28  # offset +0x28
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ stk_30, 0x30  # offset +0x30
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_64, 0x64  # offset +0x64
.equ field_420, 0x420  # offset +0x420
.equ field_620, 0x620  # offset +0x620
.equ field_720, 0x720  # offset +0x720
.equ field_b20, 0xb20  # offset +0xb20
.equ field_b24, 0xb24  # offset +0xb24
.equ field_b34, 0xb34  # offset +0xb34

# --- external targets -----------------------------------------------
.set FUN_004ff2f0, .text + (0x004ff2f0 - 0x401000)
.set FUN_004ffc50, .text + (0x004ffc50 - 0x401000)
.set FUN_005028f0, .text + (0x005028f0 - 0x401000)
.set FUN_00502970, .text + (0x00502970 - 0x401000)
.set FUN_005029d0, .text + (0x005029d0 - 0x401000)
.set FUN_00504fc0, .text + (0x00504fc0 - 0x401000)
.set FUN_005051f0, .text + (0x005051f0 - 0x401000)
.set FUN_005053a0, .text + (0x005053a0 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x004fef70 - 0x401000
.globl FUN_004fef70
FUN_004fef70:
    # block 0x004fef70: entry, 73 instruction(s), calls FUN_0050e97e, FUN_004ff2f0, FUN_005053a0, FUN_005051f0, ends with je to 0x004ff136 (forward)
    push ebx                                     # 004fef70
    mov ebx, dword ptr [esp + stk_8]             # 004fef71
    push ebp                                     # 004fef75
    mov ebp, dword ptr [esp + stk_10]            # 004fef76
    push esi                                     # 004fef7a
    push edi                                     # 004fef7b
    mov esi, dword ptr [ebp + field_1c]          # 004fef7c
    mov ecx, 0x1a                                # 004fef7f
    {load} xor eax, eax                          # 004fef84
    {load} mov edi, ebx                          # 004fef86
    push 0xb4                                    # 004fef88
    push 0x1                                     # 004fef8d
    rep stosd dword ptr es:[edi], eax            # 004fef8f
    call FUN_0050e97e                            # 004fef91
    {load} mov edi, eax                          # 004fef96
    mov dword ptr [ebx + field_4], ebp           # 004fef98
    mov dword ptr [ebx + field_64], edi          # 004fef9b
    mov eax, dword ptr [esi + field_8]           # 004fef9e
    push eax                                     # 004fefa1
    call FUN_004ff2f0                            # 004fefa2
    push 0x4                                     # 004fefa7
    push 0x1                                     # 004fefa9
    mov dword ptr [edi + field_2c], eax          # 004fefab
    call FUN_0050e97e                            # 004fefae
    push 0x4                                     # 004fefb3
    push 0x1                                     # 004fefb5
    mov dword ptr [edi + field_c], eax           # 004fefb7
    call FUN_0050e97e                            # 004fefba
    push 0x14                                    # 004fefbf
    push 0x1                                     # 004fefc1
    mov dword ptr [edi + field_10], eax          # 004fefc3
    call FUN_0050e97e                            # 004fefc6
    mov ecx, dword ptr [edi + field_c]           # 004fefcb
    push 0x14                                    # 004fefce
    push 0x1                                     # 004fefd0
    mov dword ptr [ecx], eax                     # 004fefd2
    call FUN_0050e97e                            # 004fefd4
    mov edx, dword ptr [edi + field_10]          # 004fefd9
    mov dword ptr [edx], eax                     # 004fefdc
    mov ecx, dword ptr [edi + field_c]           # 004fefde
    mov eax, dword ptr [esi]                     # 004fefe1
    mov edx, dword ptr [ecx]                     # 004fefe3
    push eax                                     # 004fefe5
    push edx                                     # 004fefe6
    call FUN_005053a0                            # 004fefe7
    mov ecx, dword ptr [edi + field_10]          # 004fefec
    mov eax, dword ptr [esi + field_4]           # 004fefef
    push eax                                     # 004feff2
    mov edx, dword ptr [ecx]                     # 004feff3
    push edx                                     # 004feff5
    call FUN_005053a0                            # 004feff6
    mov eax, dword ptr [esi]                     # 004feffb
    {load} xor ebp, ebp                          # 004feffd
    cdq                                          # 004fefff
    {load} sub eax, edx                          # 004ff000
    sar eax                                      # 004ff002
    push eax                                     # 004ff004
    push ebp                                     # 004ff005
    call FUN_005051f0                            # 004ff006
    mov dword ptr [edi + field_4], eax           # 004ff00b
    mov eax, dword ptr [esi + field_4]           # 004ff00e
    cdq                                          # 004ff011
    {load} sub eax, edx                          # 004ff012
    add esp, 0x44                                # 004ff014
    sar eax                                      # 004ff017
    push eax                                     # 004ff019
    push ebp                                     # 004ff01a
    call FUN_005051f0                            # 004ff01b
    mov dword ptr [edi + field_8], eax           # 004ff020
    mov eax, dword ptr [esp + stk_24]            # 004ff023
    add esp, 0x8                                 # 004ff027
    {load} cmp eax, ebp                          # 004ff02a
    je.d32 L_004ff136                            # 004ff02c
    # block 0x004ff032: entered by fall-through of je at 0x004ff02c, 14 instruction(s), calls FUN_00504fc0, ends with jne to 0x004ff0ba (forward)
    mov eax, dword ptr [esi]                     # 004ff032
    lea ecx, [edi + field_14]                    # 004ff034
    push eax                                     # 004ff037
    push ecx                                     # 004ff038
    call FUN_00504fc0                            # 004ff039
    mov edx, dword ptr [esi + field_4]           # 004ff03e
    lea eax, [edi + field_20]                    # 004ff041
    push edx                                     # 004ff044
    push eax                                     # 004ff045
    call FUN_00504fc0                            # 004ff046
    mov eax, dword ptr [esi + field_b20]         # 004ff04b
    add esp, 0x10                                # 004ff051
    {load} cmp eax, ebp                          # 004ff054
    jne.d8 L_004ff0ba                            # 004ff056
    # block 0x004ff058: entered by fall-through of jne at 0x004ff056, 10 instruction(s), calls FUN_0050e97e, ends with jle to 0x004ff0ba (forward)
    mov ecx, dword ptr [esi + field_18]          # 004ff058
    push 0x2c                                    # 004ff05b
    push ecx                                     # 004ff05d
    call FUN_0050e97e                            # 004ff05e
    mov dword ptr [esi + field_b20], eax         # 004ff063
    mov eax, dword ptr [esi + field_18]          # 004ff069
    add esp, 0x8                                 # 004ff06c
    {load} cmp eax, ebp                          # 004ff06f
    mov dword ptr [esp + stk_14], ebp            # 004ff071
    jle.d8 L_004ff0ba                            # 004ff075
    # block 0x004ff077: entered by fall-through of jle at 0x004ff075, 2 instruction(s), falls into the block at 0x004ff081
    mov dword ptr [esp + stk_1c], ebp            # 004ff077
    lea ebp, [esi + field_720]                   # 004ff07b
L_004ff081:
    # block 0x004ff081: entered by jl at 0x004ff0b6, 18 instruction(s), calls FUN_00502970, ends with jl to 0x004ff081 (backward)
    {disp8} mov edx, dword ptr [ebp]             # 004ff081
    mov eax, dword ptr [esp + stk_1c]            # 004ff084
    push edx                                     # 004ff088
    mov edx, dword ptr [esi + field_b20]         # 004ff089
    {load} add eax, edx                          # 004ff08f
    push eax                                     # 004ff091
    call FUN_00502970                            # 004ff092
    mov eax, dword ptr [esp + stk_1c]            # 004ff097
    mov edx, dword ptr [esp + stk_24]            # 004ff09b
    mov ecx, dword ptr [esi + field_18]          # 004ff09f
    add esp, 0x8                                 # 004ff0a2
    inc eax                                      # 004ff0a5
    add ebp, 0x4                                 # 004ff0a6
    add edx, 0x2c                                # 004ff0a9
    {load} cmp eax, ecx                          # 004ff0ac
    mov dword ptr [esp + stk_14], eax            # 004ff0ae
    mov dword ptr [esp + stk_1c], edx            # 004ff0b2
    jl.d8 L_004ff081                             # 004ff0b6
    # block 0x004ff0b8: entered by fall-through of jl at 0x004ff0b6, 1 instruction(s), falls into the block at 0x004ff0ba
    {load} xor ebp, ebp                          # 004ff0b8
L_004ff0ba:
    # block 0x004ff0ba: entered by jne at 0x004ff056; jle at 0x004ff075, 10 instruction(s), calls FUN_0050e97e, ends with jle to 0x004ff12e (forward)
    mov ecx, dword ptr [esi + field_1c]          # 004ff0ba
    push 0x30                                    # 004ff0bd
    push ecx                                     # 004ff0bf
    call FUN_0050e97e                            # 004ff0c0
    mov dword ptr [edi + field_38], eax          # 004ff0c5
    mov eax, dword ptr [esi + field_1c]          # 004ff0c8
    add esp, 0x8                                 # 004ff0cb
    {load} cmp eax, ebp                          # 004ff0ce
    mov dword ptr [esp + stk_14], ebp            # 004ff0d0
    jle.d8 L_004ff12e                            # 004ff0d4
    # block 0x004ff0d6: entered by fall-through of jle at 0x004ff0d4, 2 instruction(s), falls into the block at 0x004ff0e0
    mov dword ptr [esp + stk_1c], ebp            # 004ff0d6
    lea ebp, [esi + field_b24]                   # 004ff0da
L_004ff0e0:
    # block 0x004ff0e0: entered by jl at 0x004ff12c, 29 instruction(s), calls FUN_004ffc50, ends with jl to 0x004ff0e0 (backward)
    mov edx, dword ptr [esp + stk_18]            # 004ff0e0
    {disp8} mov ecx, dword ptr [ebp]             # 004ff0e4
    mov eax, dword ptr [edx + field_8]           # 004ff0e7
    mov edx, dword ptr [ecx]                     # 004ff0ea
    push eax                                     # 004ff0ec
    mov eax, dword ptr [esi + 4*edx]             # 004ff0ed
    cdq                                          # 004ff0f0
    {load} sub eax, edx                          # 004ff0f1
    mov edx, dword ptr [edi + field_38]          # 004ff0f3
    sar eax                                      # 004ff0f6
    push eax                                     # 004ff0f8
    lea eax, [esi + field_b34]                   # 004ff0f9
    push eax                                     # 004ff0ff
    mov eax, dword ptr [esp + stk_28]            # 004ff100
    {load} add eax, edx                          # 004ff104
    push ecx                                     # 004ff106
    push eax                                     # 004ff107
    call FUN_004ffc50                            # 004ff108
    mov eax, dword ptr [esp + stk_28]            # 004ff10d
    mov edx, dword ptr [esp + stk_30]            # 004ff111
    mov ecx, dword ptr [esi + field_1c]          # 004ff115
    add esp, 0x14                                # 004ff118
    inc eax                                      # 004ff11b
    add ebp, 0x4                                 # 004ff11c
    add edx, 0x30                                # 004ff11f
    {load} cmp eax, ecx                          # 004ff122
    mov dword ptr [esp + stk_14], eax            # 004ff124
    mov dword ptr [esp + stk_1c], edx            # 004ff128
    jl.d8 L_004ff0e0                             # 004ff12c
L_004ff12e:
    # block 0x004ff12e: entered by jle at 0x004ff0d4; fall-through of jl at 0x004ff12c, 2 instruction(s), ends with forward jump to 0x004ff1ae
    mov dword ptr [ebx], 0x1                     # 004ff12e
    jmp.d8 L_004ff1ae                            # 004ff134
L_004ff136:
    # block 0x004ff136: entered by je at 0x004ff02c, 2 instruction(s), ends with jne to 0x004ff1ae (forward)
    cmp dword ptr [esi + field_b20], ebp         # 004ff136
    jne.d8 L_004ff1ae                            # 004ff13c
    # block 0x004ff13e: entered by fall-through of jne at 0x004ff13c, 10 instruction(s), calls FUN_0050e97e, ends with jle to 0x004ff1ae (forward)
    mov ecx, dword ptr [esi + field_18]          # 004ff13e
    push 0x2c                                    # 004ff141
    push ecx                                     # 004ff143
    call FUN_0050e97e                            # 004ff144
    mov dword ptr [esi + field_b20], eax         # 004ff149
    mov eax, dword ptr [esi + field_18]          # 004ff14f
    add esp, 0x8                                 # 004ff152
    {load} cmp eax, ebp                          # 004ff155
    mov dword ptr [esp + stk_14], ebp            # 004ff157
    jle.d8 L_004ff1ae                            # 004ff15b
    # block 0x004ff15d: entered by fall-through of jle at 0x004ff15b, 2 instruction(s), falls into the block at 0x004ff167
    mov dword ptr [esp + stk_1c], ebp            # 004ff15d
    lea ebp, [esi + field_720]                   # 004ff161
L_004ff167:
    # block 0x004ff167: entered by jl at 0x004ff1ac, 22 instruction(s), calls FUN_005029d0, FUN_005028f0, ends with jl to 0x004ff167 (backward)
    {disp8} mov edx, dword ptr [ebp]             # 004ff167
    mov eax, dword ptr [esp + stk_1c]            # 004ff16a
    push edx                                     # 004ff16e
    mov edx, dword ptr [esi + field_b20]         # 004ff16f
    {load} add eax, edx                          # 004ff175
    push eax                                     # 004ff177
    call FUN_005029d0                            # 004ff178
    {disp8} mov ecx, dword ptr [ebp]             # 004ff17d
    push ecx                                     # 004ff180
    call FUN_005028f0                            # 004ff181
    mov eax, dword ptr [esp + stk_20]            # 004ff186
    mov edx, dword ptr [esp + stk_28]            # 004ff18a
    add esp, 0xc                                 # 004ff18e
    {disp8} mov dword ptr [ebp], 0x0             # 004ff191
    mov ecx, dword ptr [esi + field_18]          # 004ff198
    inc eax                                      # 004ff19b
    add ebp, 0x4                                 # 004ff19c
    add edx, 0x2c                                # 004ff19f
    {load} cmp eax, ecx                          # 004ff1a2
    mov dword ptr [esp + stk_14], eax            # 004ff1a4
    mov dword ptr [esp + stk_1c], edx            # 004ff1a8
    jl.d8 L_004ff167                             # 004ff1ac
L_004ff1ae:
    # block 0x004ff1ae: entered by jmp at 0x004ff134; jne at 0x004ff13c; jle at 0x004ff15b; fall-through of jl at 0x004ff1ac, 19 instruction(s), calls FUN_0050ea90, ends with jle to 0x004ff206 (forward)
    mov edx, dword ptr [esi + field_4]           # 004ff1ae
    mov ebp, dword ptr [esp + stk_18]            # 004ff1b1
    mov dword ptr [ebx + field_10], edx          # 004ff1b5
    mov eax, dword ptr [ebp + field_4]           # 004ff1b8
    shl eax, 0x2                                 # 004ff1bb
    push eax                                     # 004ff1be
    call FUN_0050ea90                            # 004ff1bf
    mov dword ptr [ebx + field_8], eax           # 004ff1c4
    mov ecx, dword ptr [ebp + field_4]           # 004ff1c7
    shl ecx, 0x2                                 # 004ff1ca
    push ecx                                     # 004ff1cd
    call FUN_0050ea90                            # 004ff1ce
    mov edx, dword ptr [esp + stk_20]            # 004ff1d3
    mov dword ptr [ebx + field_c], eax           # 004ff1d7
    add esp, 0x8                                 # 004ff1da
    {load} xor ebp, ebp                          # 004ff1dd
    mov eax, dword ptr [edx + field_4]           # 004ff1df
    test eax, eax                                # 004ff1e2
    jle.d8 L_004ff206                            # 004ff1e4
L_004ff1e6:
    # block 0x004ff1e6: entered by jl at 0x004ff204; fall-through of jle at 0x004ff1e4, 12 instruction(s), calls FUN_0050e97e, ends with jl to 0x004ff1e6 (backward)
    mov eax, dword ptr [ebx + field_10]          # 004ff1e6
    push 0x4                                     # 004ff1e9
    push eax                                     # 004ff1eb
    call FUN_0050e97e                            # 004ff1ec
    mov ecx, dword ptr [ebx + field_8]           # 004ff1f1
    mov edx, dword ptr [esp + stk_20]            # 004ff1f4
    add esp, 0x8                                 # 004ff1f8
    mov dword ptr [ecx + 4*ebp], eax             # 004ff1fb
    mov eax, dword ptr [edx + field_4]           # 004ff1fe
    inc ebp                                      # 004ff201
    {load} cmp ebp, eax                          # 004ff202
    jl.d8 L_004ff1e6                             # 004ff204
L_004ff206:
    # block 0x004ff206: entered by jle at 0x004ff1e4; fall-through of jl at 0x004ff204, 24 instruction(s), calls FUN_0050e97e, ends with jle to 0x004ff292 (forward)
    {load} xor eax, eax                          # 004ff206
    push 0x4                                     # 004ff208
    mov dword ptr [ebx + field_24], eax          # 004ff20a
    mov dword ptr [ebx + field_28], eax          # 004ff20d
    mov eax, dword ptr [esi + field_4]           # 004ff210
    cdq                                          # 004ff213
    {load} sub eax, edx                          # 004ff214
    sar eax                                      # 004ff216
    mov dword ptr [ebx + field_30], eax          # 004ff218
    mov dword ptr [ebx + field_14], eax          # 004ff21b
    mov eax, dword ptr [esi + field_10]          # 004ff21e
    push eax                                     # 004ff221
    call FUN_0050e97e                            # 004ff222
    mov dword ptr [edi + field_30], eax          # 004ff227
    mov ecx, dword ptr [esi + field_14]          # 004ff22a
    push 0x4                                     # 004ff22d
    push ecx                                     # 004ff22f
    call FUN_0050e97e                            # 004ff230
    mov dword ptr [edi + field_34], eax          # 004ff235
    mov eax, dword ptr [esi + field_10]          # 004ff238
    add esp, 0x10                                # 004ff23b
    mov dword ptr [esp + stk_14], 0x0            # 004ff23e
    test eax, eax                                # 004ff246
    jle.d8 L_004ff292                            # 004ff248
    # block 0x004ff24a: entered by fall-through of jle at 0x004ff248, 4 instruction(s), falls into the block at 0x004ff25b
    mov eax, 0xfffffbe0                          # 004ff24a
    lea ebp, [esi + field_420]                   # 004ff24f
    {load} sub eax, esi                          # 004ff255
    mov dword ptr [esp + stk_18], eax            # 004ff257
L_004ff25b:
    # block 0x004ff25b: entered by jl at 0x004ff290, 18 instruction(s), calls indirect dword ptr [eax + 0x8], ends with jl to 0x004ff25b (backward)
    mov edx, dword ptr [ebp - field_minus_100]   # 004ff25b
    {disp8} mov ecx, dword ptr [ebp]             # 004ff261
    push ecx                                     # 004ff264
    push ebx                                     # 004ff265
    mov eax, dword ptr [4*edx + 0x5669e0]        # 004ff266
    call dword ptr [eax + field_8]               # 004ff26d
    mov edx, dword ptr [esp + stk_20]            # 004ff270
    mov ecx, dword ptr [edi + field_30]          # 004ff274
    {load} add edx, ebp                          # 004ff277
    add esp, 0x8                                 # 004ff279
    add ebp, 0x4                                 # 004ff27c
    mov dword ptr [edx + ecx], eax               # 004ff27f
    mov eax, dword ptr [esp + stk_14]            # 004ff282
    mov ecx, dword ptr [esi + field_10]          # 004ff286
    inc eax                                      # 004ff289
    {load} cmp eax, ecx                          # 004ff28a
    mov dword ptr [esp + stk_14], eax            # 004ff28c
    jl.d8 L_004ff25b                             # 004ff290
L_004ff292:
    # block 0x004ff292: entered by jle at 0x004ff248; fall-through of jl at 0x004ff290, 4 instruction(s), ends with jle to 0x004ff2e9 (forward)
    mov eax, dword ptr [esi + field_14]          # 004ff292
    mov dword ptr [esp + stk_14], 0x0            # 004ff295
    test eax, eax                                # 004ff29d
    jle.d8 L_004ff2e9                            # 004ff29f
    # block 0x004ff2a1: entered by fall-through of jle at 0x004ff29f, 4 instruction(s), falls into the block at 0x004ff2b2
    mov eax, 0xfffff9e0                          # 004ff2a1
    lea ebp, [esi + field_620]                   # 004ff2a6
    {load} sub eax, esi                          # 004ff2ac
    mov dword ptr [esp + stk_18], eax            # 004ff2ae
L_004ff2b2:
    # block 0x004ff2b2: entered by jl at 0x004ff2e7, 18 instruction(s), calls indirect dword ptr [eax + 0x8], ends with jl to 0x004ff2b2 (backward)
    mov edx, dword ptr [ebp - field_minus_100]   # 004ff2b2
    {disp8} mov ecx, dword ptr [ebp]             # 004ff2b8
    push ecx                                     # 004ff2bb
    push ebx                                     # 004ff2bc
    mov eax, dword ptr [4*edx + 0x5669e8]        # 004ff2bd
    call dword ptr [eax + field_8]               # 004ff2c4
    mov edx, dword ptr [esp + stk_20]            # 004ff2c7
    mov ecx, dword ptr [edi + field_34]          # 004ff2cb
    {load} add edx, ebp                          # 004ff2ce
    add esp, 0x8                                 # 004ff2d0
    add ebp, 0x4                                 # 004ff2d3
    mov dword ptr [edx + ecx], eax               # 004ff2d6
    mov eax, dword ptr [esp + stk_14]            # 004ff2d9
    mov ecx, dword ptr [esi + field_14]          # 004ff2dd
    inc eax                                      # 004ff2e0
    {load} cmp eax, ecx                          # 004ff2e1
    mov dword ptr [esp + stk_14], eax            # 004ff2e3
    jl.d8 L_004ff2b2                             # 004ff2e7
L_004ff2e9:
    # block 0x004ff2e9: entered by jle at 0x004ff29f; fall-through of jl at 0x004ff2e7, 6 instruction(s), ends with ret
    pop edi                                      # 004ff2e9
    pop esi                                      # 004ff2ea
    pop ebp                                      # 004ff2eb
    {load} xor eax, eax                          # 004ff2ec
    pop ebx                                      # 004ff2ee
    ret                                          # 004ff2ef

