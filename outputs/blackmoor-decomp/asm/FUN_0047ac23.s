# FUN_0047ac23
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ac23
# extent:       0x0047ac23-0x0047ac33 (16 code bytes)
# span:         0x0047ac23-0x0047ac33 (code 16, tables 0, padding 0)
# sha256:       abc7f63e1f42cc0ea963a93cd4a40e23f2a73959208baf6523862e55df5410a2
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47ac23_get_constant
# naming:       native port src/original_methods_fl36b.c:m47ac23_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d4f8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m47ac23_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0047ac23 - 0x401000
.globl FUN_0047ac23
FUN_0047ac23:
    # block 0x0047ac23: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0047ac23
    {load} mov ebp, esp                          # 0047ac24
    push ecx                                     # 0047ac26
    mov dword ptr [ebp - local_4], ecx           # 0047ac27
    mov eax, 0x52d4f8                            # 0047ac2a
    {load} mov esp, ebp                          # 0047ac2f
    pop ebp                                      # 0047ac31
    ret                                          # 0047ac32

