# FUN_00464100
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00464100
# extent:       0x00464100-0x004641bb (187 code bytes)
# span:         0x00464100-0x004641bb (code 187, tables 0, padding 0)
# sha256:       cbbd92f55bd2381e5cd302cf9d23d261f05008f72a2628f9aee413c55be940eb
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_cube_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/464100.c.txt, not original source) refers to the data labelled s_Loaded_AT_CUBE_PUZZLE_action_rec_0054b308, s_for_SCENE__d__pData_for_ACTION_R_0054b2c0
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_CUBE_PUZZLE.
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

.org 0x00464100 - 0x401000
.globl FUN_00464100
FUN_00464100:
    # block 0x00464100: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00464167 (forward)
    push ebp                                     # 00464100
    {load} mov ebp, esp                          # 00464101
    sub esp, 0x8                                 # 00464103
    push esi                                     # 00464106
    push edi                                     # 00464107
    mov dword ptr [ebp - local_8], ecx           # 00464108
    push 0x43f                                   # 0046410b
    call FUN_0051dc43                            # 00464110
    add esp, 0x4                                 # 00464115
    mov dword ptr [ebp - local_4], eax           # 00464118
    mov eax, dword ptr [ebp + arg_8]             # 0046411b
    mov ecx, dword ptr [ebp - local_4]           # 0046411e
    mov dword ptr [eax], ecx                     # 00464121
    cmp dword ptr [ebp - local_4], 0x0           # 00464123
    jne.d8 L_00464167                            # 00464127
    # block 0x00464129: entered by fall-through of jne at 0x00464127, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00464167
    movsx edx, word ptr [0x5c39e3]               # 00464129
    push edx                                     # 00464130
    mov eax, dword ptr [0x5bb57b]                # 00464131
    push eax                                     # 00464136
    push 0x54b2c0                                # 00464137
    push 0x63888b                                # 0046413c
    call FUN_0050ca3e                            # 00464141
    add esp, 0x10                                # 00464146
    push 0x63888b                                # 00464149
    push 0x54b2ec                                # 0046414e
    mov ecx, 0x583979                            # 00464153
    call FUN_0042639d                            # 00464158
    mov ecx, 0x5cf659                            # 0046415d
    call FUN_004c97b4                            # 00464162
L_00464167:
    # block 0x00464167: entered by jne at 0x00464127, 21 instruction(s), ends with je to 0x004641b3 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00464167
    mov esi, dword ptr [ecx]                     # 0046416a
    mov edx, dword ptr [ebp + arg_8]             # 0046416c
    mov edi, dword ptr [edx]                     # 0046416f
    mov ecx, 0x10f                               # 00464171
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00464176
    movsw word ptr es:[edi], word ptr [esi]      # 00464178
    movsb byte ptr es:[edi], byte ptr [esi]      # 0046417a
    mov eax, dword ptr [ebp + arg_10]            # 0046417b
    mov ecx, dword ptr [eax]                     # 0046417e
    add ecx, 0x43f                               # 00464180
    mov edx, dword ptr [ebp + arg_10]            # 00464186
    mov dword ptr [edx], ecx                     # 00464189
    mov eax, dword ptr [ebp + arg_c]             # 0046418b
    mov ecx, dword ptr [eax]                     # 0046418e
    add ecx, 0x43f                               # 00464190
    mov edx, dword ptr [ebp + arg_c]             # 00464196
    mov dword ptr [edx], ecx                     # 00464199
    movsx eax, word ptr [0x63a4cd]               # 0046419b
    test eax, eax                                # 004641a2
    je.d8 L_004641b3                             # 004641a4
    # block 0x004641a6: entered by fall-through of je at 0x004641a4, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004641b3
    push 0x54b308                                # 004641a6
    call FUN_0044a2b7                            # 004641ab
    add esp, 0x4                                 # 004641b0
L_004641b3:
    # block 0x004641b3: entered by je at 0x004641a4, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004641b3
    pop esi                                      # 004641b4
    {load} mov esp, ebp                          # 004641b5
    pop ebp                                      # 004641b7
    ret 0xc                                      # 004641b8

