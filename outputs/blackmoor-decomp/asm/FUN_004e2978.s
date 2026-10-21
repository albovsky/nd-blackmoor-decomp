# FUN_004e2978
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2978
# extent:       0x004e2978-0x004e2990 (24 code bytes)
# span:         0x004e2978-0x004e2990 (code 24, tables 0, padding 0)
# sha256:       ec8b818768e7c1f54c2f9369f0ad0f1886a95d31af6eac326438193a498e4a37
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2978_set_field_const
# naming:       native port src/original_methods_fl36e.c:m4e2978_set_field_const (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x1u at [this + 0x177], returns this. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_177
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e2978_set_field_const (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_177, 0x177  # offset +0x177

# --- external targets -----------------------------------------------

.org 0x004e2978 - 0x401000
.globl FUN_004e2978
FUN_004e2978:
    # block 0x004e2978: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e2978
    {load} mov ebp, esp                          # 004e2979
    push ecx                                     # 004e297b
    mov dword ptr [ebp - local_4], ecx           # 004e297c
    mov eax, dword ptr [ebp - local_4]           # 004e297f
    mov dword ptr [eax + field_177], 0x1         # 004e2982
    {load} mov esp, ebp                          # 004e298c
    pop ebp                                      # 004e298e
    ret                                          # 004e298f

