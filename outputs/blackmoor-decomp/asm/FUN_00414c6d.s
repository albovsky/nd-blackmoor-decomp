# FUN_00414c6d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414c6d
# extent:       0x00414c6d-0x00414c7d (16 code bytes)
# span:         0x00414c6d-0x00414c80 (code 16, tables 0, padding 3)
# sha256:       13a4c3c108ef3ed7bd875849e262e43e0b5a0d148d7f14f7efee5eb854a17649
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m414c6d_get_constant
# naming:       native port src/original_methods_fl38a.c:m414c6d_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52c4d0u; the object is not read. No branch; all 8 instructions run (the span adds 0x3 int3 padding bytes).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m414c6d_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00414c6d - 0x401000
.globl FUN_00414c6d
FUN_00414c6d:
    # block 0x00414c6d: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00414c6d
    {load} mov ebp, esp                          # 00414c6e
    push ecx                                     # 00414c70
    mov dword ptr [ebp - local_4], ecx           # 00414c71
    mov eax, 0x52c4d0                            # 00414c74
    {load} mov esp, ebp                          # 00414c79
    pop ebp                                      # 00414c7b
    ret                                          # 00414c7c

# --- data items (not part of the function) -------------------------
.org 0x00414c7d - 0x401000
PAD_00414c7d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

