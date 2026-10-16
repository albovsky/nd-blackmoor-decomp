# FUN_004dd380
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd380
# extent:       0x004dd380-0x004dd3ae (46 code bytes)
# span:         0x004dd380-0x004dd3b0 (code 46, tables 0, padding 2)
# sha256:       33bcd7d241169e7c8f4b00f4b182055d80bcf887d4438cdce3339945ab2a3dc5
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dd380
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dbf6e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004dbf6e, .text + (0x004dbf6e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004dd380 - 0x401000
.globl FUN_004dd380
FUN_004dd380:
    # block 0x004dd380: entry, 10 instruction(s), calls FUN_004dbf6e, ends with je to 0x004dd3a5 (forward)
    push ebp                                     # 004dd380
    {load} mov ebp, esp                          # 004dd381
    push ecx                                     # 004dd383
    mov dword ptr [ebp - local_4], ecx           # 004dd384
    mov ecx, dword ptr [ebp - local_4]           # 004dd387
    call FUN_004dbf6e                            # 004dd38a
    mov eax, dword ptr [ebp + arg_8]             # 004dd38f
    and eax, 0x1                                 # 004dd392
    test eax, eax                                # 004dd395
    je.d8 L_004dd3a5                             # 004dd397
    # block 0x004dd399: entered by fall-through of je at 0x004dd397, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004dd3a5
    mov ecx, dword ptr [ebp - local_4]           # 004dd399
    push ecx                                     # 004dd39c
    call FUN_0051dc6c                            # 004dd39d
    add esp, 0x4                                 # 004dd3a2
L_004dd3a5:
    # block 0x004dd3a5: entered by je at 0x004dd397, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004dd3a5
    {load} mov esp, ebp                          # 004dd3a8
    pop ebp                                      # 004dd3aa
    ret 0x4                                      # 004dd3ab

# --- data items (not part of the function) -------------------------
.org 0x004dd3ae - 0x401000
PAD_004dd3ae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

