# FUN_004ae178
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ae178
# extent:       0x004ae178-0x004ae452 (730 code bytes)
# span:         0x004ae178-0x004ae452 (code 730, tables 0, padding 0)
# sha256:       3601d742e7062fd4714e870d8a2ea5e886d26222a0632b32ec3e38efec66fa58
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_tangram_solution_setup
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ae178.c.txt, not original source) refers to the data labelled s_CTangramPuzzle__SolutionSetup_____00551510, s_DF_Solution_Source_Surface_005514c4
# name-note:    Builds the tangram solution mask from the CIFTREE DF_Solution_Source_Surface; on allocation failure reports CTangramPuzzle::SolutionSetup with Unable to get memory for Solution.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       10 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28
# fields:       [eax + n] field_4, field_8, field_c, field_c17, field_e59, field_e5d, field_e61, field_e65, field_e69, field_e6d, field_e71, field_e73 and 4 more; [ecx + n] field_2f, field_c17, field_e71, field_e73, field_e75, field_e79, field_e85, field_minus_1; [edx + n] field_4, field_8, field_c, field_e59, field_e5d, field_e6d, field_e79, field_e7d
# callees:      calls FUN_004c2790, FUN_0051dc43, FUN_0050ca3e, FUN_004c2dfb, FUN_0052139c, FUN_0044a2b7, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 197 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_2f, 0x2f  # offset +0x2f
.equ field_c17, 0xc17  # offset +0xc17
.equ field_e59, 0xe59  # offset +0xe59
.equ field_e5d, 0xe5d  # offset +0xe5d
.equ field_e61, 0xe61  # offset +0xe61
.equ field_e65, 0xe65  # offset +0xe65
.equ field_e69, 0xe69  # offset +0xe69
.equ field_e6d, 0xe6d  # offset +0xe6d
.equ field_e71, 0xe71  # offset +0xe71
.equ field_e73, 0xe73  # offset +0xe73
.equ field_e75, 0xe75  # offset +0xe75
.equ field_e79, 0xe79  # offset +0xe79
.equ field_e7d, 0xe7d  # offset +0xe7d
.equ field_e81, 0xe81  # offset +0xe81
.equ field_e85, 0xe85  # offset +0xe85

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c2790, .text + (0x004c2790 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004ae178 - 0x401000
.globl FUN_004ae178
FUN_004ae178:
    # block 0x004ae178: entry, 85 instruction(s), calls FUN_004c2790, FUN_0051dc43, ends with jne to 0x004ae2ea (forward)
    push ebp                                     # 004ae178
    {load} mov ebp, esp                          # 004ae179
    sub esp, 0x28                                # 004ae17b
    push edi                                     # 004ae17e
    mov dword ptr [ebp - local_28], ecx          # 004ae17f
    push 0x5514c4                                # 004ae182
    push 0x6                                     # 004ae187
    mov eax, dword ptr [ebp - local_28]          # 004ae189
    mov ecx, dword ptr [eax + field_c17]         # 004ae18c
    add ecx, 0x21                                # 004ae192
    push ecx                                     # 004ae195
    push 0x5514e0                                # 004ae196
    mov ecx, 0x5cf659                            # 004ae19b
    call FUN_004c2790                            # 004ae1a0
    mov edx, dword ptr [ebp - local_28]          # 004ae1a5
    mov dword ptr [edx + field_e59], eax         # 004ae1a8
    mov eax, dword ptr [ebp - local_28]          # 004ae1ae
    mov ecx, dword ptr [eax + field_e59]         # 004ae1b1
    mov dword ptr [ebp - local_8], ecx           # 004ae1b7
    mov edx, dword ptr [ebp - local_8]           # 004ae1ba
    mov eax, dword ptr [edx]                     # 004ae1bd
    mov dword ptr [ebp - local_10], eax          # 004ae1bf
    mov ecx, dword ptr [ebp - local_28]          # 004ae1c2
    mov edx, dword ptr [ecx + field_c17]         # 004ae1c5
    add edx, 0x224                               # 004ae1cb
    mov eax, dword ptr [ebp - local_28]          # 004ae1d1
    add eax, 0xe79                               # 004ae1d4
    mov ecx, dword ptr [edx]                     # 004ae1d9
    mov dword ptr [eax], ecx                     # 004ae1db
    mov ecx, dword ptr [edx + field_4]           # 004ae1dd
    mov dword ptr [eax + field_4], ecx           # 004ae1e0
    mov ecx, dword ptr [edx + field_8]           # 004ae1e3
    mov dword ptr [eax + field_8], ecx           # 004ae1e6
    mov edx, dword ptr [edx + field_c]           # 004ae1e9
    mov dword ptr [eax + field_c], edx           # 004ae1ec
    mov eax, dword ptr [ebp - local_28]          # 004ae1ef
    mov ecx, dword ptr [ebp - local_28]          # 004ae1f2
    mov edx, dword ptr [eax + field_e81]         # 004ae1f5
    sub edx, dword ptr [ecx + field_e79]         # 004ae1fb
    add edx, 0x1                                 # 004ae201
    mov eax, dword ptr [ebp - local_28]          # 004ae204
    mov word ptr [eax + field_e71], dx           # 004ae207
    mov ecx, dword ptr [ebp - local_28]          # 004ae20e
    mov edx, dword ptr [ebp - local_28]          # 004ae211
    mov eax, dword ptr [ecx + field_e85]         # 004ae214
    sub eax, dword ptr [edx + field_e7d]         # 004ae21a
    add eax, 0x1                                 # 004ae220
    mov ecx, dword ptr [ebp - local_28]          # 004ae223
    mov word ptr [ecx + field_e73], ax           # 004ae226
    mov edx, dword ptr [ebp - local_28]          # 004ae22d
    mov dword ptr [edx + field_e5d], 0x0         # 004ae230
    mov eax, dword ptr [ebp - local_28]          # 004ae23a
    mov dword ptr [eax + field_e61], 0x0         # 004ae23d
    mov ecx, dword ptr [ebp - local_28]          # 004ae247
    movsx edx, word ptr [ecx + field_e73]        # 004ae24a
    mov eax, dword ptr [ebp - local_28]          # 004ae251
    mov ecx, dword ptr [eax + field_e61]         # 004ae254
    lea edx, [ecx + edx - field_minus_1]         # 004ae25a
    mov eax, dword ptr [ebp - local_28]          # 004ae25e
    mov dword ptr [eax + field_e69], edx         # 004ae261
    mov ecx, dword ptr [ebp - local_28]          # 004ae267
    movsx edx, word ptr [ecx + field_e71]        # 004ae26a
    mov eax, dword ptr [ebp - local_28]          # 004ae271
    mov ecx, dword ptr [eax + field_e5d]         # 004ae274
    lea edx, [ecx + edx - field_minus_1]         # 004ae27a
    mov eax, dword ptr [ebp - local_28]          # 004ae27e
    mov dword ptr [eax + field_e65], edx         # 004ae281
    mov ecx, dword ptr [ebp - local_28]          # 004ae287
    movsx edx, word ptr [ecx + field_e71]        # 004ae28a
    mov eax, dword ptr [ebp - local_28]          # 004ae291
    movsx ecx, word ptr [eax + field_e73]        # 004ae294
    imul edx, ecx                                # 004ae29b
    mov eax, dword ptr [ebp - local_28]          # 004ae29e
    mov dword ptr [eax + field_e75], edx         # 004ae2a1
    mov ecx, dword ptr [ebp - local_28]          # 004ae2a7
    mov edx, dword ptr [ecx + field_e75]         # 004ae2aa
    push edx                                     # 004ae2b0
    call FUN_0051dc43                            # 004ae2b1
    add esp, 0x4                                 # 004ae2b6
    mov dword ptr [ebp - local_24], eax          # 004ae2b9
    mov eax, dword ptr [ebp - local_28]          # 004ae2bc
    mov ecx, dword ptr [ebp - local_24]          # 004ae2bf
    mov dword ptr [eax + field_e6d], ecx         # 004ae2c2
    cmp dword ptr [ebp - local_24], 0x0          # 004ae2c8
    jne.d8 L_004ae2ea                            # 004ae2cc
    # block 0x004ae2ce: entered by fall-through of jne at 0x004ae2cc, 7 instruction(s), calls FUN_0050ca3e, ends with forward jump to 0x004ae44b
    push 0x5514e8                                # 004ae2ce
    mov edx, dword ptr [ebp - local_28]          # 004ae2d3
    add edx, 0xd39                               # 004ae2d6
    push edx                                     # 004ae2dc
    call FUN_0050ca3e                            # 004ae2dd
    add esp, 0x8                                 # 004ae2e2
    jmp.d32 L_004ae44b                           # 004ae2e5
L_004ae2ea:
    # block 0x004ae2ea: entered by jne at 0x004ae2cc, 23 instruction(s), ends with forward jump to 0x004ae340
    mov eax, dword ptr [ebp - local_28]          # 004ae2ea
    mov ecx, dword ptr [eax + field_e75]         # 004ae2ed
    {load} xor eax, eax                          # 004ae2f3
    mov edx, dword ptr [ebp - local_28]          # 004ae2f5
    mov edi, dword ptr [edx + field_e6d]         # 004ae2f8
    {load} mov edx, ecx                          # 004ae2fe
    shr ecx, 0x2                                 # 004ae300
    rep stosd dword ptr es:[edi], eax            # 004ae303
    {load} mov ecx, edx                          # 004ae305
    and ecx, 0x3                                 # 004ae307
    rep stosb byte ptr es:[edi], al              # 004ae30a
    mov byte ptr [ebp - local_14], 0x0           # 004ae30c
    mov al, byte ptr [ebp - local_14]            # 004ae310
    or al, -0x80                                 # 004ae313
    mov byte ptr [ebp - local_14], al            # 004ae315
    mov ecx, dword ptr [ebp - local_8]           # 004ae318
    movsx edx, word ptr [ecx + field_2f]         # 004ae31b
    mov dword ptr [ebp - local_20], edx          # 004ae31f
    mov dword ptr [ebp - local_c], 0x0           # 004ae322
    mov eax, dword ptr [ebp - local_28]          # 004ae329
    mov ecx, dword ptr [eax + field_e7d]         # 004ae32c
    mov dword ptr [ebp - local_1c], ecx          # 004ae332
    jmp.d8 L_004ae340                            # 004ae335
L_004ae337:
    # block 0x004ae337: entered by jmp at 0x004ae3c7, 3 instruction(s), falls into the block at 0x004ae340
    mov edx, dword ptr [ebp - local_1c]          # 004ae337
    add edx, 0x1                                 # 004ae33a
    mov dword ptr [ebp - local_1c], edx          # 004ae33d
L_004ae340:
    # block 0x004ae340: entered by jmp at 0x004ae335, 4 instruction(s), ends with jg to 0x004ae3cc (forward)
    mov eax, dword ptr [ebp - local_28]          # 004ae340
    mov ecx, dword ptr [ebp - local_1c]          # 004ae343
    cmp ecx, dword ptr [eax + field_e85]         # 004ae346
    jg.d8 L_004ae3cc                             # 004ae34c
    # block 0x004ae34e: entered by fall-through of jg at 0x004ae34c, 4 instruction(s), ends with forward jump to 0x004ae36e
    mov edx, dword ptr [ebp - local_28]          # 004ae34e
    mov eax, dword ptr [edx + field_e79]         # 004ae351
    mov dword ptr [ebp - local_18], eax          # 004ae357
    jmp.d8 L_004ae36e                            # 004ae35a
L_004ae35c:
    # block 0x004ae35c: entered by jmp at 0x004ae3c5, 6 instruction(s), falls into the block at 0x004ae36e
    mov ecx, dword ptr [ebp - local_18]          # 004ae35c
    add ecx, 0x1                                 # 004ae35f
    mov dword ptr [ebp - local_18], ecx          # 004ae362
    mov edx, dword ptr [ebp - local_c]           # 004ae365
    add edx, 0x1                                 # 004ae368
    mov dword ptr [ebp - local_c], edx           # 004ae36b
L_004ae36e:
    # block 0x004ae36e: entered by jmp at 0x004ae35a, 4 instruction(s), ends with jg to 0x004ae3c7 (forward)
    mov eax, dword ptr [ebp - local_28]          # 004ae36e
    mov ecx, dword ptr [ebp - local_18]          # 004ae371
    cmp ecx, dword ptr [eax + field_e81]         # 004ae374
    jg.d8 L_004ae3c7                             # 004ae37a
    # block 0x004ae37c: entered by fall-through of jg at 0x004ae37a, 15 instruction(s), ends with je to 0x004ae3c5 (forward)
    mov edx, dword ptr [ebp - local_1c]          # 004ae37c
    imul edx, dword ptr [ebp - local_20]         # 004ae37f
    mov eax, dword ptr [ebp - local_10]          # 004ae383
    {load} add eax, edx                          # 004ae386
    movsx ecx, word ptr [0x639895]               # 004ae388
    mov edx, dword ptr [ebp - local_18]          # 004ae38f
    imul edx, ecx                                # 004ae392
    mov ax, word ptr [eax + edx]                 # 004ae395
    mov word ptr [ebp - local_4], ax             # 004ae399
    mov ecx, dword ptr [ebp - local_4]           # 004ae39d
    and ecx, 0xffff                              # 004ae3a0
    {load} xor edx, edx                          # 004ae3a6
    mov dx, word ptr [0x5d2f29]                  # 004ae3a8
    {load} cmp ecx, edx                          # 004ae3af
    je.d8 L_004ae3c5                             # 004ae3b1
    # block 0x004ae3b3: entered by fall-through of je at 0x004ae3b1, 5 instruction(s), falls into the block at 0x004ae3c5
    mov eax, dword ptr [ebp - local_28]          # 004ae3b3
    mov ecx, dword ptr [eax + field_e6d]         # 004ae3b6
    mov edx, dword ptr [ebp - local_c]           # 004ae3bc
    mov al, byte ptr [ebp - local_14]            # 004ae3bf
    mov byte ptr [ecx + edx], al                 # 004ae3c2
L_004ae3c5:
    # block 0x004ae3c5: entered by je at 0x004ae3b1, 1 instruction(s), ends with backward jump to 0x004ae35c
    jmp.d8 L_004ae35c                            # 004ae3c5
L_004ae3c7:
    # block 0x004ae3c7: entered by jg at 0x004ae37a, 1 instruction(s), ends with backward jump to 0x004ae337
    jmp.d32 L_004ae337                           # 004ae3c7
L_004ae3cc:
    # block 0x004ae3cc: entered by jg at 0x004ae34c, 8 instruction(s), calls FUN_004c2dfb, ends with forward jump to 0x004ae44d
    mov ecx, dword ptr [ebp - local_28]          # 004ae3cc
    add ecx, 0xe59                               # 004ae3cf
    push ecx                                     # 004ae3d5
    mov ecx, 0x5cf659                            # 004ae3d6
    call FUN_004c2dfb                            # 004ae3db
    mov edx, dword ptr [ebp - local_28]          # 004ae3e0
    mov dword ptr [edx + field_e59], 0x0         # 004ae3e3
    jmp.d8 L_004ae44d                            # 004ae3ed
L_004ae3ef:
    # block 0x004ae3ef: entered by jmp at 0x004ae44b, 18 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with je to 0x004ae43f (forward)
    mov eax, dword ptr [ebp - local_28]          # 004ae3ef
    add eax, 0xd39                               # 004ae3f2
    push eax                                     # 004ae3f7
    push 0x551510                                # 004ae3f8
    mov ecx, dword ptr [ebp - local_28]          # 004ae3fd
    add ecx, 0xc39                               # 004ae400
    push ecx                                     # 004ae406
    call FUN_0050ca3e                            # 004ae407
    add esp, 0xc                                 # 004ae40c
    push 0x0                                     # 004ae40f
    push 0x0                                     # 004ae411
    mov edx, dword ptr [ebp - local_28]          # 004ae413
    add edx, 0xc39                               # 004ae416
    push edx                                     # 004ae41c
    call FUN_0052139c                            # 004ae41d
    movsx eax, word ptr [0x63a4cd]               # 004ae422
    test eax, eax                                # 004ae429
    je.d8 L_004ae43f                             # 004ae42b
    # block 0x004ae42d: entered by fall-through of je at 0x004ae42b, 5 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004ae43f
    mov ecx, dword ptr [ebp - local_28]          # 004ae42d
    add ecx, 0xc39                               # 004ae430
    push ecx                                     # 004ae436
    call FUN_0044a2b7                            # 004ae437
    add esp, 0x4                                 # 004ae43c
L_004ae43f:
    # block 0x004ae43f: entered by je at 0x004ae42b, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x004ae44d
    mov ecx, 0x5cf659                            # 004ae43f
    call FUN_004c97b4                            # 004ae444
    jmp.d8 L_004ae44d                            # 004ae449
L_004ae44b:
    # block 0x004ae44b: entered by jmp at 0x004ae2e5, 1 instruction(s), ends with backward jump to 0x004ae3ef
    jmp.d8 L_004ae3ef                            # 004ae44b
L_004ae44d:
    # block 0x004ae44d: entered by jmp at 0x004ae3ed; jmp at 0x004ae449, 4 instruction(s), ends with ret
    pop edi                                      # 004ae44d
    {load} mov esp, ebp                          # 004ae44e
    pop ebp                                      # 004ae450
    ret                                          # 004ae451

