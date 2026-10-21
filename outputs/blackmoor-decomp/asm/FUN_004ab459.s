# FUN_004ab459
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab459
# extent:       0x004ab459-0x004ab46d (20 code bytes)
# span:         0x004ab459-0x004ab46d (code 20, tables 0, padding 0)
# sha256:       46eabcf2a55246eb07a05114ead1e6e458dc2be3b3438baa06e73ec76b3a937a
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab459_set_word
# naming:       native port src/original_methods_fl36e.c:m4ab459_set_word (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the word 0x0 at 0x5957b9. No branch; all 8 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4ab459_set_word (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ab459 - 0x401000
.globl FUN_004ab459
FUN_004ab459:
    # block 0x004ab459: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ab459
    {load} mov ebp, esp                          # 004ab45a
    push ecx                                     # 004ab45c
    mov dword ptr [ebp - local_4], ecx           # 004ab45d
    mov word ptr [0x5957b9], 0x0                 # 004ab460
    {load} mov esp, ebp                          # 004ab469
    pop ebp                                      # 004ab46b
    ret                                          # 004ab46c

