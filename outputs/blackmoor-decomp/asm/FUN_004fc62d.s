# FUN_004fc62d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc62d
# extent:       0x004fc62d-0x004fc808 (475 code bytes)
# span:         0x004fc62d-0x004fc808 (code 475, tables 0, padding 0)
# sha256:       b1067b9796a241a15b875cf4504b715678f52459489249769ba6459313b9aeb2
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_file_load_requester
# naming:       INFERRED (lower confidence, not verified): the repository text his-audio-recovery.md:13 says "`0x4fc62d` reaches `0x4fadc4` for a requested file load."; src/action_family_97_runtime.c:118 says "then 0x4fc62d builds"
# name-note:    Builds the sound path and reaches 0x4fadc4 for a requested file load.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_108, local_10c, local_110, local_114, local_118
# fields:       [edx + n] field_132
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004fc808, FUN_0050cd72, FUN_00449d90, FUN_0052139c, FUN_004c97b4, FUN_004fadc4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 124 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_108, 0x108  # offset -0x108
.equ local_10c, 0x10c  # offset -0x10c
.equ local_110, 0x110  # offset -0x110
.equ local_114, 0x114  # offset -0x114
.equ local_118, 0x118  # offset -0x118
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_00449d90, .text + (0x00449d90 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_004fadc4, .text + (0x004fadc4 - 0x401000)
.set FUN_004fc808, .text + (0x004fc808 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004fc62d - 0x401000
.globl FUN_004fc62d
FUN_004fc62d:
    # block 0x004fc62d: entry, 6 instruction(s), ends with jne to 0x004fc650 (forward)
    push ebp                                     # 004fc62d
    {load} mov ebp, esp                          # 004fc62e
    sub esp, 0x118                               # 004fc630
    mov dword ptr [ebp - local_10c], ecx         # 004fc636
    cmp dword ptr [ebp + arg_14], 0x0            # 004fc63c
    jne.d8 L_004fc650                            # 004fc640
    # block 0x004fc642: entered by fall-through of jne at 0x004fc640, 3 instruction(s), ends with forward jump to 0x004fc659
    lea eax, [ebp - local_108]                   # 004fc642
    mov dword ptr [ebp - local_110], eax         # 004fc648
    jmp.d8 L_004fc659                            # 004fc64e
L_004fc650:
    # block 0x004fc650: entered by jne at 0x004fc640, 2 instruction(s), falls into the block at 0x004fc659
    mov ecx, dword ptr [ebp + arg_14]            # 004fc650
    mov dword ptr [ebp - local_110], ecx         # 004fc653
L_004fc659:
    # block 0x004fc659: entered by jmp at 0x004fc64e, 5 instruction(s), ends with je to 0x004fc6bc (forward)
    mov edx, dword ptr [ebp - local_110]         # 004fc659
    mov dword ptr [ebp - local_4], edx           # 004fc65f
    movsx eax, word ptr [0x63a4cd]               # 004fc662
    test eax, eax                                # 004fc669
    je.d8 L_004fc6bc                             # 004fc66b
    # block 0x004fc66d: entered by fall-through of je at 0x004fc66b, 2 instruction(s), ends with je to 0x004fc67f (forward)
    cmp dword ptr [ebp + arg_18], 0x0            # 004fc66d
    je.d8 L_004fc67f                             # 004fc671
    # block 0x004fc673: entered by fall-through of je at 0x004fc671, 2 instruction(s), ends with forward jump to 0x004fc689
    mov dword ptr [ebp - local_114], 0x56084c    # 004fc673
    jmp.d8 L_004fc689                            # 004fc67d
L_004fc67f:
    # block 0x004fc67f: entered by je at 0x004fc671, 1 instruction(s), falls into the block at 0x004fc689
    mov dword ptr [ebp - local_114], 0x560854    # 004fc67f
L_004fc689:
    # block 0x004fc689: entered by jmp at 0x004fc67d, 14 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fc6bc
    mov ecx, dword ptr [ebp - local_114]         # 004fc689
    push ecx                                     # 004fc68f
    mov edx, dword ptr [ebp + arg_c]             # 004fc690
    push edx                                     # 004fc693
    mov eax, dword ptr [ebp + arg_8]             # 004fc694
    and eax, 0xffff                              # 004fc697
    push eax                                     # 004fc69c
    push 0x56085c                                # 004fc69d
    push 0x63888b                                # 004fc6a2
    call FUN_0050ca3e                            # 004fc6a7
    add esp, 0x14                                # 004fc6ac
    push 0x63888b                                # 004fc6af
    call FUN_0044a2b7                            # 004fc6b4
    add esp, 0x4                                 # 004fc6b9
L_004fc6bc:
    # block 0x004fc6bc: entered by je at 0x004fc66b, 8 instruction(s), ends with je to 0x004fc722 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004fc6bc
    and ecx, 0xffff                              # 004fc6bf
    imul ecx, ecx, 0x5bb                         # 004fc6c5
    mov edx, dword ptr [ebp - local_10c]         # 004fc6cb
    {load} xor eax, eax                          # 004fc6d1
    mov ax, word ptr [edx + ecx + field_132]     # 004fc6d3
    test eax, eax                                # 004fc6db
    je.d8 L_004fc722                             # 004fc6dd
    # block 0x004fc6df: entered by fall-through of je at 0x004fc6dd, 7 instruction(s), calls FUN_004fc808, ends with je to 0x004fc722 (forward)
    mov cx, word ptr [ebp + arg_8]               # 004fc6df
    push ecx                                     # 004fc6e3
    mov ecx, dword ptr [ebp - local_10c]         # 004fc6e4
    call FUN_004fc808                            # 004fc6ea
    movsx edx, word ptr [0x63a4cd]               # 004fc6ef
    test edx, edx                                # 004fc6f6
    je.d8 L_004fc722                             # 004fc6f8
    # block 0x004fc6fa: entered by fall-through of je at 0x004fc6f8, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fc722
    mov eax, dword ptr [ebp + arg_8]             # 004fc6fa
    and eax, 0xffff                              # 004fc6fd
    push eax                                     # 004fc702
    push 0x560890                                # 004fc703
    push 0x63888b                                # 004fc708
    call FUN_0050ca3e                            # 004fc70d
    add esp, 0xc                                 # 004fc712
    push 0x63888b                                # 004fc715
    call FUN_0044a2b7                            # 004fc71a
    add esp, 0x4                                 # 004fc71f
L_004fc722:
    # block 0x004fc722: entered by je at 0x004fc6dd; je at 0x004fc6f8, 5 instruction(s), ends with je to 0x004fc746 (forward)
    mov dword ptr [ebp + arg_10], 0x1            # 004fc722
    mov ecx, dword ptr [ebp + arg_10]            # 004fc729
    mov dword ptr [ebp - local_118], ecx         # 004fc72c
    cmp dword ptr [ebp - local_118], 0x1         # 004fc732
    je.d8 L_004fc746                             # 004fc739
    # block 0x004fc73b: entered by fall-through of je at 0x004fc739, 2 instruction(s), ends with je to 0x004fc779 (forward)
    cmp dword ptr [ebp - local_118], 0x2         # 004fc73b
    je.d8 L_004fc779                             # 004fc742
    # block 0x004fc744: entered by fall-through of je at 0x004fc742, 1 instruction(s), ends with forward jump to 0x004fc79a
    jmp.d8 L_004fc79a                            # 004fc744
L_004fc746:
    # block 0x004fc746: entered by je at 0x004fc739, 15 instruction(s), calls FUN_0050cd72, FUN_00449d90, ends with jne to 0x004fc777 (forward)
    push 0x5608cc                                # 004fc746
    mov edx, dword ptr [ebp + arg_c]             # 004fc74b
    push edx                                     # 004fc74e
    push 0x63a0bd                                # 004fc74f
    push 0x639dae                                # 004fc754
    mov eax, dword ptr [ebp - local_4]           # 004fc759
    push eax                                     # 004fc75c
    call FUN_0050cd72                            # 004fc75d
    add esp, 0x14                                # 004fc762
    mov ecx, dword ptr [ebp - local_4]           # 004fc765
    push ecx                                     # 004fc768
    call FUN_00449d90                            # 004fc769
    add esp, 0x4                                 # 004fc76e
    test eax, eax                                # 004fc771
    jne.d8 L_004fc777                            # 004fc773
    # block 0x004fc775: entered by fall-through of jne at 0x004fc773, 1 instruction(s), ends with forward jump to 0x004fc779
    jmp.d8 L_004fc779                            # 004fc775
L_004fc777:
    # block 0x004fc777: entered by jne at 0x004fc773, 1 instruction(s), ends with forward jump to 0x004fc7e8
    jmp.d8 L_004fc7e8                            # 004fc777
L_004fc779:
    # block 0x004fc779: entered by je at 0x004fc742; jmp at 0x004fc775, 10 instruction(s), calls FUN_0050cd72, ends with forward jump to 0x004fc7e8
    push 0x5608d4                                # 004fc779
    mov edx, dword ptr [ebp + arg_c]             # 004fc77e
    push edx                                     # 004fc781
    push 0x63a1c1                                # 004fc782
    push 0x639dab                                # 004fc787
    mov eax, dword ptr [ebp - local_4]           # 004fc78c
    push eax                                     # 004fc78f
    call FUN_0050cd72                            # 004fc790
    add esp, 0x14                                # 004fc795
    jmp.d8 L_004fc7e8                            # 004fc798
L_004fc79a:
    # block 0x004fc79a: entered by jmp at 0x004fc744, 7 instruction(s), calls FUN_0050ca3e, ends with je to 0x004fc7c4 (forward)
    push 0x5608dc                                # 004fc79a
    push 0x63888b                                # 004fc79f
    call FUN_0050ca3e                            # 004fc7a4
    add esp, 0x8                                 # 004fc7a9
    movsx ecx, word ptr [0x63a4cd]               # 004fc7ac
    test ecx, ecx                                # 004fc7b3
    je.d8 L_004fc7c4                             # 004fc7b5
    # block 0x004fc7b7: entered by fall-through of je at 0x004fc7b5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fc7c4
    push 0x63888b                                # 004fc7b7
    call FUN_0044a2b7                            # 004fc7bc
    add esp, 0x4                                 # 004fc7c1
L_004fc7c4:
    # block 0x004fc7c4: entered by je at 0x004fc7b5, 8 instruction(s), calls FUN_0052139c, FUN_004c97b4, ends with forward jump to 0x004fc802
    push 0x0                                     # 004fc7c4
    push 0x0                                     # 004fc7c6
    push 0x63888b                                # 004fc7c8
    call FUN_0052139c                            # 004fc7cd
    mov dword ptr [0x63a58a], 0x5                # 004fc7d2
    mov ecx, 0x5cf659                            # 004fc7dc
    call FUN_004c97b4                            # 004fc7e1
    jmp.d8 L_004fc802                            # 004fc7e6
L_004fc7e8:
    # block 0x004fc7e8: entered by jmp at 0x004fc777; jmp at 0x004fc798, 2 instruction(s), ends with je to 0x004fc802 (forward)
    cmp dword ptr [ebp + arg_18], 0x0            # 004fc7e8
    je.d8 L_004fc802                             # 004fc7ec
    # block 0x004fc7ee: entered by fall-through of je at 0x004fc7ec, 6 instruction(s), calls FUN_004fadc4, falls into the block at 0x004fc802
    mov dx, word ptr [ebp + arg_8]               # 004fc7ee
    push edx                                     # 004fc7f2
    mov eax, dword ptr [ebp - local_4]           # 004fc7f3
    push eax                                     # 004fc7f6
    mov ecx, dword ptr [ebp - local_10c]         # 004fc7f7
    call FUN_004fadc4                            # 004fc7fd
L_004fc802:
    # block 0x004fc802: entered by jmp at 0x004fc7e6; je at 0x004fc7ec, 3 instruction(s), ends with ret 0x14
    {load} mov esp, ebp                          # 004fc802
    pop ebp                                      # 004fc804
    ret 0x14                                     # 004fc805

