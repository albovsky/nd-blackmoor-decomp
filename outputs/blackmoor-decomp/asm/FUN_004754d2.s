# FUN_004754d2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004754d2
# extent:       0x004754d2-0x004756b7 (485 code bytes)
# span:         0x004754d2-0x004756c0 (code 485, tables 0, padding 9)
# sha256:       9e66ecc3337cc787b6c865e4796b94a7782bad49492fc6aca3f8da0f518002ce
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_magnetmaze_puzzle_renderer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4754d2.c.txt, not original source) refers to the data labelled s_MAGNETMAZEPUZZLE___non_transpare_0054c790, s_MAGNETMAZEPUZZLE___refresh_entir_0054c6d8
# name-note:    Redraws the MagnetMaze puzzle: refreshes the entire area, then draws transparent and non-transparent pieces depending on flags.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_102, field_103, field_107; [ecx + n] field_42, field_107; [edx + n] field_42
# callees:      calls FUN_004c5377, FUN_004c5d4b, FUN_004e2b99
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4754d2_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 130 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_42, 0x42  # offset +0x42
.equ field_102, 0x102  # offset +0x102
.equ field_103, 0x103  # offset +0x103
.equ field_107, 0x107  # offset +0x107

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)

.org 0x004754d2 - 0x401000
.globl FUN_004754d2
FUN_004754d2:
    # block 0x004754d2: entry, 9 instruction(s), ends with je to 0x00475508 (forward)
    push ebp                                     # 004754d2
    {load} mov ebp, esp                          # 004754d3
    sub esp, 0xc                                 # 004754d5
    mov eax, dword ptr [0x61e9d2]                # 004754d8
    mov dword ptr [ebp - local_4], eax           # 004754dd
    mov ecx, dword ptr [0x5a4bce]                # 004754e0
    mov dword ptr [ebp - local_8], ecx           # 004754e6
    cmp dword ptr [0x61e9d6], 0x0                # 004754e9
    je.d8 L_00475508                             # 004754f0
    # block 0x004754f2: entered by fall-through of je at 0x004754f0, 4 instruction(s), ends with je to 0x0047550d (forward)
    movsx edx, word ptr [0x61e968]               # 004754f2
    imul edx, edx, 0x8d                          # 004754f9
    cmp dword ptr [edx + 0x5bb632], 0x1          # 004754ff
    je.d8 L_0047550d                             # 00475506
L_00475508:
    # block 0x00475508: entered by je at 0x004754f0; fall-through of je at 0x00475506, 1 instruction(s), ends with forward jump to 0x004756b3
    jmp.d32 L_004756b3                           # 00475508
L_0047550d:
    # block 0x0047550d: entered by je at 0x00475506, 11 instruction(s), calls FUN_004c5377, ends with forward jump to 0x00475545
    push 0x54c6d8                                # 0047550d
    push 0x583186                                # 00475512
    push 0x583196                                # 00475517
    mov eax, dword ptr [0x5cf665]                # 0047551c
    push eax                                     # 00475521
    mov ecx, dword ptr [0x5d15e3]                # 00475522
    push ecx                                     # 00475528
    mov ecx, 0x5cf659                            # 00475529
    call FUN_004c5377                            # 0047552e
    mov dword ptr [ebp - local_c], 0x0           # 00475533
    jmp.d8 L_00475545                            # 0047553a
L_0047553c:
    # block 0x0047553c: entered by jmp at 0x00475598, 3 instruction(s), falls into the block at 0x00475545
    mov edx, dword ptr [ebp - local_c]           # 0047553c
    add edx, 0x1                                 # 0047553f
    mov dword ptr [ebp - local_c], edx           # 00475542
L_00475545:
    # block 0x00475545: entered by jmp at 0x0047553a, 2 instruction(s), ends with jge to 0x0047559a (forward)
    cmp dword ptr [ebp - local_c], 0x4           # 00475545
    jge.d8 L_0047559a                            # 00475549
    # block 0x0047554b: entered by fall-through of jge at 0x00475549, 3 instruction(s), ends with je to 0x00475598 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0047554b
    cmp eax, dword ptr [ebp - local_8]           # 0047554e
    je.d8 L_00475598                             # 00475551
    # block 0x00475553: entered by fall-through of je at 0x00475551, 18 instruction(s), calls FUN_004c5d4b, falls into the block at 0x00475598
    push 0x54c708                                # 00475553
    mov ecx, dword ptr [ebp - local_c]           # 00475558
    shl ecx, 0x4                                 # 0047555b
    add ecx, 0x61eac2                            # 0047555e
    push ecx                                     # 00475564
    mov edx, dword ptr [ebp - local_c]           # 00475565
    shl edx, 0x4                                 # 00475568
    mov eax, dword ptr [ebp - local_4]           # 0047556b
    lea ecx, [eax + edx + field_107]             # 0047556e
    push ecx                                     # 00475575
    mov edx, dword ptr [0x5cf665]                # 00475576
    push edx                                     # 0047557c
    movsx eax, word ptr [0x61e970]               # 0047557d
    imul eax, eax, 0x4a                          # 00475584
    mov ecx, dword ptr [eax + 0x5d1599]          # 00475587
    push ecx                                     # 0047558d
    mov ecx, 0x5cf659                            # 0047558e
    call FUN_004c5d4b                            # 00475593
L_00475598:
    # block 0x00475598: entered by je at 0x00475551, 1 instruction(s), ends with backward jump to 0x0047553c
    jmp.d8 L_0047553c                            # 00475598
