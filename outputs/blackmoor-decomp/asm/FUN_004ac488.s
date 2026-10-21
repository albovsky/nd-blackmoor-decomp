# FUN_004ac488
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac488
# extent:       0x004ac488-0x004ac498 (16 code bytes)
# span:         0x004ac488-0x004ac498 (code 16, tables 0, padding 0)
# sha256:       1cc9977c1644d6699cdecbe973c417db2845a519a1bd9a55e23679ad4adde3d8
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ac488_get_constant
# naming:       native port src/original_methods_fl36b.c:m4ac488_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52dee0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4ac488_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004ac488 - 0x401000
.globl FUN_004ac488
FUN_004ac488:
    # block 0x004ac488: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004ac488
    {load} mov ebp, esp                          # 004ac489
    push ecx                                     # 004ac48b
    mov dword ptr [ebp - local_4], ecx           # 004ac48c
    mov eax, 0x52dee0                            # 004ac48f
    {load} mov esp, ebp                          # 004ac494
    pop ebp                                      # 004ac496
    ret                                          # 004ac497

