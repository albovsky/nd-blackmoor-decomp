# FUN_004cdfd3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cdfd3
# extent:       0x004cdfd3-0x004ce602 (1583 code bytes)
# span:         0x004cdfd3-0x004ce602 (code 1583, tables 0, padding 0)
# sha256:       b1030236e3d5715d75aec2f7b8acdd13dbe1ae948d70ef9330b86f2e8e9729bc
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_random_movie_clip_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_2d_runtime.h:39 says "0x4cdfd3 clip load: four file probes (BIK, BIK in the second directory, AVF"
# name-note:    Clip load: probes BIK and AVF files, copies the name and initialises the player state.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       9 ebp-relative slot(s): local_4, local_c, local_10, local_114, local_118, local_11c, local_120, local_124, local_128
# fields:       [eax + n] field_21, field_2b, field_17e, field_1b2, field_1ba, field_1be, field_1d6, field_1da, field_212, field_21a, field_222, field_226 and 1 more; [ecx + n] field_2d, field_18e, field_1b2, field_1b6, field_1ba, field_1be, field_1ca, field_1cc, field_1d4, field_1d6, field_20a, field_212 and 2 more; [edx + n] field_21, field_18e, field_1b2, field_1b6, field_1ba, field_1ce, field_1d6, field_20e, field_212, field_21a
# callees:      calls FUN_0050cd72, FUN_00449d90, FUN_0044c4c1, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c2a8d, FUN_004161d1, FUN_0051dc43, FUN_004497a0, FUN_0042639d, FUN_00449bff, FUN_004bef11, FUN_004bf3b8, FUN_004bf19a
# track-n:      outputs/blackmoor-decomp/src/action_family_2d_runtime.c:load_clip (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 361 instruction(s), 24 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ local_11c, 0x11c  # offset -0x11c
.equ local_120, 0x120  # offset -0x120
.equ local_124, 0x124  # offset -0x124
.equ local_128, 0x128  # offset -0x128
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21
.equ field_2b, 0x2b  # offset +0x2b
.equ field_2d, 0x2d  # offset +0x2d
.equ field_17e, 0x17e  # offset +0x17e
.equ field_18e, 0x18e  # offset +0x18e
.equ field_1b2, 0x1b2  # offset +0x1b2
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1ba, 0x1ba  # offset +0x1ba
.equ field_1be, 0x1be  # offset +0x1be
.equ field_1ca, 0x1ca  # offset +0x1ca
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_1ce, 0x1ce  # offset +0x1ce
.equ field_1d4, 0x1d4  # offset +0x1d4
.equ field_1d6, 0x1d6  # offset +0x1d6
.equ field_1da, 0x1da  # offset +0x1da
.equ field_20a, 0x20a  # offset +0x20a
.equ field_20e, 0x20e  # offset +0x20e
.equ field_212, 0x212  # offset +0x212
.equ field_21a, 0x21a  # offset +0x21a
.equ field_222, 0x222  # offset +0x222
.equ field_226, 0x226  # offset +0x226
.equ field_232, 0x232  # offset +0x232

