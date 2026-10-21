# FUN_004d529b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d529b
# extent:       0x004d529b-0x004d52a6 (11 code bytes)
# span:         0x004d529b-0x004d52a6 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d529b_empty_method
# naming:       native port src/original_methods_fl36b.c:m4d529b_empty_method (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4d529b_empty_method (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d529b - 0x401000
.globl FUN_004d529b
FUN_004d529b:
    # block 0x004d529b: entry, 7 instruction(s), ends with ret
    push ebp                                     # 004d529b
    {load} mov ebp, esp                          # 004d529c
    push ecx                                     # 004d529e
    mov dword ptr [ebp - local_4], ecx           # 004d529f
    {load} mov esp, ebp                          # 004d52a2
    pop ebp                                      # 004d52a4
    ret                                          # 004d52a5

