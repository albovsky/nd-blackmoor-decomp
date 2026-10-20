# FUN_0047d77d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d77d
# extent:       0x0047d77d-0x0047d788 (11 code bytes)
# span:         0x0047d77d-0x0047d788 (code 11, tables 0, padding 0)
# sha256:       012a7b6ce927f083ba98a546e3d3f750b2a1d82f350ca27efbd30a9c3c7718a5
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47d77d_noop
# naming:       native port src/original_methods_fl16.c:m47d77d_noop (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m47d77d_noop (an empty method).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m47d77d_noop (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0047d77d - 0x401000
.globl FUN_0047d77d
FUN_0047d77d:
    # block 0x0047d77d: entry, 7 instruction(s), ends with ret
    push ebp                                     # 0047d77d
    {load} mov ebp, esp                          # 0047d77e
    push ecx                                     # 0047d780
    mov dword ptr [ebp - local_4], ecx           # 0047d781
    {load} mov esp, ebp                          # 0047d784
    pop ebp                                      # 0047d786
    ret                                          # 0047d787

