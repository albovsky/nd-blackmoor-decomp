# FUN_0044f4ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f4ea
# extent:       0x0044f4ea-0x0044f4fa (16 code bytes)
# span:         0x0044f4ea-0x0044f4fa (code 16, tables 0, padding 0)
# sha256:       18851bc3bb2c6ea980b60c1ceb7613fbecda388651515edf13d9a8c574e89e84
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44f4ea_get_constant
# naming:       native port src/original_methods_fl36b.c:m44f4ea_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cca0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m44f4ea_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044f4ea - 0x401000
.globl FUN_0044f4ea
FUN_0044f4ea:
    # block 0x0044f4ea: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044f4ea
    {load} mov ebp, esp                          # 0044f4eb
    push ecx                                     # 0044f4ed
    mov dword ptr [ebp - local_4], ecx           # 0044f4ee
    mov eax, 0x52cca0                            # 0044f4f1
    {load} mov esp, ebp                          # 0044f4f6
    pop ebp                                      # 0044f4f8
    ret                                          # 0044f4f9

