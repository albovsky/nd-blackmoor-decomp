# FUN_00435015
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00435015
# extent:       0x00435015-0x00437614 (9727 code bytes)
# span:         0x00435015-0x00437614 (code 9727, tables 0, padding 0)
# sha256:       8c62ea0dc962f91945fbeaef1912cabf3d20c66f2d61ce32c08f0b74dec11b29
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00435015
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       64 ebp-relative slot(s): local_4, local_c, local_110, local_213, local_214, local_318, local_31c, local_320, local_324, local_5164, local_5170, local_6290 and 52 more
# fields:       [ecx + n] field_1, field_minus_1; [edi + n] field_4; [edx + n] field_minus_1
# callees:      calls FUN_0050c920, FUN_0050db77, FUN_0050cd43, KERNEL32.dll!GetModuleFileNameA, FUN_0050d1f0, FUN_0050cd72, FUN_0050db50, SHELL32.dll!SHGetSpecialFolderPathA, KERNEL32.dll!CreateDirectoryA, SHLWAPI.dll!PathAppendA, FUN_0050d0a9, FUN_0050cee4, KERNEL32.dll!CopyFileA, FUN_0044ad41, FUN_004348b0, FUN_00419dab and 33 more
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2089 instruction(s), 82 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_110, 0x110  # offset -0x110
.equ local_213, 0x213  # offset -0x213
.equ local_214, 0x214  # offset -0x214
.equ local_318, 0x318  # offset -0x318
.equ local_31c, 0x31c  # offset -0x31c
.equ local_320, 0x320  # offset -0x320
.equ local_324, 0x324  # offset -0x324
.equ local_5164, 0x5164  # offset -0x5164
.equ local_5170, 0x5170  # offset -0x5170
.equ local_6290, 0x6290  # offset -0x6290
.equ local_b0d0, 0xb0d0  # offset -0xb0d0
.equ local_b0dc, 0xb0dc  # offset -0xb0dc
.equ local_c1fc, 0xc1fc  # offset -0xc1fc
.equ local_c200, 0xc200  # offset -0xc200
.equ local_c204, 0xc204  # offset -0xc204
.equ local_c208, 0xc208  # offset -0xc208
.equ local_c20c, 0xc20c  # offset -0xc20c
.equ local_c210, 0xc210  # offset -0xc210
.equ local_c214, 0xc214  # offset -0xc214
.equ local_c218, 0xc218  # offset -0xc218
.equ local_c21c, 0xc21c  # offset -0xc21c
.equ local_c220, 0xc220  # offset -0xc220
.equ local_c224, 0xc224  # offset -0xc224
.equ local_c228, 0xc228  # offset -0xc228
.equ local_c22c, 0xc22c  # offset -0xc22c
.equ local_c230, 0xc230  # offset -0xc230
.equ local_c234, 0xc234  # offset -0xc234
.equ local_c238, 0xc238  # offset -0xc238
.equ local_c23c, 0xc23c  # offset -0xc23c
.equ local_c240, 0xc240  # offset -0xc240
.equ local_c244, 0xc244  # offset -0xc244
.equ local_c248, 0xc248  # offset -0xc248
.equ local_c24c, 0xc24c  # offset -0xc24c
.equ local_c250, 0xc250  # offset -0xc250
.equ local_c254, 0xc254  # offset -0xc254
.equ local_c258, 0xc258  # offset -0xc258
.equ local_c25c, 0xc25c  # offset -0xc25c
.equ local_c260, 0xc260  # offset -0xc260
.equ local_c264, 0xc264  # offset -0xc264
.equ local_c268, 0xc268  # offset -0xc268
.equ local_c26c, 0xc26c  # offset -0xc26c
.equ local_c270, 0xc270  # offset -0xc270
.equ local_c274, 0xc274  # offset -0xc274
.equ local_c278, 0xc278  # offset -0xc278
.equ local_c27c, 0xc27c  # offset -0xc27c
.equ local_c280, 0xc280  # offset -0xc280
.equ local_c284, 0xc284  # offset -0xc284
.equ local_c288, 0xc288  # offset -0xc288
.equ local_c28c, 0xc28c  # offset -0xc28c
.equ local_c290, 0xc290  # offset -0xc290
.equ local_c294, 0xc294  # offset -0xc294
.equ local_c298, 0xc298  # offset -0xc298
.equ local_c29c, 0xc29c  # offset -0xc29c
.equ local_c2a0, 0xc2a0  # offset -0xc2a0
.equ local_c2a4, 0xc2a4  # offset -0xc2a4
.equ local_c2a8, 0xc2a8  # offset -0xc2a8
.equ local_c2ac, 0xc2ac  # offset -0xc2ac
.equ local_c2b0, 0xc2b0  # offset -0xc2b0
.equ local_c2b4, 0xc2b4  # offset -0xc2b4
.equ local_c2b8, 0xc2b8  # offset -0xc2b8
.equ local_c2bc, 0xc2bc  # offset -0xc2bc
.equ local_c2c0, 0xc2c0  # offset -0xc2c0
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00419dab, .text + (0x00419dab - 0x401000)
.set FUN_0042347b, .text + (0x0042347b - 0x401000)
.set FUN_00423c2b, .text + (0x00423c2b - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_00433c60, .text + (0x00433c60 - 0x401000)
.set FUN_00433e63, .text + (0x00433e63 - 0x401000)
.set FUN_004343a2, .text + (0x004343a2 - 0x401000)
.set FUN_004348b0, .text + (0x004348b0 - 0x401000)
.set FUN_00437743, .text + (0x00437743 - 0x401000)
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_0044a0c5, .text + (0x0044a0c5 - 0x401000)
.set FUN_0044a177, .text + (0x0044a177 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044a6f2, .text + (0x0044a6f2 - 0x401000)
.set FUN_0044ad41, .text + (0x0044ad41 - 0x401000)
.set FUN_0044c44c, .text + (0x0044c44c - 0x401000)
.set FUN_00468e5a, .text + (0x00468e5a - 0x401000)
.set FUN_004b3c5a, .text + (0x004b3c5a - 0x401000)
.set FUN_004c9d91, .text + (0x004c9d91 - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_004d3b95, .text + (0x004d3b95 - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004dc13f, .text + (0x004dc13f - 0x401000)
.set FUN_004de394, .text + (0x004de394 - 0x401000)
.set FUN_004e069c, .text + (0x004e069c - 0x401000)
.set FUN_004e4337, .text + (0x004e4337 - 0x401000)
.set FUN_004e4428, .text + (0x004e4428 - 0x401000)
.set FUN_004e7843, .text + (0x004e7843 - 0x401000)
.set FUN_004e7d2e, .text + (0x004e7d2e - 0x401000)
.set FUN_004e7dad, .text + (0x004e7dad - 0x401000)
.set FUN_004ec005, .text + (0x004ec005 - 0x401000)
.set FUN_0050c920, .text + (0x0050c920 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd43, .text + (0x0050cd43 - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d1f0, .text + (0x0050d1f0 - 0x401000)
.set FUN_0050db50, .text + (0x0050db50 - 0x401000)
.set FUN_0050db77, .text + (0x0050db77 - 0x401000)
.set FUN_0051d994, .text + (0x0051d994 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x00435015 - 0x401000
.globl FUN_00435015
FUN_00435015:
    # block 0x00435015: entry, 122 instruction(s), calls FUN_0050c920, FUN_0050db77, FUN_0050cd43, KERNEL32.dll!GetModuleFileNameA, FUN_0050d1f0, FUN_0050..., ends with jne to 0x004351c9 (forward)
    push ebp                                     # 00435015
    {load} mov ebp, esp                          # 00435016
    push -0x1                                    # 00435018
    push 0x527e66                                # 0043501a
    mov eax, dword ptr fs:[0x0]                  # 0043501f
    push eax                                     # 00435025
    mov dword ptr fs:[0x0], esp                  # 00435026
    mov eax, 0xc2b4                              # 0043502d
    call FUN_0050c920                            # 00435032
    push ebx                                     # 00435037
    push esi                                     # 00435038
    push edi                                     # 00435039
    mov dword ptr [ebp - local_c200], 0x0        # 0043503a
    push 0x0                                     # 00435044
    call FUN_0050db77                            # 00435046
    add esp, 0x4                                 # 0043504b
    push eax                                     # 0043504e
    call FUN_0050cd43                            # 0043504f
    add esp, 0x4                                 # 00435054
    push 0x104                                   # 00435057
    push 0x63999b                                # 0043505c
    mov eax, dword ptr [0x5703f0]                # 00435061
    push eax                                     # 00435066
    call dword ptr [0x52a28c]                    # 00435067
    push 0x639ca2                                # 0043506d
    push 0x639ba2                                # 00435072
    push 0x639aa2                                # 00435077
    push 0x639a9f                                # 0043507c
    push 0x63999b                                # 00435081
    call FUN_0050d1f0                            # 00435086
    add esp, 0x14                                # 0043508b
    mov edi, 0x639a9f                            # 0043508e
    mov edx, 0x639dae                            # 00435093
    or ecx, -0x1                                 # 00435098
    {load} xor eax, eax                          # 0043509b
    repne scasb al, byte ptr es:[edi]            # 0043509d
    not ecx                                      # 0043509f
    {load} sub edi, ecx                          # 004350a1
    {load} mov esi, edi                          # 004350a3
    {load} mov eax, ecx                          # 004350a5
    {load} mov edi, edx                          # 004350a7
    shr ecx, 0x2                                 # 004350a9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004350ac
    {load} mov ecx, eax                          # 004350ae
    and ecx, 0x3                                 # 004350b0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004350b3
    mov edi, 0x639a9f                            # 004350b5
    mov edx, 0x639da2                            # 004350ba
    or ecx, -0x1                                 # 004350bf
    {load} xor eax, eax                          # 004350c2
    repne scasb al, byte ptr es:[edi]            # 004350c4
    not ecx                                      # 004350c6
    {load} sub edi, ecx                          # 004350c8
    {load} mov esi, edi                          # 004350ca
    {load} mov eax, ecx                          # 004350cc
    {load} mov edi, edx                          # 004350ce
    shr ecx, 0x2                                 # 004350d0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004350d3
    {load} mov ecx, eax                          # 004350d5
    and ecx, 0x3                                 # 004350d7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004350da
    mov edi, 0x639a9f                            # 004350dc
    mov edx, 0x639da5                            # 004350e1
    or ecx, -0x1                                 # 004350e6
    {load} xor eax, eax                          # 004350e9
    repne scasb al, byte ptr es:[edi]            # 004350eb
    not ecx                                      # 004350ed
    {load} sub edi, ecx                          # 004350ef
    {load} mov esi, edi                          # 004350f1
    {load} mov eax, ecx                          # 004350f3
    {load} mov edi, edx                          # 004350f5
    shr ecx, 0x2                                 # 004350f7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004350fa
    {load} mov ecx, eax                          # 004350fc
    and ecx, 0x3                                 # 004350fe
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435101
    mov edi, 0x639a9f                            # 00435103
    mov edx, 0x639da8                            # 00435108
    or ecx, -0x1                                 # 0043510d
    {load} xor eax, eax                          # 00435110
    repne scasb al, byte ptr es:[edi]            # 00435112
    not ecx                                      # 00435114
    {load} sub edi, ecx                          # 00435116
    {load} mov esi, edi                          # 00435118
    {load} mov eax, ecx                          # 0043511a
    {load} mov edi, edx                          # 0043511c
    shr ecx, 0x2                                 # 0043511e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435121
    {load} mov ecx, eax                          # 00435123
    and ecx, 0x3                                 # 00435125
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435128
    push 0x54631c                                # 0043512a
    push 0x639ba2                                # 0043512f
    push 0x639aa2                                # 00435134
    push 0x639a9f                                # 00435139
    push 0x639897                                # 0043513e
    call FUN_0050cd72                            # 00435143
    add esp, 0x14                                # 00435148
    mov edi, 0x546324                            # 0043514b
    lea edx, [ebp - local_214]                   # 00435150
    or ecx, -0x1                                 # 00435156
    {load} xor eax, eax                          # 00435159
    repne scasb al, byte ptr es:[edi]            # 0043515b
    not ecx                                      # 0043515d
    {load} sub edi, ecx                          # 0043515f
    {load} mov esi, edi                          # 00435161
    {load} mov eax, ecx                          # 00435163
    {load} mov edi, edx                          # 00435165
    shr ecx, 0x2                                 # 00435167
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043516a
    {load} mov ecx, eax                          # 0043516c
    and ecx, 0x3                                 # 0043516e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435171
    push 0x3a                                    # 00435173
    push 0x546328                                # 00435175
    call FUN_0050db50                            # 0043517a
    add esp, 0x8                                 # 0043517f
    mov dword ptr [ebp - local_320], eax         # 00435182
    mov ecx, dword ptr [ebp - local_320]         # 00435188
    movsx edx, byte ptr [ecx + field_1]          # 0043518e
    cmp edx, 0x20                                # 00435192
    jne.d8 L_004351c9                            # 00435195
    # block 0x00435197: entered by fall-through of jne at 0x00435195, 19 instruction(s), ends with forward jump to 0x004351f7
    mov eax, dword ptr [ebp - local_320]         # 00435197
    add eax, 0x2                                 # 0043519d
    {load} mov edi, eax                          # 004351a0
    lea ecx, [ebp - local_213]                   # 004351a2
    {load} mov edx, ecx                          # 004351a8
    or ecx, -0x1                                 # 004351aa
    {load} xor eax, eax                          # 004351ad
    repne scasb al, byte ptr es:[edi]            # 004351af
    not ecx                                      # 004351b1
    {load} sub edi, ecx                          # 004351b3
    {load} mov esi, edi                          # 004351b5
    {load} mov eax, ecx                          # 004351b7
    {load} mov edi, edx                          # 004351b9
    shr ecx, 0x2                                 # 004351bb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004351be
    {load} mov ecx, eax                          # 004351c0
    and ecx, 0x3                                 # 004351c2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004351c5
    jmp.d8 L_004351f7                            # 004351c7
L_004351c9:
    # block 0x004351c9: entered by jne at 0x00435195, 17 instruction(s), falls into the block at 0x004351f7
    mov ecx, dword ptr [ebp - local_320]         # 004351c9
    add ecx, 0x1                                 # 004351cf
    {load} mov edi, ecx                          # 004351d2
    lea edx, [ebp - local_213]                   # 004351d4
    or ecx, -0x1                                 # 004351da
    {load} xor eax, eax                          # 004351dd
    repne scasb al, byte ptr es:[edi]            # 004351df
    not ecx                                      # 004351e1
    {load} sub edi, ecx                          # 004351e3
    {load} mov esi, edi                          # 004351e5
    {load} mov eax, ecx                          # 004351e7
    {load} mov edi, edx                          # 004351e9
    shr ecx, 0x2                                 # 004351eb
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004351ee
    {load} mov ecx, eax                          # 004351f0
    and ecx, 0x3                                 # 004351f2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004351f5
L_004351f7:
    # block 0x004351f7: entered by jmp at 0x004351c7, 23 instruction(s), calls SHELL32.dll!SHGetSpecialFolderPathA, ends with je to 0x0043533e (forward)
    lea edi, [ebp - local_214]                   # 004351f7
    lea edx, [ebp - local_110]                   # 004351fd
    or ecx, -0x1                                 # 00435203
    {load} xor eax, eax                          # 00435206
    repne scasb al, byte ptr es:[edi]            # 00435208
    not ecx                                      # 0043520a
    {load} sub edi, ecx                          # 0043520c
    {load} mov esi, edi                          # 0043520e
    {load} mov eax, ecx                          # 00435210
    {load} mov edi, edx                          # 00435212
    shr ecx, 0x2                                 # 00435214
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435217
    {load} mov ecx, eax                          # 00435219
    and ecx, 0x3                                 # 0043521b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043521e
    push 0x0                                     # 00435220
    push 0x5                                     # 00435222
    lea ecx, [ebp - local_318]                   # 00435224
    push ecx                                     # 0043522a
    push 0x0                                     # 0043522b
    call dword ptr [0x52a2d8]                    # 0043522d
    test eax, eax                                # 00435233
    je.d32 L_0043533e                            # 00435235
    # block 0x0043523b: entered by fall-through of je at 0x00435235, 60 instruction(s), calls KERNEL32.dll!CreateDirectoryA, SHLWAPI.dll!PathAppendA, FUN_0050d0a9, ends with je to 0x00435317 (forward)
    lea edi, [ebp - local_110]                   # 0043523b
    lea edx, [ebp - local_318]                   # 00435241
    or ecx, -0x1                                 # 00435247
    {load} xor eax, eax                          # 0043524a
    repne scasb al, byte ptr es:[edi]            # 0043524c
    not ecx                                      # 0043524e
    {load} sub edi, ecx                          # 00435250
    {load} mov esi, edi                          # 00435252
    {load} mov ebx, ecx                          # 00435254
    {load} mov edi, edx                          # 00435256
    or ecx, -0x1                                 # 00435258
    {load} xor eax, eax                          # 0043525b
    repne scasb al, byte ptr es:[edi]            # 0043525d
    add edi, -0x1                                # 0043525f
    {load} mov ecx, ebx                          # 00435262
    shr ecx, 0x2                                 # 00435264
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435267
    {load} mov ecx, ebx                          # 00435269
    and ecx, 0x3                                 # 0043526b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043526e
    push 0x0                                     # 00435270
    lea eax, [ebp - local_318]                   # 00435272
    push eax                                     # 00435278
    call dword ptr [0x52a290]                    # 00435279
    lea edi, [ebp - local_318]                   # 0043527f
    mov edx, 0x63a3c9                            # 00435285
    or ecx, -0x1                                 # 0043528a
    {load} xor eax, eax                          # 0043528d
    repne scasb al, byte ptr es:[edi]            # 0043528f
    not ecx                                      # 00435291
    {load} sub edi, ecx                          # 00435293
    {load} mov esi, edi                          # 00435295
    {load} mov eax, ecx                          # 00435297
    {load} mov edi, edx                          # 00435299
    shr ecx, 0x2                                 # 0043529b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043529e
    {load} mov ecx, eax                          # 004352a0
    and ecx, 0x3                                 # 004352a2
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004352a5
    push 0x639ba2                                # 004352a7
    lea ecx, [ebp - local_318]                   # 004352ac
    push ecx                                     # 004352b2
    call dword ptr [0x52a2e0]                    # 004352b3
    lea edi, [ebp - local_318]                   # 004352b9
    or ecx, -0x1                                 # 004352bf
    {load} xor eax, eax                          # 004352c2
    repne scasb al, byte ptr es:[edi]            # 004352c4
    add edi, -0x1                                # 004352c6
    mov edx, dword ptr [0x546354]                # 004352c9
    mov dword ptr [edi], edx                     # 004352cf
    mov al, byte ptr [0x546358]                  # 004352d1
    mov byte ptr [edi + field_4], al             # 004352d6
    push 0x54635c                                # 004352d9
    lea ecx, [ebp - local_318]                   # 004352de
    push ecx                                     # 004352e4
    call FUN_0050d0a9                            # 004352e5
    add esp, 0x8                                 # 004352ea
    mov dword ptr [ebp - local_c204], eax        # 004352ed
    cmp dword ptr [ebp - local_c204], 0x0        # 004352f3
    je.d8 L_00435317                             # 004352fa
    # block 0x004352fc: entered by fall-through of je at 0x004352fa, 6 instruction(s), calls FUN_0050cee4, ends with forward jump to 0x00435339
    mov edx, dword ptr [ebp - local_c204]        # 004352fc
    push edx                                     # 00435302
    call FUN_0050cee4                            # 00435303
    add esp, 0x4                                 # 00435308
    mov dword ptr [ebp - local_c200], 0x1        # 0043530b
    jmp.d8 L_00435339                            # 00435315
L_00435317:
    # block 0x00435317: entered by je at 0x004352fa, 7 instruction(s), calls KERNEL32.dll!CopyFileA, ends with je to 0x00435339 (forward)
    push 0x0                                     # 00435317
    lea eax, [ebp - local_318]                   # 00435319
    push eax                                     # 0043531f
    push 0x639897                                # 00435320
    call dword ptr [0x52a294]                    # 00435325
    test eax, eax                                # 0043532b
    je.d8 L_00435339                             # 0043532d
    # block 0x0043532f: entered by fall-through of je at 0x0043532d, 1 instruction(s), falls into the block at 0x00435339
    mov dword ptr [ebp - local_c200], 0x1        # 0043532f
L_00435339:
    # block 0x00435339: entered by jmp at 0x00435315; je at 0x0043532d, 1 instruction(s), ends with forward jump to 0x00435457
    jmp.d32 L_00435457                           # 00435339
L_0043533e:
    # block 0x0043533e: entered by je at 0x00435235, 8 instruction(s), calls SHELL32.dll!SHGetSpecialFolderPathA, ends with je to 0x00435457 (forward)
    push 0x0                                     # 0043533e
    push 0x2e                                    # 00435340
    lea ecx, [ebp - local_318]                   # 00435342
    push ecx                                     # 00435348
    push 0x0                                     # 00435349
    call dword ptr [0x52a2d8]                    # 0043534b
    test eax, eax                                # 00435351
    je.d32 L_00435457                            # 00435353
    # block 0x00435359: entered by fall-through of je at 0x00435353, 60 instruction(s), calls KERNEL32.dll!CreateDirectoryA, SHLWAPI.dll!PathAppendA, FUN_0050d0a9, ends with je to 0x00435435 (forward)
    lea edi, [ebp - local_110]                   # 00435359
    lea edx, [ebp - local_318]                   # 0043535f
    or ecx, -0x1                                 # 00435365
    {load} xor eax, eax                          # 00435368
    repne scasb al, byte ptr es:[edi]            # 0043536a
    not ecx                                      # 0043536c
    {load} sub edi, ecx                          # 0043536e
    {load} mov esi, edi                          # 00435370
    {load} mov ebx, ecx                          # 00435372
    {load} mov edi, edx                          # 00435374
    or ecx, -0x1                                 # 00435376
    {load} xor eax, eax                          # 00435379
    repne scasb al, byte ptr es:[edi]            # 0043537b
    add edi, -0x1                                # 0043537d
    {load} mov ecx, ebx                          # 00435380
    shr ecx, 0x2                                 # 00435382
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435385
    {load} mov ecx, ebx                          # 00435387
    and ecx, 0x3                                 # 00435389
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043538c
    push 0x0                                     # 0043538e
    lea eax, [ebp - local_318]                   # 00435390
    push eax                                     # 00435396
    call dword ptr [0x52a290]                    # 00435397
    lea edi, [ebp - local_318]                   # 0043539d
    mov edx, 0x63a3c9                            # 004353a3
    or ecx, -0x1                                 # 004353a8
    {load} xor eax, eax                          # 004353ab
    repne scasb al, byte ptr es:[edi]            # 004353ad
    not ecx                                      # 004353af
    {load} sub edi, ecx                          # 004353b1
    {load} mov esi, edi                          # 004353b3
    {load} mov eax, ecx                          # 004353b5
    {load} mov edi, edx                          # 004353b7
    shr ecx, 0x2                                 # 004353b9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004353bc
    {load} mov ecx, eax                          # 004353be
    and ecx, 0x3                                 # 004353c0
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004353c3
    push 0x639ba2                                # 004353c5
    lea ecx, [ebp - local_318]                   # 004353ca
    push ecx                                     # 004353d0
    call dword ptr [0x52a2e0]                    # 004353d1
    lea edi, [ebp - local_318]                   # 004353d7
    or ecx, -0x1                                 # 004353dd
    {load} xor eax, eax                          # 004353e0
    repne scasb al, byte ptr es:[edi]            # 004353e2
    add edi, -0x1                                # 004353e4
    mov edx, dword ptr [0x546360]                # 004353e7
    mov dword ptr [edi], edx                     # 004353ed
    mov al, byte ptr [0x546364]                  # 004353ef
    mov byte ptr [edi + field_4], al             # 004353f4
    push 0x546368                                # 004353f7
    lea ecx, [ebp - local_318]                   # 004353fc
    push ecx                                     # 00435402
    call FUN_0050d0a9                            # 00435403
    add esp, 0x8                                 # 00435408
    mov dword ptr [ebp - local_c204], eax        # 0043540b
    cmp dword ptr [ebp - local_c204], 0x0        # 00435411
    je.d8 L_00435435                             # 00435418
    # block 0x0043541a: entered by fall-through of je at 0x00435418, 6 instruction(s), calls FUN_0050cee4, ends with forward jump to 0x00435457
    mov edx, dword ptr [ebp - local_c204]        # 0043541a
    push edx                                     # 00435420
    call FUN_0050cee4                            # 00435421
    add esp, 0x4                                 # 00435426
    mov dword ptr [ebp - local_c200], 0x1        # 00435429
    jmp.d8 L_00435457                            # 00435433
L_00435435:
    # block 0x00435435: entered by je at 0x00435418, 7 instruction(s), calls KERNEL32.dll!CopyFileA, ends with je to 0x00435457 (forward)
    push 0x0                                     # 00435435
    lea eax, [ebp - local_318]                   # 00435437
    push eax                                     # 0043543d
    push 0x639897                                # 0043543e
    call dword ptr [0x52a294]                    # 00435443
    test eax, eax                                # 00435449
    je.d8 L_00435457                             # 0043544b
    # block 0x0043544d: entered by fall-through of je at 0x0043544b, 1 instruction(s), falls into the block at 0x00435457
    mov dword ptr [ebp - local_c200], 0x1        # 0043544d
L_00435457:
    # block 0x00435457: entered by jmp at 0x00435339; je at 0x00435353; jmp at 0x00435433; je at 0x0043544b, 2 instruction(s), ends with je to 0x0043548a (forward)
    cmp dword ptr [ebp - local_c200], 0x0        # 00435457
    je.d8 L_0043548a                             # 0043545e
    # block 0x00435460: entered by fall-through of je at 0x0043545e, 16 instruction(s), ends with forward jump to 0x004354b1
    lea edi, [ebp - local_318]                   # 00435460
    mov edx, 0x639897                            # 00435466
    or ecx, -0x1                                 # 0043546b
    {load} xor eax, eax                          # 0043546e
    repne scasb al, byte ptr es:[edi]            # 00435470
    not ecx                                      # 00435472
    {load} sub edi, ecx                          # 00435474
    {load} mov esi, edi                          # 00435476
    {load} mov eax, ecx                          # 00435478
    {load} mov edi, edx                          # 0043547a
    shr ecx, 0x2                                 # 0043547c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043547f
    {load} mov ecx, eax                          # 00435481
    and ecx, 0x3                                 # 00435483
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435486
    jmp.d8 L_004354b1                            # 00435488
L_0043548a:
    # block 0x0043548a: entered by je at 0x0043545e, 15 instruction(s), falls into the block at 0x004354b1
    mov edi, 0x63a5a8                            # 0043548a
    mov edx, 0x63a3c9                            # 0043548f
    or ecx, -0x1                                 # 00435494
    {load} xor eax, eax                          # 00435497
    repne scasb al, byte ptr es:[edi]            # 00435499
    not ecx                                      # 0043549b
    {load} sub edi, ecx                          # 0043549d
    {load} mov esi, edi                          # 0043549f
    {load} mov eax, ecx                          # 004354a1
    {load} mov edi, edx                          # 004354a3
    shr ecx, 0x2                                 # 004354a5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004354a8
    {load} mov ecx, eax                          # 004354aa
    and ecx, 0x3                                 # 004354ac
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004354af
L_004354b1:
    # block 0x004354b1: entered by jmp at 0x00435488, 5 instruction(s), calls FUN_0044ad41, FUN_004348b0, ends with jne to 0x004354ca (forward)
    call FUN_0044ad41                            # 004354b1
    call FUN_004348b0                            # 004354b6
    movsx ecx, ax                                # 004354bb
    test ecx, ecx                                # 004354be
    jne.d8 L_004354ca                            # 004354c0
    # block 0x004354c2: entered by fall-through of jne at 0x004354c0, 2 instruction(s), ends with forward jump to 0x00437603
    {load} xor ax, ax                            # 004354c2
    jmp.d32 L_00437603                           # 004354c5
L_004354ca:
    # block 0x004354ca: entered by jne at 0x004354c0, 3 instruction(s), ends with je to 0x00435554 (forward)
    movsx edx, word ptr [0x63a4cf]               # 004354ca
    test edx, edx                                # 004354d1
    je.d8 L_00435554                             # 004354d3
    # block 0x004354d5: entered by fall-through of je at 0x004354d3, 46 instruction(s), falls into the block at 0x00435554
    mov dword ptr [0x5bb1fa], 0x1                # 004354d5
    mov edi, 0x639a9f                            # 004354df
    mov edx, 0x639da2                            # 004354e4
    or ecx, -0x1                                 # 004354e9
    {load} xor eax, eax                          # 004354ec
    repne scasb al, byte ptr es:[edi]            # 004354ee
    not ecx                                      # 004354f0
    {load} sub edi, ecx                          # 004354f2
    {load} mov esi, edi                          # 004354f4
    {load} mov eax, ecx                          # 004354f6
    {load} mov edi, edx                          # 004354f8
    shr ecx, 0x2                                 # 004354fa
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004354fd
    {load} mov ecx, eax                          # 004354ff
    and ecx, 0x3                                 # 00435501
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435504
    mov edi, 0x639a9f                            # 00435506
    mov edx, 0x639da5                            # 0043550b
    or ecx, -0x1                                 # 00435510
    {load} xor eax, eax                          # 00435513
    repne scasb al, byte ptr es:[edi]            # 00435515
    not ecx                                      # 00435517
    {load} sub edi, ecx                          # 00435519
    {load} mov esi, edi                          # 0043551b
    {load} mov eax, ecx                          # 0043551d
    {load} mov edi, edx                          # 0043551f
    shr ecx, 0x2                                 # 00435521
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435524
    {load} mov ecx, eax                          # 00435526
    and ecx, 0x3                                 # 00435528
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043552b
    mov edi, 0x639a9f                            # 0043552d
    mov edx, 0x639da8                            # 00435532
    or ecx, -0x1                                 # 00435537
    {load} xor eax, eax                          # 0043553a
    repne scasb al, byte ptr es:[edi]            # 0043553c
    not ecx                                      # 0043553e
    {load} sub edi, ecx                          # 00435540
    {load} mov esi, edi                          # 00435542
    {load} mov eax, ecx                          # 00435544
    {load} mov edi, edx                          # 00435546
    shr ecx, 0x2                                 # 00435548
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043554b
    {load} mov ecx, eax                          # 0043554d
    and ecx, 0x3                                 # 0043554f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435552
L_00435554:
    # block 0x00435554: entered by je at 0x004354d3, 12 instruction(s), ends with je to 0x004355c1 (forward)
    mov dword ptr [0x57044c], 0x0                # 00435554
    mov dword ptr [0x570448], 0x0                # 0043555e
    mov dword ptr [0x63a561], 0x0                # 00435568
    mov ecx, 0x8                                 # 00435572
    {load} xor eax, eax                          # 00435577
    mov edi, 0x63a565                            # 00435579
    rep stosd dword ptr es:[edi], eax            # 0043557e
    stosb byte ptr es:[edi], al                  # 00435580
    mov dword ptr [0x5b4e0c], 0x0                # 00435581
    mov dword ptr [0x5b5083], 0x0                # 0043558b
    cmp dword ptr [0x5bb1fa], 0x0                # 00435595
    je.d8 L_004355c1                             # 0043559c
    # block 0x0043559e: entered by fall-through of je at 0x0043559c, 8 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x004355e2
    push 0x54636c                                # 0043559e
    push 0x546374                                # 004355a3
    push 0x639db1                                # 004355a8
    push 0x639da2                                # 004355ad
    push 0x63888b                                # 004355b2
    call FUN_0050cd72                            # 004355b7
    add esp, 0x14                                # 004355bc
    jmp.d8 L_004355e2                            # 004355bf
L_004355c1:
    # block 0x004355c1: entered by je at 0x0043559c, 7 instruction(s), calls FUN_0050cd72, falls into the block at 0x004355e2
    push 0x54637c                                # 004355c1
    push 0x546384                                # 004355c6
    push 0x639db1                                # 004355cb
    push 0x639dae                                # 004355d0
    push 0x63888b                                # 004355d5
    call FUN_0050cd72                            # 004355da
    add esp, 0x14                                # 004355df
L_004355e2:
    # block 0x004355e2: entered by jmp at 0x004355bf, 5 instruction(s), calls FUN_00419dab, ends with je to 0x0043561d (forward)
    push 0x63888b                                # 004355e2
    mov ecx, 0x5d2f31                            # 004355e7
    call FUN_00419dab                            # 004355ec
    cmp dword ptr [0x5bb1fa], 0x0                # 004355f1
    je.d8 L_0043561d                             # 004355f8
    # block 0x004355fa: entered by fall-through of je at 0x004355f8, 8 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x0043563e
    push 0x54638c                                # 004355fa
    push 0x546394                                # 004355ff
    push 0x639db1                                # 00435604
    push 0x639da2                                # 00435609
    push 0x63888b                                # 0043560e
    call FUN_0050cd72                            # 00435613
    add esp, 0x14                                # 00435618
    jmp.d8 L_0043563e                            # 0043561b
L_0043561d:
    # block 0x0043561d: entered by je at 0x004355f8, 7 instruction(s), calls FUN_0050cd72, falls into the block at 0x0043563e
    push 0x5463a0                                # 0043561d
    push 0x5463a8                                # 00435622
    push 0x639db1                                # 00435627
    push 0x639dae                                # 0043562c
    push 0x63888b                                # 00435631
    call FUN_0050cd72                            # 00435636
    add esp, 0x14                                # 0043563b
L_0043563e:
    # block 0x0043563e: entered by jmp at 0x0043561b, 6 instruction(s), calls FUN_0050d0a9, ends with jne to 0x00435660 (forward)
    push 0x5463b4                                # 0043563e
    push 0x63888b                                # 00435643
    call FUN_0050d0a9                            # 00435648
    add esp, 0x8                                 # 0043564d
    test eax, eax                                # 00435650
    jne.d8 L_00435660                            # 00435652
    # block 0x00435654: entered by fall-through of jne at 0x00435652, 2 instruction(s), ends with forward jump to 0x00435679
    mov dword ptr [0x5aff99], 0x1                # 00435654
    jmp.d8 L_00435679                            # 0043565e
L_00435660:
    # block 0x00435660: entered by jne at 0x00435652, 4 instruction(s), calls FUN_00419dab, falls into the block at 0x00435679
    mov dword ptr [0x5aff99], 0x0                # 00435660
    push 0x63888b                                # 0043566a
    mov ecx, 0x5d2f31                            # 0043566f
    call FUN_00419dab                            # 00435674
L_00435679:
    # block 0x00435679: entered by jmp at 0x0043565e, 9 instruction(s), calls FUN_00433c60, FUN_004343a2, ends with jne to 0x004356df (forward)
    push 0x5463b8                                # 00435679
    lea ecx, [ebp - local_c1fc]                  # 0043567e
    call FUN_00433c60                            # 00435684
    mov dword ptr [ebp - local_4], 0x0           # 00435689
    push 0x5463c0                                # 00435690
    lea ecx, [ebp - local_c1fc]                  # 00435695
    call FUN_004343a2                            # 0043569b
    test eax, eax                                # 004356a0
    jne.d8 L_004356df                            # 004356a2
    # block 0x004356a4: entered by fall-through of jne at 0x004356a2, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5463c8                                # 004356a4
    push 0x5463d0                                # 004356a9
    mov ecx, 0x583979                            # 004356ae
    call FUN_0042639d                            # 004356b3
    mov word ptr [ebp - local_c208], 0x0         # 004356b8
    mov dword ptr [ebp - local_4], 0xffffffff    # 004356c1
    lea ecx, [ebp - local_c1fc]                  # 004356c8
    call FUN_00433e63                            # 004356ce
    mov ax, word ptr [ebp - local_c208]          # 004356d3
    jmp.d32 L_00437603                           # 004356da
L_004356df:
    # block 0x004356df: entered by jne at 0x004356a2, 12 instruction(s), ends with jle to 0x0043573f (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 004356df
    mov esi, dword ptr [ebp - local_b0dc]        # 004356e5
    mov edi, 0x5b0113                            # 004356eb
    {load} mov edx, ecx                          # 004356f0
    shr ecx, 0x2                                 # 004356f2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004356f5
    {load} mov ecx, edx                          # 004356f7
    and ecx, 0x3                                 # 004356f9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004356fc
    movsx eax, word ptr [0x5b0264]               # 004356fe
    cmp eax, 0x12                                # 00435705
    jle.d8 L_0043573f                            # 00435708
    # block 0x0043570a: entered by fall-through of jle at 0x00435708, 10 instruction(s), calls FUN_0052139c, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x0                                     # 0043570a
    push 0x0                                     # 0043570c
    push 0x5463e4                                # 0043570e
    call FUN_0052139c                            # 00435713
    mov word ptr [ebp - local_c20c], 0x0         # 00435718
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435721
    lea ecx, [ebp - local_c1fc]                  # 00435728
    call FUN_00433e63                            # 0043572e
    mov ax, word ptr [ebp - local_c20c]          # 00435733
    jmp.d32 L_00437603                           # 0043573a
L_0043573f:
    # block 0x0043573f: entered by jle at 0x00435708, 3 instruction(s), ends with je to 0x004357c0 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0043573f
    test ecx, ecx                                # 00435746
    je.d8 L_004357c0                             # 00435748
    # block 0x0043574a: entered by fall-through of je at 0x00435748, 14 instruction(s), calls FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004357c0 (forward)
    push 0x546418                                # 0043574a
    push 0x5b0272                                # 0043574f
    push 0x639aa2                                # 00435754
    push 0x639a9f                                # 00435759
    push 0x63888b                                # 0043575e
    call FUN_0050cd72                            # 00435763
    add esp, 0x14                                # 00435768
    push 0x546420                                # 0043576b
    push 0x63888b                                # 00435770
    call FUN_0050d0a9                            # 00435775
    add esp, 0x8                                 # 0043577a
    mov dword ptr [0x5a4c10], eax                # 0043577d
    cmp dword ptr [0x5a4c10], 0x0                # 00435782
    jne.d8 L_004357c0                            # 00435789
    # block 0x0043578b: entered by fall-through of jne at 0x00435789, 10 instruction(s), calls FUN_0052139c, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x0                                     # 0043578b
    push 0x0                                     # 0043578d
    push 0x546424                                # 0043578f
    call FUN_0052139c                            # 00435794
    mov word ptr [ebp - local_c210], 0x0         # 00435799
    mov dword ptr [ebp - local_4], 0xffffffff    # 004357a2
    lea ecx, [ebp - local_c1fc]                  # 004357a9
    call FUN_00433e63                            # 004357af
    mov ax, word ptr [ebp - local_c210]          # 004357b4
    jmp.d32 L_00437603                           # 004357bb
L_004357c0:
    # block 0x004357c0: entered by je at 0x00435748; jne at 0x00435789, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x0043580f (forward)
    push 0x546448                                # 004357c0
    lea ecx, [ebp - local_c1fc]                  # 004357c5
    call FUN_004343a2                            # 004357cb
    test eax, eax                                # 004357d0
    jne.d8 L_0043580f                            # 004357d2
    # block 0x004357d4: entered by fall-through of jne at 0x004357d2, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546450                                # 004357d4
    push 0x546458                                # 004357d9
    mov ecx, 0x583979                            # 004357de
    call FUN_0042639d                            # 004357e3
    mov word ptr [ebp - local_c214], 0x0         # 004357e8
    mov dword ptr [ebp - local_4], 0xffffffff    # 004357f1
    lea ecx, [ebp - local_c1fc]                  # 004357f8
    call FUN_00433e63                            # 004357fe
    mov ax, word ptr [ebp - local_c214]          # 00435803
    jmp.d32 L_00437603                           # 0043580a
L_0043580f:
    # block 0x0043580f: entered by jne at 0x004357d2, 12 instruction(s), ends with jle to 0x0043588b (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 0043580f
    mov esi, dword ptr [ebp - local_b0dc]        # 00435815
    mov edi, 0x5b02a5                            # 0043581b
    {load} mov edx, ecx                          # 00435820
    shr ecx, 0x2                                 # 00435822
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435825
    {load} mov ecx, edx                          # 00435827
    and ecx, 0x3                                 # 00435829
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043582c
    movsx eax, word ptr [0x5b02a5]               # 0043582e
    cmp eax, 0x1e                                # 00435835
    jle.d8 L_0043588b                            # 00435838
    # block 0x0043583a: entered by fall-through of jle at 0x00435838, 17 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x1e                                    # 0043583a
    movsx ecx, word ptr [0x5b02a5]               # 0043583c
    push ecx                                     # 00435843
    push 0x54646c                                # 00435844
    push 0x63888b                                # 00435849
    call FUN_0050ca3e                            # 0043584e
    add esp, 0x10                                # 00435853
    push 0x0                                     # 00435856
    push 0x0                                     # 00435858
    push 0x63888b                                # 0043585a
    call FUN_0052139c                            # 0043585f
    mov word ptr [ebp - local_c218], 0x0         # 00435864
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043586d
    lea ecx, [ebp - local_c1fc]                  # 00435874
    call FUN_00433e63                            # 0043587a
    mov ax, word ptr [ebp - local_c218]          # 0043587f
    jmp.d32 L_00437603                           # 00435886
L_0043588b:
    # block 0x0043588b: entered by jle at 0x00435838, 2 instruction(s), ends with forward jump to 0x004358a6
    mov dword ptr [ebp - local_324], 0x0         # 0043588b
    jmp.d8 L_004358a6                            # 00435895
L_00435897:
    # block 0x00435897: entered by jmp at 0x00435965, 3 instruction(s), falls into the block at 0x004358a6
    mov edx, dword ptr [ebp - local_324]         # 00435897
    add edx, 0x1                                 # 0043589d
    mov dword ptr [ebp - local_324], edx         # 004358a0
L_004358a6:
    # block 0x004358a6: entered by jmp at 0x00435895, 3 instruction(s), ends with jge to 0x0043596a (forward)
    movsx eax, word ptr [0x5b02a5]               # 004358a6
    cmp dword ptr [ebp - local_324], eax         # 004358ad
    jge.d32 L_0043596a                           # 004358b3
    # block 0x004358b9: entered by fall-through of jge at 0x004358b3, 2 instruction(s), ends with je to 0x004358f0 (forward)
    cmp dword ptr [0x5bb1fa], 0x0                # 004358b9
    je.d8 L_004358f0                             # 004358c0
    # block 0x004358c2: entered by fall-through of je at 0x004358c0, 11 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x0043591c
    push 0x5464ac                                # 004358c2
    mov ecx, dword ptr [ebp - local_324]         # 004358c7
    imul ecx, ecx, 0x21                          # 004358cd
    add ecx, 0x5b02a7                            # 004358d0
    push ecx                                     # 004358d6
    push 0x639db1                                # 004358d7
    push 0x639da2                                # 004358dc
    push 0x63888b                                # 004358e1
    call FUN_0050cd72                            # 004358e6
    add esp, 0x14                                # 004358eb
    jmp.d8 L_0043591c                            # 004358ee
L_004358f0:
    # block 0x004358f0: entered by je at 0x004358c0, 10 instruction(s), calls FUN_0050cd72, falls into the block at 0x0043591c
    push 0x5464b4                                # 004358f0
    mov edx, dword ptr [ebp - local_324]         # 004358f5
    imul edx, edx, 0x21                          # 004358fb
    add edx, 0x5b02a7                            # 004358fe
    push edx                                     # 00435904
    push 0x639db1                                # 00435905
    push 0x639dae                                # 0043590a
    push 0x63888b                                # 0043590f
    call FUN_0050cd72                            # 00435914
    add esp, 0x14                                # 00435919
L_0043591c:
    # block 0x0043591c: entered by jmp at 0x004358ee, 6 instruction(s), calls FUN_00419dab, ends with je to 0x00435965 (forward)
    push 0x63888b                                # 0043591c
    mov ecx, 0x5d2f31                            # 00435921
    call FUN_00419dab                            # 00435926
    movsx eax, word ptr [0x63a4cd]               # 0043592b
    test eax, eax                                # 00435932
    je.d8 L_00435965                             # 00435934
    # block 0x00435936: entered by fall-through of je at 0x00435934, 11 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x00435965
    mov ecx, dword ptr [ebp - local_324]         # 00435936
    imul ecx, ecx, 0x21                          # 0043593c
    add ecx, 0x5b02a7                            # 0043593f
    push ecx                                     # 00435945
    push 0x5464bc                                # 00435946
    push 0x63888b                                # 0043594b
    call FUN_0050ca3e                            # 00435950
    add esp, 0xc                                 # 00435955
    push 0x63888b                                # 00435958
    call FUN_0044a2b7                            # 0043595d
    add esp, 0x4                                 # 00435962
L_00435965:
    # block 0x00435965: entered by je at 0x00435934, 1 instruction(s), ends with backward jump to 0x00435897
    jmp.d32 L_00435897                           # 00435965
L_0043596a:
    # block 0x0043596a: entered by jge at 0x004358b3, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x004359b9 (forward)
    push 0x5464d8                                # 0043596a
    lea ecx, [ebp - local_c1fc]                  # 0043596f
    call FUN_004343a2                            # 00435975
    test eax, eax                                # 0043597a
    jne.d8 L_004359b9                            # 0043597c
    # block 0x0043597e: entered by fall-through of jne at 0x0043597c, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5464e0                                # 0043597e
    push 0x5464e8                                # 00435983
    mov ecx, 0x583979                            # 00435988
    call FUN_0042639d                            # 0043598d
    mov word ptr [ebp - local_c21c], 0x0         # 00435992
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043599b
    lea ecx, [ebp - local_c1fc]                  # 004359a2
    call FUN_00433e63                            # 004359a8
    mov ax, word ptr [ebp - local_c21c]          # 004359ad
    jmp.d32 L_00437603                           # 004359b4
L_004359b9:
    # block 0x004359b9: entered by jne at 0x0043597c, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00435a27 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 004359b9
    mov esi, dword ptr [ebp - local_b0dc]        # 004359bf
    mov edi, 0x5cf631                            # 004359c5
    {load} mov edx, ecx                          # 004359ca
    shr ecx, 0x2                                 # 004359cc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004359cf
    {load} mov ecx, edx                          # 004359d1
    and ecx, 0x3                                 # 004359d3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004359d6
    push 0x5464fc                                # 004359d8
    lea ecx, [ebp - local_c1fc]                  # 004359dd
    call FUN_004343a2                            # 004359e3
    test eax, eax                                # 004359e8
    jne.d8 L_00435a27                            # 004359ea
    # block 0x004359ec: entered by fall-through of jne at 0x004359ea, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546504                                # 004359ec
    push 0x54650c                                # 004359f1
    mov ecx, 0x583979                            # 004359f6
    call FUN_0042639d                            # 004359fb
    mov word ptr [ebp - local_c220], 0x0         # 00435a00
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435a09
    lea ecx, [ebp - local_c1fc]                  # 00435a10
    call FUN_00433e63                            # 00435a16
    mov ax, word ptr [ebp - local_c220]          # 00435a1b
    jmp.d32 L_00437603                           # 00435a22
L_00435a27:
    # block 0x00435a27: entered by jne at 0x004359ea, 11 instruction(s), ends with forward jump to 0x00435a61
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435a27
    mov esi, dword ptr [ebp - local_b0dc]        # 00435a2d
    mov edi, 0x5b6048                            # 00435a33
    {load} mov eax, ecx                          # 00435a38
    shr ecx, 0x2                                 # 00435a3a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435a3d
    {load} mov ecx, eax                          # 00435a3f
    and ecx, 0x3                                 # 00435a41
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435a44
    mov dword ptr [ebp - local_324], 0x0         # 00435a46
    jmp.d8 L_00435a61                            # 00435a50
L_00435a52:
    # block 0x00435a52: entered by jmp at 0x00435b0b, 3 instruction(s), falls into the block at 0x00435a61
    mov ecx, dword ptr [ebp - local_324]         # 00435a52
    add ecx, 0x1                                 # 00435a58
    mov dword ptr [ebp - local_324], ecx         # 00435a5b
L_00435a61:
    # block 0x00435a61: entered by jmp at 0x00435a50, 4 instruction(s), ends with jge to 0x00435b10 (forward)
    {load} xor edx, edx                          # 00435a61
    mov dl, byte ptr [0x5b0205]                  # 00435a63
    cmp dword ptr [ebp - local_324], edx         # 00435a69
    jge.d32 L_00435b10                           # 00435a6f
    # block 0x00435a75: entered by fall-through of jge at 0x00435a6f, 12 instruction(s), calls FUN_0050ca3e, FUN_004343a2, ends with jne to 0x00435ae2 (forward)
    mov eax, dword ptr [ebp - local_324]         # 00435a75
    push eax                                     # 00435a7b
    push 0x546520                                # 00435a7c
    push 0x546524                                # 00435a81
    push 0x63888b                                # 00435a86
    call FUN_0050ca3e                            # 00435a8b
    add esp, 0x10                                # 00435a90
    push 0x63888b                                # 00435a93
    lea ecx, [ebp - local_c1fc]                  # 00435a98
    call FUN_004343a2                            # 00435a9e
    test eax, eax                                # 00435aa3
    jne.d8 L_00435ae2                            # 00435aa5
    # block 0x00435aa7: entered by fall-through of jne at 0x00435aa5, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x63888b                                # 00435aa7
    push 0x54652c                                # 00435aac
    mov ecx, 0x583979                            # 00435ab1
    call FUN_0042639d                            # 00435ab6
    mov word ptr [ebp - local_c224], 0x0         # 00435abb
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435ac4
    lea ecx, [ebp - local_c1fc]                  # 00435acb
    call FUN_00433e63                            # 00435ad1
    mov ax, word ptr [ebp - local_c224]          # 00435ad6
    jmp.d32 L_00437603                           # 00435add
L_00435ae2:
    # block 0x00435ae2: entered by jne at 0x00435aa5, 12 instruction(s), ends with backward jump to 0x00435a52
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435ae2
    mov esi, dword ptr [ebp - local_b0dc]        # 00435ae8
    mov edi, dword ptr [ebp - local_324]         # 00435aee
    imul edi, edi, 0x25                          # 00435af4
    add edi, 0x5b0685                            # 00435af7
    {load} mov edx, ecx                          # 00435afd
    shr ecx, 0x2                                 # 00435aff
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435b02
    {load} mov ecx, edx                          # 00435b04
    and ecx, 0x3                                 # 00435b06
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435b09
    jmp.d32 L_00435a52                           # 00435b0b
L_00435b10:
    # block 0x00435b10: entered by jge at 0x00435a6f, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x00435b5f (forward)
    push 0x546540                                # 00435b10
    lea ecx, [ebp - local_c1fc]                  # 00435b15
    call FUN_004343a2                            # 00435b1b
    test eax, eax                                # 00435b20
    jne.d8 L_00435b5f                            # 00435b22
    # block 0x00435b24: entered by fall-through of jne at 0x00435b22, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546548                                # 00435b24
    push 0x546550                                # 00435b29
    mov ecx, 0x583979                            # 00435b2e
    call FUN_0042639d                            # 00435b33
    mov word ptr [ebp - local_c228], 0x0         # 00435b38
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435b41
    lea ecx, [ebp - local_c1fc]                  # 00435b48
    call FUN_00433e63                            # 00435b4e
    mov ax, word ptr [ebp - local_c228]          # 00435b53
    jmp.d32 L_00437603                           # 00435b5a
L_00435b5f:
    # block 0x00435b5f: entered by jne at 0x00435b22, 8 instruction(s), calls FUN_004dc13f, ends with forward jump to 0x00435b92
    mov eax, dword ptr [ebp - local_b0d0]        # 00435b5f
    push eax                                     # 00435b65
    mov ecx, dword ptr [ebp - local_b0dc]        # 00435b66
    push ecx                                     # 00435b6c
    mov ecx, 0x637e85                            # 00435b6d
    call FUN_004dc13f                            # 00435b72
    mov dword ptr [ebp - local_324], 0x0         # 00435b77
    jmp.d8 L_00435b92                            # 00435b81
L_00435b83:
    # block 0x00435b83: entered by jmp at 0x00435c3b, 3 instruction(s), falls into the block at 0x00435b92
    mov edx, dword ptr [ebp - local_324]         # 00435b83
    add edx, 0x1                                 # 00435b89
    mov dword ptr [ebp - local_324], edx         # 00435b8c
L_00435b92:
    # block 0x00435b92: entered by jmp at 0x00435b81, 4 instruction(s), ends with jge to 0x00435c40 (forward)
    {load} xor eax, eax                          # 00435b92
    mov al, byte ptr [0x5b0206]                  # 00435b94
    cmp dword ptr [ebp - local_324], eax         # 00435b99
    jge.d32 L_00435c40                           # 00435b9f
    # block 0x00435ba5: entered by fall-through of jge at 0x00435b9f, 12 instruction(s), calls FUN_0050ca3e, FUN_004343a2, ends with jne to 0x00435c12 (forward)
    mov ecx, dword ptr [ebp - local_324]         # 00435ba5
    push ecx                                     # 00435bab
    push 0x546564                                # 00435bac
    push 0x546568                                # 00435bb1
    push 0x63888b                                # 00435bb6
    call FUN_0050ca3e                            # 00435bbb
    add esp, 0x10                                # 00435bc0
    push 0x63888b                                # 00435bc3
    lea ecx, [ebp - local_c1fc]                  # 00435bc8
    call FUN_004343a2                            # 00435bce
    test eax, eax                                # 00435bd3
    jne.d8 L_00435c12                            # 00435bd5
    # block 0x00435bd7: entered by fall-through of jne at 0x00435bd5, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x63888b                                # 00435bd7
    push 0x546570                                # 00435bdc
    mov ecx, 0x583979                            # 00435be1
    call FUN_0042639d                            # 00435be6
    mov word ptr [ebp - local_c22c], 0x0         # 00435beb
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435bf4
    lea ecx, [ebp - local_c1fc]                  # 00435bfb
    call FUN_00433e63                            # 00435c01
    mov ax, word ptr [ebp - local_c22c]          # 00435c06
    jmp.d32 L_00437603                           # 00435c0d
L_00435c12:
    # block 0x00435c12: entered by jne at 0x00435bd5, 12 instruction(s), ends with backward jump to 0x00435b83
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435c12
    mov esi, dword ptr [ebp - local_b0dc]        # 00435c18
    mov edi, dword ptr [ebp - local_324]         # 00435c1e
    imul edi, edi, 0x25                          # 00435c24
    add edi, 0x5b06aa                            # 00435c27
    {load} mov edx, ecx                          # 00435c2d
    shr ecx, 0x2                                 # 00435c2f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435c32
    {load} mov ecx, edx                          # 00435c34
    and ecx, 0x3                                 # 00435c36
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435c39
    jmp.d32 L_00435b83                           # 00435c3b
L_00435c40:
    # block 0x00435c40: entered by jge at 0x00435b9f, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x00435c8f (forward)
    push 0x546584                                # 00435c40
    lea ecx, [ebp - local_c1fc]                  # 00435c45
    call FUN_004343a2                            # 00435c4b
    test eax, eax                                # 00435c50
    jne.d8 L_00435c8f                            # 00435c52
    # block 0x00435c54: entered by fall-through of jne at 0x00435c52, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x54658c                                # 00435c54
    push 0x546594                                # 00435c59
    mov ecx, 0x583979                            # 00435c5e
    call FUN_0042639d                            # 00435c63
    mov word ptr [ebp - local_c230], 0x0         # 00435c68
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435c71
    lea ecx, [ebp - local_c1fc]                  # 00435c78
    call FUN_00433e63                            # 00435c7e
    mov ax, word ptr [ebp - local_c230]          # 00435c83
    jmp.d32 L_00437603                           # 00435c8a
L_00435c8f:
    # block 0x00435c8f: entered by jne at 0x00435c52, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00435cfd (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435c8f
    mov esi, dword ptr [ebp - local_b0dc]        # 00435c95
    mov edi, 0x5afcce                            # 00435c9b
    {load} mov eax, ecx                          # 00435ca0
    shr ecx, 0x2                                 # 00435ca2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435ca5
    {load} mov ecx, eax                          # 00435ca7
    and ecx, 0x3                                 # 00435ca9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435cac
    push 0x5465a8                                # 00435cae
    lea ecx, [ebp - local_c1fc]                  # 00435cb3
    call FUN_004343a2                            # 00435cb9
    test eax, eax                                # 00435cbe
    jne.d8 L_00435cfd                            # 00435cc0
    # block 0x00435cc2: entered by fall-through of jne at 0x00435cc0, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5465b0                                # 00435cc2
    push 0x5465b8                                # 00435cc7
    mov ecx, 0x583979                            # 00435ccc
    call FUN_0042639d                            # 00435cd1
    mov word ptr [ebp - local_c234], 0x0         # 00435cd6
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435cdf
    lea ecx, [ebp - local_c1fc]                  # 00435ce6
    call FUN_00433e63                            # 00435cec
    mov ax, word ptr [ebp - local_c234]          # 00435cf1
    jmp.d32 L_00437603                           # 00435cf8
L_00435cfd:
    # block 0x00435cfd: entered by jne at 0x00435cc0, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00435d6b (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435cfd
    mov esi, dword ptr [ebp - local_b0dc]        # 00435d03
    mov edi, 0x5afc7e                            # 00435d09
    {load} mov edx, ecx                          # 00435d0e
    shr ecx, 0x2                                 # 00435d10
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435d13
    {load} mov ecx, edx                          # 00435d15
    and ecx, 0x3                                 # 00435d17
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435d1a
    push 0x5465cc                                # 00435d1c
    lea ecx, [ebp - local_c1fc]                  # 00435d21
    call FUN_004343a2                            # 00435d27
    test eax, eax                                # 00435d2c
    jne.d8 L_00435d6b                            # 00435d2e
    # block 0x00435d30: entered by fall-through of jne at 0x00435d2e, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5465d4                                # 00435d30
    push 0x5465dc                                # 00435d35
    mov ecx, 0x583979                            # 00435d3a
    call FUN_0042639d                            # 00435d3f
    mov word ptr [ebp - local_c238], 0x0         # 00435d44
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435d4d
    lea ecx, [ebp - local_c1fc]                  # 00435d54
    call FUN_00433e63                            # 00435d5a
    mov ax, word ptr [ebp - local_c238]          # 00435d5f
    jmp.d32 L_00437603                           # 00435d66
L_00435d6b:
    # block 0x00435d6b: entered by jne at 0x00435d2e, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00435dd9 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435d6b
    mov esi, dword ptr [ebp - local_b0dc]        # 00435d71
    mov edi, 0x5aff9d                            # 00435d77
    {load} mov eax, ecx                          # 00435d7c
    shr ecx, 0x2                                 # 00435d7e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435d81
    {load} mov ecx, eax                          # 00435d83
    and ecx, 0x3                                 # 00435d85
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435d88
    push 0x5465f0                                # 00435d8a
    lea ecx, [ebp - local_c1fc]                  # 00435d8f
    call FUN_004343a2                            # 00435d95
    test eax, eax                                # 00435d9a
    jne.d8 L_00435dd9                            # 00435d9c
    # block 0x00435d9e: entered by fall-through of jne at 0x00435d9c, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5465f8                                # 00435d9e
    push 0x546600                                # 00435da3
    mov ecx, 0x583979                            # 00435da8
    call FUN_0042639d                            # 00435dad
    mov word ptr [ebp - local_c23c], 0x0         # 00435db2
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435dbb
    lea ecx, [ebp - local_c1fc]                  # 00435dc2
    call FUN_00433e63                            # 00435dc8
    mov ax, word ptr [ebp - local_c23c]          # 00435dcd
    jmp.d32 L_00437603                           # 00435dd4
L_00435dd9:
    # block 0x00435dd9: entered by jne at 0x00435d9c, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00435e47 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435dd9
    mov esi, dword ptr [ebp - local_b0dc]        # 00435ddf
    mov edi, 0x5b0032                            # 00435de5
    {load} mov edx, ecx                          # 00435dea
    shr ecx, 0x2                                 # 00435dec
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435def
    {load} mov ecx, edx                          # 00435df1
    and ecx, 0x3                                 # 00435df3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435df6
    push 0x546614                                # 00435df8
    lea ecx, [ebp - local_c1fc]                  # 00435dfd
    call FUN_004343a2                            # 00435e03
    test eax, eax                                # 00435e08
    jne.d8 L_00435e47                            # 00435e0a
    # block 0x00435e0c: entered by fall-through of jne at 0x00435e0a, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x54661c                                # 00435e0c
    push 0x546624                                # 00435e11
    mov ecx, 0x583979                            # 00435e16
    call FUN_0042639d                            # 00435e1b
    mov word ptr [ebp - local_c240], 0x0         # 00435e20
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435e29
    lea ecx, [ebp - local_c1fc]                  # 00435e30
    call FUN_00433e63                            # 00435e36
    mov ax, word ptr [ebp - local_c240]          # 00435e3b
    jmp.d32 L_00437603                           # 00435e42
L_00435e47:
    # block 0x00435e47: entered by jne at 0x00435e0a, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00435eb5 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435e47
    mov esi, dword ptr [ebp - local_b0dc]        # 00435e4d
    mov edi, 0x5e2e78                            # 00435e53
    {load} mov eax, ecx                          # 00435e58
    shr ecx, 0x2                                 # 00435e5a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435e5d
    {load} mov ecx, eax                          # 00435e5f
    and ecx, 0x3                                 # 00435e61
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435e64
    push 0x546638                                # 00435e66
    lea ecx, [ebp - local_c1fc]                  # 00435e6b
    call FUN_004343a2                            # 00435e71
    test eax, eax                                # 00435e76
    jne.d8 L_00435eb5                            # 00435e78
    # block 0x00435e7a: entered by fall-through of jne at 0x00435e78, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546640                                # 00435e7a
    push 0x546648                                # 00435e7f
    mov ecx, 0x583979                            # 00435e84
    call FUN_0042639d                            # 00435e89
    mov word ptr [ebp - local_c244], 0x0         # 00435e8e
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435e97
    lea ecx, [ebp - local_c1fc]                  # 00435e9e
    call FUN_00433e63                            # 00435ea4
    mov ax, word ptr [ebp - local_c244]          # 00435ea9
    jmp.d32 L_00437603                           # 00435eb0
L_00435eb5:
    # block 0x00435eb5: entered by jne at 0x00435e78, 22 instruction(s), calls FUN_004343a2, ends with jne to 0x00435f49 (forward)
    mov ecx, 0x43                                # 00435eb5
    mov esi, dword ptr [ebp - local_b0dc]        # 00435eba
    mov edi, 0x616787                            # 00435ec0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435ec5
    movsb byte ptr es:[edi], byte ptr [esi]      # 00435ec7
    mov esi, dword ptr [ebp - local_b0dc]        # 00435ec8
    add esi, 0xd1                                # 00435ece
    mov ecx, 0x43                                # 00435ed4
    mov edi, 0x616894                            # 00435ed9
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435ede
    movsb byte ptr es:[edi], byte ptr [esi]      # 00435ee0
    mov esi, dword ptr [ebp - local_b0dc]        # 00435ee1
    add esi, 0x1a2                               # 00435ee7
    mov ecx, 0x43                                # 00435eed
    mov edi, 0x6169a1                            # 00435ef2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435ef7
    movsb byte ptr es:[edi], byte ptr [esi]      # 00435ef9
    push 0x54665c                                # 00435efa
    lea ecx, [ebp - local_c1fc]                  # 00435eff
    call FUN_004343a2                            # 00435f05
    test eax, eax                                # 00435f0a
    jne.d8 L_00435f49                            # 00435f0c
    # block 0x00435f0e: entered by fall-through of jne at 0x00435f0c, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546660                                # 00435f0e
    push 0x546664                                # 00435f13
    mov ecx, 0x583979                            # 00435f18
    call FUN_0042639d                            # 00435f1d
    mov word ptr [ebp - local_c248], 0x0         # 00435f22
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435f2b
    lea ecx, [ebp - local_c1fc]                  # 00435f32
    call FUN_00433e63                            # 00435f38
    mov ax, word ptr [ebp - local_c248]          # 00435f3d
    jmp.d32 L_00437603                           # 00435f44
L_00435f49:
    # block 0x00435f49: entered by jne at 0x00435f0c, 16 instruction(s), calls FUN_004343a2, ends with jne to 0x00435fc3 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435f49
    mov esi, dword ptr [ebp - local_b0dc]        # 00435f4f
    mov edi, 0x5b06cf                            # 00435f55
    {load} mov edx, ecx                          # 00435f5a
    shr ecx, 0x2                                 # 00435f5c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435f5f
    {load} mov ecx, edx                          # 00435f61
    and ecx, 0x3                                 # 00435f63
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435f66
    mov ax, word ptr [0x5b06f0]                  # 00435f68
    mov word ptr [0x5b0a0a], ax                  # 00435f6e
    push 0x546678                                # 00435f74
    lea ecx, [ebp - local_c1fc]                  # 00435f79
    call FUN_004343a2                            # 00435f7f
    test eax, eax                                # 00435f84
    jne.d8 L_00435fc3                            # 00435f86
    # block 0x00435f88: entered by fall-through of jne at 0x00435f86, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546680                                # 00435f88
    push 0x546688                                # 00435f8d
    mov ecx, 0x583979                            # 00435f92
    call FUN_0042639d                            # 00435f97
    mov word ptr [ebp - local_c24c], 0x0         # 00435f9c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00435fa5
    lea ecx, [ebp - local_c1fc]                  # 00435fac
    call FUN_00433e63                            # 00435fb2
    mov ax, word ptr [ebp - local_c24c]          # 00435fb7
    jmp.d32 L_00437603                           # 00435fbe
L_00435fc3:
    # block 0x00435fc3: entered by jne at 0x00435f86, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00436031 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00435fc3
    mov esi, dword ptr [ebp - local_b0dc]        # 00435fc9
    mov edi, 0x61c3a7                            # 00435fcf
    {load} mov edx, ecx                          # 00435fd4
    shr ecx, 0x2                                 # 00435fd6
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00435fd9
    {load} mov ecx, edx                          # 00435fdb
    and ecx, 0x3                                 # 00435fdd
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00435fe0
    push 0x54669c                                # 00435fe2
    lea ecx, [ebp - local_c1fc]                  # 00435fe7
    call FUN_004343a2                            # 00435fed
    test eax, eax                                # 00435ff2
    jne.d8 L_00436031                            # 00435ff4
    # block 0x00435ff6: entered by fall-through of jne at 0x00435ff4, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5466a4                                # 00435ff6
    push 0x5466ac                                # 00435ffb
    mov ecx, 0x583979                            # 00436000
    call FUN_0042639d                            # 00436005
    mov word ptr [ebp - local_c250], 0x0         # 0043600a
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436013
    lea ecx, [ebp - local_c1fc]                  # 0043601a
    call FUN_00433e63                            # 00436020
    mov ax, word ptr [ebp - local_c250]          # 00436025
    jmp.d32 L_00437603                           # 0043602c
L_00436031:
    # block 0x00436031: entered by jne at 0x00435ff4, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x0043609f (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436031
    mov esi, dword ptr [ebp - local_b0dc]        # 00436037
    mov edi, 0x5b0a12                            # 0043603d
    {load} mov eax, ecx                          # 00436042
    shr ecx, 0x2                                 # 00436044
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00436047
    {load} mov ecx, eax                          # 00436049
    and ecx, 0x3                                 # 0043604b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043604e
    push 0x5466c0                                # 00436050
    lea ecx, [ebp - local_c1fc]                  # 00436055
    call FUN_004343a2                            # 0043605b
    test eax, eax                                # 00436060
    jne.d8 L_0043609f                            # 00436062
    # block 0x00436064: entered by fall-through of jne at 0x00436062, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5466c8                                # 00436064
    push 0x5466d0                                # 00436069
    mov ecx, 0x583979                            # 0043606e
    call FUN_0042639d                            # 00436073
    mov word ptr [ebp - local_c254], 0x0         # 00436078
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436081
    lea ecx, [ebp - local_c1fc]                  # 00436088
    call FUN_00433e63                            # 0043608e
    mov ax, word ptr [ebp - local_c254]          # 00436093
    jmp.d32 L_00437603                           # 0043609a
L_0043609f:
    # block 0x0043609f: entered by jne at 0x00436062, 11 instruction(s), ends with forward jump to 0x004360d9
    mov ecx, dword ptr [ebp - local_b0d0]        # 0043609f
    mov esi, dword ptr [ebp - local_b0dc]        # 004360a5
    mov edi, 0x5b160c                            # 004360ab
    {load} mov edx, ecx                          # 004360b0
    shr ecx, 0x2                                 # 004360b2
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004360b5
    {load} mov ecx, edx                          # 004360b7
    and ecx, 0x3                                 # 004360b9
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004360bc
    mov dword ptr [ebp - local_324], 0x0         # 004360be
    jmp.d8 L_004360d9                            # 004360c8
L_004360ca:
    # block 0x004360ca: entered by jmp at 0x004362d3, 3 instruction(s), falls into the block at 0x004360d9
    mov eax, dword ptr [ebp - local_324]         # 004360ca
    add eax, 0x1                                 # 004360d0
    mov dword ptr [ebp - local_324], eax         # 004360d3
L_004360d9:
    # block 0x004360d9: entered by jmp at 0x004360c8, 2 instruction(s), ends with jge to 0x004362d8 (forward)
    cmp dword ptr [ebp - local_324], 0x6b        # 004360d9
    jge.d32 L_004362d8                           # 004360e0
    # block 0x004360e6: entered by fall-through of jge at 0x004360e0, 2 instruction(s), ends with forward jump to 0x00436101
    mov dword ptr [ebp - local_31c], 0x0         # 004360e6
    jmp.d8 L_00436101                            # 004360f0
L_004360f2:
    # block 0x004360f2: entered by jmp at 0x004362ce, 3 instruction(s), falls into the block at 0x00436101
    mov ecx, dword ptr [ebp - local_31c]         # 004360f2
    add ecx, 0x1                                 # 004360f8
    mov dword ptr [ebp - local_31c], ecx         # 004360fb
L_00436101:
    # block 0x00436101: entered by jmp at 0x004360f0, 2 instruction(s), ends with jge to 0x004362d3 (forward)
    cmp dword ptr [ebp - local_31c], 0x2         # 00436101
    jge.d32 L_004362d3                           # 00436108
    # block 0x0043610e: entered by fall-through of jge at 0x00436108, 89 instruction(s), ends with backward jump to 0x004360f2
    mov edx, dword ptr [ebp - local_324]         # 0043610e
    shl edx, 0x5                                 # 00436114
    mov eax, dword ptr [ebp - local_31c]         # 00436117
    shl eax, 0x4                                 # 0043611d
    mov ecx, dword ptr [ebp - local_324]         # 00436120
    shl ecx, 0x5                                 # 00436126
    mov esi, dword ptr [ebp - local_31c]         # 00436129
    shl esi, 0x4                                 # 0043612f
    mov edx, dword ptr [edx + eax + 0x5b1614]    # 00436132
    sub edx, dword ptr [ecx + esi + 0x5b160c]    # 00436139
    add edx, 0x1                                 # 00436140
    mov eax, dword ptr [ebp - local_31c]         # 00436143
    shl eax, 0x2                                 # 00436149
    mov ecx, dword ptr [ebp - local_324]         # 0043614c
    mov word ptr [eax + 8*ecx + 0x5b3790], dx    # 00436152
    mov edx, dword ptr [ebp - local_324]         # 0043615a
    shl edx, 0x5                                 # 00436160
    mov eax, dword ptr [ebp - local_31c]         # 00436163
    shl eax, 0x4                                 # 00436169
    mov ecx, dword ptr [ebp - local_324]         # 0043616c
    shl ecx, 0x5                                 # 00436172
    mov esi, dword ptr [ebp - local_31c]         # 00436175
    shl esi, 0x4                                 # 0043617b
    mov edx, dword ptr [edx + eax + 0x5b1618]    # 0043617e
    sub edx, dword ptr [ecx + esi + 0x5b1610]    # 00436185
    add edx, 0x1                                 # 0043618c
    mov eax, dword ptr [ebp - local_31c]         # 0043618f
    shl eax, 0x2                                 # 00436195
    mov ecx, dword ptr [ebp - local_324]         # 00436198
    mov word ptr [eax + 8*ecx + 0x5b3792], dx    # 0043619e
    mov edx, dword ptr [ebp - local_324]         # 004361a6
    shl edx, 0x5                                 # 004361ac
    mov eax, dword ptr [ebp - local_31c]         # 004361af
    shl eax, 0x4                                 # 004361b5
    mov ecx, dword ptr [ebp - local_324]         # 004361b8
    shl ecx, 0x5                                 # 004361be
    mov esi, dword ptr [ebp - local_31c]         # 004361c1
    shl esi, 0x4                                 # 004361c7
    mov edx, dword ptr [edx + eax + 0x5b2374]    # 004361ca
    sub edx, dword ptr [ecx + esi + 0x5b236c]    # 004361d1
    add edx, 0x1                                 # 004361d8
    mov eax, dword ptr [ebp - local_31c]         # 004361db
    shl eax, 0x2                                 # 004361e1
    mov ecx, dword ptr [ebp - local_324]         # 004361e4
    mov word ptr [eax + 8*ecx + 0x5b3ae8], dx    # 004361ea
    mov edx, dword ptr [ebp - local_324]         # 004361f2
    shl edx, 0x5                                 # 004361f8
    mov eax, dword ptr [ebp - local_31c]         # 004361fb
    shl eax, 0x4                                 # 00436201
    mov ecx, dword ptr [ebp - local_324]         # 00436204
    shl ecx, 0x5                                 # 0043620a
    mov esi, dword ptr [ebp - local_31c]         # 0043620d
    shl esi, 0x4                                 # 00436213
    mov edx, dword ptr [edx + eax + 0x5b2378]    # 00436216
    sub edx, dword ptr [ecx + esi + 0x5b2370]    # 0043621d
    add edx, 0x1                                 # 00436224
    mov eax, dword ptr [ebp - local_31c]         # 00436227
    shl eax, 0x2                                 # 0043622d
    mov ecx, dword ptr [ebp - local_324]         # 00436230
    mov word ptr [eax + 8*ecx + 0x5b3aea], dx    # 00436236
    mov edx, dword ptr [ebp - local_324]         # 0043623e
    shl edx, 0x5                                 # 00436244
    mov eax, dword ptr [ebp - local_31c]         # 00436247
    shl eax, 0x4                                 # 0043624d
    mov ecx, dword ptr [ebp - local_324]         # 00436250
    shl ecx, 0x5                                 # 00436256
    mov esi, dword ptr [ebp - local_31c]         # 00436259
    shl esi, 0x4                                 # 0043625f
    mov edx, dword ptr [edx + eax + 0x5b236c]    # 00436262
    sub edx, dword ptr [ecx + esi + 0x5b160c]    # 00436269
    mov eax, dword ptr [ebp - local_324]         # 00436270
    shl eax, 0x4                                 # 00436276
    mov ecx, dword ptr [ebp - local_31c]         # 00436279
    mov dword ptr [eax + 8*ecx + 0x5b3e40], edx  # 0043627f
    mov edx, dword ptr [ebp - local_324]         # 00436286
    shl edx, 0x5                                 # 0043628c
    mov eax, dword ptr [ebp - local_31c]         # 0043628f
    shl eax, 0x4                                 # 00436295
    mov ecx, dword ptr [ebp - local_324]         # 00436298
    shl ecx, 0x5                                 # 0043629e
    mov esi, dword ptr [ebp - local_31c]         # 004362a1
    shl esi, 0x4                                 # 004362a7
    mov edx, dword ptr [edx + eax + 0x5b2370]    # 004362aa
    sub edx, dword ptr [ecx + esi + 0x5b1610]    # 004362b1
    mov eax, dword ptr [ebp - local_324]         # 004362b8
    shl eax, 0x4                                 # 004362be
    mov ecx, dword ptr [ebp - local_31c]         # 004362c1
    mov dword ptr [eax + 8*ecx + 0x5b3e44], edx  # 004362c7
    jmp.d32 L_004360f2                           # 004362ce
L_004362d3:
    # block 0x004362d3: entered by jge at 0x00436108, 1 instruction(s), ends with backward jump to 0x004360ca
    jmp.d32 L_004360ca                           # 004362d3
L_004362d8:
    # block 0x004362d8: entered by jge at 0x004360e0, 6 instruction(s), calls FUN_004343a2, ends with jne to 0x00436331 (forward)
    mov dword ptr [0x5b44f8], 0x0                # 004362d8
    push 0x5466e4                                # 004362e2
    lea ecx, [ebp - local_c1fc]                  # 004362e7
    call FUN_004343a2                            # 004362ed
    test eax, eax                                # 004362f2
    jne.d8 L_00436331                            # 004362f4
    # block 0x004362f6: entered by fall-through of jne at 0x004362f4, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5466ec                                # 004362f6
    push 0x5466f4                                # 004362fb
    mov ecx, 0x583979                            # 00436300
    call FUN_0042639d                            # 00436305
    mov word ptr [ebp - local_c258], 0x0         # 0043630a
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436313
    lea ecx, [ebp - local_c1fc]                  # 0043631a
    call FUN_00433e63                            # 00436320
    mov ax, word ptr [ebp - local_c258]          # 00436325
    jmp.d32 L_00437603                           # 0043632c
L_00436331:
    # block 0x00436331: entered by jne at 0x004362f4, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x0043639f (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436331
    mov esi, dword ptr [ebp - local_b0dc]        # 00436337
    mov edi, 0x583186                            # 0043633d
    {load} mov edx, ecx                          # 00436342
    shr ecx, 0x2                                 # 00436344
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00436347
    {load} mov ecx, edx                          # 00436349
    and ecx, 0x3                                 # 0043634b
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043634e
    push 0x546708                                # 00436350
    lea ecx, [ebp - local_c1fc]                  # 00436355
    call FUN_004343a2                            # 0043635b
    test eax, eax                                # 00436360
    jne.d8 L_0043639f                            # 00436362
    # block 0x00436364: entered by fall-through of jne at 0x00436362, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546710                                # 00436364
    push 0x546718                                # 00436369
    mov ecx, 0x583979                            # 0043636e
    call FUN_0042639d                            # 00436373
    mov word ptr [ebp - local_c25c], 0x0         # 00436378
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436381
    lea ecx, [ebp - local_c1fc]                  # 00436388
    call FUN_00433e63                            # 0043638e
    mov ax, word ptr [ebp - local_c25c]          # 00436393
    jmp.d32 L_00437603                           # 0043639a
L_0043639f:
    # block 0x0043639f: entered by jne at 0x00436362, 11 instruction(s), calls FUN_004e069c, FUN_004343a2, ends with jne to 0x00436406 (forward)
    mov eax, dword ptr [ebp - local_b0d0]        # 0043639f
    push eax                                     # 004363a5
    mov ecx, dword ptr [ebp - local_b0dc]        # 004363a6
    push ecx                                     # 004363ac
    mov ecx, 0x570508                            # 004363ad
    call FUN_004e069c                            # 004363b2
    push 0x54672c                                # 004363b7
    lea ecx, [ebp - local_c1fc]                  # 004363bc
    call FUN_004343a2                            # 004363c2
    test eax, eax                                # 004363c7
    jne.d8 L_00436406                            # 004363c9
    # block 0x004363cb: entered by fall-through of jne at 0x004363c9, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546734                                # 004363cb
    push 0x54673c                                # 004363d0
    mov ecx, 0x583979                            # 004363d5
    call FUN_0042639d                            # 004363da
    mov word ptr [ebp - local_c260], 0x0         # 004363df
    mov dword ptr [ebp - local_4], 0xffffffff    # 004363e8
    lea ecx, [ebp - local_c1fc]                  # 004363ef
    call FUN_00433e63                            # 004363f5
    mov ax, word ptr [ebp - local_c260]          # 004363fa
    jmp.d32 L_00437603                           # 00436401
L_00436406:
    # block 0x00436406: entered by jne at 0x004363c9, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00436474 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436406
    mov esi, dword ptr [ebp - local_b0dc]        # 0043640c
    mov edi, 0x5b44fe                            # 00436412
    {load} mov edx, ecx                          # 00436417
    shr ecx, 0x2                                 # 00436419
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043641c
    {load} mov ecx, edx                          # 0043641e
    and ecx, 0x3                                 # 00436420
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436423
    push 0x546750                                # 00436425
    lea ecx, [ebp - local_c1fc]                  # 0043642a
    call FUN_004343a2                            # 00436430
    test eax, eax                                # 00436435
    jne.d8 L_00436474                            # 00436437
    # block 0x00436439: entered by fall-through of jne at 0x00436437, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546758                                # 00436439
    push 0x546760                                # 0043643e
    mov ecx, 0x583979                            # 00436443
    call FUN_0042639d                            # 00436448
    mov word ptr [ebp - local_c264], 0x0         # 0043644d
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436456
    lea ecx, [ebp - local_c1fc]                  # 0043645d
    call FUN_00433e63                            # 00436463
    mov ax, word ptr [ebp - local_c264]          # 00436468
    jmp.d32 L_00437603                           # 0043646f
L_00436474:
    # block 0x00436474: entered by jne at 0x00436437, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x004364e2 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436474
    mov esi, dword ptr [ebp - local_b0dc]        # 0043647a
    mov edi, 0x5b4631                            # 00436480
    {load} mov eax, ecx                          # 00436485
    shr ecx, 0x2                                 # 00436487
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043648a
    {load} mov ecx, eax                          # 0043648c
    and ecx, 0x3                                 # 0043648e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436491
    push 0x546774                                # 00436493
    lea ecx, [ebp - local_c1fc]                  # 00436498
    call FUN_004343a2                            # 0043649e
    test eax, eax                                # 004364a3
    jne.d8 L_004364e2                            # 004364a5
    # block 0x004364a7: entered by fall-through of jne at 0x004364a5, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x54677c                                # 004364a7
    push 0x546784                                # 004364ac
    mov ecx, 0x583979                            # 004364b1
    call FUN_0042639d                            # 004364b6
    mov word ptr [ebp - local_c268], 0x0         # 004364bb
    mov dword ptr [ebp - local_4], 0xffffffff    # 004364c4
    lea ecx, [ebp - local_c1fc]                  # 004364cb
    call FUN_00433e63                            # 004364d1
    mov ax, word ptr [ebp - local_c268]          # 004364d6
    jmp.d32 L_00437603                           # 004364dd
L_004364e2:
    # block 0x004364e2: entered by jne at 0x004364a5, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00436550 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 004364e2
    mov esi, dword ptr [ebp - local_b0dc]        # 004364e8
    mov edi, 0x5b4766                            # 004364ee
    {load} mov edx, ecx                          # 004364f3
    shr ecx, 0x2                                 # 004364f5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004364f8
    {load} mov ecx, edx                          # 004364fa
    and ecx, 0x3                                 # 004364fc
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004364ff
    push 0x546798                                # 00436501
    lea ecx, [ebp - local_c1fc]                  # 00436506
    call FUN_004343a2                            # 0043650c
    test eax, eax                                # 00436511
    jne.d8 L_00436550                            # 00436513
    # block 0x00436515: entered by fall-through of jne at 0x00436513, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5467a0                                # 00436515
    push 0x5467a8                                # 0043651a
    mov ecx, 0x583979                            # 0043651f
    call FUN_0042639d                            # 00436524
    mov word ptr [ebp - local_c26c], 0x0         # 00436529
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436532
    lea ecx, [ebp - local_c1fc]                  # 00436539
    call FUN_00433e63                            # 0043653f
    mov ax, word ptr [ebp - local_c26c]          # 00436544
    jmp.d32 L_00437603                           # 0043654b
L_00436550:
    # block 0x00436550: entered by jne at 0x00436513, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x004365be (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436550
    mov esi, dword ptr [ebp - local_b0dc]        # 00436556
    mov edi, 0x5e3180                            # 0043655c
    {load} mov eax, ecx                          # 00436561
    shr ecx, 0x2                                 # 00436563
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00436566
    {load} mov ecx, eax                          # 00436568
    and ecx, 0x3                                 # 0043656a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043656d
    push 0x5467bc                                # 0043656f
    lea ecx, [ebp - local_c1fc]                  # 00436574
    call FUN_004343a2                            # 0043657a
    test eax, eax                                # 0043657f
    jne.d8 L_004365be                            # 00436581
    # block 0x00436583: entered by fall-through of jne at 0x00436581, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5467c4                                # 00436583
    push 0x5467cc                                # 00436588
    mov ecx, 0x583979                            # 0043658d
    call FUN_0042639d                            # 00436592
    mov word ptr [ebp - local_c270], 0x0         # 00436597
    mov dword ptr [ebp - local_4], 0xffffffff    # 004365a0
    lea ecx, [ebp - local_c1fc]                  # 004365a7
    call FUN_00433e63                            # 004365ad
    mov ax, word ptr [ebp - local_c270]          # 004365b2
    jmp.d32 L_00437603                           # 004365b9
L_004365be:
    # block 0x004365be: entered by jne at 0x00436581, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x0043662c (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 004365be
    mov esi, dword ptr [ebp - local_b0dc]        # 004365c4
    mov edi, 0x5b489b                            # 004365ca
    {load} mov edx, ecx                          # 004365cf
    shr ecx, 0x2                                 # 004365d1
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004365d4
    {load} mov ecx, edx                          # 004365d6
    and ecx, 0x3                                 # 004365d8
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004365db
    push 0x5467e0                                # 004365dd
    lea ecx, [ebp - local_c1fc]                  # 004365e2
    call FUN_004343a2                            # 004365e8
    test eax, eax                                # 004365ed
    jne.d8 L_0043662c                            # 004365ef
    # block 0x004365f1: entered by fall-through of jne at 0x004365ef, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5467e4                                # 004365f1
    push 0x5467e8                                # 004365f6
    mov ecx, 0x583979                            # 004365fb
    call FUN_0042639d                            # 00436600
    mov word ptr [ebp - local_c274], 0x0         # 00436605
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043660e
    lea ecx, [ebp - local_c1fc]                  # 00436615
    call FUN_00433e63                            # 0043661b
    mov ax, word ptr [ebp - local_c274]          # 00436620
    jmp.d32 L_00437603                           # 00436627
L_0043662c:
    # block 0x0043662c: entered by jne at 0x004365ef, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x0043669a (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 0043662c
    mov esi, dword ptr [ebp - local_b0dc]        # 00436632
    mov edi, 0x583239                            # 00436638
    {load} mov eax, ecx                          # 0043663d
    shr ecx, 0x2                                 # 0043663f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00436642
    {load} mov ecx, eax                          # 00436644
    and ecx, 0x3                                 # 00436646
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436649
    push 0x5467fc                                # 0043664b
    lea ecx, [ebp - local_c1fc]                  # 00436650
    call FUN_004343a2                            # 00436656
    test eax, eax                                # 0043665b
    jne.d8 L_0043669a                            # 0043665d
    # block 0x0043665f: entered by fall-through of jne at 0x0043665d, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546800                                # 0043665f
    push 0x546804                                # 00436664
    mov ecx, 0x583979                            # 00436669
    call FUN_0042639d                            # 0043666e
    mov word ptr [ebp - local_c278], 0x0         # 00436673
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043667c
    lea ecx, [ebp - local_c1fc]                  # 00436683
    call FUN_00433e63                            # 00436689
    mov ax, word ptr [ebp - local_c278]          # 0043668e
    jmp.d32 L_00437603                           # 00436695
L_0043669a:
    # block 0x0043669a: entered by jne at 0x0043665d, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00436708 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 0043669a
    mov esi, dword ptr [ebp - local_b0dc]        # 004366a0
    mov edi, 0x5b49d0                            # 004366a6
    {load} mov edx, ecx                          # 004366ab
    shr ecx, 0x2                                 # 004366ad
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004366b0
    {load} mov ecx, edx                          # 004366b2
    and ecx, 0x3                                 # 004366b4
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004366b7
    push 0x546818                                # 004366b9
    lea ecx, [ebp - local_c1fc]                  # 004366be
    call FUN_004343a2                            # 004366c4
    test eax, eax                                # 004366c9
    jne.d8 L_00436708                            # 004366cb
    # block 0x004366cd: entered by fall-through of jne at 0x004366cb, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x54681c                                # 004366cd
    push 0x546820                                # 004366d2
    mov ecx, 0x583979                            # 004366d7
    call FUN_0042639d                            # 004366dc
    mov word ptr [ebp - local_c27c], 0x0         # 004366e1
    mov dword ptr [ebp - local_4], 0xffffffff    # 004366ea
    lea ecx, [ebp - local_c1fc]                  # 004366f1
    call FUN_00433e63                            # 004366f7
    mov ax, word ptr [ebp - local_c27c]          # 004366fc
    jmp.d32 L_00437603                           # 00436703
L_00436708:
    # block 0x00436708: entered by jne at 0x004366cb, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x00436776 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436708
    mov esi, dword ptr [ebp - local_b0dc]        # 0043670e
    mov edi, 0x5b4b05                            # 00436714
    {load} mov eax, ecx                          # 00436719
    shr ecx, 0x2                                 # 0043671b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043671e
    {load} mov ecx, eax                          # 00436720
    and ecx, 0x3                                 # 00436722
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436725
    push 0x546834                                # 00436727
    lea ecx, [ebp - local_c1fc]                  # 0043672c
    call FUN_004343a2                            # 00436732
    test eax, eax                                # 00436737
    jne.d8 L_00436776                            # 00436739
    # block 0x0043673b: entered by fall-through of jne at 0x00436739, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x54683c                                # 0043673b
    push 0x546844                                # 00436740
    mov ecx, 0x583979                            # 00436745
    call FUN_0042639d                            # 0043674a
    mov word ptr [ebp - local_c280], 0x0         # 0043674f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436758
    lea ecx, [ebp - local_c1fc]                  # 0043675f
    call FUN_00433e63                            # 00436765
    mov ax, word ptr [ebp - local_c280]          # 0043676a
    jmp.d32 L_00437603                           # 00436771
L_00436776:
    # block 0x00436776: entered by jne at 0x00436739, 15 instruction(s), calls FUN_004e7dad, ends with jne to 0x004367d1 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436776
    mov esi, dword ptr [ebp - local_b0dc]        # 0043677c
    mov edi, 0x5b5237                            # 00436782
    {load} mov edx, ecx                          # 00436787
    shr ecx, 0x2                                 # 00436789
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043678c
    {load} mov ecx, edx                          # 0043678e
    and ecx, 0x3                                 # 00436790
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436793
    lea eax, [ebp - local_c1fc]                  # 00436795
    push eax                                     # 0043679b
    mov ecx, 0x571442                            # 0043679c
    call FUN_004e7dad                            # 004367a1
    test eax, eax                                # 004367a6
    jne.d8 L_004367d1                            # 004367a8
    # block 0x004367aa: entered by fall-through of jne at 0x004367a8, 6 instruction(s), calls FUN_00433e63, ends with forward jump to 0x00437603
    mov word ptr [ebp - local_c284], 0x0         # 004367aa
    mov dword ptr [ebp - local_4], 0xffffffff    # 004367b3
    lea ecx, [ebp - local_c1fc]                  # 004367ba
    call FUN_00433e63                            # 004367c0
    mov ax, word ptr [ebp - local_c284]          # 004367c5
    jmp.d32 L_00437603                           # 004367cc
L_004367d1:
    # block 0x004367d1: entered by jne at 0x004367a8, 5 instruction(s), calls FUN_004343a2, ends with jne to 0x00436820 (forward)
    push 0x546858                                # 004367d1
    lea ecx, [ebp - local_c1fc]                  # 004367d6
    call FUN_004343a2                            # 004367dc
    test eax, eax                                # 004367e1
    jne.d8 L_00436820                            # 004367e3
    # block 0x004367e5: entered by fall-through of jne at 0x004367e3, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546860                                # 004367e5
    push 0x546868                                # 004367ea
    mov ecx, 0x583979                            # 004367ef
    call FUN_0042639d                            # 004367f4
    mov word ptr [ebp - local_c288], 0x0         # 004367f9
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436802
    lea ecx, [ebp - local_c1fc]                  # 00436809
    call FUN_00433e63                            # 0043680f
    mov ax, word ptr [ebp - local_c288]          # 00436814
    jmp.d32 L_00437603                           # 0043681b
L_00436820:
    # block 0x00436820: entered by jne at 0x004367e3, 11 instruction(s), calls FUN_004e7d2e, FUN_004343a2, ends with jne to 0x00436887 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436820
    push ecx                                     # 00436826
    mov edx, dword ptr [ebp - local_b0dc]        # 00436827
    push edx                                     # 0043682d
    mov ecx, 0x571442                            # 0043682e
    call FUN_004e7d2e                            # 00436833
    push 0x54687c                                # 00436838
    lea ecx, [ebp - local_c1fc]                  # 0043683d
    call FUN_004343a2                            # 00436843
    test eax, eax                                # 00436848
    jne.d8 L_00436887                            # 0043684a
    # block 0x0043684c: entered by fall-through of jne at 0x0043684a, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546884                                # 0043684c
    push 0x54688c                                # 00436851
    mov ecx, 0x583979                            # 00436856
    call FUN_0042639d                            # 0043685b
    mov word ptr [ebp - local_c28c], 0x0         # 00436860
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436869
    lea ecx, [ebp - local_c1fc]                  # 00436870
    call FUN_00433e63                            # 00436876
    mov ax, word ptr [ebp - local_c28c]          # 0043687b
    jmp.d32 L_00437603                           # 00436882
L_00436887:
    # block 0x00436887: entered by jne at 0x0043684a, 11 instruction(s), calls FUN_004e7843, FUN_004343a2, ends with jne to 0x004368ee (forward)
    mov eax, dword ptr [ebp - local_b0d0]        # 00436887
    push eax                                     # 0043688d
    mov ecx, dword ptr [ebp - local_b0dc]        # 0043688e
    push ecx                                     # 00436894
    mov ecx, 0x582711                            # 00436895
    call FUN_004e7843                            # 0043689a
    push 0x5468a0                                # 0043689f
    lea ecx, [ebp - local_c1fc]                  # 004368a4
    call FUN_004343a2                            # 004368aa
    test eax, eax                                # 004368af
    jne.d8 L_004368ee                            # 004368b1
    # block 0x004368b3: entered by fall-through of jne at 0x004368b1, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5468a8                                # 004368b3
    push 0x5468b0                                # 004368b8
    mov ecx, 0x583979                            # 004368bd
    call FUN_0042639d                            # 004368c2
    mov word ptr [ebp - local_c290], 0x0         # 004368c7
    mov dword ptr [ebp - local_4], 0xffffffff    # 004368d0
    lea ecx, [ebp - local_c1fc]                  # 004368d7
    call FUN_00433e63                            # 004368dd
    mov ax, word ptr [ebp - local_c290]          # 004368e2
    jmp.d32 L_00437603                           # 004368e9
L_004368ee:
    # block 0x004368ee: entered by jne at 0x004368b1, 11 instruction(s), calls FUN_004de394, FUN_004343a2, ends with jne to 0x00436955 (forward)
    mov edx, dword ptr [ebp - local_b0d0]        # 004368ee
    push edx                                     # 004368f4
    mov eax, dword ptr [ebp - local_b0dc]        # 004368f5
    push eax                                     # 004368fb
    mov ecx, 0x61f864                            # 004368fc
    call FUN_004de394                            # 00436901
    push 0x5468c4                                # 00436906
    lea ecx, [ebp - local_c1fc]                  # 0043690b
    call FUN_004343a2                            # 00436911
    test eax, eax                                # 00436916
    jne.d8 L_00436955                            # 00436918
    # block 0x0043691a: entered by fall-through of jne at 0x00436918, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5468cc                                # 0043691a
    push 0x5468d4                                # 0043691f
    mov ecx, 0x583979                            # 00436924
    call FUN_0042639d                            # 00436929
    mov word ptr [ebp - local_c294], 0x0         # 0043692e
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436937
    lea ecx, [ebp - local_c1fc]                  # 0043693e
    call FUN_00433e63                            # 00436944
    mov ax, word ptr [ebp - local_c294]          # 00436949
    jmp.d32 L_00437603                           # 00436950
L_00436955:
    # block 0x00436955: entered by jne at 0x00436918, 14 instruction(s), calls FUN_004343a2, ends with jne to 0x004369c3 (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436955
    mov esi, dword ptr [ebp - local_b0dc]        # 0043695b
    mov edi, 0x5afbfe                            # 00436961
    {load} mov edx, ecx                          # 00436966
    shr ecx, 0x2                                 # 00436968
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043696b
    {load} mov ecx, edx                          # 0043696d
    and ecx, 0x3                                 # 0043696f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436972
    push 0x5468e8                                # 00436974
    lea ecx, [ebp - local_c1fc]                  # 00436979
    call FUN_004343a2                            # 0043697f
    test eax, eax                                # 00436984
    jne.d8 L_004369c3                            # 00436986
    # block 0x00436988: entered by fall-through of jne at 0x00436986, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x5468f0                                # 00436988
    push 0x5468f8                                # 0043698d
    mov ecx, 0x583979                            # 00436992
    call FUN_0042639d                            # 00436997
    mov word ptr [ebp - local_c298], 0x0         # 0043699c
    mov dword ptr [ebp - local_4], 0xffffffff    # 004369a5
    lea ecx, [ebp - local_c1fc]                  # 004369ac
    call FUN_00433e63                            # 004369b2
    mov ax, word ptr [ebp - local_c298]          # 004369b7
    jmp.d32 L_00437603                           # 004369be
L_004369c3:
    # block 0x004369c3: entered by jne at 0x00436986, 11 instruction(s), calls FUN_004e4337, FUN_004343a2, ends with jne to 0x00436a2a (forward)
    mov eax, dword ptr [ebp - local_b0d0]        # 004369c3
    push eax                                     # 004369c9
    mov ecx, dword ptr [ebp - local_b0dc]        # 004369ca
    push ecx                                     # 004369d0
    mov ecx, 0x57975c                            # 004369d1
    call FUN_004e4337                            # 004369d6
    push 0x54690c                                # 004369db
    lea ecx, [ebp - local_c1fc]                  # 004369e0
    call FUN_004343a2                            # 004369e6
    test eax, eax                                # 004369eb
    jne.d8 L_00436a2a                            # 004369ed
    # block 0x004369ef: entered by fall-through of jne at 0x004369ed, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546914                                # 004369ef
    push 0x54691c                                # 004369f4
    mov ecx, 0x583979                            # 004369f9
    call FUN_0042639d                            # 004369fe
    mov word ptr [ebp - local_c29c], 0x0         # 00436a03
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436a0c
    lea ecx, [ebp - local_c1fc]                  # 00436a13
    call FUN_00433e63                            # 00436a19
    mov ax, word ptr [ebp - local_c29c]          # 00436a1e
    jmp.d32 L_00437603                           # 00436a25
L_00436a2a:
    # block 0x00436a2a: entered by jne at 0x004369ed, 11 instruction(s), calls FUN_004e4428, FUN_004343a2, ends with jne to 0x00436a91 (forward)
    mov edx, dword ptr [ebp - local_b0d0]        # 00436a2a
    push edx                                     # 00436a30
    mov eax, dword ptr [ebp - local_b0dc]        # 00436a31
    push eax                                     # 00436a37
    mov ecx, 0x57975c                            # 00436a38
    call FUN_004e4428                            # 00436a3d
    push 0x546930                                # 00436a42
    lea ecx, [ebp - local_c1fc]                  # 00436a47
    call FUN_004343a2                            # 00436a4d
    test eax, eax                                # 00436a52
    jne.d8 L_00436a91                            # 00436a54
    # block 0x00436a56: entered by fall-through of jne at 0x00436a54, 10 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546938                                # 00436a56
    push 0x546940                                # 00436a5b
    mov ecx, 0x583979                            # 00436a60
    call FUN_0042639d                            # 00436a65
    mov word ptr [ebp - local_c2a0], 0x0         # 00436a6a
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436a73
    lea ecx, [ebp - local_c1fc]                  # 00436a7a
    call FUN_00433e63                            # 00436a80
    mov ax, word ptr [ebp - local_c2a0]          # 00436a85
    jmp.d32 L_00437603                           # 00436a8c
L_00436a91:
    # block 0x00436a91: entered by jne at 0x00436a54, 15 instruction(s), calls FUN_004ec005, FUN_00433c60, FUN_004343a2, ends with jne to 0x00436b1b (forward)
    mov ecx, dword ptr [ebp - local_b0d0]        # 00436a91
    push ecx                                     # 00436a97
    mov edx, dword ptr [ebp - local_b0dc]        # 00436a98
    push edx                                     # 00436a9e
    mov ecx, 0x57fd34                            # 00436a9f
    call FUN_004ec005                            # 00436aa4
    push 0x546954                                # 00436aa9
    lea ecx, [ebp - local_6290]                  # 00436aae
    call FUN_00433c60                            # 00436ab4
    mov byte ptr [ebp - local_4], 0x1            # 00436ab9
    push 0x54695c                                # 00436abd
    lea ecx, [ebp - local_6290]                  # 00436ac2
    call FUN_004343a2                            # 00436ac8
    test eax, eax                                # 00436acd
    jne.d8 L_00436b1b                            # 00436acf
    # block 0x00436ad1: entered by fall-through of jne at 0x00436acf, 13 instruction(s), calls FUN_0042639d, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x546964                                # 00436ad1
    push 0x54696c                                # 00436ad6
    mov ecx, 0x583979                            # 00436adb
    call FUN_0042639d                            # 00436ae0
    mov word ptr [ebp - local_c2a4], 0x0         # 00436ae5
    mov byte ptr [ebp - local_4], 0x0            # 00436aee
    lea ecx, [ebp - local_6290]                  # 00436af2
    call FUN_00433e63                            # 00436af8
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436afd
    lea ecx, [ebp - local_c1fc]                  # 00436b04
    call FUN_00433e63                            # 00436b0a
    mov ax, word ptr [ebp - local_c2a4]          # 00436b0f
    jmp.d32 L_00437603                           # 00436b16
L_00436b1b:
    # block 0x00436b1b: entered by jne at 0x00436acf, 4 instruction(s), ends with je to 0x00436b9b (forward)
    movsx eax, word ptr [0x5b0264]               # 00436b1b
    imul eax, eax, 0x7f3                         # 00436b22
    cmp dword ptr [ebp - local_5164], eax        # 00436b28
    je.d8 L_00436b9b                             # 00436b2e
    # block 0x00436b30: entered by fall-through of je at 0x00436b2e, 22 instruction(s), calls FUN_0050ca3e, FUN_0052139c, FUN_00433e63, ends with forward jump to 0x00437603
    mov ecx, dword ptr [ebp - local_5164]        # 00436b30
    push ecx                                     # 00436b36
    movsx edx, word ptr [0x5b0264]               # 00436b37
    imul edx, edx, 0x7f3                         # 00436b3e
    push edx                                     # 00436b44
    push 0x546980                                # 00436b45
    push 0x63888b                                # 00436b4a
    call FUN_0050ca3e                            # 00436b4f
    add esp, 0x10                                # 00436b54
    push 0x0                                     # 00436b57
    push 0x0                                     # 00436b59
    push 0x63888b                                # 00436b5b
    call FUN_0052139c                            # 00436b60
    mov word ptr [ebp - local_c2a8], 0x0         # 00436b65
    mov byte ptr [ebp - local_4], 0x0            # 00436b6e
    lea ecx, [ebp - local_6290]                  # 00436b72
    call FUN_00433e63                            # 00436b78
    mov dword ptr [ebp - local_4], 0xffffffff    # 00436b7d
    lea ecx, [ebp - local_c1fc]                  # 00436b84
    call FUN_00433e63                            # 00436b8a
    mov ax, word ptr [ebp - local_c2a8]          # 00436b8f
    jmp.d32 L_00437603                           # 00436b96
L_00436b9b:
    # block 0x00436b9b: entered by je at 0x00436b2e, 11 instruction(s), ends with forward jump to 0x00436bd5
    mov ecx, dword ptr [ebp - local_5164]        # 00436b9b
    mov esi, dword ptr [ebp - local_5170]        # 00436ba1
    mov edi, 0x5a4c24                            # 00436ba7
    {load} mov eax, ecx                          # 00436bac
    shr ecx, 0x2                                 # 00436bae
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00436bb1
    {load} mov ecx, eax                          # 00436bb3
    and ecx, 0x3                                 # 00436bb5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00436bb8
    mov dword ptr [ebp - local_324], 0x0         # 00436bba
    jmp.d8 L_00436bd5                            # 00436bc4
L_00436bc6:
    # block 0x00436bc6: entered by jmp at 0x00436cbf, 3 instruction(s), falls into the block at 0x00436bd5
    mov ecx, dword ptr [ebp - local_324]         # 00436bc6
    add ecx, 0x1                                 # 00436bcc
    mov dword ptr [ebp - local_324], ecx         # 00436bcf
L_00436bd5:
    # block 0x00436bd5: entered by jmp at 0x00436bc4, 3 instruction(s), ends with jge to 0x00436cc4 (forward)
    movsx edx, word ptr [0x5b0264]               # 00436bd5
    cmp dword ptr [ebp - local_324], edx         # 00436bdc
    jge.d32 L_00436cc4                           # 00436be2
    # block 0x00436be8: entered by fall-through of jge at 0x00436be2, 2 instruction(s), ends with forward jump to 0x00436c03
    mov dword ptr [ebp - local_31c], 0x0         # 00436be8
    jmp.d8 L_00436c03                            # 00436bf2
L_00436bf4:
    # block 0x00436bf4: entered by jmp at 0x00436cba, 3 instruction(s), falls into the block at 0x00436c03
    mov eax, dword ptr [ebp - local_31c]         # 00436bf4
    add eax, 0x1                                 # 00436bfa
    mov dword ptr [ebp - local_31c], eax         # 00436bfd
L_00436c03:
    # block 0x00436c03: entered by jmp at 0x00436bf2, 2 instruction(s), ends with jge to 0x00436cbf (forward)
    cmp dword ptr [ebp - local_31c], 0x73        # 00436c03
    jge.d32 L_00436cbf                           # 00436c0a
    # block 0x00436c10: entered by fall-through of jge at 0x00436c0a, 31 instruction(s), ends with backward jump to 0x00436bf4
    mov ecx, dword ptr [ebp - local_324]         # 00436c10
    imul ecx, ecx, 0x7f3                         # 00436c16
    mov edx, dword ptr [ebp - local_31c]         # 00436c1c
    shl edx, 0x4                                 # 00436c22
    mov eax, dword ptr [ebp - local_324]         # 00436c25
    imul eax, eax, 0x7f3                         # 00436c2b
    mov esi, dword ptr [ebp - local_31c]         # 00436c31
    shl esi, 0x4                                 # 00436c37
    mov ecx, dword ptr [ecx + edx + 0x5a4cef]    # 00436c3a
    sub ecx, dword ptr [eax + esi + 0x5a4ce7]    # 00436c41
    add ecx, 0x1                                 # 00436c48
    mov edx, dword ptr [ebp - local_324]         # 00436c4b
    imul edx, edx, 0x1d0                         # 00436c51
    mov eax, dword ptr [ebp - local_31c]         # 00436c57
    mov word ptr [edx + 4*eax + 0x5adb3a], cx    # 00436c5d
    mov ecx, dword ptr [ebp - local_324]         # 00436c65
    imul ecx, ecx, 0x7f3                         # 00436c6b
    mov edx, dword ptr [ebp - local_31c]         # 00436c71
    shl edx, 0x4                                 # 00436c77
    mov eax, dword ptr [ebp - local_324]         # 00436c7a
    imul eax, eax, 0x7f3                         # 00436c80
    mov esi, dword ptr [ebp - local_31c]         # 00436c86
    shl esi, 0x4                                 # 00436c8c
    mov ecx, dword ptr [ecx + edx + 0x5a4cf3]    # 00436c8f
    sub ecx, dword ptr [eax + esi + 0x5a4ceb]    # 00436c96
    add ecx, 0x1                                 # 00436c9d
    mov edx, dword ptr [ebp - local_324]         # 00436ca0
    imul edx, edx, 0x1d0                         # 00436ca6
    mov eax, dword ptr [ebp - local_31c]         # 00436cac
    mov word ptr [edx + 4*eax + 0x5adb3c], cx    # 00436cb2
    jmp.d32 L_00436bf4                           # 00436cba
L_00436cbf:
    # block 0x00436cbf: entered by jge at 0x00436c0a, 1 instruction(s), ends with backward jump to 0x00436bc6
    jmp.d32 L_00436bc6                           # 00436cbf
L_00436cc4:
    # block 0x00436cc4: entered by jge at 0x00436be2, 2 instruction(s), ends with forward jump to 0x00436cdf
    mov dword ptr [ebp - local_324], 0x0         # 00436cc4
    jmp.d8 L_00436cdf                            # 00436cce
L_00436cd0:
    # block 0x00436cd0: entered by jmp at 0x00436cf8, 3 instruction(s), falls into the block at 0x00436cdf
    mov ecx, dword ptr [ebp - local_324]         # 00436cd0
    add ecx, 0x1                                 # 00436cd6
    mov dword ptr [ebp - local_324], ecx         # 00436cd9
L_00436cdf:
    # block 0x00436cdf: entered by jmp at 0x00436cce, 2 instruction(s), ends with jge to 0x00436cfa (forward)
    cmp dword ptr [ebp - local_324], 0x12        # 00436cdf
    jge.d8 L_00436cfa                            # 00436ce6
    # block 0x00436ce8: entered by fall-through of jge at 0x00436ce6, 3 instruction(s), ends with backward jump to 0x00436cd0
    mov edx, dword ptr [ebp - local_324]         # 00436ce8
    mov word ptr [2*edx + 0x5afbda], 0x0         # 00436cee
    jmp.d8 L_00436cd0                            # 00436cf8
L_00436cfa:
    # block 0x00436cfa: entered by jge at 0x00436ce6, 3 instruction(s), ends with je to 0x00436d12 (forward)
    movsx eax, word ptr [0x63a4cd]               # 00436cfa
    test eax, eax                                # 00436d01
    je.d8 L_00436d12                             # 00436d03
    # block 0x00436d05: entered by fall-through of je at 0x00436d03, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00436d12
    push 0x5469d4                                # 00436d05
    call FUN_0044a2b7                            # 00436d0a
    add esp, 0x4                                 # 00436d0f
L_00436d12:
    # block 0x00436d12: entered by je at 0x00436d03, 3 instruction(s), calls FUN_0044a6f2, ends with forward jump to 0x00436d32
    call FUN_0044a6f2                            # 00436d12
    mov dword ptr [ebp - local_324], 0x0         # 00436d17
    jmp.d8 L_00436d32                            # 00436d21
L_00436d23:
    # block 0x00436d23: entered by jmp at 0x00436d58, 3 instruction(s), falls into the block at 0x00436d32
    mov ecx, dword ptr [ebp - local_324]         # 00436d23
    add ecx, 0x1                                 # 00436d29
    mov dword ptr [ebp - local_324], ecx         # 00436d2c
L_00436d32:
    # block 0x00436d32: entered by jmp at 0x00436d21, 2 instruction(s), ends with jge to 0x00436d5a (forward)
    cmp dword ptr [ebp - local_324], 0xa         # 00436d32
    jge.d8 L_00436d5a                            # 00436d39
    # block 0x00436d3b: entered by fall-through of jge at 0x00436d39, 8 instruction(s), ends with backward jump to 0x00436d23
    mov ecx, 0x41                                # 00436d3b
    {load} xor eax, eax                          # 00436d40
    mov edi, dword ptr [ebp - local_324]         # 00436d42
    imul edi, edi, 0x106                         # 00436d48
    add edi, 0x585d65                            # 00436d4e
    rep stosd dword ptr es:[edi], eax            # 00436d54
    stosw word ptr es:[edi], ax                  # 00436d56
    jmp.d8 L_00436d23                            # 00436d58
L_00436d5a:
    # block 0x00436d5a: entered by jge at 0x00436d39, 37 instruction(s), calls FUN_00437743, ends with forward jump to 0x00436ea6
    mov ecx, 0x583208                            # 00436d5a
    call FUN_00437743                            # 00436d5f
    mov dword ptr [0x63a4d1], 0x0                # 00436d64
    mov dword ptr [0x63a4d5], 0x0                # 00436d6e
    mov dword ptr [0x63a4d9], 0x0                # 00436d78
    mov dword ptr [0x63a4dd], 0xffffffff         # 00436d82
    mov dword ptr [0x63a4e1], 0xffffffff         # 00436d8c
    mov dword ptr [0x63a4e5], 0x1                # 00436d96
    mov dword ptr [0x63a4e9], 0x0                # 00436da0
    mov dword ptr [0x63a4ed], 0xffffffff         # 00436daa
    mov dword ptr [0x63a4f1], 0x0                # 00436db4
    mov ecx, 0x7                                 # 00436dbe
    {load} xor eax, eax                          # 00436dc3
    mov edi, 0x5c3a4b                            # 00436dc5
    rep stosd dword ptr es:[edi], eax            # 00436dca
    mov byte ptr [0x5bb320], 0x0                 # 00436dcc
    mov byte ptr [0x5b4c8b], 0x0                 # 00436dd3
    mov byte ptr [0x5b4f02], 0x0                 # 00436dda
    mov dword ptr [0x5bb2f4], 0x0                # 00436de1
    mov dword ptr [0x5b4c5f], 0x0                # 00436deb
    mov dword ptr [0x5b4ed6], 0x0                # 00436df5
    mov dword ptr [0x5bb300], 0x0                # 00436dff
    mov dword ptr [0x5b4c6b], 0x0                # 00436e09
    mov dword ptr [0x5b4ee2], 0x0                # 00436e13
    mov dword ptr [0x5bb2f8], 0x0                # 00436e1d
    mov dword ptr [0x5b4c63], 0x0                # 00436e27
    mov dword ptr [0x5b4eda], 0x0                # 00436e31
    mov dword ptr [0x5bb2fc], 0x0                # 00436e3b
    mov dword ptr [0x5b4c67], 0x0                # 00436e45
    mov dword ptr [0x5b4ede], 0x0                # 00436e4f
    mov dword ptr [0x5bb4db], 0x0                # 00436e59
    mov dword ptr [0x5b4dc4], 0x0                # 00436e63
    mov dword ptr [0x5b503b], 0x0                # 00436e6d
    mov dword ptr [0x5b4e8f], 0x0                # 00436e77
    mov dword ptr [0x5b5106], 0x0                # 00436e81
    mov dword ptr [ebp - local_324], 0x0         # 00436e8b
    jmp.d8 L_00436ea6                            # 00436e95
L_00436e97:
    # block 0x00436e97: entered by jmp at 0x00436ed0, 3 instruction(s), falls into the block at 0x00436ea6
    mov edx, dword ptr [ebp - local_324]         # 00436e97
    add edx, 0x1                                 # 00436e9d
    mov dword ptr [ebp - local_324], edx         # 00436ea0
L_00436ea6:
    # block 0x00436ea6: entered by jmp at 0x00436e95, 2 instruction(s), ends with jge to 0x00436ed2 (forward)
    cmp dword ptr [ebp - local_324], 0x19        # 00436ea6
    jge.d8 L_00436ed2                            # 00436ead
    # block 0x00436eaf: entered by fall-through of jge at 0x00436ead, 5 instruction(s), ends with backward jump to 0x00436e97
    mov eax, dword ptr [ebp - local_324]         # 00436eaf
    mov dword ptr [4*eax + 0x5bb445], 0x0        # 00436eb5
    mov ecx, dword ptr [ebp - local_324]         # 00436ec0
    mov word ptr [2*ecx + 0x5bb4a9], 0x0         # 00436ec6
    jmp.d8 L_00436e97                            # 00436ed0
L_00436ed2:
    # block 0x00436ed2: entered by jge at 0x00436ead, 47 instruction(s), calls FUN_0044c44c, ends with forward jump to 0x00437086
    mov dword ptr [0x5b4db8], 0x0                # 00436ed2
    mov dword ptr [0x5b4dbc], 0x0                # 00436edc
    mov word ptr [0x5b4dc0], 0x0                 # 00436ee6
    mov word ptr [0x5b4dc2], 0x0                 # 00436eef
    mov dword ptr [0x5b502f], 0x0                # 00436ef8
    mov dword ptr [0x5b5033], 0x0                # 00436f02
    mov word ptr [0x5b5037], 0x0                 # 00436f0c
    mov word ptr [0x5b5039], 0x0                 # 00436f15
    mov dword ptr [0x5b4db0], 0x1                # 00436f1e
    mov dword ptr [0x5b5027], 0x1                # 00436f28
    mov dword ptr [0x5bb4df], 0x0                # 00436f32
    mov dword ptr [0x5b4db4], 0x0                # 00436f3c
    mov dword ptr [0x5b502b], 0x0                # 00436f46
    mov dword ptr [0x5bb22a], 0x0                # 00436f50
    call FUN_0044c44c                            # 00436f5a
    mov dword ptr [0x5c39e9], 0x0                # 00436f5f
    mov dword ptr [0x5c39ed], 0x0                # 00436f69
    mov dword ptr [0x5c39f1], 0x0                # 00436f73
    mov dword ptr [0x5c39f5], 0x0                # 00436f7d
    mov dword ptr [0x5c39f9], 0x0                # 00436f87
    mov dword ptr [0x5c39e5], 0xffffffff         # 00436f91
    mov dword ptr [0x5bb505], 0x0                # 00436f9b
    mov dword ptr [0x5bb57b], 0x0                # 00436fa5
    mov word ptr [0x5bb599], 0x0                 # 00436faf
    mov dx, word ptr [0x5bb599]                  # 00436fb8
    mov word ptr [0x5bb597], dx                  # 00436fbf
    mov word ptr [0x5bb595], 0x0                 # 00436fc6
    mov ax, word ptr [0x5bb595]                  # 00436fcf
    mov word ptr [0x5bb593], ax                  # 00436fd5
    mov word ptr [0x5c39e3], 0x0                 # 00436fdb
    mov word ptr [0x5c3a05], 0x270f              # 00436fe4
    mov word ptr [0x5c3a07], 0x270f              # 00436fed
    mov word ptr [0x5c3a09], 0x0                 # 00436ff6
    mov word ptr [0x5c3a0b], 0x0                 # 00436fff
    mov word ptr [0x5c3a0d], 0x2                 # 00437008
    mov word ptr [0x5c3a1b], 0x270f              # 00437011
    mov word ptr [0x5c3a1d], 0x270f              # 0043701a
    mov word ptr [0x5c3a1f], 0x0                 # 00437023
    mov word ptr [0x5c3a21], 0x0                 # 0043702c
    mov word ptr [0x5c3a23], 0x2                 # 00437035
    mov word ptr [0x5c3a31], 0x270f              # 0043703e
    mov word ptr [0x5c3a33], 0x270f              # 00437047
    mov word ptr [0x5c3a35], 0x0                 # 00437050
    mov word ptr [0x5c3a37], 0x0                 # 00437059
    mov word ptr [0x5c3a39], 0x2                 # 00437062
    mov dword ptr [ebp - local_324], 0x0         # 0043706b
    jmp.d8 L_00437086                            # 00437075
L_00437077:
    # block 0x00437077: entered by jmp at 0x00437105, 3 instruction(s), falls into the block at 0x00437086
    mov ecx, dword ptr [ebp - local_324]         # 00437077
    add ecx, 0x1                                 # 0043707d
    mov dword ptr [ebp - local_324], ecx         # 00437080
L_00437086:
    # block 0x00437086: entered by jmp at 0x00437075, 2 instruction(s), ends with jge to 0x0043710a (forward)
    cmp dword ptr [ebp - local_324], 0xf0        # 00437086
    jge.d8 L_0043710a                            # 00437090
    # block 0x00437092: entered by fall-through of jge at 0x00437090, 20 instruction(s), ends with backward jump to 0x00437077
    mov ecx, 0x23                                # 00437092
    {load} xor eax, eax                          # 00437097
    mov edi, dword ptr [ebp - local_324]         # 00437099
    imul edi, edi, 0x8d                          # 0043709f
    add edi, 0x5bb5b3                            # 004370a5
    rep stosd dword ptr es:[edi], eax            # 004370ab
    stosb byte ptr es:[edi], al                  # 004370ad
    mov edx, dword ptr [ebp - local_324]         # 004370ae
    imul edx, edx, 0x8d                          # 004370b4
    mov dword ptr [edx + 0x5bb632], 0x0          # 004370ba
    mov eax, dword ptr [ebp - local_324]         # 004370c4
    imul eax, eax, 0x8d                          # 004370ca
    mov word ptr [eax + 0x5bb636], 0xffff        # 004370d0
    mov ecx, dword ptr [ebp - local_324]         # 004370d9
    imul ecx, ecx, 0x8d                          # 004370df
    mov dword ptr [ecx + 0x5bb638], 0x1          # 004370e5
    mov edx, dword ptr [ebp - local_324]         # 004370ef
    imul edx, edx, 0x8d                          # 004370f5
    mov dword ptr [edx + 0x5bb63c], 0x0          # 004370fb
    jmp.d32 L_00437077                           # 00437105
L_0043710a:
    # block 0x0043710a: entered by jge at 0x00437090, 11 instruction(s), calls FUN_00423c2b, ends with jns to 0x00437153 (forward)
    mov ecx, 0x63786d                            # 0043710a
    call FUN_00423c2b                            # 0043710f
    mov byte ptr [0x5b6047], 0x0                 # 00437114
    mov dword ptr [0x583204], 0x0                # 0043711b
    mov dword ptr [0x5a4c14], 0x0                # 00437125
    mov dword ptr [0x5bb21a], 0x1                # 0043712f
    mov eax, dword ptr [0x58318e]                # 00437139
    sub eax, dword ptr [0x583186]                # 0043713e
    add eax, 0x1                                 # 00437144
    and eax, 0x80000003                          # 00437147
    jns.d8 L_00437153                            # 0043714c
    # block 0x0043714e: entered by fall-through of jns at 0x0043714c, 3 instruction(s), falls into the block at 0x00437153
    dec eax                                      # 0043714e
    or eax, -0x4                                 # 0043714f
    inc eax                                      # 00437152
L_00437153:
    # block 0x00437153: entered by jns at 0x0043714c, 2 instruction(s), ends with je to 0x0043719b (forward)
    test eax, eax                                # 00437153
    je.d8 L_0043719b                             # 00437155
    # block 0x00437157: entered by fall-through of je at 0x00437155, 13 instruction(s), calls FUN_0052139c, FUN_00433e63, ends with forward jump to 0x00437603
    push 0x0                                     # 00437157
    push 0x0                                     # 00437159
    push 0x5469ec                                # 0043715b
    call FUN_0052139c                            # 00437160
    mov word ptr [ebp - local_c2ac], 0x0         # 00437165
    mov byte ptr [ebp - local_4], 0x0            # 0043716e
    lea ecx, [ebp - local_6290]                  # 00437172
    call FUN_00433e63                            # 00437178
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043717d
    lea ecx, [ebp - local_c1fc]                  # 00437184
    call FUN_00433e63                            # 0043718a
    mov ax, word ptr [ebp - local_c2ac]          # 0043718f
    jmp.d32 L_00437603                           # 00437196
L_0043719b:
    # block 0x0043719b: entered by je at 0x00437155, 20 instruction(s), ends with forward jump to 0x00437213
    movsx ecx, word ptr [0x5b0262]               # 0043719b
    mov edx, dword ptr [0x58318a]                # 004371a2
    lea eax, [edx + ecx - field_minus_1]         # 004371a8
    mov dword ptr [0x5831ba], eax                # 004371ac
    movsx ecx, word ptr [0x5b0262]               # 004371b1
    mov edx, dword ptr [0x583192]                # 004371b8
    {load} sub edx, ecx                          # 004371be
    add edx, 0x1                                 # 004371c0
    mov dword ptr [0x5831c2], edx                # 004371c3
    movsx eax, word ptr [0x5b0260]               # 004371c9
    mov ecx, dword ptr [0x583186]                # 004371d0
    lea edx, [ecx + eax - field_minus_1]         # 004371d6
    mov dword ptr [0x5831b6], edx                # 004371da
    movsx eax, word ptr [0x5b0260]               # 004371e0
    mov ecx, dword ptr [0x58318e]                # 004371e7
    {load} sub ecx, eax                          # 004371ed
    add ecx, 0x1                                 # 004371ef
    mov dword ptr [0x5831be], ecx                # 004371f2
    mov dword ptr [ebp - local_324], 0x0         # 004371f8
    jmp.d8 L_00437213                            # 00437202
L_00437204:
    # block 0x00437204: entered by jmp at 0x0043722c, 3 instruction(s), falls into the block at 0x00437213
    mov edx, dword ptr [ebp - local_324]         # 00437204
    add edx, 0x1                                 # 0043720a
    mov dword ptr [ebp - local_324], edx         # 0043720d
L_00437213:
    # block 0x00437213: entered by jmp at 0x00437202, 2 instruction(s), ends with jge to 0x0043722e (forward)
    cmp dword ptr [ebp - local_324], 0x58        # 00437213
    jge.d8 L_0043722e                            # 0043721a
    # block 0x0043721c: entered by fall-through of jge at 0x0043721a, 5 instruction(s), calls FUN_004d3992, ends with backward jump to 0x00437204
    mov ax, word ptr [ebp - local_324]           # 0043721c
    push eax                                     # 00437223
    call FUN_004d3992                            # 00437224
    add esp, 0x4                                 # 00437229
    jmp.d8 L_00437204                            # 0043722c
L_0043722e:
    # block 0x0043722e: entered by jge at 0x0043721a, 69 instruction(s), calls FUN_0043dbd5, FUN_004d36ed, FUN_004d3b95, FUN_00468e5a, FUN_004b3c5a, FUN_0042347b, FUN_004dad60, ends with je to 0x00437443 (forward)
    call FUN_0043dbd5                            # 0043722e
    call FUN_004d36ed                            # 00437233
    mov dword ptr [0x5aff4d], 0x0                # 00437238
    mov dword ptr [0x5aff51], 0x0                # 00437242
    mov word ptr [0x5aff55], 0xffff              # 0043724c
    mov dword ptr [0x5b0006], 0x0                # 00437255
    mov dword ptr [0x5b000a], 0x0                # 0043725f
    mov word ptr [0x5b000e], 0xffff              # 00437269
    mov ecx, 0x61c387                            # 00437272
    call FUN_004d3b95                            # 00437277
    mov byte ptr [0x5b5158], 0x0                 # 0043727c
    mov byte ptr [0x5b51ab], 0x0                 # 00437283
    mov byte ptr [0x5b51c6], 0x0                 # 0043728a
    mov byte ptr [0x5b615e], 0x0                 # 00437291
    mov byte ptr [0x5b51f6], 0x0                 # 00437298
    mov byte ptr [0x5b61af], 0x0                 # 0043729f
    mov ecx, 0x616ab2                            # 004372a6
    call FUN_00468e5a                            # 004372ab
    mov ecx, 0x617066                            # 004372b0
    call FUN_004b3c5a                            # 004372b5
    mov ecx, 0x63786d                            # 004372ba
    call FUN_0042347b                            # 004372bf
    mov dword ptr [0x5bb1ee], 0x0                # 004372c4
    mov dword ptr [0x5bb1ea], 0x0                # 004372ce
    mov dword ptr [0x5bb1f6], 0x0                # 004372d8
    mov dword ptr [0x5bb1f2], 0x0                # 004372e2
    mov dword ptr [0x5bb1d2], 0x0                # 004372ec
    mov dword ptr [0x5b15da], 0x0                # 004372f6
    mov ecx, dword ptr [0x5b0a2a]                # 00437300
    sub ecx, dword ptr [0x5b0a22]                # 00437306
    add ecx, 0x1                                 # 0043730c
    mov word ptr [0x5b0a74], cx                  # 0043730f
    mov edx, dword ptr [0x5b0a2e]                # 00437316
    sub edx, dword ptr [0x5b0a26]                # 0043731c
    add edx, 0x1                                 # 00437322
    mov word ptr [0x5b0a76], dx                  # 00437325
    mov dword ptr [0x5bb1da], 0x0                # 0043732c
    mov eax, dword ptr [0x5b0a52]                # 00437336
    sub eax, dword ptr [0x5b0a4a]                # 0043733b
    add eax, 0x1                                 # 00437341
    mov word ptr [0x5b15ee], ax                  # 00437344
    mov ecx, dword ptr [0x5b0a56]                # 0043734a
    sub ecx, dword ptr [0x5b0a4e]                # 00437350
    add ecx, 0x1                                 # 00437356
    mov word ptr [0x5b15f0], cx                  # 00437359
    mov word ptr [0x5831c6], 0x0                 # 00437360
    mov dword ptr [0x5831c8], 0x0                # 00437369
    mov dword ptr [0x5bb1de], 0x0                # 00437373
    mov dword ptr [0x5bb1e2], 0x0                # 0043737d
    mov ecx, 0x5830a6                            # 00437387
    call FUN_004dad60                            # 0043738c
    mov dword ptr [0x58397d], 0x0                # 00437391
    mov dword ptr [0x583981], 0x0                # 0043739b
    mov dword ptr [0x583985], 0x0                # 004373a5
    mov dword ptr [0x583989], 0x0                # 004373af
    mov dword ptr [0x58398d], 0x0                # 004373b9
    mov dword ptr [0x583991], 0x0                # 004373c3
    mov dword ptr [0x583995], 0x0                # 004373cd
    mov dword ptr [0x5839a1], 0x0                # 004373d7
    mov dword ptr [0x5839a5], 0x0                # 004373e1
    mov dword ptr [0x583999], 0x0                # 004373eb
    mov dword ptr [0x5839a9], 0x1                # 004373f5
    mov dword ptr [0x5839ad], 0x0                # 004373ff
    mov byte ptr [0x5a161f], 0x0                 # 00437409
    mov dword ptr [0x5bb20c], 0x0                # 00437410
    mov dl, byte ptr [0x5b0171]                  # 0043741a
    mov byte ptr [ebp - local_c2c0], dl          # 00437420
    cmp byte ptr [ebp - local_c2c0], 0x1         # 00437426
    je.d8 L_00437443                             # 0043742d
    # block 0x0043742f: entered by fall-through of je at 0x0043742d, 2 instruction(s), ends with je to 0x0043746c (forward)
    cmp byte ptr [ebp - local_c2c0], 0x2         # 0043742f
    je.d8 L_0043746c                             # 00437436
    # block 0x00437438: entered by fall-through of je at 0x00437436, 2 instruction(s), ends with je to 0x00437495 (forward)
    cmp byte ptr [ebp - local_c2c0], 0x3         # 00437438
    je.d8 L_00437495                             # 0043743f
    # block 0x00437441: entered by fall-through of je at 0x0043743f, 1 instruction(s), ends with forward jump to 0x004374bc
    jmp.d8 L_004374bc                            # 00437441
L_00437443:
    # block 0x00437443: entered by je at 0x0043742d, 16 instruction(s), ends with forward jump to 0x004374bc
    mov edi, 0x639da2                            # 00437443
    mov edx, 0x639dab                            # 00437448
    or ecx, -0x1                                 # 0043744d
    {load} xor eax, eax                          # 00437450
    repne scasb al, byte ptr es:[edi]            # 00437452
    not ecx                                      # 00437454
    {load} sub edi, ecx                          # 00437456
    {load} mov esi, edi                          # 00437458
    {load} mov eax, ecx                          # 0043745a
    {load} mov edi, edx                          # 0043745c
    shr ecx, 0x2                                 # 0043745e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00437461
    {load} mov ecx, eax                          # 00437463
    and ecx, 0x3                                 # 00437465
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00437468
    jmp.d8 L_004374bc                            # 0043746a
L_0043746c:
    # block 0x0043746c: entered by je at 0x00437436, 16 instruction(s), ends with forward jump to 0x004374bc
    mov edi, 0x639da5                            # 0043746c
    mov edx, 0x639dab                            # 00437471
    or ecx, -0x1                                 # 00437476
    {load} xor eax, eax                          # 00437479
    repne scasb al, byte ptr es:[edi]            # 0043747b
    not ecx                                      # 0043747d
    {load} sub edi, ecx                          # 0043747f
    {load} mov esi, edi                          # 00437481
    {load} mov eax, ecx                          # 00437483
    {load} mov edi, edx                          # 00437485
    shr ecx, 0x2                                 # 00437487
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043748a
    {load} mov ecx, eax                          # 0043748c
    and ecx, 0x3                                 # 0043748e
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00437491
    jmp.d8 L_004374bc                            # 00437493
L_00437495:
    # block 0x00437495: entered by je at 0x0043743f, 15 instruction(s), falls into the block at 0x004374bc
    mov edi, 0x639da8                            # 00437495
    mov edx, 0x639dab                            # 0043749a
    or ecx, -0x1                                 # 0043749f
    {load} xor eax, eax                          # 004374a2
    repne scasb al, byte ptr es:[edi]            # 004374a4
    not ecx                                      # 004374a6
    {load} sub edi, ecx                          # 004374a8
    {load} mov esi, edi                          # 004374aa
    {load} mov eax, ecx                          # 004374ac
    {load} mov edi, edx                          # 004374ae
    shr ecx, 0x2                                 # 004374b0
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004374b3
    {load} mov ecx, eax                          # 004374b5
    and ecx, 0x3                                 # 004374b7
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004374ba
L_004374bc:
    # block 0x004374bc: entered by jmp at 0x00437441; jmp at 0x0043746a; jmp at 0x00437493, 1 instruction(s), falls into the block at 0x004374c6
    mov dword ptr [0x5bb1c6], 0x0                # 004374bc
L_004374c6:
    # block 0x004374c6: entered by jmp at 0x004374f4, 6 instruction(s), calls FUN_0044a177, ends with je to 0x004374f6 (forward)
    call FUN_0044a177                            # 004374c6
    and eax, 0xff                                # 004374cb
    {load} xor ecx, ecx                          # 004374d0
    mov cl, byte ptr [0x5b0171]                  # 004374d2
    {load} cmp eax, ecx                          # 004374d8
    je.d8 L_004374f6                             # 004374da
    # block 0x004374dc: entered by fall-through of je at 0x004374da, 2 instruction(s), ends with jne to 0x004374f6 (forward)
    cmp dword ptr [0x5bb1c6], 0x0                # 004374dc
    jne.d8 L_004374f6                            # 004374e3
    # block 0x004374e5: entered by fall-through of jne at 0x004374e3, 5 instruction(s), calls FUN_0044a0c5, ends with backward jump to 0x004374c6
    mov dl, byte ptr [0x5b0171]                  # 004374e5
    push edx                                     # 004374eb
    call FUN_0044a0c5                            # 004374ec
    add esp, 0x4                                 # 004374f1
    jmp.d8 L_004374c6                            # 004374f4
L_004374f6:
    # block 0x004374f6: entered by je at 0x004374da; jne at 0x004374e3, 2 instruction(s), ends with je to 0x0043753f (forward)
    cmp dword ptr [0x5bb1c6], 0x0                # 004374f6
    je.d8 L_0043753f                             # 004374fd
    # block 0x004374ff: entered by fall-through of je at 0x004374fd, 10 instruction(s), calls FUN_00433e63, ends with forward jump to 0x00437603
    mov dword ptr [0x5bb20c], 0x1                # 004374ff
    mov word ptr [ebp - local_c2b0], 0x0         # 00437509
    mov byte ptr [ebp - local_4], 0x0            # 00437512
    lea ecx, [ebp - local_6290]                  # 00437516
    call FUN_00433e63                            # 0043751c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00437521
    lea ecx, [ebp - local_c1fc]                  # 00437528
    call FUN_00433e63                            # 0043752e
    mov ax, word ptr [ebp - local_c2b0]          # 00437533
    jmp.d32 L_00437603                           # 0043753a
L_0043753f:
    # block 0x0043753f: entered by je at 0x004374fd, 6 instruction(s), calls FUN_0051d994, FUN_004c9d91, ends with jne to 0x0043758a (forward)
    mov ecx, 0x570388                            # 0043753f
    call FUN_0051d994                            # 00437544
    mov ecx, 0x5cf659                            # 00437549
    call FUN_004c9d91                            # 0043754e
    test eax, eax                                # 00437553
    jne.d8 L_0043758a                            # 00437555
    # block 0x00437557: entered by fall-through of jne at 0x00437555, 9 instruction(s), calls FUN_00433e63, ends with forward jump to 0x00437603
    mov word ptr [ebp - local_c2b4], 0x0         # 00437557
    mov byte ptr [ebp - local_4], 0x0            # 00437560
    lea ecx, [ebp - local_6290]                  # 00437564
    call FUN_00433e63                            # 0043756a
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043756f
    lea ecx, [ebp - local_c1fc]                  # 00437576
    call FUN_00433e63                            # 0043757c
    mov ax, word ptr [ebp - local_c2b4]          # 00437581
    jmp.d8 L_00437603                            # 00437588
L_0043758a:
    # block 0x0043758a: entered by jne at 0x00437555, 3 instruction(s), ends with je to 0x004375a2 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0043758a
    test eax, eax                                # 00437591
    je.d8 L_004375a2                             # 00437593
    # block 0x00437595: entered by fall-through of je at 0x00437593, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004375a2
    push 0x546a20                                # 00437595
    call FUN_0044a2b7                            # 0043759a
    add esp, 0x4                                 # 0043759f
L_004375a2:
    # block 0x004375a2: entered by je at 0x00437593, 2 instruction(s), ends with jne to 0x004375d2 (forward)
    cmp dword ptr [0x5d2f05], 0x0                # 004375a2
    jne.d8 L_004375d2                            # 004375a9
    # block 0x004375ab: entered by fall-through of jne at 0x004375a9, 3 instruction(s), calls USER32.dll!ShowCursor, falls into the block at 0x004375b9
    push 0x0                                     # 004375ab
    call dword ptr [0x52a4cc]                    # 004375ad
    mov dword ptr [ebp - local_c2bc], eax        # 004375b3
L_004375b9:
    # block 0x004375b9: entered by jmp at 0x004375d0, 2 instruction(s), ends with jl to 0x004375d2 (forward)
    cmp dword ptr [ebp - local_c2bc], 0x0        # 004375b9
    jl.d8 L_004375d2                             # 004375c0
    # block 0x004375c2: entered by fall-through of jl at 0x004375c0, 4 instruction(s), calls USER32.dll!ShowCursor, ends with backward jump to 0x004375b9
    push 0x0                                     # 004375c2
    call dword ptr [0x52a4cc]                    # 004375c4
    mov dword ptr [ebp - local_c2bc], eax        # 004375ca
    jmp.d8 L_004375b9                            # 004375d0
L_004375d2:
    # block 0x004375d2: entered by jne at 0x004375a9; jl at 0x004375c0, 8 instruction(s), calls FUN_00433e63, falls into the block at 0x00437603
    mov word ptr [ebp - local_c2b8], 0x1         # 004375d2
    mov byte ptr [ebp - local_4], 0x0            # 004375db
    lea ecx, [ebp - local_6290]                  # 004375df
    call FUN_00433e63                            # 004375e5
    mov dword ptr [ebp - local_4], 0xffffffff    # 004375ea
    lea ecx, [ebp - local_c1fc]                  # 004375f1
    call FUN_00433e63                            # 004375f7
    mov ax, word ptr [ebp - local_c2b8]          # 004375fc
L_00437603:
    # block 0x00437603: entered by jmp at 0x004354c5; jmp at 0x004356da; jmp at 0x0043573a; jmp at 0x004357bb; more, 8 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - local_c]           # 00437603
    mov dword ptr fs:[0x0], ecx                  # 00437606
    pop edi                                      # 0043760d
    pop esi                                      # 0043760e
    pop ebx                                      # 0043760f
    {load} mov esp, ebp                          # 00437610
    pop ebp                                      # 00437612
    ret                                          # 00437613