# --- external targets -----------------------------------------------
.set FUN_004161d1, .text + (0x004161d1 - 0x401000)
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004497a0, .text + (0x004497a0 - 0x401000)
.set FUN_00449bff, .text + (0x00449bff - 0x401000)
.set FUN_00449d90, .text + (0x00449d90 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c4c1, .text + (0x0044c4c1 - 0x401000)
.set FUN_004bef11, .text + (0x004bef11 - 0x401000)
.set FUN_004bf19a, .text + (0x004bf19a - 0x401000)
.set FUN_004bf3b8, .text + (0x004bf3b8 - 0x401000)
.set FUN_004c2a8d, .text + (0x004c2a8d - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004cdfd3 - 0x401000
.globl FUN_004cdfd3
FUN_004cdfd3:
    # block 0x004cdfd3: entry, 14 instruction(s), ends with je to 0x004ce017 (forward)
    push ebp                                     # 004cdfd3
    {load} mov ebp, esp                          # 004cdfd4
    push -0x1                                    # 004cdfd6
    push 0x52883e                                # 004cdfd8
    mov eax, dword ptr fs:[0x0]                  # 004cdfdd
    push eax                                     # 004cdfe3
    mov dword ptr fs:[0x0], esp                  # 004cdfe4
    sub esp, 0x11c                               # 004cdfeb
    push esi                                     # 004cdff1
    push edi                                     # 004cdff2
    mov dword ptr [ebp - local_120], ecx         # 004cdff3
    mov eax, dword ptr [ebp - local_120]         # 004cdff9
    cmp dword ptr [eax + field_222], 0x0         # 004cdfff
    je.d8 L_004ce017                             # 004ce006
    # block 0x004ce008: entered by fall-through of je at 0x004ce006, 3 instruction(s), ends with jne to 0x004ce01e (forward)
    mov ecx, dword ptr [ebp - local_120]         # 004ce008
    cmp dword ptr [ecx + field_226], 0x0         # 004ce00e
    jne.d8 L_004ce01e                            # 004ce015
L_004ce017:
    # block 0x004ce017: entered by je at 0x004ce006; fall-through of jne at 0x004ce015, 2 instruction(s), ends with forward jump to 0x004ce5f0
    {load} xor eax, eax                          # 004ce017
    jmp.d32 L_004ce5f0                           # 004ce019
L_004ce01e:
    # block 0x004ce01e: entered by jne at 0x004ce015, 23 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x004ce08c (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004ce01e
    imul edx, edx, 0x35                          # 004ce021
    mov eax, dword ptr [ebp - local_120]         # 004ce024
    mov ecx, dword ptr [eax + field_226]         # 004ce02a
    {load} add ecx, edx                          # 004ce030
    mov dword ptr [ebp - local_10], ecx          # 004ce032
    mov edx, dword ptr [ebp - local_120]         # 004ce035
    mov dword ptr [edx + field_21a], 0xffffffff  # 004ce03b
    push 0x55981c                                # 004ce045
    mov eax, dword ptr [ebp - local_10]          # 004ce04a
    push eax                                     # 004ce04d
    push 0x639eb5                                # 004ce04e
    push 0x639dae                                # 004ce053
    lea ecx, [ebp - local_114]                   # 004ce058
    push ecx                                     # 004ce05e
    call FUN_0050cd72                            # 004ce05f
    add esp, 0x14                                # 004ce064
    lea edx, [ebp - local_114]                   # 004ce067
    push edx                                     # 004ce06d
    call FUN_00449d90                            # 004ce06e
    add esp, 0x4                                 # 004ce073
    test eax, eax                                # 004ce076
    je.d8 L_004ce08c                             # 004ce078
    # block 0x004ce07a: entered by fall-through of je at 0x004ce078, 3 instruction(s), ends with forward jump to 0x004ce0d1
    mov eax, dword ptr [ebp - local_120]         # 004ce07a
    mov dword ptr [eax + field_21a], 0x1         # 004ce080
    jmp.d8 L_004ce0d1                            # 004ce08a
L_004ce08c:
    # block 0x004ce08c: entered by je at 0x004ce078, 15 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x004ce0d1 (forward)
    push 0x559824                                # 004ce08c
    mov ecx, dword ptr [ebp - local_10]          # 004ce091
    push ecx                                     # 004ce094
    push 0x639fb9                                # 004ce095
    push 0x639dab                                # 004ce09a
    lea edx, [ebp - local_114]                   # 004ce09f
    push edx                                     # 004ce0a5
    call FUN_0050cd72                            # 004ce0a6
    add esp, 0x14                                # 004ce0ab
    lea eax, [ebp - local_114]                   # 004ce0ae
    push eax                                     # 004ce0b4
    call FUN_00449d90                            # 004ce0b5
    add esp, 0x4                                 # 004ce0ba
    test eax, eax                                # 004ce0bd
    je.d8 L_004ce0d1                             # 004ce0bf
    # block 0x004ce0c1: entered by fall-through of je at 0x004ce0bf, 2 instruction(s), falls into the block at 0x004ce0d1
    mov ecx, dword ptr [ebp - local_120]         # 004ce0c1
    mov dword ptr [ecx + field_21a], 0x1         # 004ce0c7
L_004ce0d1:
    # block 0x004ce0d1: entered by jmp at 0x004ce08a; je at 0x004ce0bf, 3 instruction(s), ends with jne to 0x004ce170 (forward)
    mov edx, dword ptr [ebp - local_120]         # 004ce0d1
    cmp dword ptr [edx + field_21a], -0x1        # 004ce0d7
    jne.d32 L_004ce170                           # 004ce0de
    # block 0x004ce0e4: entered by fall-through of jne at 0x004ce0de, 15 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x004ce12b (forward)
    push 0x55982c                                # 004ce0e4
    mov eax, dword ptr [ebp - local_10]          # 004ce0e9
    push eax                                     # 004ce0ec
    push 0x639eb5                                # 004ce0ed
    push 0x639dae                                # 004ce0f2
    lea ecx, [ebp - local_114]                   # 004ce0f7
    push ecx                                     # 004ce0fd
    call FUN_0050cd72                            # 004ce0fe
    add esp, 0x14                                # 004ce103
    lea edx, [ebp - local_114]                   # 004ce106
    push edx                                     # 004ce10c
    call FUN_00449d90                            # 004ce10d
    add esp, 0x4                                 # 004ce112
    test eax, eax                                # 004ce115
    je.d8 L_004ce12b                             # 004ce117
    # block 0x004ce119: entered by fall-through of je at 0x004ce117, 3 instruction(s), ends with forward jump to 0x004ce170
    mov eax, dword ptr [ebp - local_120]         # 004ce119
    mov dword ptr [eax + field_21a], 0x0         # 004ce11f
    jmp.d8 L_004ce170                            # 004ce129
L_004ce12b:
    # block 0x004ce12b: entered by je at 0x004ce117, 15 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with je to 0x004ce170 (forward)
    push 0x559834                                # 004ce12b
    mov ecx, dword ptr [ebp - local_10]          # 004ce130
    push ecx                                     # 004ce133
    push 0x639fb9                                # 004ce134
    push 0x639dab                                # 004ce139
    lea edx, [ebp - local_114]                   # 004ce13e
    push edx                                     # 004ce144
    call FUN_0050cd72                            # 004ce145
    add esp, 0x14                                # 004ce14a
    lea eax, [ebp - local_114]                   # 004ce14d
    push eax                                     # 004ce153
    call FUN_00449d90                            # 004ce154
    add esp, 0x4                                 # 004ce159
    test eax, eax                                # 004ce15c
    je.d8 L_004ce170                             # 004ce15e
    # block 0x004ce160: entered by fall-through of je at 0x004ce15e, 2 instruction(s), falls into the block at 0x004ce170
    mov ecx, dword ptr [ebp - local_120]         # 004ce160
    mov dword ptr [ecx + field_21a], 0x0         # 004ce166
L_004ce170:
    # block 0x004ce170: entered by jne at 0x004ce0de; jmp at 0x004ce129; je at 0x004ce15e, 3 instruction(s), ends with jne to 0x004ce186 (forward)
    mov edx, dword ptr [ebp - local_120]         # 004ce170
    cmp dword ptr [edx + field_21a], -0x1        # 004ce176
    jne.d8 L_004ce186                            # 004ce17d
    # block 0x004ce17f: entered by fall-through of jne at 0x004ce17d, 2 instruction(s), ends with forward jump to 0x004ce5f0
    {load} xor eax, eax                          # 004ce17f
    jmp.d32 L_004ce5f0                           # 004ce181
L_004ce186:
    # block 0x004ce186: entered by jne at 0x004ce17d, 33 instruction(s), calls FUN_0044c4c1, ends with je to 0x004ce2b0 (forward)
    mov edi, dword ptr [ebp - local_10]          # 004ce186
    mov eax, dword ptr [ebp - local_120]         # 004ce189
    add eax, 0x159                               # 004ce18f
    {load} mov edx, eax                          # 004ce194
    or ecx, -0x1                                 # 004ce196
    {load} xor eax, eax                          # 004ce199
    repne scasb al, byte ptr es:[edi]            # 004ce19b
    not ecx                                      # 004ce19d
    {load} sub edi, ecx                          # 004ce19f
    {load} mov esi, edi                          # 004ce1a1
    {load} mov eax, ecx                          # 004ce1a3
    {load} mov edi, edx                          # 004ce1a5
    shr ecx, 0x2                                 # 004ce1a7
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ce1aa
    {load} mov ecx, eax                          # 004ce1ac
    and ecx, 0x3                                 # 004ce1ae
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ce1b1
    mov ecx, dword ptr [ebp - local_120]         # 004ce1b3
    mov word ptr [ecx + field_1cc], 0x1          # 004ce1b9
    mov edx, dword ptr [ebp - local_120]         # 004ce1c2
    mov word ptr [edx + field_1ce], 0x2          # 004ce1c8
    mov eax, dword ptr [ebp - local_120]         # 004ce1d1
    mov ecx, dword ptr [ebp - local_120]         # 004ce1d7
    mov edx, dword ptr [ecx + field_21a]         # 004ce1dd
    mov dword ptr [eax + field_17e], edx         # 004ce1e3
    mov eax, dword ptr [ebp - local_120]         # 004ce1e9
    add eax, 0x8                                 # 004ce1ef
    push eax                                     # 004ce1f2
    call FUN_0044c4c1                            # 004ce1f3
    add esp, 0x4                                 # 004ce1f8
    mov ecx, dword ptr [ebp - local_120]         # 004ce1fb
    cmp dword ptr [ecx + field_212], 0x0         # 004ce201
    je.d32 L_004ce2b0                            # 004ce208
    # block 0x004ce20e: entered by fall-through of je at 0x004ce208, 10 instruction(s), ends with jne to 0x004ce26c (forward)
    mov edx, dword ptr [ebp - local_120]         # 004ce20e
    mov eax, dword ptr [edx + field_212]         # 004ce214
    movsx ecx, word ptr [eax + field_2b]         # 004ce21a
    mov edx, dword ptr [ebp - local_120]         # 004ce21e
    mov eax, dword ptr [ebp - local_120]         # 004ce224
    mov edx, dword ptr [edx + field_1ba]         # 004ce22a
    sub edx, dword ptr [eax + field_1b2]         # 004ce230
    add edx, 0x1                                 # 004ce236
    {load} cmp ecx, edx                          # 004ce239
    jne.d8 L_004ce26c                            # 004ce23b
    # block 0x004ce23d: entered by fall-through of jne at 0x004ce23b, 10 instruction(s), ends with je to 0x004ce2b0 (forward)
    mov eax, dword ptr [ebp - local_120]         # 004ce23d
    mov ecx, dword ptr [eax + field_212]         # 004ce243
    movsx edx, word ptr [ecx + field_2d]         # 004ce249
    mov eax, dword ptr [ebp - local_120]         # 004ce24d
    mov ecx, dword ptr [ebp - local_120]         # 004ce253
    mov eax, dword ptr [eax + field_1be]         # 004ce259
    sub eax, dword ptr [ecx + field_1b6]         # 004ce25f
    add eax, 0x1                                 # 004ce265
    {load} cmp edx, eax                          # 004ce268
    je.d8 L_004ce2b0                             # 004ce26a
L_004ce26c:
    # block 0x004ce26c: entered by jne at 0x004ce23b; fall-through of je at 0x004ce26a, 12 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x004ce2a9 (forward)
    mov ecx, dword ptr [ebp - local_10]          # 004ce26c
    push ecx                                     # 004ce26f
    push 0x55983c                                # 004ce270
    push 0x63888b                                # 004ce275
    call FUN_0050ca3e                            # 004ce27a
    add esp, 0xc                                 # 004ce27f
    push 0x63888b                                # 004ce282
    mov ecx, 0x583979                            # 004ce287
    call FUN_004264e8                            # 004ce28c
    movsx edx, word ptr [0x63a4cd]               # 004ce291
    test edx, edx                                # 004ce298
    je.d8 L_004ce2a9                             # 004ce29a
    # block 0x004ce29c: entered by fall-through of je at 0x004ce29a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ce2a9
    push 0x63888b                                # 004ce29c
    call FUN_0044a2b7                            # 004ce2a1
    add esp, 0x4                                 # 004ce2a6
L_004ce2a9:
    # block 0x004ce2a9: entered by je at 0x004ce29a, 2 instruction(s), ends with forward jump to 0x004ce5f0
    {load} xor eax, eax                          # 004ce2a9
    jmp.d32 L_004ce5f0                           # 004ce2ab
L_004ce2b0:
    # block 0x004ce2b0: entered by je at 0x004ce208; je at 0x004ce26a, 5 instruction(s), ends with je to 0x004ce2dd (forward)
    mov eax, dword ptr [ebp - local_120]         # 004ce2b0
    mov ecx, dword ptr [eax + field_21a]         # 004ce2b6
    mov dword ptr [ebp - local_124], ecx         # 004ce2bc
    cmp dword ptr [ebp - local_124], 0x0         # 004ce2c2
    je.d8 L_004ce2dd                             # 004ce2c9
    # block 0x004ce2cb: entered by fall-through of je at 0x004ce2c9, 2 instruction(s), ends with je to 0x004ce46c (forward)
    cmp dword ptr [ebp - local_124], 0x1         # 004ce2cb
    je.d32 L_004ce46c                            # 004ce2d2
    # block 0x004ce2d8: entered by fall-through of je at 0x004ce2d2, 1 instruction(s), ends with forward jump to 0x004ce5a7
    jmp.d32 L_004ce5a7                           # 004ce2d8
L_004ce2dd:
    # block 0x004ce2dd: entered by je at 0x004ce2c9, 3 instruction(s), ends with jne to 0x004ce341 (forward)
    mov edx, dword ptr [ebp - local_120]         # 004ce2dd
    cmp dword ptr [edx + field_212], 0x0         # 004ce2e3
    jne.d8 L_004ce341                            # 004ce2ea
    # block 0x004ce2ec: entered by fall-through of jne at 0x004ce2ea, 18 instruction(s), calls FUN_004c2a8d, falls into the block at 0x004ce341
    push 0x5598bc                                # 004ce2ec
    push 0x8                                     # 004ce2f1
    mov eax, dword ptr [ebp - local_120]         # 004ce2f3
    mov ecx, dword ptr [ebp - local_120]         # 004ce2f9
    mov edx, dword ptr [eax + field_1be]         # 004ce2ff
    sub edx, dword ptr [ecx + field_1b6]         # 004ce305
    add edx, 0x1                                 # 004ce30b
    push edx                                     # 004ce30e
    mov eax, dword ptr [ebp - local_120]         # 004ce30f
    mov ecx, dword ptr [ebp - local_120]         # 004ce315
    mov edx, dword ptr [eax + field_1ba]         # 004ce31b
    sub edx, dword ptr [ecx + field_1b2]         # 004ce321
    add edx, 0x1                                 # 004ce327
    push edx                                     # 004ce32a
    mov ecx, 0x5cf659                            # 004ce32b
    call FUN_004c2a8d                            # 004ce330
    mov ecx, dword ptr [ebp - local_120]         # 004ce335
    mov dword ptr [ecx + field_212], eax         # 004ce33b
L_004ce341:
    # block 0x004ce341: entered by jne at 0x004ce2ea, 8 instruction(s), calls FUN_004161d1, ends with jne to 0x004ce433 (forward)
    mov edx, dword ptr [ebp - local_120]         # 004ce341
    add edx, 0x8                                 # 004ce347
    push edx                                     # 004ce34a
    mov ecx, 0x5e2dbe                            # 004ce34b
    call FUN_004161d1                            # 004ce350
    mov eax, dword ptr [ebp - local_120]         # 004ce355
    cmp dword ptr [eax + field_1d6], 0x0         # 004ce35b
    jne.d32 L_004ce433                           # 004ce362
    # block 0x004ce368: entered by fall-through of jne at 0x004ce362, 13 instruction(s), calls FUN_0050ca3e, FUN_0051dc43, ends with je to 0x004ce3c8 (forward)
    mov ecx, dword ptr [0x5bb57b]                # 004ce368
    push ecx                                     # 004ce36e
    push 0x5598d4                                # 004ce36f
    push 0x63888b                                # 004ce374
    call FUN_0050ca3e                            # 004ce379
    add esp, 0xc                                 # 004ce37e
    push 0x46                                    # 004ce381
    call FUN_0051dc43                            # 004ce383
    add esp, 0x4                                 # 004ce388
    mov dword ptr [ebp - local_11c], eax         # 004ce38b
    mov dword ptr [ebp - local_4], 0x0           # 004ce391
    cmp dword ptr [ebp - local_11c], 0x0         # 004ce398
    je.d8 L_004ce3c8                             # 004ce39f
    # block 0x004ce3a1: entered by fall-through of je at 0x004ce39f, 9 instruction(s), calls FUN_004497a0, ends with forward jump to 0x004ce3d2
    push 0x4                                     # 004ce3a1
    movsx edx, word ptr [0x5b016f]               # 004ce3a3
    push edx                                     # 004ce3aa
    push 0x63888b                                # 004ce3ab
    push 0x4cf687                                # 004ce3b0
    mov ecx, dword ptr [ebp - local_11c]         # 004ce3b5
    call FUN_004497a0                            # 004ce3bb
    mov dword ptr [ebp - local_128], eax         # 004ce3c0
    jmp.d8 L_004ce3d2                            # 004ce3c6
L_004ce3c8:
    # block 0x004ce3c8: entered by je at 0x004ce39f, 1 instruction(s), falls into the block at 0x004ce3d2
    mov dword ptr [ebp - local_128], 0x0         # 004ce3c8
L_004ce3d2:
    # block 0x004ce3d2: entered by jmp at 0x004ce3c6, 8 instruction(s), ends with jne to 0x004ce433 (forward)
    mov eax, dword ptr [ebp - local_128]         # 004ce3d2
    mov dword ptr [ebp - local_118], eax         # 004ce3d8
    mov dword ptr [ebp - local_4], 0xffffffff    # 004ce3de
    mov ecx, dword ptr [ebp - local_120]         # 004ce3e5
    mov edx, dword ptr [ebp - local_118]         # 004ce3eb
    mov dword ptr [ecx + field_1d6], edx         # 004ce3f1
    cmp dword ptr [ebp - local_118], 0x0         # 004ce3f7
    jne.d8 L_004ce433                            # 004ce3fe
    # block 0x004ce400: entered by fall-through of jne at 0x004ce3fe, 7 instruction(s), calls FUN_0042639d, ends with je to 0x004ce42c (forward)
    push 0x63888b                                # 004ce400
    push 0x5598fc                                # 004ce405
    mov ecx, 0x583979                            # 004ce40a
    call FUN_0042639d                            # 004ce40f
    movsx eax, word ptr [0x63a4cd]               # 004ce414
    test eax, eax                                # 004ce41b
    je.d8 L_004ce42c                             # 004ce41d
    # block 0x004ce41f: entered by fall-through of je at 0x004ce41d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ce42c
    push 0x63888b                                # 004ce41f
    call FUN_0044a2b7                            # 004ce424
    add esp, 0x4                                 # 004ce429
L_004ce42c:
    # block 0x004ce42c: entered by je at 0x004ce41d, 2 instruction(s), ends with forward jump to 0x004ce5f0
    {load} xor eax, eax                          # 004ce42c
    jmp.d32 L_004ce5f0                           # 004ce42e
L_004ce433:
    # block 0x004ce433: entered by jne at 0x004ce362; jne at 0x004ce3fe, 10 instruction(s), calls FUN_00449bff, ends with forward jump to 0x004ce5ab
    mov ecx, dword ptr [ebp - local_120]         # 004ce433
    mov edx, dword ptr [ebp - local_10]          # 004ce439
    mov ax, word ptr [edx + field_21]            # 004ce43c
    mov word ptr [ecx + field_1ca], ax           # 004ce440
    mov ecx, dword ptr [ebp - local_120]         # 004ce447
    mov word ptr [ecx + field_1d4], 0x0          # 004ce44d
    mov edx, dword ptr [ebp - local_120]         # 004ce456
    mov ecx, dword ptr [edx + field_1d6]         # 004ce45c
    call FUN_00449bff                            # 004ce462
    jmp.d32 L_004ce5ab                           # 004ce467
L_004ce46c:
    # block 0x004ce46c: entered by je at 0x004ce2d2, 3 instruction(s), ends with jne to 0x004ce4d0 (forward)
    mov eax, dword ptr [ebp - local_120]         # 004ce46c
    cmp dword ptr [eax + field_212], 0x0         # 004ce472
    jne.d8 L_004ce4d0                            # 004ce479
    # block 0x004ce47b: entered by fall-through of jne at 0x004ce479, 18 instruction(s), calls FUN_004c2a8d, falls into the block at 0x004ce4d0
    push 0x559920                                # 004ce47b
    push 0x8                                     # 004ce480
    mov ecx, dword ptr [ebp - local_120]         # 004ce482
    mov edx, dword ptr [ebp - local_120]         # 004ce488
    mov eax, dword ptr [ecx + field_1be]         # 004ce48e
    sub eax, dword ptr [edx + field_1b6]         # 004ce494
    add eax, 0x1                                 # 004ce49a
    push eax                                     # 004ce49d
    mov ecx, dword ptr [ebp - local_120]         # 004ce49e
    mov edx, dword ptr [ebp - local_120]         # 004ce4a4
    mov eax, dword ptr [ecx + field_1ba]         # 004ce4aa
    sub eax, dword ptr [edx + field_1b2]         # 004ce4b0
    add eax, 0x1                                 # 004ce4b6
    push eax                                     # 004ce4b9
    mov ecx, 0x5cf659                            # 004ce4ba
    call FUN_004c2a8d                            # 004ce4bf
    mov ecx, dword ptr [ebp - local_120]         # 004ce4c4
    mov dword ptr [ecx + field_212], eax         # 004ce4ca
L_004ce4d0:
    # block 0x004ce4d0: entered by jne at 0x004ce479, 8 instruction(s), calls FUN_004bef11, ends with je to 0x004ce53a (forward)
    push 0x0                                     # 004ce4d0
    mov edx, dword ptr [ebp - local_120]         # 004ce4d2
    mov eax, dword ptr [edx + field_18e]         # 004ce4d8
    push eax                                     # 004ce4de
    mov ecx, 0x6201f9                            # 004ce4df
    call FUN_004bef11                            # 004ce4e4
    test eax, eax                                # 004ce4e9
    je.d8 L_004ce53a                             # 004ce4eb
    # block 0x004ce4ed: entered by fall-through of je at 0x004ce4eb, 11 instruction(s), calls FUN_004bf3b8, FUN_0050ca3e, ends with je to 0x004ce524 (forward)
    push 0x0                                     # 004ce4ed
    mov ecx, 0x6201f9                            # 004ce4ef
    call FUN_004bf3b8                            # 004ce4f4
    push eax                                     # 004ce4f9
    push 0x559938                                # 004ce4fa
    push 0x63888b                                # 004ce4ff
    call FUN_0050ca3e                            # 004ce504
    add esp, 0xc                                 # 004ce509
    movsx ecx, word ptr [0x63a4cd]               # 004ce50c
    test ecx, ecx                                # 004ce513
    je.d8 L_004ce524                             # 004ce515
    # block 0x004ce517: entered by fall-through of je at 0x004ce515, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ce524
    push 0x63888b                                # 004ce517
    call FUN_0044a2b7                            # 004ce51c
    add esp, 0x4                                 # 004ce521
L_004ce524:
    # block 0x004ce524: entered by je at 0x004ce515, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ce5f0
    push 0x63888b                                # 004ce524
    mov ecx, 0x583979                            # 004ce529
    call FUN_004264e8                            # 004ce52e
    {load} xor eax, eax                          # 004ce533
    jmp.d32 L_004ce5f0                           # 004ce535
L_004ce53a:
    # block 0x004ce53a: entered by je at 0x004ce4eb, 11 instruction(s), calls FUN_004bf19a, ends with jne to 0x004ce5a5 (forward)
    mov edx, dword ptr [ebp - local_10]          # 004ce53a
    movsx eax, word ptr [edx + field_21]         # 004ce53d
    add eax, 0x1                                 # 004ce541
    push eax                                     # 004ce544
    mov ecx, dword ptr [ebp - local_120]         # 004ce545
    mov edx, dword ptr [ecx + field_18e]         # 004ce54b
    push edx                                     # 004ce551
    mov ecx, 0x6201f9                            # 004ce552
    call FUN_004bf19a                            # 004ce557
    test eax, eax                                # 004ce55c
    jne.d8 L_004ce5a5                            # 004ce55e
    # block 0x004ce560: entered by fall-through of jne at 0x004ce55e, 10 instruction(s), calls FUN_0050ca3e, ends with je to 0x004ce592 (forward)
    mov eax, dword ptr [ebp - local_10]          # 004ce560
    movsx ecx, word ptr [eax + field_21]         # 004ce563
    push ecx                                     # 004ce567
    push 0x559958                                # 004ce568
    push 0x63888b                                # 004ce56d
    call FUN_0050ca3e                            # 004ce572
    add esp, 0xc                                 # 004ce577
    movsx edx, word ptr [0x63a4cd]               # 004ce57a
    test edx, edx                                # 004ce581
    je.d8 L_004ce592                             # 004ce583
    # block 0x004ce585: entered by fall-through of je at 0x004ce583, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ce592
    push 0x63888b                                # 004ce585
    call FUN_0044a2b7                            # 004ce58a
    add esp, 0x4                                 # 004ce58f
L_004ce592:
    # block 0x004ce592: entered by je at 0x004ce583, 5 instruction(s), calls FUN_004264e8, ends with forward jump to 0x004ce5f0
    push 0x63888b                                # 004ce592
    mov ecx, 0x583979                            # 004ce597
    call FUN_004264e8                            # 004ce59c
    {load} xor eax, eax                          # 004ce5a1
    jmp.d8 L_004ce5f0                            # 004ce5a3
L_004ce5a5:
    # block 0x004ce5a5: entered by jne at 0x004ce55e, 1 instruction(s), ends with forward jump to 0x004ce5ab
    jmp.d8 L_004ce5ab                            # 004ce5a5
L_004ce5a7:
    # block 0x004ce5a7: entered by jmp at 0x004ce2d8, 2 instruction(s), ends with forward jump to 0x004ce5f0
    {load} xor eax, eax                          # 004ce5a7
    jmp.d8 L_004ce5f0                            # 004ce5a9
L_004ce5ab:
    # block 0x004ce5ab: entered by jmp at 0x004ce467; jmp at 0x004ce5a5, 9 instruction(s), falls into the block at 0x004ce5f0
    mov eax, dword ptr [ebp - local_120]         # 004ce5ab
    mov dword ptr [eax + field_1da], 0x0         # 004ce5b1
    mov ecx, dword ptr [ebp - local_120]         # 004ce5bb
    mov dword ptr [ecx + field_20a], 0x0         # 004ce5c1
    mov edx, dword ptr [ebp - local_120]         # 004ce5cb
    mov dword ptr [edx + field_20e], 0x0         # 004ce5d1
    mov eax, dword ptr [ebp - local_120]         # 004ce5db
    mov dword ptr [eax + field_232], 0xffffffff  # 004ce5e1
    mov eax, 0x1                                 # 004ce5eb
L_004ce5f0:
    # block 0x004ce5f0: entered by jmp at 0x004ce019; jmp at 0x004ce181; jmp at 0x004ce2ab; jmp at 0x004ce42e; more, 7 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [ebp - local_c]           # 004ce5f0
    mov dword ptr fs:[0x0], ecx                  # 004ce5f3
    pop edi                                      # 004ce5fa
    pop esi                                      # 004ce5fb
    {load} mov esp, ebp                          # 004ce5fc
    pop ebp                                      # 004ce5fe
    ret 0x4                                      # 004ce5ff

