# FUN_0045d2b6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045d2b6
# extent:       0x0045d2b6-0x0045d2c6 (16 code bytes)
# span:         0x0045d2b6-0x0045d2c6 (code 16, tables 0, padding 0)
# sha256:       c8e631ea3223fceaafee64339528841ccf25ab113931e8dffcd3c46588629ab3
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45d2b6_get_constant
# naming:       native port src/original_methods_fl36b.c:m45d2b6_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cf50u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m45d2b6_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0045d2b6 - 0x401000
.globl FUN_0045d2b6
FUN_0045d2b6:
    # block 0x0045d2b6: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0045d2b6
    {load} mov ebp, esp                          # 0045d2b7
    push ecx                                     # 0045d2b9
    mov dword ptr [ebp - local_4], ecx           # 0045d2ba
    mov eax, 0x52cf50                            # 0045d2bd
    {load} mov esp, ebp                          # 0045d2c2
    pop ebp                                      # 0045d2c4
    ret                                          # 0045d2c5

