# FUN_0041a4be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041a4be
# extent:       0x0041a4be-0x0041a4c9 (11 code bytes)
# span:         0x0041a4be-0x0041a4c9 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41a4be_empty_method
# naming:       native port src/original_methods_fl36b.c:m41a4be_empty_method (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m41a4be_empty_method (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0041a4be - 0x401000
.globl FUN_0041a4be
FUN_0041a4be:
    # block 0x0041a4be: entry, 7 instruction(s), ends with ret
    push ebp                                     # 0041a4be
    {load} mov ebp, esp                          # 0041a4bf
    push ecx                                     # 0041a4c1
    mov dword ptr [ebp - local_4], ecx           # 0041a4c2
    {load} mov esp, ebp                          # 0041a4c5
    pop ebp                                      # 0041a4c7
    ret                                          # 0041a4c8

