# FUN_004fcd69
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcd69
# extent:       0x004fcd69-0x004fcd85 (28 code bytes)
# span:         0x004fcd69-0x004fcd85 (code 28, tables 0, padding 0)
# sha256:       8312e0a944199112acf1b320cc9d786ac2582403d3cb7e46a848d8d1e4da0e08
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fcd69
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

.org 0x004fcd69 - 0x401000
.globl FUN_004fcd69
FUN_004fcd69:
    # block 0x004fcd69: entry, 12 instruction(s), calls FUN_004fccf2, ends with ret 0x4
    push ebp                                     # 004fcd69
    {load} mov ebp, esp                          # 004fcd6a
    push ecx                                     # 004fcd6c
    mov dword ptr [ebp - local_4], ecx           # 004fcd6d
    push 0x1                                     # 004fcd70
    mov ax, word ptr [ebp + arg_8]               # 004fcd72
    push eax                                     # 004fcd76
    mov ecx, dword ptr [ebp - local_4]           # 004fcd77
    call FUN_004fccf2                            # 004fcd7a
    {load} mov esp, ebp                          # 004fcd7f
    pop ebp                                      # 004fcd81
    ret 0x4                                      # 004fcd82

