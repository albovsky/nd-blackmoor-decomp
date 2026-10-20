# FUN_0047c0f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047c0f0
# extent:       0x0047c0f0-0x0047cd7c (3212 code bytes)
# span:         0x0047c0f0-0x0047cd90 (code 3212, tables 20, padding 0)
# sha256:       e221b87b9366b237a561f910584da9662d34a21f94bc8a194800e317ca8d22f9
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_memory_puzzle_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ee_runtime.h:19 says "0x47c0f0 the handler: a switch on the row phase dword"
# name-note:    Handler of the raw 0xee Memory puzzle: a switch on the row phase dword.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_4, field_6, field_8, field_c, field_10, field_28, field_2c, field_40, field_119, field_1c0, field_1cc, field_26c and 16 more; [ecx + n] field_4, field_6, field_8, field_c, field_10, field_24, field_2c, field_3c, field_48, field_115, field_1c4, field_1cc and 22 more; [edx + n] field_4, field_6, field_8, field_c, field_24, field_2c, field_30, field_44, field_111, field_11d, field_1bc, field_1c8 and 28 more
# callees:      calls FUN_004e8d96, FUN_004db870, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4, FUN_004d39f9, FUN_004c2790, FUN_0047bb56, FUN_0047ba79, FUN_0047cf4e, FUN_004f6334, FUN_0047ce6f, FUN_0042ba3a, FUN_0047b321
# track-n:      outputs/blackmoor-decomp/src/action_family_ee_runtime.h:mp_step (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 758 instruction(s), 37 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_111, 0x111  # offset +0x111
.equ field_115, 0x115  # offset +0x115
.equ field_119, 0x119  # offset +0x119
.equ field_11d, 0x11d  # offset +0x11d
.equ field_1bc, 0x1bc  # offset +0x1bc
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_1c8, 0x1c8  # offset +0x1c8
.equ field_1cc, 0x1cc  # offset +0x1cc
.equ field_26c, 0x26c  # offset +0x26c
.equ field_270, 0x270  # offset +0x270
.equ field_280, 0x280  # offset +0x280
.equ field_284, 0x284  # offset +0x284
.equ field_291, 0x291  # offset +0x291
.equ field_295, 0x295  # offset +0x295
.equ field_298, 0x298  # offset +0x298
.equ field_299, 0x299  # offset +0x299
.equ field_29c, 0x29c  # offset +0x29c
.equ field_29d, 0x29d  # offset +0x29d
.equ field_2a1, 0x2a1  # offset +0x2a1
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2b0, 0x2b0  # offset +0x2b0
.equ field_2bc, 0x2bc  # offset +0x2bc
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_345, 0x345  # offset +0x345
.equ field_347, 0x347  # offset +0x347
.equ field_34b, 0x34b  # offset +0x34b
.equ field_34f, 0x34f  # offset +0x34f
.equ field_353, 0x353  # offset +0x353
.equ field_357, 0x357  # offset +0x357
.equ field_35b, 0x35b  # offset +0x35b
.equ field_856, 0x856  # offset +0x856
.equ field_877, 0x877  # offset +0x877
.equ field_f72, 0xf72  # offset +0xf72
.equ field_f93, 0xf93  # offset +0xf93
.equ field_168e, 0x168e  # offset +0x168e
.equ field_1690, 0x1690  # offset +0x1690
.equ field_1692, 0x1692  # offset +0x1692
.equ field_1694, 0x1694  # offset +0x1694
.equ field_1696, 0x1696  # offset +0x1696
.equ field_169a, 0x169a  # offset +0x169a
.equ field_169e, 0x169e  # offset +0x169e
.equ field_16a2, 0x16a2  # offset +0x16a2
.equ field_16a4, 0x16a4  # offset +0x16a4
.equ field_16a6, 0x16a6  # offset +0x16a6
.equ field_16a8, 0x16a8  # offset +0x16a8
.equ field_16aa, 0x16aa  # offset +0x16aa
.equ field_16ac, 0x16ac  # offset +0x16ac
.equ field_16ae, 0x16ae  # offset +0x16ae
.equ field_16b0, 0x16b0  # offset +0x16b0
.equ field_16b4, 0x16b4  # offset +0x16b4
.equ field_16b8, 0x16b8  # offset +0x16b8
.equ field_16bc, 0x16bc  # offset +0x16bc
.equ field_16be, 0x16be  # offset +0x16be
.equ field_16c0, 0x16c0  # offset +0x16c0

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0042ba3a, .text + (0x0042ba3a - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0047b321, .text + (0x0047b321 - 0x401000)
.set FUN_0047ba79, .text + (0x0047ba79 - 0x401000)
.set FUN_0047bb56, .text + (0x0047bb56 - 0x401000)
.set FUN_0047ce6f, .text + (0x0047ce6f - 0x401000)
.set FUN_0047cf4e, .text + (0x0047cf4e - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004d39f9, .text + (0x004d39f9 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004e8d96, .text + (0x004e8d96 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x0047c0f0 - 0x401000
.globl FUN_0047c0f0
FUN_0047c0f0:
    # block 0x0047c0f0: entry, 17 instruction(s), ends with je to 0x0047c143 (forward)
    push ebp                                     # 0047c0f0
    {load} mov ebp, esp                          # 0047c0f1
    sub esp, 0x14                                # 0047c0f3
    push esi                                     # 0047c0f6
    push edi                                     # 0047c0f7
    mov dword ptr [ebp - local_c], ecx           # 0047c0f8
    movsx eax, word ptr [ebp + arg_8]            # 0047c0fb
    imul eax, eax, 0x8d                          # 0047c0ff
    mov ecx, dword ptr [ebp - local_c]           # 0047c105
    mov edx, dword ptr [eax + 0x5bb5e5]          # 0047c108
    mov dword ptr [ecx + field_c], edx           # 0047c10e
    movsx eax, word ptr [ebp + arg_8]            # 0047c111
    imul eax, eax, 0x8d                          # 0047c115
    mov ecx, dword ptr [eax + 0x5bb632]          # 0047c11b
    mov dword ptr [ebp - local_10], ecx          # 0047c121
    cmp dword ptr [ebp - local_10], 0x0          # 0047c124
    je.d8 L_0047c143                             # 0047c128
    # block 0x0047c12a: entered by fall-through of je at 0x0047c128, 2 instruction(s), ends with je to 0x0047c936 (forward)
    cmp dword ptr [ebp - local_10], 0x1          # 0047c12a
    je.d32 L_0047c936                            # 0047c12e
    # block 0x0047c134: entered by fall-through of je at 0x0047c12e, 2 instruction(s), ends with je to 0x0047cb35 (forward)
    cmp dword ptr [ebp - local_10], 0x2          # 0047c134
    je.d32 L_0047cb35                            # 0047c138
    # block 0x0047c13e: entered by fall-through of je at 0x0047c138, 1 instruction(s), ends with forward jump to 0x0047cd74
    jmp.d32 L_0047cd74                           # 0047c13e
L_0047c143:
    # block 0x0047c143: entered by je at 0x0047c128, 13 instruction(s), calls FUN_004e8d96, ends with je to 0x0047c187 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c143
    mov ax, word ptr [ebp + arg_8]               # 0047c146
    mov word ptr [edx + field_6], ax             # 0047c14a
    mov ecx, dword ptr [ebp - local_c]           # 0047c14e
    mov dword ptr [ecx + field_24], 0x1          # 0047c151
    mov dword ptr [0x5bb1ca], 0x1                # 0047c158
    mov ecx, 0x571442                            # 0047c162
    call FUN_004e8d96                            # 0047c167
    mov edx, dword ptr [ebp - local_c]           # 0047c16c
    mov eax, dword ptr [edx + field_c]           # 0047c16f
    movsx ecx, byte ptr [eax + field_345]        # 0047c172
    test ecx, ecx                                # 0047c179
    je.d8 L_0047c187                             # 0047c17b
    # block 0x0047c17d: entered by fall-through of je at 0x0047c17b, 2 instruction(s), calls FUN_004db870, falls into the block at 0x0047c187
    mov ecx, 0x5830ce                            # 0047c17d
    call FUN_004db870                            # 0047c182
L_0047c187:
    # block 0x0047c187: entered by je at 0x0047c17b, 4 instruction(s), ends with jle to 0x0047c1eb (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c187
    mov eax, dword ptr [edx + field_c]           # 0047c18a
    cmp dword ptr [eax + field_347], 0x3         # 0047c18d
    jle.d8 L_0047c1eb                            # 0047c194
    # block 0x0047c196: entered by fall-through of jle at 0x0047c194, 14 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0047c1dc (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c196
    mov edx, dword ptr [ecx + field_c]           # 0047c199
    mov eax, dword ptr [edx + field_347]         # 0047c19c
    push eax                                     # 0047c1a2
    push 0x54cec4                                # 0047c1a3
    push 0x63888b                                # 0047c1a8
    call FUN_0050ca3e                            # 0047c1ad
    add esp, 0xc                                 # 0047c1b2
    push 0x63888b                                # 0047c1b5
    mov ecx, 0x583979                            # 0047c1ba
    call FUN_004264e8                            # 0047c1bf
    movsx ecx, word ptr [0x63a4cd]               # 0047c1c4
    test ecx, ecx                                # 0047c1cb
    je.d8 L_0047c1dc                             # 0047c1cd
    # block 0x0047c1cf: entered by fall-through of je at 0x0047c1cd, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047c1dc
    push 0x63888b                                # 0047c1cf
    call FUN_0044a2b7                            # 0047c1d4
    add esp, 0x4                                 # 0047c1d9
L_0047c1dc:
    # block 0x0047c1dc: entered by je at 0x0047c1cd, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0047cd74
    mov ecx, 0x5cf659                            # 0047c1dc
    call FUN_004c97b4                            # 0047c1e1
    jmp.d32 L_0047cd74                           # 0047c1e6
L_0047c1eb:
    # block 0x0047c1eb: entered by jle at 0x0047c194, 4 instruction(s), ends with jle to 0x0047c24f (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c1eb
    mov eax, dword ptr [edx + field_c]           # 0047c1ee
    cmp dword ptr [eax + field_34b], 0x6         # 0047c1f1
    jle.d8 L_0047c24f                            # 0047c1f8
    # block 0x0047c1fa: entered by fall-through of jle at 0x0047c1f8, 14 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0047c240 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c1fa
    mov edx, dword ptr [ecx + field_c]           # 0047c1fd
    mov eax, dword ptr [edx + field_34b]         # 0047c200
    push eax                                     # 0047c206
    push 0x54cf14                                # 0047c207
    push 0x63888b                                # 0047c20c
    call FUN_0050ca3e                            # 0047c211
    add esp, 0xc                                 # 0047c216
    push 0x63888b                                # 0047c219
    mov ecx, 0x583979                            # 0047c21e
    call FUN_004264e8                            # 0047c223
    movsx ecx, word ptr [0x63a4cd]               # 0047c228
    test ecx, ecx                                # 0047c22f
    je.d8 L_0047c240                             # 0047c231
    # block 0x0047c233: entered by fall-through of je at 0x0047c231, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047c240
    push 0x63888b                                # 0047c233
    call FUN_0044a2b7                            # 0047c238
    add esp, 0x4                                 # 0047c23d
L_0047c240:
    # block 0x0047c240: entered by je at 0x0047c231, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0047cd74
    mov ecx, 0x5cf659                            # 0047c240
    call FUN_004c97b4                            # 0047c245
    jmp.d32 L_0047cd74                           # 0047c24a
L_0047c24f:
    # block 0x0047c24f: entered by jle at 0x0047c1f8, 4 instruction(s), ends with jle to 0x0047c2b3 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c24f
    mov eax, dword ptr [edx + field_c]           # 0047c252
    cmp dword ptr [eax + field_34f], 0x4         # 0047c255
    jle.d8 L_0047c2b3                            # 0047c25c
    # block 0x0047c25e: entered by fall-through of jle at 0x0047c25c, 14 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0047c2a4 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c25e
    mov edx, dword ptr [ecx + field_c]           # 0047c261
    mov eax, dword ptr [edx + field_34f]         # 0047c264
    push eax                                     # 0047c26a
    push 0x54cf74                                # 0047c26b
    push 0x63888b                                # 0047c270
    call FUN_0050ca3e                            # 0047c275
    add esp, 0xc                                 # 0047c27a
    push 0x63888b                                # 0047c27d
    mov ecx, 0x583979                            # 0047c282
    call FUN_004264e8                            # 0047c287
    movsx ecx, word ptr [0x63a4cd]               # 0047c28c
    test ecx, ecx                                # 0047c293
    je.d8 L_0047c2a4                             # 0047c295
    # block 0x0047c297: entered by fall-through of je at 0x0047c295, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047c2a4
    push 0x63888b                                # 0047c297
    call FUN_0044a2b7                            # 0047c29c
    add esp, 0x4                                 # 0047c2a1
L_0047c2a4:
    # block 0x0047c2a4: entered by je at 0x0047c295, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0047cd74
    mov ecx, 0x5cf659                            # 0047c2a4
    call FUN_004c97b4                            # 0047c2a9
    jmp.d32 L_0047cd74                           # 0047c2ae
L_0047c2b3:
    # block 0x0047c2b3: entered by jle at 0x0047c25c, 4 instruction(s), ends with jle to 0x0047c317 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c2b3
    mov eax, dword ptr [edx + field_c]           # 0047c2b6
    cmp dword ptr [eax + field_353], 0x6         # 0047c2b9
    jle.d8 L_0047c317                            # 0047c2c0
    # block 0x0047c2c2: entered by fall-through of jle at 0x0047c2c0, 14 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0047c308 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c2c2
    mov edx, dword ptr [ecx + field_c]           # 0047c2c5
    mov eax, dword ptr [edx + field_353]         # 0047c2c8
    push eax                                     # 0047c2ce
    push 0x54cfd4                                # 0047c2cf
    push 0x63888b                                # 0047c2d4
    call FUN_0050ca3e                            # 0047c2d9
    add esp, 0xc                                 # 0047c2de
    push 0x63888b                                # 0047c2e1
    mov ecx, 0x583979                            # 0047c2e6
    call FUN_004264e8                            # 0047c2eb
    movsx ecx, word ptr [0x63a4cd]               # 0047c2f0
    test ecx, ecx                                # 0047c2f7
    je.d8 L_0047c308                             # 0047c2f9
    # block 0x0047c2fb: entered by fall-through of je at 0x0047c2f9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047c308
    push 0x63888b                                # 0047c2fb
    call FUN_0044a2b7                            # 0047c300
    add esp, 0x4                                 # 0047c305
L_0047c308:
    # block 0x0047c308: entered by je at 0x0047c2f9, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0047cd74
    mov ecx, 0x5cf659                            # 0047c308
    call FUN_004c97b4                            # 0047c30d
    jmp.d32 L_0047cd74                           # 0047c312
L_0047c317:
    # block 0x0047c317: entered by jle at 0x0047c2c0, 4 instruction(s), ends with jle to 0x0047c37b (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c317
    mov eax, dword ptr [edx + field_c]           # 0047c31a
    cmp dword ptr [eax + field_357], 0x2         # 0047c31d
    jle.d8 L_0047c37b                            # 0047c324
    # block 0x0047c326: entered by fall-through of jle at 0x0047c324, 14 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0047c36c (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c326
    mov edx, dword ptr [ecx + field_c]           # 0047c329
    mov eax, dword ptr [edx + field_357]         # 0047c32c
    push eax                                     # 0047c332
    push 0x54d038                                # 0047c333
    push 0x63888b                                # 0047c338
    call FUN_0050ca3e                            # 0047c33d
    add esp, 0xc                                 # 0047c342
    push 0x63888b                                # 0047c345
    mov ecx, 0x583979                            # 0047c34a
    call FUN_004264e8                            # 0047c34f
    movsx ecx, word ptr [0x63a4cd]               # 0047c354
    test ecx, ecx                                # 0047c35b
    je.d8 L_0047c36c                             # 0047c35d
    # block 0x0047c35f: entered by fall-through of je at 0x0047c35d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047c36c
    push 0x63888b                                # 0047c35f
    call FUN_0044a2b7                            # 0047c364
    add esp, 0x4                                 # 0047c369
L_0047c36c:
    # block 0x0047c36c: entered by je at 0x0047c35d, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0047cd74
    mov ecx, 0x5cf659                            # 0047c36c
    call FUN_004c97b4                            # 0047c371
    jmp.d32 L_0047cd74                           # 0047c376
L_0047c37b:
    # block 0x0047c37b: entered by jle at 0x0047c324, 54 instruction(s), ends with forward jump to 0x0047c45f
    mov edx, dword ptr [ebp - local_c]           # 0047c37b
    mov eax, dword ptr [edx + field_c]           # 0047c37e
    mov ecx, dword ptr [ebp - local_c]           # 0047c381
    mov edx, dword ptr [ecx + field_c]           # 0047c384
    mov eax, dword ptr [eax + field_34b]         # 0047c387
    imul eax, dword ptr [edx + field_34f]        # 0047c38d
    mov ecx, dword ptr [ebp - local_c]           # 0047c394
    mov dword ptr [ecx + field_280], eax         # 0047c397
    mov edx, dword ptr [ebp - local_c]           # 0047c39d
    mov eax, dword ptr [edx + field_c]           # 0047c3a0
    mov ecx, dword ptr [ebp - local_c]           # 0047c3a3
    mov edx, dword ptr [ecx + field_280]         # 0047c3a6
    imul edx, dword ptr [eax + field_347]        # 0047c3ac
    mov eax, dword ptr [ebp - local_c]           # 0047c3b3
    mov dword ptr [eax + field_284], edx         # 0047c3b6
    mov ecx, dword ptr [ebp - local_c]           # 0047c3bc
    mov eax, dword ptr [ecx + field_280]         # 0047c3bf
    cdq                                          # 0047c3c5
    {load} sub eax, edx                          # 0047c3c6
    sar eax                                      # 0047c3c8
    mov edx, dword ptr [ebp - local_c]           # 0047c3ca
    mov dword ptr [edx + field_29c], eax         # 0047c3cd
    mov eax, dword ptr [ebp - local_c]           # 0047c3d3
    mov eax, dword ptr [eax + field_284]         # 0047c3d6
    cdq                                          # 0047c3dc
    {load} sub eax, edx                          # 0047c3dd
    sar eax                                      # 0047c3df
    mov ecx, dword ptr [ebp - local_c]           # 0047c3e1
    mov dword ptr [ecx + field_298], eax         # 0047c3e4
    mov edx, dword ptr [ebp - local_c]           # 0047c3ea
    add edx, 0x26c                               # 0047c3ed
    mov eax, dword ptr [0x583186]                # 0047c3f3
    mov dword ptr [edx], eax                     # 0047c3f8
    mov ecx, dword ptr [0x58318a]                # 0047c3fa
    mov dword ptr [edx + field_4], ecx           # 0047c400
    mov eax, dword ptr [0x58318e]                # 0047c403
    mov dword ptr [edx + field_8], eax           # 0047c408
    mov ecx, dword ptr [0x583192]                # 0047c40b
    mov dword ptr [edx + field_c], ecx           # 0047c411
    mov edx, dword ptr [ebp - local_c]           # 0047c414
    add edx, 0x26c                               # 0047c417
    mov eax, dword ptr [ebp - local_c]           # 0047c41d
    add eax, 0x25c                               # 0047c420
    mov ecx, dword ptr [edx]                     # 0047c425
    mov dword ptr [eax], ecx                     # 0047c427
    mov ecx, dword ptr [edx + field_4]           # 0047c429
    mov dword ptr [eax + field_4], ecx           # 0047c42c
    mov ecx, dword ptr [edx + field_8]           # 0047c42f
    mov dword ptr [eax + field_8], ecx           # 0047c432
    mov edx, dword ptr [edx + field_c]           # 0047c435
    mov dword ptr [eax + field_c], edx           # 0047c438
    mov eax, dword ptr [ebp - local_c]           # 0047c43b
    mov dword ptr [eax + field_2ac], 0x0         # 0047c43e
    jmp.d8 L_0047c45f                            # 0047c448
L_0047c44a:
    # block 0x0047c44a: entered by jmp at 0x0047c54b, 5 instruction(s), falls into the block at 0x0047c45f
    mov ecx, dword ptr [ebp - local_c]           # 0047c44a
    mov edx, dword ptr [ecx + field_2ac]         # 0047c44d
    add edx, 0x1                                 # 0047c453
    mov eax, dword ptr [ebp - local_c]           # 0047c456
    mov dword ptr [eax + field_2ac], edx         # 0047c459
L_0047c45f:
    # block 0x0047c45f: entered by jmp at 0x0047c448, 5 instruction(s), ends with jge to 0x0047c550 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c45f
    mov edx, dword ptr [ebp - local_c]           # 0047c462
    mov eax, dword ptr [ecx + field_2ac]         # 0047c465
    cmp eax, dword ptr [edx + field_280]         # 0047c46b
    jge.d32 L_0047c550                           # 0047c471
    # block 0x0047c477: entered by fall-through of jge at 0x0047c471, 53 instruction(s), ends with backward jump to 0x0047c44a
    mov ecx, dword ptr [ebp - local_c]           # 0047c477
    mov edx, dword ptr [ecx + field_c]           # 0047c47a
    mov eax, dword ptr [ebp - local_c]           # 0047c47d
    mov ecx, dword ptr [eax + field_2ac]         # 0047c480
    shl ecx, 0x4                                 # 0047c486
    mov edx, dword ptr [edx + ecx + field_111]   # 0047c489
    mov eax, dword ptr [ebp - local_c]           # 0047c490
    add edx, dword ptr [eax + field_26c]         # 0047c493
    mov ecx, dword ptr [ebp - local_c]           # 0047c499
    mov eax, dword ptr [ecx + field_2ac]         # 0047c49c
    shl eax, 0x4                                 # 0047c4a2
    mov ecx, dword ptr [ebp - local_c]           # 0047c4a5
    mov dword ptr [ecx + eax + field_3c], edx    # 0047c4a8
    mov edx, dword ptr [ebp - local_c]           # 0047c4ac
    mov eax, dword ptr [edx + field_c]           # 0047c4af
    mov ecx, dword ptr [ebp - local_c]           # 0047c4b2
    mov edx, dword ptr [ecx + field_2ac]         # 0047c4b5
    shl edx, 0x4                                 # 0047c4bb
    mov eax, dword ptr [eax + edx + field_119]   # 0047c4be
    mov ecx, dword ptr [ebp - local_c]           # 0047c4c5
    add eax, dword ptr [ecx + field_26c]         # 0047c4c8
    mov edx, dword ptr [ebp - local_c]           # 0047c4ce
    mov ecx, dword ptr [edx + field_2ac]         # 0047c4d1
    shl ecx, 0x4                                 # 0047c4d7
    mov edx, dword ptr [ebp - local_c]           # 0047c4da
    mov dword ptr [edx + ecx + field_44], eax    # 0047c4dd
    mov eax, dword ptr [ebp - local_c]           # 0047c4e1
    mov ecx, dword ptr [eax + field_c]           # 0047c4e4
    mov edx, dword ptr [ebp - local_c]           # 0047c4e7
    mov eax, dword ptr [edx + field_2ac]         # 0047c4ea
    shl eax, 0x4                                 # 0047c4f0
    mov ecx, dword ptr [ecx + eax + field_115]   # 0047c4f3
    mov edx, dword ptr [ebp - local_c]           # 0047c4fa
    add ecx, dword ptr [edx + field_270]         # 0047c4fd
    mov eax, dword ptr [ebp - local_c]           # 0047c503
    mov edx, dword ptr [eax + field_2ac]         # 0047c506
    shl edx, 0x4                                 # 0047c50c
    mov eax, dword ptr [ebp - local_c]           # 0047c50f
    mov dword ptr [eax + edx + field_40], ecx    # 0047c512
    mov ecx, dword ptr [ebp - local_c]           # 0047c516
    mov edx, dword ptr [ecx + field_c]           # 0047c519
    mov eax, dword ptr [ebp - local_c]           # 0047c51c
    mov ecx, dword ptr [eax + field_2ac]         # 0047c51f
    shl ecx, 0x4                                 # 0047c525
    mov edx, dword ptr [edx + ecx + field_11d]   # 0047c528
    mov eax, dword ptr [ebp - local_c]           # 0047c52f
    add edx, dword ptr [eax + field_270]         # 0047c532
    mov ecx, dword ptr [ebp - local_c]           # 0047c538
    mov eax, dword ptr [ecx + field_2ac]         # 0047c53b
    shl eax, 0x4                                 # 0047c541
    mov ecx, dword ptr [ebp - local_c]           # 0047c544
    mov dword ptr [ecx + eax + field_48], edx    # 0047c547
    jmp.d32 L_0047c44a                           # 0047c54b
L_0047c550:
    # block 0x0047c550: entered by jge at 0x0047c471, 5 instruction(s), ends with je to 0x0047c7c9 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c550
    mov eax, dword ptr [edx + field_c]           # 0047c553
    movsx ecx, byte ptr [eax + field_35b]        # 0047c556
    test ecx, ecx                                # 0047c55d
    je.d32 L_0047c7c9                            # 0047c55f
    # block 0x0047c565: entered by fall-through of je at 0x0047c55f, 3 instruction(s), ends with forward jump to 0x0047c589
    mov edx, dword ptr [ebp - local_c]           # 0047c565
    mov dword ptr [edx + field_2ac], 0x0         # 0047c568
    jmp.d8 L_0047c589                            # 0047c572
L_0047c574:
    # block 0x0047c574: entered by jmp at 0x0047c73b, 5 instruction(s), falls into the block at 0x0047c589
    mov eax, dword ptr [ebp - local_c]           # 0047c574
    mov ecx, dword ptr [eax + field_2ac]         # 0047c577
    add ecx, 0x1                                 # 0047c57d
    mov edx, dword ptr [ebp - local_c]           # 0047c580
    mov dword ptr [edx + field_2ac], ecx         # 0047c583
L_0047c589:
    # block 0x0047c589: entered by jmp at 0x0047c572, 6 instruction(s), ends with jge to 0x0047c740 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047c589
    mov ecx, dword ptr [eax + field_c]           # 0047c58c
    mov edx, dword ptr [ebp - local_c]           # 0047c58f
    mov eax, dword ptr [edx + field_2ac]         # 0047c592
    cmp eax, dword ptr [ecx + field_347]         # 0047c598
    jge.d32 L_0047c740                           # 0047c59e
    # block 0x0047c5a4: entered by fall-through of jge at 0x0047c59e, 3 instruction(s), ends with forward jump to 0x0047c5c8
    mov ecx, dword ptr [ebp - local_c]           # 0047c5a4
    mov dword ptr [ecx + field_2b0], 0x0         # 0047c5a7
    jmp.d8 L_0047c5c8                            # 0047c5b1
L_0047c5b3:
    # block 0x0047c5b3: entered by jmp at 0x0047c736, 5 instruction(s), falls into the block at 0x0047c5c8
    mov edx, dword ptr [ebp - local_c]           # 0047c5b3
    mov eax, dword ptr [edx + field_2b0]         # 0047c5b6
    add eax, 0x1                                 # 0047c5bc
    mov ecx, dword ptr [ebp - local_c]           # 0047c5bf
    mov dword ptr [ecx + field_2b0], eax         # 0047c5c2
L_0047c5c8:
    # block 0x0047c5c8: entered by jmp at 0x0047c5b1, 3 instruction(s), ends with jge to 0x0047c73b (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047c5c8
    cmp dword ptr [edx + field_2b0], 0x3         # 0047c5cb
    jge.d32 L_0047c73b                           # 0047c5d2
    # block 0x0047c5d8: entered by fall-through of jge at 0x0047c5d2, 85 instruction(s), ends with backward jump to 0x0047c5b3
    mov eax, dword ptr [ebp - local_c]           # 0047c5d8
    mov ecx, dword ptr [eax + field_c]           # 0047c5db
    mov edx, dword ptr [ebp - local_c]           # 0047c5de
    mov eax, dword ptr [edx + field_2ac]         # 0047c5e1
    imul eax, eax, 0x30                          # 0047c5e7
    lea ecx, [ecx + eax + field_2a1]             # 0047c5ea
    mov edx, dword ptr [ebp - local_c]           # 0047c5f1
    mov eax, dword ptr [edx + field_2b0]         # 0047c5f4
    shl eax, 0x4                                 # 0047c5fa
    mov ecx, dword ptr [ecx + eax]               # 0047c5fd
    mov edx, dword ptr [ebp - local_c]           # 0047c600
    add ecx, dword ptr [edx + field_26c]         # 0047c603
    mov eax, dword ptr [ebp - local_c]           # 0047c609
    mov edx, dword ptr [eax + field_2ac]         # 0047c60c
    imul edx, edx, 0x30                          # 0047c612
    mov eax, dword ptr [ebp - local_c]           # 0047c615
    lea edx, [eax + edx + field_1cc]             # 0047c618
    mov eax, dword ptr [ebp - local_c]           # 0047c61f
    mov eax, dword ptr [eax + field_2b0]         # 0047c622
    shl eax, 0x4                                 # 0047c628
    mov dword ptr [edx + eax], ecx               # 0047c62b
    mov ecx, dword ptr [ebp - local_c]           # 0047c62e
    mov edx, dword ptr [ecx + field_c]           # 0047c631
    mov eax, dword ptr [ebp - local_c]           # 0047c634
    mov ecx, dword ptr [eax + field_2ac]         # 0047c637
    imul ecx, ecx, 0x30                          # 0047c63d
    lea edx, [edx + ecx + field_2a1]             # 0047c640
    mov eax, dword ptr [ebp - local_c]           # 0047c647
    mov ecx, dword ptr [eax + field_2b0]         # 0047c64a
    shl ecx, 0x4                                 # 0047c650
    mov edx, dword ptr [edx + ecx + field_8]     # 0047c653
    mov eax, dword ptr [ebp - local_c]           # 0047c657
    add edx, dword ptr [eax + field_26c]         # 0047c65a
    mov ecx, dword ptr [ebp - local_c]           # 0047c660
    mov eax, dword ptr [ecx + field_2ac]         # 0047c663
    imul eax, eax, 0x30                          # 0047c669
    mov ecx, dword ptr [ebp - local_c]           # 0047c66c
    lea eax, [ecx + eax + field_1cc]             # 0047c66f
    mov ecx, dword ptr [ebp - local_c]           # 0047c676
    mov ecx, dword ptr [ecx + field_2b0]         # 0047c679
    shl ecx, 0x4                                 # 0047c67f
    mov dword ptr [eax + ecx + field_8], edx     # 0047c682
    mov edx, dword ptr [ebp - local_c]           # 0047c686
    mov eax, dword ptr [edx + field_c]           # 0047c689
    mov ecx, dword ptr [ebp - local_c]           # 0047c68c
    mov edx, dword ptr [ecx + field_2ac]         # 0047c68f
    imul edx, edx, 0x30                          # 0047c695
    lea eax, [eax + edx + field_2a1]             # 0047c698
    mov ecx, dword ptr [ebp - local_c]           # 0047c69f
    mov edx, dword ptr [ecx + field_2b0]         # 0047c6a2
    shl edx, 0x4                                 # 0047c6a8
    mov eax, dword ptr [eax + edx + field_4]     # 0047c6ab
    mov ecx, dword ptr [ebp - local_c]           # 0047c6af
    add eax, dword ptr [ecx + field_270]         # 0047c6b2
    mov edx, dword ptr [ebp - local_c]           # 0047c6b8
    mov ecx, dword ptr [edx + field_2ac]         # 0047c6bb
    imul ecx, ecx, 0x30                          # 0047c6c1
    mov edx, dword ptr [ebp - local_c]           # 0047c6c4
    lea ecx, [edx + ecx + field_1cc]             # 0047c6c7
    mov edx, dword ptr [ebp - local_c]           # 0047c6ce
    mov edx, dword ptr [edx + field_2b0]         # 0047c6d1
    shl edx, 0x4                                 # 0047c6d7
    mov dword ptr [ecx + edx + field_4], eax     # 0047c6da
    mov eax, dword ptr [ebp - local_c]           # 0047c6de
    mov ecx, dword ptr [eax + field_c]           # 0047c6e1
    mov edx, dword ptr [ebp - local_c]           # 0047c6e4
    mov eax, dword ptr [edx + field_2ac]         # 0047c6e7
    imul eax, eax, 0x30                          # 0047c6ed
    lea ecx, [ecx + eax + field_2a1]             # 0047c6f0
    mov edx, dword ptr [ebp - local_c]           # 0047c6f7
    mov eax, dword ptr [edx + field_2b0]         # 0047c6fa
    shl eax, 0x4                                 # 0047c700
    mov ecx, dword ptr [ecx + eax + field_c]     # 0047c703
    mov edx, dword ptr [ebp - local_c]           # 0047c707
    add ecx, dword ptr [edx + field_270]         # 0047c70a
    mov eax, dword ptr [ebp - local_c]           # 0047c710
    mov edx, dword ptr [eax + field_2ac]         # 0047c713
    imul edx, edx, 0x30                          # 0047c719
    mov eax, dword ptr [ebp - local_c]           # 0047c71c
    lea edx, [eax + edx + field_1cc]             # 0047c71f
    mov eax, dword ptr [ebp - local_c]           # 0047c726
    mov eax, dword ptr [eax + field_2b0]         # 0047c729
    shl eax, 0x4                                 # 0047c72f
    mov dword ptr [edx + eax + field_c], ecx     # 0047c732
    jmp.d32 L_0047c5b3                           # 0047c736
L_0047c73b:
    # block 0x0047c73b: entered by jge at 0x0047c5d2, 1 instruction(s), ends with backward jump to 0x0047c574
    jmp.d32 L_0047c574                           # 0047c73b
L_0047c740:
    # block 0x0047c740: entered by jge at 0x0047c59e, 5 instruction(s), ends with je to 0x0047c7c9 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c740
    mov edx, dword ptr [ecx + field_c]           # 0047c743
    movsx eax, byte ptr [edx + field_35b]        # 0047c746
    test eax, eax                                # 0047c74d
    je.d8 L_0047c7c9                             # 0047c74f
    # block 0x0047c751: entered by fall-through of je at 0x0047c74f, 28 instruction(s), falls into the block at 0x0047c7c9
    mov ecx, dword ptr [ebp - local_c]           # 0047c751
    mov edx, dword ptr [ecx + field_c]           # 0047c754
    mov eax, dword ptr [edx + field_291]         # 0047c757
    mov ecx, dword ptr [ebp - local_c]           # 0047c75d
    add eax, dword ptr [ecx + field_26c]         # 0047c760
    mov edx, dword ptr [ebp - local_c]           # 0047c766
    mov dword ptr [edx + field_1bc], eax         # 0047c769
    mov eax, dword ptr [ebp - local_c]           # 0047c76f
    mov ecx, dword ptr [eax + field_c]           # 0047c772
    mov edx, dword ptr [ecx + field_299]         # 0047c775
    mov eax, dword ptr [ebp - local_c]           # 0047c77b
    add edx, dword ptr [eax + field_26c]         # 0047c77e
    mov ecx, dword ptr [ebp - local_c]           # 0047c784
    mov dword ptr [ecx + field_1c4], edx         # 0047c787
    mov edx, dword ptr [ebp - local_c]           # 0047c78d
    mov eax, dword ptr [edx + field_c]           # 0047c790
    mov ecx, dword ptr [eax + field_295]         # 0047c793
    mov edx, dword ptr [ebp - local_c]           # 0047c799
    add ecx, dword ptr [edx + field_270]         # 0047c79c
    mov eax, dword ptr [ebp - local_c]           # 0047c7a2
    mov dword ptr [eax + field_1c0], ecx         # 0047c7a5
    mov ecx, dword ptr [ebp - local_c]           # 0047c7ab
    mov edx, dword ptr [ecx + field_c]           # 0047c7ae
    mov eax, dword ptr [edx + field_29d]         # 0047c7b1
    mov ecx, dword ptr [ebp - local_c]           # 0047c7b7
    add eax, dword ptr [ecx + field_270]         # 0047c7ba
    mov edx, dword ptr [ebp - local_c]           # 0047c7c0
    mov dword ptr [edx + field_1c8], eax         # 0047c7c3
L_0047c7c9:
    # block 0x0047c7c9: entered by je at 0x0047c55f; je at 0x0047c74f, 57 instruction(s), calls FUN_004d39f9, ends with jne to 0x0047c8d4 (forward)
    call FUN_004d39f9                            # 0047c7c9
    mov ecx, dword ptr [ebp - local_c]           # 0047c7ce
    mov word ptr [ecx + field_4], ax             # 0047c7d1
    mov edx, dword ptr [ebp - local_c]           # 0047c7d5
    movsx eax, word ptr [edx + field_4]          # 0047c7d8
    imul eax, eax, 0x4a                          # 0047c7dc
    mov dword ptr [eax + 0x5d1591], 0xb          # 0047c7df
    mov ecx, dword ptr [ebp - local_c]           # 0047c7e9
    movsx edx, word ptr [ecx + field_4]          # 0047c7ec
    imul edx, edx, 0x4a                          # 0047c7f0
    mov dword ptr [edx + 0x5d1595], 0x47d24e     # 0047c7f3
    mov eax, dword ptr [ebp - local_c]           # 0047c7fd
    movsx ecx, word ptr [eax + field_4]          # 0047c800
    imul ecx, ecx, 0x4a                          # 0047c804
    mov dword ptr [ecx + 0x5d1599], 0x0          # 0047c807
    mov edx, dword ptr [ebp - local_c]           # 0047c811
    movsx eax, word ptr [edx + field_4]          # 0047c814
    imul eax, eax, 0x4a                          # 0047c818
    mov dword ptr [eax + 0x5d159d], 0x0          # 0047c81b
    mov ecx, dword ptr [ebp - local_c]           # 0047c825
    movsx edx, word ptr [ecx + field_4]          # 0047c828
    imul edx, edx, 0x4a                          # 0047c82c
    mov dword ptr [edx + 0x5d15a1], 0x0          # 0047c82f
    mov eax, dword ptr [ebp - local_c]           # 0047c839
    movsx ecx, word ptr [eax + field_4]          # 0047c83c
    imul ecx, ecx, 0x4a                          # 0047c840
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0047c843
    mov edx, dword ptr [ebp - local_c]           # 0047c84d
    movsx eax, word ptr [edx + field_4]          # 0047c850
    imul eax, eax, 0x4a                          # 0047c854
    mov dword ptr [eax + 0x5d15a9], 0x1          # 0047c857
    mov ecx, dword ptr [ebp - local_c]           # 0047c861
    movsx edx, word ptr [ecx + field_4]          # 0047c864
    imul edx, edx, 0x4a                          # 0047c868
    mov word ptr [edx + 0x5d15ad], 0x0           # 0047c86b
    mov edi, 0x54d0a0                            # 0047c874
    mov eax, dword ptr [ebp - local_c]           # 0047c879
    movsx ecx, word ptr [eax + field_4]          # 0047c87c
    imul ecx, ecx, 0x4a                          # 0047c880
    add ecx, 0x5d15b3                            # 0047c883
    {load} mov edx, ecx                          # 0047c889
    or ecx, -0x1                                 # 0047c88b
    {load} xor eax, eax                          # 0047c88e
    repne scasb al, byte ptr es:[edi]            # 0047c890
    not ecx                                      # 0047c892
    {load} sub edi, ecx                          # 0047c894
    {load} mov esi, edi                          # 0047c896
    {load} mov eax, ecx                          # 0047c898
    {load} mov edi, edx                          # 0047c89a
    shr ecx, 0x2                                 # 0047c89c
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0047c89f
    {load} mov ecx, eax                          # 0047c8a1
    and ecx, 0x3                                 # 0047c8a3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0047c8a6
    mov ecx, dword ptr [ebp - local_c]           # 0047c8a8
    cmp dword ptr [ecx + field_8], 0x0           # 0047c8ab
    jne.d8 L_0047c8d4                            # 0047c8af
    # block 0x0047c8b1: entered by fall-through of jne at 0x0047c8af, 10 instruction(s), calls FUN_004c2790, falls into the block at 0x0047c8d4
    push 0x54d0c4                                # 0047c8b1
    push 0x6                                     # 0047c8b6
    mov edx, dword ptr [ebp - local_c]           # 0047c8b8
    mov eax, dword ptr [edx + field_c]           # 0047c8bb
    push eax                                     # 0047c8be
    push 0x54d0e4                                # 0047c8bf
    mov ecx, 0x5cf659                            # 0047c8c4
    call FUN_004c2790                            # 0047c8c9
    mov ecx, dword ptr [ebp - local_c]           # 0047c8ce
    mov dword ptr [ecx + field_8], eax           # 0047c8d1
L_0047c8d4:
    # block 0x0047c8d4: entered by jne at 0x0047c8af, 21 instruction(s), calls FUN_0047bb56, ends with forward jump to 0x0047cd74
    mov edx, dword ptr [ebp - local_c]           # 0047c8d4
    movsx eax, word ptr [edx + field_4]          # 0047c8d7
    imul eax, eax, 0x4a                          # 0047c8db
    mov ecx, dword ptr [ebp - local_c]           # 0047c8de
    mov edx, dword ptr [ecx + field_8]           # 0047c8e1
    mov dword ptr [eax + 0x5d1599], edx          # 0047c8e4
    mov ecx, dword ptr [ebp - local_c]           # 0047c8ea
    call FUN_0047bb56                            # 0047c8ed
    mov eax, dword ptr [ebp - local_c]           # 0047c8f2
    mov dword ptr [eax + field_28], 0x0          # 0047c8f5
    mov ecx, dword ptr [ebp - local_c]           # 0047c8fc
    mov dword ptr [ecx + field_2c], 0x0          # 0047c8ff
    mov edx, dword ptr [ebp - local_c]           # 0047c906
    mov dword ptr [edx + field_30], 0x1          # 0047c909
    mov eax, dword ptr [ebp - local_c]           # 0047c910
    mov dword ptr [eax + field_10], 0x0          # 0047c913
    mov ecx, dword ptr [ebp - local_c]           # 0047c91a
    movsx edx, word ptr [ecx + field_6]          # 0047c91d
    imul edx, edx, 0x8d                          # 0047c921
    mov dword ptr [edx + 0x5bb632], 0x1          # 0047c927
    jmp.d32 L_0047cd74                           # 0047c931
L_0047c936:
    # block 0x0047c936: entered by je at 0x0047c12e, 5 instruction(s), ends with ja to 0x0047cb30 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047c936
    mov ecx, dword ptr [eax + field_10]          # 0047c939
    mov dword ptr [ebp - local_14], ecx          # 0047c93c
    cmp dword ptr [ebp - local_14], 0x4          # 0047c93f
    ja.d32 L_0047cb30                            # 0047c943
    # block 0x0047c949: entered by fall-through of ja at 0x0047c943, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x47cd7c]
    mov edx, dword ptr [ebp - local_14]          # 0047c949
    jmp dword ptr [4*edx + SWTAB_0047cd7c_VA]    # 0047c94c
L_0047c953:
    # block 0x0047c953: entered by switch case, 5 instruction(s), calls FUN_0047ba79, ends with je to 0x0047c978 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c953
    call FUN_0047ba79                            # 0047c956
    mov eax, dword ptr [ebp - local_c]           # 0047c95b
    cmp dword ptr [eax + field_28], 0x0          # 0047c95e
    je.d8 L_0047c978                             # 0047c962
    # block 0x0047c964: entered by fall-through of je at 0x0047c962, 4 instruction(s), falls into the block at 0x0047c978
    mov ecx, dword ptr [ebp - local_c]           # 0047c964
    mov dword ptr [ecx + field_10], 0x1          # 0047c967
    mov edx, dword ptr [ebp - local_c]           # 0047c96e
    mov dword ptr [edx + field_30], 0x1          # 0047c971
L_0047c978:
    # block 0x0047c978: entered by je at 0x0047c962, 3 instruction(s), ends with je to 0x0047c995 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047c978
    cmp dword ptr [eax + field_2c], 0x0          # 0047c97b
    je.d8 L_0047c995                             # 0047c97f
    # block 0x0047c981: entered by fall-through of je at 0x0047c97f, 4 instruction(s), falls into the block at 0x0047c995
    mov ecx, dword ptr [ebp - local_c]           # 0047c981
    mov dword ptr [ecx + field_10], 0x2          # 0047c984
    mov edx, dword ptr [ebp - local_c]           # 0047c98b
    mov dword ptr [edx + field_30], 0x1          # 0047c98e
L_0047c995:
    # block 0x0047c995: entered by je at 0x0047c97f, 1 instruction(s), ends with forward jump to 0x0047cb30
    jmp.d32 L_0047cb30                           # 0047c995
L_0047c99a:
    # block 0x0047c99a: entered by switch case, 5 instruction(s), calls FUN_0047cf4e, ends with je to 0x0047c9ff (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047c99a
    call FUN_0047cf4e                            # 0047c99d
    mov eax, dword ptr [ebp - local_c]           # 0047c9a2
    cmp dword ptr [eax + field_2c0], -0x1        # 0047c9a5
    je.d8 L_0047c9ff                             # 0047c9ac
    # block 0x0047c9ae: entered by fall-through of je at 0x0047c9ac, 11 instruction(s), ends with je to 0x0047c9e6 (forward)
    mov edi, 0x54d0ec                            # 0047c9ae
    mov ecx, dword ptr [ebp - local_c]           # 0047c9b3
    mov edx, dword ptr [ecx + field_c]           # 0047c9b6
    mov eax, dword ptr [ebp - local_c]           # 0047c9b9
    mov ecx, dword ptr [eax + field_2c0]         # 0047c9bc
    imul ecx, ecx, 0xb6                          # 0047c9c2
    lea esi, [edx + ecx + field_f72]             # 0047c9c8
    mov ecx, 0x9                                 # 0047c9cf
    {load} xor edx, edx                          # 0047c9d4
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047c9d6
    je.d8 L_0047c9e6                             # 0047c9d8
    # block 0x0047c9da: entered by fall-through of je at 0x0047c9d8, 3 instruction(s), ends with forward jump to 0x0047c9fd
    mov eax, dword ptr [ebp - local_c]           # 0047c9da
    mov dword ptr [eax + field_10], 0x3          # 0047c9dd
    jmp.d8 L_0047c9fd                            # 0047c9e4
L_0047c9e6:
    # block 0x0047c9e6: entered by je at 0x0047c9d8, 4 instruction(s), falls into the block at 0x0047c9fd
    mov ecx, dword ptr [ebp - local_c]           # 0047c9e6
    movsx edx, word ptr [ecx + field_6]          # 0047c9e9
    imul edx, edx, 0x8d                          # 0047c9ed
    mov dword ptr [edx + 0x5bb632], 0x2          # 0047c9f3
L_0047c9fd:
    # block 0x0047c9fd: entered by jmp at 0x0047c9e4, 1 instruction(s), ends with forward jump to 0x0047ca16
    jmp.d8 L_0047ca16                            # 0047c9fd
L_0047c9ff:
    # block 0x0047c9ff: entered by je at 0x0047c9ac, 4 instruction(s), falls into the block at 0x0047ca16
    mov eax, dword ptr [ebp - local_c]           # 0047c9ff
    movsx ecx, word ptr [eax + field_6]          # 0047ca02
    imul ecx, ecx, 0x8d                          # 0047ca06
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0047ca0c
L_0047ca16:
    # block 0x0047ca16: entered by jmp at 0x0047c9fd, 1 instruction(s), ends with forward jump to 0x0047cb30
    jmp.d32 L_0047cb30                           # 0047ca16
L_0047ca1b:
    # block 0x0047ca1b: entered by switch case, 13 instruction(s), calls FUN_004f6334, ends with jne to 0x0047ca64 (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047ca1b
    mov eax, dword ptr [edx + field_c]           # 0047ca1e
    mov ecx, dword ptr [ebp - local_c]           # 0047ca21
    mov edx, dword ptr [ecx + field_2c0]         # 0047ca24
    imul edx, edx, 0xb6                          # 0047ca2a
    movsx eax, word ptr [eax + edx + field_f93]  # 0047ca30
    mov dword ptr [ebp - local_4], eax           # 0047ca38
    mov ecx, dword ptr [ebp - local_4]           # 0047ca3b
    push ecx                                     # 0047ca3e
    mov ecx, 0x5cf1eb                            # 0047ca3f
    call FUN_004f6334                            # 0047ca44
    test eax, eax                                # 0047ca49
    jne.d8 L_0047ca64                            # 0047ca4b
    # block 0x0047ca4d: entered by fall-through of jne at 0x0047ca4b, 4 instruction(s), falls into the block at 0x0047ca64
    mov edx, dword ptr [ebp - local_c]           # 0047ca4d
    movsx eax, word ptr [edx + field_6]          # 0047ca50
    imul eax, eax, 0x8d                          # 0047ca54
    mov dword ptr [eax + 0x5bb632], 0x2          # 0047ca5a
L_0047ca64:
    # block 0x0047ca64: entered by jne at 0x0047ca4b, 1 instruction(s), ends with forward jump to 0x0047cb30
    jmp.d32 L_0047cb30                           # 0047ca64
L_0047ca69:
    # block 0x0047ca69: entered by switch case, 5 instruction(s), calls FUN_0047ce6f, ends with je to 0x0047cace (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047ca69
    call FUN_0047ce6f                            # 0047ca6c
    mov ecx, dword ptr [ebp - local_c]           # 0047ca71
    cmp dword ptr [ecx + field_2bc], -0x1        # 0047ca74
    je.d8 L_0047cace                             # 0047ca7b
    # block 0x0047ca7d: entered by fall-through of je at 0x0047ca7b, 11 instruction(s), ends with je to 0x0047cab5 (forward)
    mov edi, 0x54d0f8                            # 0047ca7d
    mov edx, dword ptr [ebp - local_c]           # 0047ca82
    mov eax, dword ptr [edx + field_c]           # 0047ca85
    mov ecx, dword ptr [ebp - local_c]           # 0047ca88
    mov edx, dword ptr [ecx + field_2bc]         # 0047ca8b
    imul edx, edx, 0xb6                          # 0047ca91
    lea esi, [eax + edx + field_856]             # 0047ca97
    mov ecx, 0x9                                 # 0047ca9e
    {load} xor eax, eax                          # 0047caa3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0047caa5
    je.d8 L_0047cab5                             # 0047caa7
    # block 0x0047caa9: entered by fall-through of je at 0x0047caa7, 3 instruction(s), ends with forward jump to 0x0047cacc
    mov ecx, dword ptr [ebp - local_c]           # 0047caa9
    mov dword ptr [ecx + field_10], 0x4          # 0047caac
    jmp.d8 L_0047cacc                            # 0047cab3
L_0047cab5:
    # block 0x0047cab5: entered by je at 0x0047caa7, 4 instruction(s), falls into the block at 0x0047cacc
    mov edx, dword ptr [ebp - local_c]           # 0047cab5
    movsx eax, word ptr [edx + field_6]          # 0047cab8
    imul eax, eax, 0x8d                          # 0047cabc
    mov dword ptr [eax + 0x5bb632], 0x2          # 0047cac2
L_0047cacc:
    # block 0x0047cacc: entered by jmp at 0x0047cab3, 1 instruction(s), ends with forward jump to 0x0047cae5
    jmp.d8 L_0047cae5                            # 0047cacc
L_0047cace:
    # block 0x0047cace: entered by je at 0x0047ca7b, 4 instruction(s), falls into the block at 0x0047cae5
    mov ecx, dword ptr [ebp - local_c]           # 0047cace
    movsx edx, word ptr [ecx + field_6]          # 0047cad1
    imul edx, edx, 0x8d                          # 0047cad5
    mov dword ptr [edx + 0x5bb632], 0x2          # 0047cadb
L_0047cae5:
    # block 0x0047cae5: entered by jmp at 0x0047cacc, 1 instruction(s), ends with forward jump to 0x0047cb30
    jmp.d8 L_0047cb30                            # 0047cae5
L_0047cae7:
    # block 0x0047cae7: entered by switch case, 13 instruction(s), calls FUN_004f6334, ends with jne to 0x0047cb30 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047cae7
    mov ecx, dword ptr [eax + field_c]           # 0047caea
    mov edx, dword ptr [ebp - local_c]           # 0047caed
    mov eax, dword ptr [edx + field_2bc]         # 0047caf0
    imul eax, eax, 0xb6                          # 0047caf6
    movsx ecx, word ptr [ecx + eax + field_877]  # 0047cafc
    mov dword ptr [ebp - local_8], ecx           # 0047cb04
    mov edx, dword ptr [ebp - local_8]           # 0047cb07
    push edx                                     # 0047cb0a
    mov ecx, 0x5cf1eb                            # 0047cb0b
    call FUN_004f6334                            # 0047cb10
    test eax, eax                                # 0047cb15
    jne.d8 L_0047cb30                            # 0047cb17
    # block 0x0047cb19: entered by fall-through of jne at 0x0047cb17, 4 instruction(s), falls into the block at 0x0047cb30
    mov eax, dword ptr [ebp - local_c]           # 0047cb19
    movsx ecx, word ptr [eax + field_6]          # 0047cb1c
    imul ecx, ecx, 0x8d                          # 0047cb20
    mov dword ptr [ecx + 0x5bb632], 0x2          # 0047cb26
L_0047cb30:
    # block 0x0047cb30: entered by ja at 0x0047c943; jmp at 0x0047c995; jmp at 0x0047ca16; jmp at 0x0047ca64; more, 1 instruction(s), ends with forward jump to 0x0047cd74
    jmp.d32 L_0047cd74                           # 0047cb30
L_0047cb35:
    # block 0x0047cb35: entered by je at 0x0047c138, 5 instruction(s), ends with je to 0x0047cc4c (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047cb35
    mov dword ptr [edx + field_24], 0x0          # 0047cb38
    mov eax, dword ptr [ebp - local_c]           # 0047cb3f
    cmp dword ptr [eax + field_28], 0x0          # 0047cb42
    je.d32 L_0047cc4c                            # 0047cb46
    # block 0x0047cb4c: entered by fall-through of je at 0x0047cb46, 5 instruction(s), ends with je to 0x0047cc14 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047cb4c
    mov edx, dword ptr [ecx + field_c]           # 0047cb4f
    movsx eax, word ptr [edx + field_168e]       # 0047cb52
    cmp eax, 0x270f                              # 0047cb59
    je.d32 L_0047cc14                            # 0047cb5e
    # block 0x0047cb64: entered by fall-through of je at 0x0047cb5e, 33 instruction(s), ends with jne to 0x0047cc00 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047cb64
    mov edx, dword ptr [ecx + field_c]           # 0047cb67
    movsx eax, word ptr [edx + field_168e]       # 0047cb6a
    mov dword ptr [0x5bb57b], eax                # 0047cb71
    mov ecx, dword ptr [ebp - local_c]           # 0047cb76
    mov edx, dword ptr [ecx + field_c]           # 0047cb79
    mov ax, word ptr [edx + field_1690]          # 0047cb7c
    mov word ptr [0x5bb599], ax                  # 0047cb83
    mov ecx, dword ptr [ebp - local_c]           # 0047cb89
    mov edx, dword ptr [ecx + field_c]           # 0047cb8c
    mov ax, word ptr [edx + field_1692]          # 0047cb8f
    mov word ptr [0x5bb595], ax                  # 0047cb96
    mov ecx, dword ptr [ebp - local_c]           # 0047cb9c
    mov edx, dword ptr [ecx + field_c]           # 0047cb9f
    mov ax, word ptr [edx + field_1694]          # 0047cba2
    mov word ptr [0x5c39ff], ax                  # 0047cba9
    mov ecx, dword ptr [ebp - local_c]           # 0047cbaf
    mov edx, dword ptr [ecx + field_c]           # 0047cbb2
    mov eax, dword ptr [edx + field_1696]        # 0047cbb5
    mov dword ptr [0x5bb59b], eax                # 0047cbbb
    mov ecx, dword ptr [ebp - local_c]           # 0047cbc0
    mov edx, dword ptr [ecx + field_c]           # 0047cbc3
    mov eax, dword ptr [edx + field_169a]        # 0047cbc6
    mov dword ptr [0x5bb59f], eax                # 0047cbcc
    mov ecx, dword ptr [ebp - local_c]           # 0047cbd1
    mov edx, dword ptr [ecx + field_c]           # 0047cbd4
    mov eax, dword ptr [edx + field_169e]        # 0047cbd7
    mov dword ptr [0x5bb5a3], eax                # 0047cbdd
    mov ecx, dword ptr [ebp - local_c]           # 0047cbe2
    mov edx, dword ptr [ecx + field_c]           # 0047cbe5
    movsx eax, word ptr [edx + field_16a2]       # 0047cbe8
    cmp eax, 0x1                                 # 0047cbef
    jne.d8 L_0047cc00                            # 0047cbf2
    # block 0x0047cbf4: entered by fall-through of jne at 0x0047cbf2, 2 instruction(s), ends with forward jump to 0x0047cc0a
    mov dword ptr [0x5bb1ca], 0x0                # 0047cbf4
    jmp.d8 L_0047cc0a                            # 0047cbfe
L_0047cc00:
    # block 0x0047cc00: entered by jne at 0x0047cbf2, 1 instruction(s), falls into the block at 0x0047cc0a
    mov dword ptr [0x5bb1ca], 0x1                # 0047cc00
L_0047cc0a:
    # block 0x0047cc0a: entered by jmp at 0x0047cbfe, 1 instruction(s), falls into the block at 0x0047cc14
    mov dword ptr [0x583999], 0x4                # 0047cc0a
L_0047cc14:
    # block 0x0047cc14: entered by je at 0x0047cb5e, 5 instruction(s), ends with je to 0x0047cc47 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 0047cc14
    mov edx, dword ptr [ecx + field_c]           # 0047cc17
    movsx eax, word ptr [edx + field_16a4]       # 0047cc1a
    cmp eax, -0x1                                # 0047cc21
    je.d8 L_0047cc47                             # 0047cc24
    # block 0x0047cc26: entered by fall-through of je at 0x0047cc24, 7 instruction(s), falls into the block at 0x0047cc47
    mov ecx, dword ptr [ebp - local_c]           # 0047cc26
    mov edx, dword ptr [ecx + field_c]           # 0047cc29
    movsx eax, word ptr [edx + field_16a6]       # 0047cc2c
    mov ecx, dword ptr [ebp - local_c]           # 0047cc33
    mov edx, dword ptr [ecx + field_c]           # 0047cc36
    movsx ecx, word ptr [edx + field_16a4]       # 0047cc39
    mov dword ptr [4*ecx + 0x585801], eax        # 0047cc40
L_0047cc47:
    # block 0x0047cc47: entered by je at 0x0047cc24, 1 instruction(s), ends with forward jump to 0x0047cd5c
    jmp.d32 L_0047cd5c                           # 0047cc47
L_0047cc4c:
    # block 0x0047cc4c: entered by je at 0x0047cb46, 3 instruction(s), ends with je to 0x0047cd5c (forward)
    mov edx, dword ptr [ebp - local_c]           # 0047cc4c
    cmp dword ptr [edx + field_2c], 0x0          # 0047cc4f
    je.d32 L_0047cd5c                            # 0047cc53
    # block 0x0047cc59: entered by fall-through of je at 0x0047cc53, 5 instruction(s), ends with je to 0x0047cd29 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047cc59
    mov ecx, dword ptr [eax + field_c]           # 0047cc5c
    movsx edx, word ptr [ecx + field_16a8]       # 0047cc5f
    cmp edx, 0x270f                              # 0047cc66
    je.d32 L_0047cd29                            # 0047cc6c
    # block 0x0047cc72: entered by fall-through of je at 0x0047cc6c, 33 instruction(s), ends with jne to 0x0047cd15 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047cc72
    mov ecx, dword ptr [eax + field_c]           # 0047cc75
    movsx edx, word ptr [ecx + field_16a8]       # 0047cc78
    mov dword ptr [0x5bb57b], edx                # 0047cc7f
    mov eax, dword ptr [ebp - local_c]           # 0047cc85
    mov ecx, dword ptr [eax + field_c]           # 0047cc88
    mov dx, word ptr [ecx + field_16aa]          # 0047cc8b
    mov word ptr [0x5bb599], dx                  # 0047cc92
    mov eax, dword ptr [ebp - local_c]           # 0047cc99
    mov ecx, dword ptr [eax + field_c]           # 0047cc9c
    mov dx, word ptr [ecx + field_16ac]          # 0047cc9f
    mov word ptr [0x5bb595], dx                  # 0047cca6
    mov eax, dword ptr [ebp - local_c]           # 0047ccad
    mov ecx, dword ptr [eax + field_c]           # 0047ccb0
    mov dx, word ptr [ecx + field_16ae]          # 0047ccb3
    mov word ptr [0x5c39ff], dx                  # 0047ccba
    mov eax, dword ptr [ebp - local_c]           # 0047ccc1
    mov ecx, dword ptr [eax + field_c]           # 0047ccc4
    mov edx, dword ptr [ecx + field_16b0]        # 0047ccc7
    mov dword ptr [0x5bb59b], edx                # 0047cccd
    mov eax, dword ptr [ebp - local_c]           # 0047ccd3
    mov ecx, dword ptr [eax + field_c]           # 0047ccd6
    mov edx, dword ptr [ecx + field_16b4]        # 0047ccd9
    mov dword ptr [0x5bb59f], edx                # 0047ccdf
    mov eax, dword ptr [ebp - local_c]           # 0047cce5
    mov ecx, dword ptr [eax + field_c]           # 0047cce8
    mov edx, dword ptr [ecx + field_16b8]        # 0047cceb
    mov dword ptr [0x5bb5a3], edx                # 0047ccf1
    mov eax, dword ptr [ebp - local_c]           # 0047ccf7
    mov ecx, dword ptr [eax + field_c]           # 0047ccfa
    movsx edx, word ptr [ecx + field_16bc]       # 0047ccfd
    cmp edx, 0x1                                 # 0047cd04
    jne.d8 L_0047cd15                            # 0047cd07
    # block 0x0047cd09: entered by fall-through of jne at 0x0047cd07, 2 instruction(s), ends with forward jump to 0x0047cd1f
    mov dword ptr [0x5bb1ca], 0x0                # 0047cd09
    jmp.d8 L_0047cd1f                            # 0047cd13
L_0047cd15:
    # block 0x0047cd15: entered by jne at 0x0047cd07, 1 instruction(s), falls into the block at 0x0047cd1f
    mov dword ptr [0x5bb1ca], 0x1                # 0047cd15
L_0047cd1f:
    # block 0x0047cd1f: entered by jmp at 0x0047cd13, 1 instruction(s), falls into the block at 0x0047cd29
    mov dword ptr [0x583999], 0x4                # 0047cd1f
L_0047cd29:
    # block 0x0047cd29: entered by je at 0x0047cc6c, 5 instruction(s), ends with je to 0x0047cd5c (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047cd29
    mov ecx, dword ptr [eax + field_c]           # 0047cd2c
    movsx edx, word ptr [ecx + field_16be]       # 0047cd2f
    cmp edx, -0x1                                # 0047cd36
    je.d8 L_0047cd5c                             # 0047cd39
    # block 0x0047cd3b: entered by fall-through of je at 0x0047cd39, 7 instruction(s), falls into the block at 0x0047cd5c
    mov eax, dword ptr [ebp - local_c]           # 0047cd3b
    mov ecx, dword ptr [eax + field_c]           # 0047cd3e
    movsx edx, word ptr [ecx + field_16c0]       # 0047cd41
    mov eax, dword ptr [ebp - local_c]           # 0047cd48
    mov ecx, dword ptr [eax + field_c]           # 0047cd4b
    movsx eax, word ptr [ecx + field_16be]       # 0047cd4e
    mov dword ptr [4*eax + 0x585801], edx        # 0047cd55
L_0047cd5c:
    # block 0x0047cd5c: entered by jmp at 0x0047cc47; je at 0x0047cc53; je at 0x0047cd39, 7 instruction(s), calls FUN_0042ba3a, FUN_0047b321, falls into the block at 0x0047cd74
    mov ecx, dword ptr [ebp - local_c]           # 0047cd5c
    mov dx, word ptr [ecx + field_6]             # 0047cd5f
    push edx                                     # 0047cd63
    call FUN_0042ba3a                            # 0047cd64
    add esp, 0x4                                 # 0047cd69
    mov ecx, dword ptr [ebp - local_c]           # 0047cd6c
    call FUN_0047b321                            # 0047cd6f
L_0047cd74:
    # block 0x0047cd74: entered by jmp at 0x0047c13e; jmp at 0x0047c1e6; jmp at 0x0047c24a; jmp at 0x0047c2ae; more, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0047cd74
    pop esi                                      # 0047cd75
    {load} mov esp, ebp                          # 0047cd76
    pop ebp                                      # 0047cd78
    ret 0x4                                      # 0047cd79

# --- data items (not part of the function) -------------------------
.org 0x0047cd7c - 0x401000
SWTAB_0047cd7c:  # 5 case address(es)
    .long L_0047c953 - .text + 0x401000
    .long L_0047c99a - .text + 0x401000
    .long L_0047ca69 - .text + 0x401000
    .long L_0047ca1b - .text + 0x401000
    .long L_0047cae7 - .text + 0x401000
.set SWTAB_0047cd7c_VA, SWTAB_0047cd7c - .text + 0x401000

