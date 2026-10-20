# FUN_0046b79a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b79a
# extent:       0x0046b79a-0x0046b855 (187 code bytes)
# span:         0x0046b79a-0x0046b855 (code 187, tables 0, padding 0)
# sha256:       29ff3e67810005fb00fbd615f715458c81bd95f6cf650c15f2400ceea7cd808a
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_gridmap_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/46b79a.c.txt, not original source) refers to the data labelled s_Loaded_AT_GRIDMAP_PUZZLE_action_r_0054bccc, s_for_SCENE__d__pData_for_ACTION_R_0054bc84
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_GRIDMAP_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0046b79a - 0x401000
.globl FUN_0046b79a
FUN_0046b79a:
    # block 0x0046b79a: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0046b801 (forward)
    push ebp                                     # 0046b79a
    {load} mov ebp, esp                          # 0046b79b
    sub esp, 0x8                                 # 0046b79d
    push esi                                     # 0046b7a0
    push edi                                     # 0046b7a1
    mov dword ptr [ebp - local_8], ecx           # 0046b7a2
    push 0x6e3                                   # 0046b7a5
    call FUN_0051dc43                            # 0046b7aa
    add esp, 0x4                                 # 0046b7af
    mov dword ptr [ebp - local_4], eax           # 0046b7b2
    mov eax, dword ptr [ebp + arg_8]             # 0046b7b5
    mov ecx, dword ptr [ebp - local_4]           # 0046b7b8
    mov dword ptr [eax], ecx                     # 0046b7bb
    cmp dword ptr [ebp - local_4], 0x0           # 0046b7bd
    jne.d8 L_0046b801                            # 0046b7c1
    # block 0x0046b7c3: entered by fall-through of jne at 0x0046b7c1, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0046b801
    movsx edx, word ptr [0x5c39e3]               # 0046b7c3
    push edx                                     # 0046b7ca
    mov eax, dword ptr [0x5bb57b]                # 0046b7cb
    push eax                                     # 0046b7d0
    push 0x54bc84                                # 0046b7d1
    push 0x63888b                                # 0046b7d6
    call FUN_0050ca3e                            # 0046b7db
    add esp, 0x10                                # 0046b7e0
    push 0x63888b                                # 0046b7e3
    push 0x54bcb0                                # 0046b7e8
    mov ecx, 0x583979                            # 0046b7ed
    call FUN_0042639d                            # 0046b7f2
    mov ecx, 0x5cf659                            # 0046b7f7
    call FUN_004c97b4                            # 0046b7fc
L_0046b801:
    # block 0x0046b801: entered by jne at 0x0046b7c1, 21 instruction(s), ends with je to 0x0046b84d (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0046b801
    mov esi, dword ptr [ecx]                     # 0046b804
    mov edx, dword ptr [ebp + arg_8]             # 0046b806
    mov edi, dword ptr [edx]                     # 0046b809
    mov ecx, 0x1b8                               # 0046b80b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0046b810
    movsw word ptr es:[edi], word ptr [esi]      # 0046b812
    movsb byte ptr es:[edi], byte ptr [esi]      # 0046b814
    mov eax, dword ptr [ebp + arg_10]            # 0046b815
    mov ecx, dword ptr [eax]                     # 0046b818
    add ecx, 0x6e3                               # 0046b81a
    mov edx, dword ptr [ebp + arg_10]            # 0046b820
    mov dword ptr [edx], ecx                     # 0046b823
    mov eax, dword ptr [ebp + arg_c]             # 0046b825
    mov ecx, dword ptr [eax]                     # 0046b828
    add ecx, 0x6e3                               # 0046b82a
    mov edx, dword ptr [ebp + arg_c]             # 0046b830
    mov dword ptr [edx], ecx                     # 0046b833
    movsx eax, word ptr [0x63a4cd]               # 0046b835
    test eax, eax                                # 0046b83c
    je.d8 L_0046b84d                             # 0046b83e
    # block 0x0046b840: entered by fall-through of je at 0x0046b83e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0046b84d
    push 0x54bccc                                # 0046b840
    call FUN_0044a2b7                            # 0046b845
    add esp, 0x4                                 # 0046b84a
L_0046b84d:
    # block 0x0046b84d: entered by je at 0x0046b83e, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0046b84d
    pop esi                                      # 0046b84e
    {load} mov esp, ebp                          # 0046b84f
    pop ebp                                      # 0046b851
    ret 0xc                                      # 0046b852

