# FUN_00437614
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437614
# extent:       0x00437614-0x0043770a (246 code bytes)
# span:         0x00437614-0x00437710 (code 246, tables 0, padding 6)
# sha256:       192c8ec7771f51805458e7b98c5fbf5f75b639b4149981541b3591c6f0a617c9
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_game_cleanup_routine
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/437614.c.txt, not original source) refers to the data labelled s_Begin_CleanUp___00546a58
# name-note:    Begin CleanUp: sets shutdown state, restores a system parameter, frees ten entries and other resources, and shows the cursor again.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [edx + n] field_58
# callees:      calls FUN_0044a2b7, USER32.dll!SystemParametersInfoA, FUN_00425fc0, FUN_00433bd2, FUN_004fad50, FUN_0043dbe3, FUN_004e7c72, FUN_004c425e, USER32.dll!ShowCursor, FUN_0051dc6c; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 67 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------
.set FUN_00425fc0, .text + (0x00425fc0 - 0x401000)
.set FUN_00433bd2, .text + (0x00433bd2 - 0x401000)
.set FUN_0043dbe3, .text + (0x0043dbe3 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c425e, .text + (0x004c425e - 0x401000)
.set FUN_004e7c72, .text + (0x004e7c72 - 0x401000)
.set FUN_004fad50, .text + (0x004fad50 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00437614 - 0x401000
.globl FUN_00437614
FUN_00437614:
    # block 0x00437614: entry, 6 instruction(s), ends with je to 0x00437632 (forward)
    push ebp                                     # 00437614
    {load} mov ebp, esp                          # 00437615
    sub esp, 0xc                                 # 00437617
    movsx eax, word ptr [0x63a4cd]               # 0043761a
    test eax, eax                                # 00437621
    je.d8 L_00437632                             # 00437623
    # block 0x00437625: entered by fall-through of je at 0x00437623, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00437632
    push 0x546a58                                # 00437625
    call FUN_0044a2b7                            # 0043762a
    add esp, 0x4                                 # 0043762f
L_00437632:
    # block 0x00437632: entered by je at 0x00437623, 3 instruction(s), ends with je to 0x00437653 (forward)
    mov dword ptr [0x58397d], 0x2                # 00437632
    cmp dword ptr [0x63a586], 0x0                # 0043763c
    je.d8 L_00437653                             # 00437643
    # block 0x00437645: entered by fall-through of je at 0x00437643, 5 instruction(s), calls USER32.dll!SystemParametersInfoA, falls into the block at 0x00437653
    push 0x0                                     # 00437645
    push 0x0                                     # 00437647
    push 0x1                                     # 00437649
    push 0x11                                    # 0043764b
    call dword ptr [0x52a4bc]                    # 0043764d
L_00437653:
    # block 0x00437653: entered by je at 0x00437643, 3 instruction(s), calls FUN_00425fc0, ends with forward jump to 0x0043766a
    call FUN_00425fc0                            # 00437653
    mov dword ptr [ebp - local_4], 0x0           # 00437658
    jmp.d8 L_0043766a                            # 0043765f
L_00437661:
    # block 0x00437661: entered by jmp at 0x00437688, 3 instruction(s), falls into the block at 0x0043766a
    mov ecx, dword ptr [ebp - local_4]           # 00437661
    add ecx, 0x1                                 # 00437664
    mov dword ptr [ebp - local_4], ecx           # 00437667
L_0043766a:
    # block 0x0043766a: entered by jmp at 0x0043765f, 2 instruction(s), ends with jge to 0x0043768a (forward)
    cmp dword ptr [ebp - local_4], 0xa           # 0043766a
    jge.d8 L_0043768a                            # 0043766e
    # block 0x00437670: entered by fall-through of jge at 0x0043766e, 7 instruction(s), calls FUN_00433bd2, ends with backward jump to 0x00437661
    mov edx, dword ptr [ebp - local_4]           # 00437670
    imul edx, edx, 0x106                         # 00437673
    add edx, 0x585d65                            # 00437679
    push edx                                     # 0043767f
    call FUN_00433bd2                            # 00437680
    add esp, 0x4                                 # 00437685
    jmp.d8 L_00437661                            # 00437688
L_0043768a:
    # block 0x0043768a: entered by jge at 0x0043766e, 12 instruction(s), calls FUN_004fad50, FUN_0043dbe3, FUN_004e7c72, FUN_004c425e, USER32.dll!ShowCursor, falls into the block at 0x004376bd
    mov ecx, 0x5c3a67                            # 0043768a
    call FUN_004fad50                            # 0043768f
    push 0x0                                     # 00437694
    call FUN_0043dbe3                            # 00437696
    add esp, 0x4                                 # 0043769b
    mov ecx, 0x571442                            # 0043769e
    call FUN_004e7c72                            # 004376a3
    mov ecx, 0x5cf659                            # 004376a8
    call FUN_004c425e                            # 004376ad
    push 0x1                                     # 004376b2
    call dword ptr [0x52a4cc]                    # 004376b4
    mov dword ptr [ebp - local_c], eax           # 004376ba
L_004376bd:
    # block 0x004376bd: entered by jmp at 0x004376ce, 2 instruction(s), ends with jge to 0x004376d0 (forward)
    cmp dword ptr [ebp - local_c], 0x0           # 004376bd
    jge.d8 L_004376d0                            # 004376c1
    # block 0x004376c3: entered by fall-through of jge at 0x004376c1, 4 instruction(s), calls USER32.dll!ShowCursor, ends with backward jump to 0x004376bd
    push 0x1                                     # 004376c3
    call dword ptr [0x52a4cc]                    # 004376c5
    mov dword ptr [ebp - local_c], eax           # 004376cb
    jmp.d8 L_004376bd                            # 004376ce
L_004376d0:
    # block 0x004376d0: entered by jge at 0x004376c1, 2 instruction(s), ends with je to 0x004376e9 (forward)
    cmp dword ptr [0x57044c], 0x0                # 004376d0
    je.d8 L_004376e9                             # 004376d7
    # block 0x004376d9: entered by fall-through of je at 0x004376d7, 4 instruction(s), calls indirect dword ptr [edx + 0x58], falls into the block at 0x004376e9
    mov eax, dword ptr [0x57044c]                # 004376d9
    mov edx, dword ptr [eax]                     # 004376de
    mov ecx, dword ptr [0x57044c]                # 004376e0
    call dword ptr [edx + field_58]              # 004376e6
L_004376e9:
    # block 0x004376e9: entered by je at 0x004376d7, 2 instruction(s), ends with je to 0x00437706 (forward)
    cmp dword ptr [0x570448], 0x0                # 004376e9
    je.d8 L_00437706                             # 004376f0
    # block 0x004376f2: entered by fall-through of je at 0x004376f0, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00437706
    mov eax, dword ptr [0x570448]                # 004376f2
    mov dword ptr [ebp - local_8], eax           # 004376f7
    mov ecx, dword ptr [ebp - local_8]           # 004376fa
    push ecx                                     # 004376fd
    call FUN_0051dc6c                            # 004376fe
    add esp, 0x4                                 # 00437703
L_00437706:
    # block 0x00437706: entered by je at 0x004376f0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00437706
    pop ebp                                      # 00437708
    ret                                          # 00437709

# --- data items (not part of the function) -------------------------
.org 0x0043770a - 0x401000
PAD_0043770a:  # 6 byte(s) of int3 padding
    .fill 6, 1, 0xcc

