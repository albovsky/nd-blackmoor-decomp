# FUN_004010b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004010b0
# extent:       0x004010b0-0x004010c0 (16 code bytes)
# span:         0x004010b0-0x004010c0 (code 16, tables 0, padding 0)
# sha256:       c4278f75cc27c6156af8a361a2ab10caf4033f7aca4f12191dd5cb37cfada52c
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4010b0_get_constant
# naming:       native port src/original_methods_fl36b.c:m4010b0_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x80u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4010b0_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004010b0 - 0x401000
.globl FUN_004010b0
FUN_004010b0:
    # block 0x004010b0: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004010b0
    {load} mov ebp, esp                          # 004010b1
    push ecx                                     # 004010b3
    mov dword ptr [ebp - local_4], ecx           # 004010b4
    mov eax, 0x80                                # 004010b7
    {load} mov esp, ebp                          # 004010bc
    pop ebp                                      # 004010be
    ret                                          # 004010bf

