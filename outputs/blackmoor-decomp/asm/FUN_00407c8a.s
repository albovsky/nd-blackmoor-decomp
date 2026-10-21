# FUN_00407c8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407c8a
# extent:       0x00407c8a-0x00407c97 (13 code bytes)
# span:         0x00407c8a-0x00407c97 (code 13, tables 0, padding 0)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407c8a_empty_method_args
# naming:       native port src/original_methods_fl36e.c:m407c8a_empty_method_args (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing and pops 4 bytes of arguments; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m407c8a_empty_method_args (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00407c8a - 0x401000
.globl FUN_00407c8a
FUN_00407c8a:
    # block 0x00407c8a: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 00407c8a
    {load} mov ebp, esp                          # 00407c8b
    push ecx                                     # 00407c8d
    mov dword ptr [ebp - local_4], ecx           # 00407c8e
    {load} mov esp, ebp                          # 00407c91
    pop ebp                                      # 00407c93
    ret 0x4                                      # 00407c94

