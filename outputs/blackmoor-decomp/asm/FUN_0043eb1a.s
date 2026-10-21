# FUN_0043eb1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eb1a
# extent:       0x0043eb1a-0x0043eb2a (16 code bytes)
# span:         0x0043eb1a-0x0043eb2a (code 16, tables 0, padding 0)
# sha256:       4600648dea79a048651f850af07d624bdfd3ee23156d6e4ac91ca60ddab61c70
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43eb1a_get_constant
# naming:       native port src/original_methods_fl36b.c:m43eb1a_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52c7c0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m43eb1a_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0043eb1a - 0x401000
.globl FUN_0043eb1a
FUN_0043eb1a:
    # block 0x0043eb1a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0043eb1a
    {load} mov ebp, esp                          # 0043eb1b
    push ecx                                     # 0043eb1d
    mov dword ptr [ebp - local_4], ecx           # 0043eb1e
    mov eax, 0x52c7c0                            # 0043eb21
    {load} mov esp, ebp                          # 0043eb26
    pop ebp                                      # 0043eb28
    ret                                          # 0043eb29

