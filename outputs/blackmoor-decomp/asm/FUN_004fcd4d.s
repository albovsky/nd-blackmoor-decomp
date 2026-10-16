# FUN_004fcd4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcd4d
# extent:       0x004fcd4d-0x004fcd69 (28 code bytes)
# span:         0x004fcd4d-0x004fcd69 (code 28, tables 0, padding 0)
# sha256:       dce9b8d981406ff59d82b6418e1d606f4b82cb6c7b5099248702c81d45634d2c
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fcd4d
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fccf2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004fccf2, .text + (0x004fccf2 - 0x401000)

.org 0x004fcd4d - 0x401000
.globl FUN_004fcd4d
FUN_004fcd4d:
    # block 0x004fcd4d: entry, 12 instruction(s), calls FUN_004fccf2, ends with ret 0x4
    push ebp                                     # 004fcd4d
    {load} mov ebp, esp                          # 004fcd4e
    push ecx                                     # 004fcd50
    mov dword ptr [ebp - local_4], ecx           # 004fcd51
    push 0x0                                     # 004fcd54
    mov ax, word ptr [ebp + arg_8]               # 004fcd56
    push eax                                     # 004fcd5a
    mov ecx, dword ptr [ebp - local_4]           # 004fcd5b
    call FUN_004fccf2                            # 004fcd5e
    {load} mov esp, ebp                          # 004fcd63
    pop ebp                                      # 004fcd65
    ret 0x4                                      # 004fcd66

