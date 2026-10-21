# FUN_004bf3a4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf3a4
# extent:       0x004bf3a4-0x004bf3b8 (20 code bytes)
# span:         0x004bf3a4-0x004bf3b8 (code 20, tables 0, padding 0)
# sha256:       76402b036023bbdb144b3a206fa690b86dfd5b0caba7c419873a77f9468bee5c
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf3a4_get_field
# naming:       native port src/original_methods_fl36e.c:m4bf3a4_get_field (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the dword at [this + 0x2c0]. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4bf3a4_get_field (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------

.org 0x004bf3a4 - 0x401000
.globl FUN_004bf3a4
FUN_004bf3a4:
    # block 0x004bf3a4: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004bf3a4
    {load} mov ebp, esp                          # 004bf3a5
    push ecx                                     # 004bf3a7
    mov dword ptr [ebp - local_4], ecx           # 004bf3a8
    mov eax, dword ptr [ebp - local_4]           # 004bf3ab
    mov eax, dword ptr [eax + field_2c0]         # 004bf3ae
    {load} mov esp, ebp                          # 004bf3b4
    pop ebp                                      # 004bf3b6
    ret                                          # 004bf3b7

