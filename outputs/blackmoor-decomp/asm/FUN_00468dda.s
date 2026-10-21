# FUN_00468dda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468dda
# extent:       0x00468dda-0x00468dea (16 code bytes)
# span:         0x00468dda-0x00468dea (code 16, tables 0, padding 0)
# sha256:       84860a78eb246af3372411c60cd03b9cbaa670ed83c5bce2012c3430629f0c0e
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m468dda_get_constant
# naming:       native port src/original_methods_fl36b.c:m468dda_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d1e8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m468dda_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00468dda - 0x401000
.globl FUN_00468dda
FUN_00468dda:
    # block 0x00468dda: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00468dda
    {load} mov ebp, esp                          # 00468ddb
    push ecx                                     # 00468ddd
    mov dword ptr [ebp - local_4], ecx           # 00468dde
    mov eax, 0x52d1e8                            # 00468de1
    {load} mov esp, ebp                          # 00468de6
    pop ebp                                      # 00468de8
    ret                                          # 00468de9

