# FUN_00447d60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447d60
# extent:       0x00447d60-0x00447d73 (19 code bytes)
# span:         0x00447d60-0x00447d80 (code 19, tables 0, padding 13)
# sha256:       42bf7a3ecffcc3b9468ae6d89a2cf9121e6a9f3a50f8f290d97fe0396ecd318c
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447d60_lifted
# naming:       native port src/original_methods_fl40.c:m447d60_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 9/9 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00447d4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m447d60_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00447d4b, .text + (0x00447d4b - 0x401000)

.org 0x00447d60 - 0x401000
.globl FUN_00447d60
FUN_00447d60:
    # block 0x00447d60: entry, 9 instruction(s), calls FUN_00447d4b, ends with ret
    push ebp                                     # 00447d60
    {load} mov ebp, esp                          # 00447d61
    push ecx                                     # 00447d63
    mov dword ptr [ebp - local_4], ecx           # 00447d64
    mov ecx, dword ptr [ebp - local_4]           # 00447d67
    call FUN_00447d4b                            # 00447d6a
    {load} mov esp, ebp                          # 00447d6f
    pop ebp                                      # 00447d71
    ret                                          # 00447d72

# --- data items (not part of the function) -------------------------
.org 0x00447d73 - 0x401000
PAD_00447d73:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

