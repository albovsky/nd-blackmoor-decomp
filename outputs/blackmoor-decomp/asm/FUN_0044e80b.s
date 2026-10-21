# FUN_0044e80b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e80b
# extent:       0x0044e80b-0x0044e816 (11 code bytes)
# span:         0x0044e80b-0x0044e816 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e80b_empty_method
# naming:       native port src/original_methods_fl36b.c:m44e80b_empty_method (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m44e80b_empty_method (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044e80b - 0x401000
.globl FUN_0044e80b
FUN_0044e80b:
    # block 0x0044e80b: entry, 7 instruction(s), ends with ret
    push ebp                                     # 0044e80b
    {load} mov ebp, esp                          # 0044e80c
    push ecx                                     # 0044e80e
    mov dword ptr [ebp - local_4], ecx           # 0044e80f
    {load} mov esp, ebp                          # 0044e812
    pop ebp                                      # 0044e814
    ret                                          # 0044e815

