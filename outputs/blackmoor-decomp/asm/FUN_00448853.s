# FUN_00448853
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448853
# extent:       0x00448853-0x0044885e (11 code bytes)
# span:         0x00448853-0x0044885e (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m448853_empty_method
# naming:       native port src/original_methods_fl36b.c:m448853_empty_method (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m448853_empty_method (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00448853 - 0x401000
.globl FUN_00448853
FUN_00448853:
    # block 0x00448853: entry, 7 instruction(s), ends with ret
    push ebp                                     # 00448853
    {load} mov ebp, esp                          # 00448854
    push ecx                                     # 00448856
    mov dword ptr [ebp - local_4], ecx           # 00448857
    {load} mov esp, ebp                          # 0044885a
    pop ebp                                      # 0044885c
    ret                                          # 0044885d

