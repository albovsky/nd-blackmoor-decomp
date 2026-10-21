# FUN_004876dd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004876dd
# extent:       0x004876dd-0x004876ed (16 code bytes)
# span:         0x004876dd-0x004876ed (code 16, tables 0, padding 0)
# sha256:       b2ea98f2445b01dd53cf9bd93eb448e4161f10dc36ceebbddb92be4cb0b8503c
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4876dd_get_constant
# naming:       native port src/original_methods_fl36b.c:m4876dd_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d720u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4876dd_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004876dd - 0x401000
.globl FUN_004876dd
FUN_004876dd:
    # block 0x004876dd: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004876dd
    {load} mov ebp, esp                          # 004876de
    push ecx                                     # 004876e0
    mov dword ptr [ebp - local_4], ecx           # 004876e1
    mov eax, 0x52d720                            # 004876e4
    {load} mov esp, ebp                          # 004876e9
    pop ebp                                      # 004876eb
    ret                                          # 004876ec

