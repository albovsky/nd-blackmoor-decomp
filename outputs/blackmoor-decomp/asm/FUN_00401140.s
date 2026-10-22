# FUN_00401140
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401140
# extent:       0x00401140-0x0040114d (13 code bytes)
# span:         0x00401140-0x00401150 (code 13, tables 0, padding 3)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m401140_lifted
# naming:       native port src/original_methods_fl40.c:m401140_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 7/7 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m401140_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00401140 - 0x401000
.globl FUN_00401140
FUN_00401140:
    # block 0x00401140: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 00401140
    {load} mov ebp, esp                          # 00401141
    push ecx                                     # 00401143
    mov dword ptr [ebp - local_4], ecx           # 00401144
    {load} mov esp, ebp                          # 00401147
    pop ebp                                      # 00401149
    ret 0x4                                      # 0040114a

# --- data items (not part of the function) -------------------------
.org 0x0040114d - 0x401000
PAD_0040114d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

