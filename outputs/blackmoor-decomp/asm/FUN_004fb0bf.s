# FUN_004fb0bf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fb0bf
# extent:       0x004fb0bf-0x004fb1c6 (263 code bytes)
# span:         0x004fb0bf-0x004fb1c6 (code 263, tables 0, padding 0)
# sha256:       6d828a9e1104bcfbe443fc15124b2d0a5d20509e16de6c4504f73909a0af32ae
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_restore_channel
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4fb0bf.c.txt, not original source) refers to the data labelled s_CSound__RestoreChannel_____chann_005606b4
# name-note:    Restores a saved channel by resuming it and clearing the saved flag; logs CSound::RestoreChannel.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_12c; [ecx + n] field_12c; [edx + n] field_132
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004f6624
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_12c, 0x12c  # offset +0x12c
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6624, .text + (0x004f6624 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fb0bf - 0x401000
.globl FUN_004fb0bf
FUN_004fb0bf:
    # block 0x004fb0bf: entry, 7 instruction(s), ends with je to 0x004fb0fa (forward)
    push ebp                                     # 004fb0bf
    {load} mov ebp, esp                          # 004fb0c0
    push ecx                                     # 004fb0c2
    mov dword ptr [ebp - local_4], ecx           # 004fb0c3
    movsx eax, word ptr [0x63a4cd]               # 004fb0c6
    test eax, eax                                # 004fb0cd
    je.d8 L_004fb0fa                             # 004fb0cf
    # block 0x004fb0d1: entered by fall-through of je at 0x004fb0cf, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb0fa
    mov ecx, dword ptr [ebp + arg_8]             # 004fb0d1
    and ecx, 0xffff                              # 004fb0d4
    push ecx                                     # 004fb0da
    push 0x5606b4                                # 004fb0db
    push 0x63888b                                # 004fb0e0
    call FUN_0050ca3e                            # 004fb0e5
    add esp, 0xc                                 # 004fb0ea
    push 0x63888b                                # 004fb0ed
    call FUN_0044a2b7                            # 004fb0f2
    add esp, 0x4                                 # 004fb0f7
L_004fb0fa:
    # block 0x004fb0fa: entered by je at 0x004fb0cf, 6 instruction(s), ends with je to 0x004fb1c0 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 004fb0fa
    and edx, 0xffff                              # 004fb0fd
    imul edx, edx, 0x5bb                         # 004fb103
    mov eax, dword ptr [ebp - local_4]           # 004fb109
    cmp dword ptr [eax + edx + field_12c], 0x0   # 004fb10c
    je.d32 L_004fb1c0                            # 004fb114
    # block 0x004fb11a: entered by fall-through of je at 0x004fb114, 8 instruction(s), ends with jne to 0x004fb1c0 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004fb11a
    and ecx, 0xffff                              # 004fb11d
    imul ecx, ecx, 0x5bb                         # 004fb123
    mov edx, dword ptr [ebp - local_4]           # 004fb129
    {load} xor eax, eax                          # 004fb12c
    mov ax, word ptr [edx + ecx + field_132]     # 004fb12e
    cmp eax, 0x2                                 # 004fb136
    jne.d32 L_004fb1c0                           # 004fb139
    # block 0x004fb13f: entered by fall-through of jne at 0x004fb139, 3 instruction(s), ends with je to 0x004fb173 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004fb13f
    test ecx, ecx                                # 004fb146
    je.d8 L_004fb173                             # 004fb148
    # block 0x004fb14a: entered by fall-through of je at 0x004fb148, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fb173
    mov edx, dword ptr [ebp + arg_8]             # 004fb14a
    and edx, 0xffff                              # 004fb14d
    push edx                                     # 004fb153
    push 0x5606ec                                # 004fb154
    push 0x63888b                                # 004fb159
    call FUN_0050ca3e                            # 004fb15e
    add esp, 0xc                                 # 004fb163
    push 0x63888b                                # 004fb166
    call FUN_0044a2b7                            # 004fb16b
    add esp, 0x4                                 # 004fb170
L_004fb173:
    # block 0x004fb173: entered by je at 0x004fb148, 16 instruction(s), calls FUN_004f6624, falls into the block at 0x004fb1c0
    push 0x0                                     # 004fb173
    mov eax, dword ptr [ebp + arg_8]             # 004fb175
    and eax, 0xffff                              # 004fb178
    push eax                                     # 004fb17d
    mov ecx, 0x5cf1eb                            # 004fb17e
    call FUN_004f6624                            # 004fb183
    mov ecx, dword ptr [ebp + arg_8]             # 004fb188
    and ecx, 0xffff                              # 004fb18b
    imul ecx, ecx, 0x5bb                         # 004fb191
    mov edx, dword ptr [ebp - local_4]           # 004fb197
    mov word ptr [edx + ecx + field_132], 0x1    # 004fb19a
    mov eax, dword ptr [ebp + arg_8]             # 004fb1a4
    and eax, 0xffff                              # 004fb1a7
    imul eax, eax, 0x5bb                         # 004fb1ac
    mov ecx, dword ptr [ebp - local_4]           # 004fb1b2
    mov dword ptr [ecx + eax + field_12c], 0x0   # 004fb1b5
L_004fb1c0:
    # block 0x004fb1c0: entered by je at 0x004fb114; jne at 0x004fb139, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004fb1c0
    pop ebp                                      # 004fb1c2
    ret 0x4                                      # 004fb1c3

