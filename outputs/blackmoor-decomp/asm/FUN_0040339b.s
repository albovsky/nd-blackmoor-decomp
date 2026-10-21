# FUN_0040339b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040339b
# extent:       0x0040339b-0x004033ab (16 code bytes)
# span:         0x0040339b-0x004033ab (code 16, tables 0, padding 0)
# sha256:       4ee489ff494e34cebfbb4ace0b07031d1501b33520f4e7ae2ac0c9829e5adfd2
# evidence:     ev_e09edac65bcad9caee2d1862e36312f5e4008fb317e393d76486b97c5d7f9943
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40339b_get_constant
# naming:       native port src/original_methods_fl36b.c:m40339b_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52afa8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m40339b_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0040339b - 0x401000
.globl FUN_0040339b
FUN_0040339b:
    # block 0x0040339b: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0040339b
    {load} mov ebp, esp                          # 0040339c
    push ecx                                     # 0040339e
    mov dword ptr [ebp - local_4], ecx           # 0040339f
    mov eax, 0x52afa8                            # 004033a2
    {load} mov esp, ebp                          # 004033a7
    pop ebp                                      # 004033a9
    ret                                          # 004033aa

