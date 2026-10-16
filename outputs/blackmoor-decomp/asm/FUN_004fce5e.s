# FUN_004fce5e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fce5e
# extent:       0x004fce5e-0x004fce8e (48 code bytes)
# span:         0x004fce5e-0x004fce90 (code 48, tables 0, padding 2)
# sha256:       1b81e5242071f76d23abaa0517684f5b93e8963e4edb0fca0a79dcf653c8239f
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fce5e
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004f7e93
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004f7e93, .text + (0x004f7e93 - 0x401000)

.org 0x004fce5e - 0x401000
.globl FUN_004fce5e
FUN_004fce5e:
    # block 0x004fce5e: entry, 15 instruction(s), calls FUN_004f7e93, ends with ret 0x4
    push ebp                                     # 004fce5e
    {load} mov ebp, esp                          # 004fce5f
    sub esp, 0x8                                 # 004fce61
    mov dword ptr [ebp - local_8], ecx           # 004fce64
    movsx eax, word ptr [ebp + arg_8]            # 004fce67
    imul eax, eax, 0x8d                          # 004fce6b
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004fce71
    mov dword ptr [ebp - local_4], ecx           # 004fce77
    mov edx, dword ptr [ebp - local_4]           # 004fce7a
    push edx                                     # 004fce7d
    mov ecx, 0x5cf1eb                            # 004fce7e
    call FUN_004f7e93                            # 004fce83
    {load} mov esp, ebp                          # 004fce88
    pop ebp                                      # 004fce8a
    ret 0x4                                      # 004fce8b

# --- data items (not part of the function) -------------------------
.org 0x004fce8e - 0x401000
PAD_004fce8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