L_0047559a:
    # block 0x0047559a: entered by jge at 0x00475549, 2 instruction(s), ends with je to 0x004755e4 (forward)
    cmp dword ptr [ebp - local_8], -0x1          # 0047559a
    je.d8 L_004755e4                             # 0047559e
    # block 0x004755a0: entered by fall-through of je at 0x0047559e, 18 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004755e4
    push 0x54c734                                # 004755a0
    mov edx, dword ptr [ebp - local_8]           # 004755a5
    shl edx, 0x4                                 # 004755a8
    add edx, 0x61eac2                            # 004755ab
    push edx                                     # 004755b1
    mov eax, dword ptr [ebp - local_8]           # 004755b2
    shl eax, 0x4                                 # 004755b5
    mov ecx, dword ptr [ebp - local_4]           # 004755b8
    lea edx, [ecx + eax + field_107]             # 004755bb
    push edx                                     # 004755c2
    mov eax, dword ptr [0x5cf665]                # 004755c3
    push eax                                     # 004755c8
    movsx ecx, word ptr [0x61e970]               # 004755c9
    imul ecx, ecx, 0x4a                          # 004755d0
    mov edx, dword ptr [ecx + 0x5d1599]          # 004755d3
    push edx                                     # 004755d9
    mov ecx, 0x5cf659                            # 004755da
    call FUN_004c5d4b                            # 004755df
L_004755e4:
    # block 0x004755e4: entered by je at 0x0047559e, 4 instruction(s), ends with jne to 0x004756a9 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004755e4
    movsx ecx, byte ptr [eax + field_103]        # 004755e7
    test ecx, ecx                                # 004755ee
    jne.d32 L_004756a9                           # 004755f0
    # block 0x004755f6: entered by fall-through of jne at 0x004755f0, 2 instruction(s), ends with forward jump to 0x00475608
    mov dword ptr [ebp - local_c], 0x0           # 004755f6
    jmp.d8 L_00475608                            # 004755fd
L_004755ff:
    # block 0x004755ff: entered by jmp at 0x004756a4, 3 instruction(s), falls into the block at 0x00475608
    mov edx, dword ptr [ebp - local_c]           # 004755ff
    add edx, 0x1                                 # 00475602
    mov dword ptr [ebp - local_c], edx           # 00475605
L_00475608:
    # block 0x00475608: entered by jmp at 0x004755fd, 2 instruction(s), ends with jge to 0x004756a9 (forward)
    cmp dword ptr [ebp - local_c], 0x6           # 00475608
    jge.d32 L_004756a9                           # 0047560c
    # block 0x00475612: entered by fall-through of jge at 0x0047560c, 4 instruction(s), ends with je to 0x00475663 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00475612
    movsx ecx, byte ptr [eax + field_102]        # 00475615
    test ecx, ecx                                # 0047561c
    je.d8 L_00475663                             # 0047561e
    # block 0x00475620: entered by fall-through of je at 0x0047561e, 19 instruction(s), calls FUN_004c5d4b, ends with forward jump to 0x004756a4
    push 0x54c768                                # 00475620
    mov edx, dword ptr [ebp - local_c]           # 00475625
    shl edx, 0x4                                 # 00475628
    add edx, 0x61e972                            # 0047562b
    push edx                                     # 00475631
    mov eax, dword ptr [ebp - local_c]           # 00475632
    shl eax, 0x4                                 # 00475635
    mov ecx, dword ptr [ebp - local_4]           # 00475638
    lea edx, [ecx + eax + field_42]              # 0047563b
    push edx                                     # 0047563f
    mov eax, dword ptr [0x5cf665]                # 00475640
    push eax                                     # 00475645
    movsx ecx, word ptr [0x61e970]               # 00475646
    imul ecx, ecx, 0x4a                          # 0047564d
    mov edx, dword ptr [ecx + 0x5d1599]          # 00475650
    push edx                                     # 00475656
    mov ecx, 0x5cf659                            # 00475657
    call FUN_004c5d4b                            # 0047565c
    jmp.d8 L_004756a4                            # 00475661
L_00475663:
    # block 0x00475663: entered by je at 0x0047561e, 18 instruction(s), calls FUN_004c5377, falls into the block at 0x004756a4
    push 0x54c790                                # 00475663
    mov eax, dword ptr [ebp - local_c]           # 00475668
    shl eax, 0x4                                 # 0047566b
    add eax, 0x61e972                            # 0047566e
    push eax                                     # 00475673
    mov ecx, dword ptr [ebp - local_c]           # 00475674
    shl ecx, 0x4                                 # 00475677
    mov edx, dword ptr [ebp - local_4]           # 0047567a
    lea eax, [edx + ecx + field_42]              # 0047567d
    push eax                                     # 00475681
    mov ecx, dword ptr [0x5cf665]                # 00475682
    push ecx                                     # 00475688
    movsx edx, word ptr [0x61e970]               # 00475689
    imul edx, edx, 0x4a                          # 00475690
    mov eax, dword ptr [edx + 0x5d1599]          # 00475693
    push eax                                     # 00475699
    mov ecx, 0x5cf659                            # 0047569a
    call FUN_004c5377                            # 0047569f
L_004756a4:
    # block 0x004756a4: entered by jmp at 0x00475661, 1 instruction(s), ends with backward jump to 0x004755ff
    jmp.d32 L_004755ff                           # 004756a4
L_004756a9:
    # block 0x004756a9: entered by jne at 0x004755f0; jge at 0x0047560c, 2 instruction(s), calls FUN_004e2b99, falls into the block at 0x004756b3
    mov ecx, 0x61eb02                            # 004756a9
    call FUN_004e2b99                            # 004756ae
L_004756b3:
    # block 0x004756b3: entered by jmp at 0x00475508, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004756b3
    pop ebp                                      # 004756b5
    ret                                          # 004756b6

# --- data items (not part of the function) -------------------------
.org 0x004756b7 - 0x401000
PAD_004756b7:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

