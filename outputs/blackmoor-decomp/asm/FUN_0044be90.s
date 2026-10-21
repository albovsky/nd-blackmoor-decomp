# FUN_0044be90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044be90
# extent:       0x0044be90-0x0044bea7 (23 code bytes)
# span:         0x0044be90-0x0044bea7 (code 23, tables 0, padding 0)
# sha256:       e8c01a5fb050d00f10d41e3880ddd9107067b9acd08bae162d4edf02a4162b2e
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44be90_init_vtable_ret_self
# naming:       native port src/original_methods_fl36e.c:m44be90_init_vtable_ret_self (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cbf0u at [this], returns this. No branch; all 10 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m44be90_init_vtable_ret_self (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044be90 - 0x401000
.globl FUN_0044be90
FUN_0044be90:
    # block 0x0044be90: entry, 10 instruction(s), ends with ret
    push ebp                                     # 0044be90
    {load} mov ebp, esp                          # 0044be91
    push ecx                                     # 0044be93
    mov dword ptr [ebp - local_4], ecx           # 0044be94
    mov eax, dword ptr [ebp - local_4]           # 0044be97
    mov dword ptr [eax], 0x52cbf0                # 0044be9a
    mov eax, dword ptr [ebp - local_4]           # 0044bea0
    {load} mov esp, ebp                          # 0044bea3
    pop ebp                                      # 0044bea5
    ret                                          # 0044bea6

