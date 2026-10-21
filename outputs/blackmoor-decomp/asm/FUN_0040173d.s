# FUN_0040173d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040173d
# extent:       0x0040173d-0x0040175a (29 code bytes)
# span:         0x0040173d-0x0040175a (code 29, tables 0, padding 0)
# sha256:       e773a06f5d8549db317e006f17e6ced5f54b776321a48b99d66170934eab8f55
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40173d_set_mode_call
# naming:       native port src/original_methods_fl36c.c:m40173d_set_mode_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x6u in 0x569138, returns 0x401526(this). No branch; all 10 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m40173d_set_mode_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x0040173d - 0x401000
.globl FUN_0040173d
FUN_0040173d:
    # block 0x0040173d: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 0040173d
    {load} mov ebp, esp                          # 0040173e
    push ecx                                     # 00401740
    mov dword ptr [ebp - local_4], ecx           # 00401741
    mov dword ptr [0x569138], 0x6                # 00401744
    mov ecx, dword ptr [ebp - local_4]           # 0040174e
    call FUN_00401526                            # 00401751
    {load} mov esp, ebp                          # 00401756
    pop ebp                                      # 00401758
    ret                                          # 00401759

