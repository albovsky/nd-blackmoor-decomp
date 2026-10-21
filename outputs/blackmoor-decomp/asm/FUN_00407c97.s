# FUN_00407c97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407c97
# extent:       0x00407c97-0x00407ca7 (16 code bytes)
# span:         0x00407c97-0x00407ca7 (code 16, tables 0, padding 0)
# sha256:       564b0095cfcd2120bba5e055af14be739223f35a61afc93bf31fd6f4ee5083ce
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407c97_get_constant
# naming:       native port src/original_methods_fl36b.c:m407c97_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52bb40u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m407c97_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00407c97 - 0x401000
.globl FUN_00407c97
FUN_00407c97:
    # block 0x00407c97: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00407c97
    {load} mov ebp, esp                          # 00407c98
    push ecx                                     # 00407c9a
    mov dword ptr [ebp - local_4], ecx           # 00407c9b
    mov eax, 0x52bb40                            # 00407c9e
    {load} mov esp, ebp                          # 00407ca3
    pop ebp                                      # 00407ca5
    ret                                          # 00407ca6

