# FUN_00470cfa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470cfa
# extent:       0x00470cfa-0x00470d0a (16 code bytes)
# span:         0x00470cfa-0x00470d0a (code 16, tables 0, padding 0)
# sha256:       52f612bc50905ce02597f0d3b566488c5b5dd68ba19ed532440f4cbd43b8d62e
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m470cfa_get_constant
# naming:       native port src/original_methods_fl36b.c:m470cfa_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d3c0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m470cfa_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00470cfa - 0x401000
.globl FUN_00470cfa
FUN_00470cfa:
    # block 0x00470cfa: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00470cfa
    {load} mov ebp, esp                          # 00470cfb
    push ecx                                     # 00470cfd
    mov dword ptr [ebp - local_4], ecx           # 00470cfe
    mov eax, 0x52d3c0                            # 00470d01
    {load} mov esp, ebp                          # 00470d06
    pop ebp                                      # 00470d08
    ret                                          # 00470d09

