# FUN_0048bc9b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bc9b
# extent:       0x0048bc9b-0x0048bca6 (11 code bytes)
# span:         0x0048bc9b-0x0048bca6 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48bc9b_empty_method
# naming:       native port src/original_methods_fl36b.c:m48bc9b_empty_method (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m48bc9b_empty_method (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0048bc9b - 0x401000
.globl FUN_0048bc9b
FUN_0048bc9b:
    # block 0x0048bc9b: entry, 7 instruction(s), ends with ret
    push ebp                                     # 0048bc9b
    {load} mov ebp, esp                          # 0048bc9c
    push ecx                                     # 0048bc9e
    mov dword ptr [ebp - local_4], ecx           # 0048bc9f
    {load} mov esp, ebp                          # 0048bca2
    pop ebp                                      # 0048bca4
    ret                                          # 0048bca5

