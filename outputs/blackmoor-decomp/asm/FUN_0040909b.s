# FUN_0040909b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040909b
# extent:       0x0040909b-0x004090ab (16 code bytes)
# span:         0x0040909b-0x004090ab (code 16, tables 0, padding 0)
# sha256:       c3fbe9accd2b9f616dfe2fe663b56c1ffdea50f8b10ffe1ff1250b30021154e2
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40909b_get_constant
# naming:       native port src/original_methods_fl36b.c:m40909b_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x1u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m40909b_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0040909b - 0x401000
.globl FUN_0040909b
FUN_0040909b:
    # block 0x0040909b: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0040909b
    {load} mov ebp, esp                          # 0040909c
    push ecx                                     # 0040909e
    mov dword ptr [ebp - local_4], ecx           # 0040909f
    mov eax, 0x1                                 # 004090a2
    {load} mov esp, ebp                          # 004090a7
    pop ebp                                      # 004090a9
    ret                                          # 004090aa

