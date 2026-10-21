# FUN_00454d8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454d8a
# extent:       0x00454d8a-0x00454d9e (20 code bytes)
# span:         0x00454d8a-0x00454d9e (code 20, tables 0, padding 0)
# sha256:       29c8aecdd3ab39880b1433f7cd9efaa14a7505165dcab9b8250655d302edf1a3
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454d8a_set_word
# naming:       native port src/original_methods_fl36e.c:m454d8a_set_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the word 0x0 at 0x5a0541. No branch; all 8 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m454d8a_set_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00454d8a - 0x401000
.globl FUN_00454d8a
FUN_00454d8a:
    # block 0x00454d8a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00454d8a
    {load} mov ebp, esp                          # 00454d8b
    push ecx                                     # 00454d8d
    mov dword ptr [ebp - local_4], ecx           # 00454d8e
    mov word ptr [0x5a0541], 0x0                 # 00454d91
    {load} mov esp, ebp                          # 00454d9a
    pop ebp                                      # 00454d9c
    ret                                          # 00454d9d

