# FUN_004dd05a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd05a
# extent:       0x004dd05a-0x004dd28d (563 code bytes)
# span:         0x004dd05a-0x004dd28d (code 563, tables 0, padding 0)
# sha256:       f8e0ed603ee440858814e1dbfd85375985a96a5ec02791e1729082695b250469
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_partner_logo_movie_sequence
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4dd05a.c.txt, not original source) refers to the data labelled s_CPartnerLogo__ProcessSequence_____0055b604, s_ProcessSecondaryMovieSequence_____0055b5c0
# name-note:    State machine playing the secondary partner-logo movie (ProcessSecondaryMovieSequence): starts it, per-frame copy, finishes and ends the sequence.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c, field_4a, field_de, field_106; [ecx + n] field_2d, field_2f, field_102, field_106; [edx + n] field_de, field_102, field_106
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004bef85, FUN_004befc8, FUN_004bf098, FUN_004bf10f, FUN_004fb2e3, FUN_004f6334, FUN_004dad60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 149 instruction(s), 14 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c
.equ field_2d, 0x2d  # offset +0x2d
.equ field_2f, 0x2f  # offset +0x2f
.equ field_4a, 0x4a  # offset +0x4a
.equ field_de, 0xde  # offset +0xde
.equ field_102, 0x102  # offset +0x102
.equ field_106, 0x106  # offset +0x106

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bef85, .text + (0x004bef85 - 0x401000)
.set FUN_004befc8, .text + (0x004befc8 - 0x401000)
.set FUN_004bf098, .text + (0x004bf098 - 0x401000)
.set FUN_004bf10f, .text + (0x004bf10f - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004dd05a - 0x401000
.globl FUN_004dd05a
FUN_004dd05a:
    # block 0x004dd05a: entry, 8 instruction(s), ends with je to 0x004dd08a (forward)
    push ebp                                     # 004dd05a
    {load} mov ebp, esp                          # 004dd05b
    sub esp, 0xc                                 # 004dd05d
    mov dword ptr [ebp - local_8], ecx           # 004dd060
    mov eax, dword ptr [0x6381a9]                # 004dd063
    mov dword ptr [ebp - local_c], eax           # 004dd068
    cmp dword ptr [ebp - local_c], 0x0           # 004dd06b
    je.d8 L_004dd08a                             # 004dd06f
    # block 0x004dd071: entered by fall-through of je at 0x004dd06f, 2 instruction(s), ends with je to 0x004dd191 (forward)
    cmp dword ptr [ebp - local_c], 0x4           # 004dd071
    je.d32 L_004dd191                            # 004dd075
    # block 0x004dd07b: entered by fall-through of je at 0x004dd075, 2 instruction(s), ends with je to 0x004dd25d (forward)
    cmp dword ptr [ebp - local_c], 0x5           # 004dd07b
    je.d32 L_004dd25d                            # 004dd07f
    # block 0x004dd085: entered by fall-through of je at 0x004dd07f, 1 instruction(s), ends with forward jump to 0x004dd289
    jmp.d32 L_004dd289                           # 004dd085
L_004dd08a:
    # block 0x004dd08a: entered by je at 0x004dd06f, 3 instruction(s), ends with je to 0x004dd0b4 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004dd08a
    test ecx, ecx                                # 004dd091
    je.d8 L_004dd0b4                             # 004dd093
    # block 0x004dd095: entered by fall-through of je at 0x004dd093, 7 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004dd0b4
    push 0x55b5c0                                # 004dd095
    push 0x63888b                                # 004dd09a
    call FUN_0050ca3e                            # 004dd09f
    add esp, 0x8                                 # 004dd0a4
    push 0x63888b                                # 004dd0a7
    call FUN_0044a2b7                            # 004dd0ac
    add esp, 0x4                                 # 004dd0b1
L_004dd0b4:
    # block 0x004dd0b4: entered by je at 0x004dd093, 7 instruction(s), calls FUN_004bef85, ends with je to 0x004dd18c (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dd0b4
    mov eax, dword ptr [edx + field_106]         # 004dd0b7
    push eax                                     # 004dd0bd
    mov ecx, 0x6201f9                            # 004dd0be
    call FUN_004bef85                            # 004dd0c3
    test eax, eax                                # 004dd0c8
    je.d32 L_004dd18c                            # 004dd0ca
    # block 0x004dd0d0: entered by fall-through of je at 0x004dd0ca, 31 instruction(s), calls FUN_004befc8, FUN_004bf098, FUN_004bf10f, ends with je to 0x004dd13f (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dd0d0
    mov edx, dword ptr [ecx + field_106]         # 004dd0d3
    push edx                                     # 004dd0d9
    mov ecx, 0x6201f9                            # 004dd0da
    call FUN_004befc8                            # 004dd0df
    push 0x0                                     # 004dd0e4
    push 0x0                                     # 004dd0e6
    mov eax, dword ptr [ebp - local_8]           # 004dd0e8
    mov ecx, dword ptr [eax + field_4a]          # 004dd0eb
    movsx edx, word ptr [ecx + field_2d]         # 004dd0ee
    push edx                                     # 004dd0f2
    mov eax, dword ptr [ebp - local_8]           # 004dd0f3
    mov ecx, dword ptr [eax + field_4a]          # 004dd0f6
    movsx edx, word ptr [ecx + field_2f]         # 004dd0f9
    push edx                                     # 004dd0fd
    mov eax, dword ptr [ebp - local_8]           # 004dd0fe
    mov ecx, dword ptr [eax + field_4a]          # 004dd101
    mov edx, dword ptr [ecx]                     # 004dd104
    push edx                                     # 004dd106
    mov eax, dword ptr [ebp - local_8]           # 004dd107
    mov ecx, dword ptr [eax + field_106]         # 004dd10a
    push ecx                                     # 004dd110
    mov ecx, 0x6201f9                            # 004dd111
    call FUN_004bf098                            # 004dd116
    mov edx, dword ptr [ebp - local_8]           # 004dd11b
    mov eax, dword ptr [edx + field_106]         # 004dd11e
    push eax                                     # 004dd124
    mov ecx, 0x6201f9                            # 004dd125
    call FUN_004bf10f                            # 004dd12a
    test eax, eax                                # 004dd12f
    je.d8 L_004dd13f                             # 004dd131
    # block 0x004dd133: entered by fall-through of je at 0x004dd131, 2 instruction(s), ends with forward jump to 0x004dd149
    mov dword ptr [0x6381a9], 0x4                # 004dd133
    jmp.d8 L_004dd149                            # 004dd13d
L_004dd13f:
    # block 0x004dd13f: entered by je at 0x004dd131, 1 instruction(s), falls into the block at 0x004dd149
    mov dword ptr [0x6381a9], 0x5                # 004dd13f
L_004dd149:
    # block 0x004dd149: entered by jmp at 0x004dd13d, 3 instruction(s), ends with je to 0x004dd16a (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dd149
    cmp dword ptr [ecx + field_102], 0x0         # 004dd14c
    je.d8 L_004dd16a                             # 004dd153
    # block 0x004dd155: entered by fall-through of je at 0x004dd153, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004dd16a
    mov edx, dword ptr [ebp - local_8]           # 004dd155
    mov ax, word ptr [edx + field_de]            # 004dd158
    push eax                                     # 004dd15f
    mov ecx, 0x5c3a67                            # 004dd160
    call FUN_004fb2e3                            # 004dd165
L_004dd16a:
    # block 0x004dd16a: entered by je at 0x004dd153, 4 instruction(s), ends with je to 0x004dd18c (forward)
    mov dword ptr [0x6381e5], 0x1                # 004dd16a
    movsx ecx, word ptr [0x63a4cd]               # 004dd174
    test ecx, ecx                                # 004dd17b
    je.d8 L_004dd18c                             # 004dd17d
    # block 0x004dd17f: entered by fall-through of je at 0x004dd17d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dd18c
    push 0x55b604                                # 004dd17f
    call FUN_0044a2b7                            # 004dd184
    add esp, 0x4                                 # 004dd189
L_004dd18c:
    # block 0x004dd18c: entered by je at 0x004dd0ca; je at 0x004dd17d, 1 instruction(s), ends with forward jump to 0x004dd289
    jmp.d32 L_004dd289                           # 004dd18c
L_004dd191:
    # block 0x004dd191: entered by je at 0x004dd075, 7 instruction(s), calls FUN_004bef85, ends with je to 0x004dd25b (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dd191
    mov eax, dword ptr [edx + field_106]         # 004dd194
    push eax                                     # 004dd19a
    mov ecx, 0x6201f9                            # 004dd19b
    call FUN_004bef85                            # 004dd1a0
    test eax, eax                                # 004dd1a5
    je.d32 L_004dd25b                            # 004dd1a7
    # block 0x004dd1ad: entered by fall-through of je at 0x004dd1a7, 31 instruction(s), calls FUN_004befc8, FUN_004bf098, FUN_004bf10f, ends with jne to 0x004dd251 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dd1ad
    mov edx, dword ptr [ecx + field_106]         # 004dd1b0
    push edx                                     # 004dd1b6
    mov ecx, 0x6201f9                            # 004dd1b7
    call FUN_004befc8                            # 004dd1bc
    push 0x0                                     # 004dd1c1
    push 0x0                                     # 004dd1c3
    mov eax, dword ptr [ebp - local_8]           # 004dd1c5
    mov ecx, dword ptr [eax + field_4a]          # 004dd1c8
    movsx edx, word ptr [ecx + field_2d]         # 004dd1cb
    push edx                                     # 004dd1cf
    mov eax, dword ptr [ebp - local_8]           # 004dd1d0
    mov ecx, dword ptr [eax + field_4a]          # 004dd1d3
    movsx edx, word ptr [ecx + field_2f]         # 004dd1d6
    push edx                                     # 004dd1da
    mov eax, dword ptr [ebp - local_8]           # 004dd1db
    mov ecx, dword ptr [eax + field_4a]          # 004dd1de
    mov edx, dword ptr [ecx]                     # 004dd1e1
    push edx                                     # 004dd1e3
    mov eax, dword ptr [ebp - local_8]           # 004dd1e4
    mov ecx, dword ptr [eax + field_106]         # 004dd1e7
    push ecx                                     # 004dd1ed
    mov ecx, 0x6201f9                            # 004dd1ee
    call FUN_004bf098                            # 004dd1f3
    mov edx, dword ptr [ebp - local_8]           # 004dd1f8
    mov eax, dword ptr [edx + field_106]         # 004dd1fb
    push eax                                     # 004dd201
    mov ecx, 0x6201f9                            # 004dd202
    call FUN_004bf10f                            # 004dd207
    test eax, eax                                # 004dd20c
    jne.d8 L_004dd251                            # 004dd20e
    # block 0x004dd210: entered by fall-through of jne at 0x004dd20e, 3 instruction(s), ends with je to 0x004dd247 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004dd210
    cmp dword ptr [ecx + field_102], 0x0         # 004dd213
    je.d8 L_004dd247                             # 004dd21a
    # block 0x004dd21c: entered by fall-through of je at 0x004dd21a, 3 instruction(s), ends with je to 0x004dd251 (forward)
    mov edx, dword ptr [ebp - local_8]           # 004dd21c
    cmp dword ptr [edx + field_102], 0x0         # 004dd21f
    je.d8 L_004dd251                             # 004dd226
    # block 0x004dd228: entered by fall-through of je at 0x004dd226, 9 instruction(s), calls FUN_004f6334, ends with jne to 0x004dd251 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004dd228
    movsx ecx, word ptr [eax + field_de]         # 004dd22b
    mov dword ptr [ebp - local_4], ecx           # 004dd232
    mov edx, dword ptr [ebp - local_4]           # 004dd235
    push edx                                     # 004dd238
    mov ecx, 0x5cf1eb                            # 004dd239
    call FUN_004f6334                            # 004dd23e
    test eax, eax                                # 004dd243
    jne.d8 L_004dd251                            # 004dd245
L_004dd247:
    # block 0x004dd247: entered by je at 0x004dd21a; fall-through of jne at 0x004dd245, 1 instruction(s), falls into the block at 0x004dd251
    mov dword ptr [0x6381a9], 0x5                # 004dd247
L_004dd251:
    # block 0x004dd251: entered by jne at 0x004dd20e; je at 0x004dd226; jne at 0x004dd245, 1 instruction(s), falls into the block at 0x004dd25b
    mov dword ptr [0x6381e5], 0x1                # 004dd251
L_004dd25b:
    # block 0x004dd25b: entered by je at 0x004dd1a7, 1 instruction(s), ends with forward jump to 0x004dd289
    jmp.d8 L_004dd289                            # 004dd25b
L_004dd25d:
    # block 0x004dd25d: entered by je at 0x004dd07f, 7 instruction(s), calls FUN_004dad60, ends with je to 0x004dd289 (forward)
    mov eax, dword ptr [ebp - local_8]           # 004dd25d
    mov dword ptr [eax + field_1c], 0x3          # 004dd260
    mov ecx, 0x5830a6                            # 004dd267
    call FUN_004dad60                            # 004dd26c
    movsx ecx, word ptr [0x63a4cd]               # 004dd271
    test ecx, ecx                                # 004dd278
    je.d8 L_004dd289                             # 004dd27a
    # block 0x004dd27c: entered by fall-through of je at 0x004dd27a, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dd289
    push 0x55b644                                # 004dd27c
    call FUN_0044a2b7                            # 004dd281
    add esp, 0x4                                 # 004dd286
L_004dd289:
    # block 0x004dd289: entered by jmp at 0x004dd085; jmp at 0x004dd18c; jmp at 0x004dd25b; je at 0x004dd27a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004dd289
    pop ebp                                      # 004dd28b
    ret                                          # 004dd28c

