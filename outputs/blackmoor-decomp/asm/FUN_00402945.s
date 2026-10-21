# FUN_00402945
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00402945
# extent:       0x00402945-0x00402952 (13 code bytes)
# span:         0x00402945-0x00402952 (code 13, tables 0, padding 0)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m402945_empty_method_args
# naming:       native port src/original_methods_fl36e.c:m402945_empty_method_args (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing and pops 4 bytes of arguments; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m402945_empty_method_args (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00402945 - 0x401000
.globl FUN_00402945
FUN_00402945:
    # block 0x00402945: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 00402945
    {load} mov ebp, esp                          # 00402946
    push ecx                                     # 00402948
    mov dword ptr [ebp - local_4], ecx           # 00402949
    {load} mov esp, ebp                          # 0040294c
    pop ebp                                      # 0040294e
    ret 0x4                                      # 0040294f

