# FUN_004487de
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004487de
# extent:       0x004487de-0x004487ee (16 code bytes)
# span:         0x004487de-0x004487f0 (code 16, tables 0, padding 2)
# sha256:       663ac22a5c70b00c039b12f1f034e52395bead573578fc9e0cc65c5e9cdb67da
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4487de_get_constant
# naming:       native port src/original_methods_fl38a.c:m4487de_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cae8u; the object is not read. No branch; all 8 instructions run (the span adds 0x2 int3 padding bytes).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m4487de_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004487de - 0x401000
.globl FUN_004487de
FUN_004487de:
    # block 0x004487de: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004487de
    {load} mov ebp, esp                          # 004487df
    push ecx                                     # 004487e1
    mov dword ptr [ebp - local_4], ecx           # 004487e2
    mov eax, 0x52cae8                            # 004487e5
    {load} mov esp, ebp                          # 004487ea
    pop ebp                                      # 004487ec
    ret                                          # 004487ed

# --- data items (not part of the function) -------------------------
.org 0x004487ee - 0x401000
PAD_004487ee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

