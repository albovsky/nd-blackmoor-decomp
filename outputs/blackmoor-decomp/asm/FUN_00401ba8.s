# FUN_00401ba8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401ba8
# extent:       0x00401ba8-0x00401bc5 (29 code bytes)
# span:         0x00401ba8-0x00401bc5 (code 29, tables 0, padding 0)
# sha256:       16f117fcb7f11e2cc175019969b2be388879fcebbe6dfa81d072b0c1c6ddbd32
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401ba8_set_mode_call
# naming:       native port src/original_methods_fl36c.c:m401ba8_set_mode_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x2du in 0x569138, returns 0x401526(this). No branch; all 10 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m401ba8_set_mode_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401ba8 - 0x401000
.globl FUN_00401ba8
FUN_00401ba8:
    # block 0x00401ba8: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401ba8
    {load} mov ebp, esp                          # 00401ba9
    push ecx                                     # 00401bab
    mov dword ptr [ebp - local_4], ecx           # 00401bac
    mov dword ptr [0x569138], 0x2d               # 00401baf
    mov ecx, dword ptr [ebp - local_4]           # 00401bb9
    call FUN_00401526                            # 00401bbc
    {load} mov esp, ebp                          # 00401bc1
    pop ebp                                      # 00401bc3
    ret                                          # 00401bc4

