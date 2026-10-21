# FUN_0040905e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040905e
# extent:       0x0040905e-0x0040906b (13 code bytes)
# span:         0x0040905e-0x0040906b (code 13, tables 0, padding 0)
# sha256:       8a964d1d7ff7ce1a3c60997027339b1b12723566ff413f0bb34cb92f56441d3a
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40905e_empty_method_args
# naming:       native port src/original_methods_fl36e.c:m40905e_empty_method_args (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing and pops 4 bytes of arguments; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m40905e_empty_method_args (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0040905e - 0x401000
.globl FUN_0040905e
FUN_0040905e:
    # block 0x0040905e: entry, 7 instruction(s), ends with ret 0x4
    push ebp                                     # 0040905e
    {load} mov ebp, esp                          # 0040905f
    push ecx                                     # 00409061
    mov dword ptr [ebp - local_4], ecx           # 00409062
    {load} mov esp, ebp                          # 00409065
    pop ebp                                      # 00409067
    ret 0x4                                      # 00409068

