# FUN_004e7d04
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7d04
# extent:       0x004e7d04-0x004e7d2e (42 code bytes)
# span:         0x004e7d04-0x004e7d2e (code 42, tables 0, padding 0)
# sha256:       f7cc1012916b165c716ecb86ae7d8f47938e8ed4668e7077833a054a4ae2d405
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7d04
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004edb97, FUN_004e7bf3, FUN_004d36ed
# track-n:      outputs/blackmoor-decomp/src/inventory_view_runtime.h:inventory_view_close (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e7bf3, .text + (0x004e7bf3 - 0x401000)
.set FUN_004edb97, .text + (0x004edb97 - 0x401000)

.org 0x004e7d04 - 0x401000
.globl FUN_004e7d04
FUN_004e7d04:
    # block 0x004e7d04: entry, 13 instruction(s), calls FUN_004edb97, FUN_004e7bf3, FUN_004d36ed, ends with ret
    push ebp                                     # 004e7d04
    {load} mov ebp, esp                          # 004e7d05
    push ecx                                     # 004e7d07
    mov dword ptr [ebp - local_4], ecx           # 004e7d08
    mov ecx, dword ptr [ebp - local_4]           # 004e7d0b
    call FUN_004edb97                            # 004e7d0e
    mov ecx, dword ptr [ebp - local_4]           # 004e7d13
    call FUN_004e7bf3                            # 004e7d16
    mov dword ptr [0x583204], 0x0                # 004e7d1b
    call FUN_004d36ed                            # 004e7d25
    {load} mov esp, ebp                          # 004e7d2a
    pop ebp                                      # 004e7d2c
    ret                                          # 004e7d2d

