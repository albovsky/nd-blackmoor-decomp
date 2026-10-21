# FUN_00470e71
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470e71
# extent:       0x00470e71-0x00470e8e (29 code bytes)
# span:         0x00470e71-0x00470e8e (code 29, tables 0, padding 0)
# sha256:       b5723bea0749c4c8a376cea26062531bc673e11ac9de5d1aa849095fb80f738a
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m470e71_set_two_words
# naming:       native port src/original_methods_fl36e.c:m470e71_set_two_words (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores the word 0x0 at 0x5957b5 and 0x0 at 0x5957b7. No branch; all 9 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m470e71_set_two_words (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00470e71 - 0x401000
.globl FUN_00470e71
FUN_00470e71:
    # block 0x00470e71: entry, 9 instruction(s), ends with ret
    push ebp                                     # 00470e71
    {load} mov ebp, esp                          # 00470e72
    push ecx                                     # 00470e74
    mov dword ptr [ebp - local_4], ecx           # 00470e75
    mov word ptr [0x5957b5], 0x0                 # 00470e78
    mov word ptr [0x5957b7], 0x0                 # 00470e81
    {load} mov esp, ebp                          # 00470e8a
    pop ebp                                      # 00470e8c
    ret                                          # 00470e8d

