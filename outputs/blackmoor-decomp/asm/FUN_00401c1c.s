# FUN_00401c1c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401c1c
# extent:       0x00401c1c-0x00401c39 (29 code bytes)
# span:         0x00401c1c-0x00401c40 (code 29, tables 0, padding 7)
# sha256:       40c0599de87c1813d1a3c117b2bae412886967b5f3bece527d83f47e7cf6d5d4
# evidence:     ev_455a1567ac014214df64acbf5361dabf30a6cc1d06d560bab71935befaaf0a54
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401c1c_lifted
# naming:       native port src/original_methods_fl40.c:m401c1c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 10/10 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401526
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401c1c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00401526, .text + (0x00401526 - 0x401000)

.org 0x00401c1c - 0x401000
.globl FUN_00401c1c
FUN_00401c1c:
    # block 0x00401c1c: entry, 10 instruction(s), calls FUN_00401526, ends with ret
    push ebp                                     # 00401c1c
    {load} mov ebp, esp                          # 00401c1d
    push ecx                                     # 00401c1f
    mov dword ptr [ebp - local_4], ecx           # 00401c20
    mov dword ptr [0x569138], 0x31               # 00401c23
    mov ecx, dword ptr [ebp - local_4]           # 00401c2d
    call FUN_00401526                            # 00401c30
    {load} mov esp, ebp                          # 00401c35
    pop ebp                                      # 00401c37
    ret                                          # 00401c38

# --- data items (not part of the function) -------------------------
.org 0x00401c39 - 0x401000
PAD_00401c39:  # 7 byte(s) of int3 padding
    .fill 7, 1, 0xcc

