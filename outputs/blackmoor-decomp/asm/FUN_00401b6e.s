# FUN_00401b6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401b6e
# extent:       0x00401b6e-0x00401b8b (29 code bytes)
# span:         0x00401b6e-0x00401b8b (code 29, tables 0, padding 0)
# sha256:       d92cebbc5c31b41bb17e30b8c0c485bc3b72c2f3f4f4eb744d8d68d829753e53
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401b6e_set_mode_call
# naming:       native port src/original_methods_fl36c.c:m401b6e_set_mode_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x2bu in 0x569138, returns 0x401526(this). No branch; all 10 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m401b6e_set_mode_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401b6e - 0x401000
.globl FUN_00401b6e
FUN_00401b6e:
    # block 0x00401b6e: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401b6e
    {load} mov ebp, esp                          # 00401b6f
    push ecx                                     # 00401b71
    mov dword ptr [ebp - local_4], ecx           # 00401b72
    mov dword ptr [0x569138], 0x2b               # 00401b75
    mov ecx, dword ptr [ebp - local_4]           # 00401b7f
    call FUN_00401526                            # 00401b82
    {load} mov esp, ebp                          # 00401b87
    pop ebp                                      # 00401b89
    ret                                          # 00401b8a

