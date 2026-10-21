# FUN_004a9ea7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9ea7
# extent:       0x004a9ea7-0x004a9eb7 (16 code bytes)
# span:         0x004a9ea7-0x004a9eb7 (code 16, tables 0, padding 0)
# sha256:       8b9c60e2ddfe925a01ac153e8e140773efe60ceed708d8fd1f18befafcad5d0b
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9ea7_get_constant
# naming:       native port src/original_methods_fl36b.c:m4a9ea7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52de40u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4a9ea7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a9ea7 - 0x401000
.globl FUN_004a9ea7
FUN_004a9ea7:
    # block 0x004a9ea7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a9ea7
    {load} mov ebp, esp                          # 004a9ea8
    push ecx                                     # 004a9eaa
    mov dword ptr [ebp - local_4], ecx           # 004a9eab
    mov eax, 0x52de40                            # 004a9eae
    {load} mov esp, ebp                          # 004a9eb3
    pop ebp                                      # 004a9eb5
    ret                                          # 004a9eb6

