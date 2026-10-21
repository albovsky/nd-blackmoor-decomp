# FUN_00401703
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401703
# extent:       0x00401703-0x00401720 (29 code bytes)
# span:         0x00401703-0x00401720 (code 29, tables 0, padding 0)
# sha256:       79ea5d78b8a7ba1ecd21fca83b151ae92a01e2093b535a64bea0cfe7062ed698
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401703_set_mode_call
# naming:       native port src/original_methods_fl36c.c:m401703_set_mode_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x4u in 0x569138, returns 0x401526(this). No branch; all 10 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m401703_set_mode_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401703 - 0x401000
.globl FUN_00401703
FUN_00401703:
    # block 0x00401703: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401703
    {load} mov ebp, esp                          # 00401704
    push ecx                                     # 00401706
    mov dword ptr [ebp - local_4], ecx           # 00401707
    mov dword ptr [0x569138], 0x4                # 0040170a
    mov ecx, dword ptr [ebp - local_4]           # 00401714
    call FUN_00401526                            # 00401717
    {load} mov esp, ebp                          # 0040171c
    pop ebp                                      # 0040171e
    ret                                          # 0040171f

