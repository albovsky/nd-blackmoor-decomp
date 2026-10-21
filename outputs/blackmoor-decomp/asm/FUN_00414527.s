# FUN_00414527
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414527
# extent:       0x00414527-0x00414537 (16 code bytes)
# span:         0x00414527-0x00414537 (code 16, tables 0, padding 0)
# sha256:       4c97d13aa43c79a5adbd7f9551d49fdff5251c5145472d8651894aad29653446
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m414527_get_constant
# naming:       native port src/original_methods_fl36b.c:m414527_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52c4b8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m414527_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00414527 - 0x401000
.globl FUN_00414527
FUN_00414527:
    # block 0x00414527: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00414527
    {load} mov ebp, esp                          # 00414528
    push ecx                                     # 0041452a
    mov dword ptr [ebp - local_4], ecx           # 0041452b
    mov eax, 0x52c4b8                            # 0041452e
    {load} mov esp, ebp                          # 00414533
    pop ebp                                      # 00414535
    ret                                          # 00414536

