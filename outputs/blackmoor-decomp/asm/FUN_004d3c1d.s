# FUN_004d3c1d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3c1d
# extent:       0x004d3c1d-0x004d3c31 (20 code bytes)
# span:         0x004d3c1d-0x004d3c31 (code 20, tables 0, padding 0)
# sha256:       18bd4c5f10e4194969a545e2c6554bf4e66e4b038230464b136258279212aa93
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3c1d_get_field
# naming:       native port src/original_methods_fl36e.c:m4d3c1d_get_field (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the dword at [this + 0x462]. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_462
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4d3c1d_get_field (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------

.org 0x004d3c1d - 0x401000
.globl FUN_004d3c1d
FUN_004d3c1d:
    # block 0x004d3c1d: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004d3c1d
    {load} mov ebp, esp                          # 004d3c1e
    push ecx                                     # 004d3c20
    mov dword ptr [ebp - local_4], ecx           # 004d3c21
    mov eax, dword ptr [ebp - local_4]           # 004d3c24
    mov eax, dword ptr [eax + field_462]         # 004d3c27
    {load} mov esp, ebp                          # 004d3c2d
    pop ebp                                      # 004d3c2f
    ret                                          # 004d3c30

