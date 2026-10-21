# FUN_004d51f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d51f7
# extent:       0x004d51f7-0x004d5207 (16 code bytes)
# span:         0x004d51f7-0x004d5207 (code 16, tables 0, padding 0)
# sha256:       74a520f7ddce6886f85a8c40aa5d286488713f6510e621463babaf0169ab6883
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d51f7_get_constant
# naming:       native port src/original_methods_fl36b.c:m4d51f7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52e360u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4d51f7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d51f7 - 0x401000
.globl FUN_004d51f7
FUN_004d51f7:
    # block 0x004d51f7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004d51f7
    {load} mov ebp, esp                          # 004d51f8
    push ecx                                     # 004d51fa
    mov dword ptr [ebp - local_4], ecx           # 004d51fb
    mov eax, 0x52e360                            # 004d51fe
    {load} mov esp, ebp                          # 004d5203
    pop ebp                                      # 004d5205
    ret                                          # 004d5206

