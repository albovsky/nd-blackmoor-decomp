# FUN_004712b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004712b0
# extent:       0x004712b0-0x004712bd (13 code bytes)
# span:         0x004712b0-0x004712bd (code 13, tables 0, padding 0)
# sha256:       4ade1d8e5215866f23695f07800936f46a1e0f3cbc31d5027c2919f35615073a
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4712b0_empty_method_args
# naming:       native port src/original_methods_fl36e.c:m4712b0_empty_method_args (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Does nothing and pops 8 bytes of arguments; the object is not read or written. No branch; all 7 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4712b0_empty_method_args (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 7 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004712b0 - 0x401000
.globl FUN_004712b0
FUN_004712b0:
    # block 0x004712b0: entry, 7 instruction(s), ends with ret 0x8
    push ebp                                     # 004712b0
    {load} mov ebp, esp                          # 004712b1
    push ecx                                     # 004712b3
    mov dword ptr [ebp - local_4], ecx           # 004712b4
    {load} mov esp, ebp                          # 004712b7
    pop ebp                                      # 004712b9
    ret 0x8                                      # 004712ba

