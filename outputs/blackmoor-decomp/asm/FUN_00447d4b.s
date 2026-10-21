# FUN_00447d4b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447d4b
# extent:       0x00447d4b-0x00447d60 (21 code bytes)
# span:         0x00447d4b-0x00447d60 (code 21, tables 0, padding 0)
# sha256:       fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447d4b_set_field_const
# naming:       native port src/original_methods_fl36e.c:m447d4b_set_field_const (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x0u at [this + 0x4], returns this. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m447d4b_set_field_const (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00447d4b - 0x401000
.globl FUN_00447d4b
FUN_00447d4b:
    # block 0x00447d4b: entry, 9 instruction(s), ends with ret
    push ebp                                     # 00447d4b
    {load} mov ebp, esp                          # 00447d4c
    push ecx                                     # 00447d4e
    mov dword ptr [ebp - local_4], ecx           # 00447d4f
    mov eax, dword ptr [ebp - local_4]           # 00447d52
    mov dword ptr [eax + field_4], 0x0           # 00447d55
    {load} mov esp, ebp                          # 00447d5c
    pop ebp                                      # 00447d5e
    ret                                          # 00447d5f

