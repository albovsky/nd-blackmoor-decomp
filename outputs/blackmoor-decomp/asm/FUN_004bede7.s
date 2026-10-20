# FUN_004bede7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bede7
# extent:       0x004bede7-0x004bedfa (19 code bytes)
# span:         0x004bede7-0x004bedfa (code 19, tables 0, padding 0)
# sha256:       f340287dec07073ff3198eada61d04d3617a36ea8a64dbde7e7dd6a346b181f7
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bede7_clear_state
# naming:       native port src/original_methods_fl16.c:m4bede7_clear_state (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4bede7_clear_state (calls 0x4bedb5 on this; direct call to the ported symbol).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bedb5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4bede7_clear_state (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004bedb5, .text + (0x004bedb5 - 0x401000)

.org 0x004bede7 - 0x401000
.globl FUN_004bede7
FUN_004bede7:
    # block 0x004bede7: entry, 9 instruction(s), calls FUN_004bedb5, ends with ret
    push ebp                                     # 004bede7
    {load} mov ebp, esp                          # 004bede8
    push ecx                                     # 004bedea
    mov dword ptr [ebp - local_4], ecx           # 004bedeb
    mov ecx, dword ptr [ebp - local_4]           # 004bedee
    call FUN_004bedb5                            # 004bedf1
    {load} mov esp, ebp                          # 004bedf6
    pop ebp                                      # 004bedf8
    ret                                          # 004bedf9

