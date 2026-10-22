# FUN_004fcd85
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcd85
# extent:       0x004fcd85-0x004fcda1 (28 code bytes)
# span:         0x004fcd85-0x004fcda1 (code 28, tables 0, padding 0)
# sha256:       99f72774f27f74a472156cde00295847885c53ec4e1996428bff56f9d14f20f8
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fcd85_forward_word
# naming:       native port src/original_methods_fl39c.c:m4fcd85_forward_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4fccf2(this = self, stack word argument (low 16 bits meaningful), 2) and returns its eax; pops 4 bytes. No jumps; all 12 instructions run.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fccf2
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39c.c:m4fcd85_forward_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004fccf2, .text + (0x004fccf2 - 0x401000)

.org 0x004fcd85 - 0x401000
.globl FUN_004fcd85
FUN_004fcd85:
    # block 0x004fcd85: entry, 12 instruction(s), calls FUN_004fccf2, ends with ret 0x4
    push ebp                                     # 004fcd85
    {load} mov ebp, esp                          # 004fcd86
    push ecx                                     # 004fcd88
    mov dword ptr [ebp - local_4], ecx           # 004fcd89
    push 0x2                                     # 004fcd8c
    mov ax, word ptr [ebp + arg_8]               # 004fcd8e
    push eax                                     # 004fcd92
    mov ecx, dword ptr [ebp - local_4]           # 004fcd93
    call FUN_004fccf2                            # 004fcd96
    {load} mov esp, ebp                          # 004fcd9b
    pop ebp                                      # 004fcd9d
    ret 0x4                                      # 004fcd9e

