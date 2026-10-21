# FUN_0040906b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040906b
# extent:       0x0040906b-0x0040907b (16 code bytes)
# span:         0x0040906b-0x0040907b (code 16, tables 0, padding 0)
# sha256:       9f012f44013175ba28468d6103297fd6088dae4d3d3c08da52d46253b7a9893e
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40906b_get_constant
# naming:       native port src/original_methods_fl36b.c:m40906b_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52bfe0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m40906b_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0040906b - 0x401000
.globl FUN_0040906b
FUN_0040906b:
    # block 0x0040906b: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0040906b
    {load} mov ebp, esp                          # 0040906c
    push ecx                                     # 0040906e
    mov dword ptr [ebp - local_4], ecx           # 0040906f
    mov eax, 0x52bfe0                            # 00409072
    {load} mov esp, ebp                          # 00409077
    pop ebp                                      # 00409079
    ret                                          # 0040907a

