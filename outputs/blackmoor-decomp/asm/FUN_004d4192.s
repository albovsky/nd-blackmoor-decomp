# FUN_004d4192
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4192
# extent:       0x004d4192-0x004d41a2 (16 code bytes)
# span:         0x004d4192-0x004d41a2 (code 16, tables 0, padding 0)
# sha256:       6d8433fcaa41ae9719424ea11e1161462f5565c5dd48dd8017be3b4e3b9b6980
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d4192_get_constant
# naming:       native port src/original_methods_fl36b.c:m4d4192_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52e2f0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4d4192_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d4192 - 0x401000
.globl FUN_004d4192
FUN_004d4192:
    # block 0x004d4192: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004d4192
    {load} mov ebp, esp                          # 004d4193
    push ecx                                     # 004d4195
    mov dword ptr [ebp - local_4], ecx           # 004d4196
    mov eax, 0x52e2f0                            # 004d4199
    {load} mov esp, ebp                          # 004d419e
    pop ebp                                      # 004d41a0
    ret                                          # 004d41a1

