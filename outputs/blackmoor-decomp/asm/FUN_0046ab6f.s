# FUN_0046ab6f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046ab6f
# extent:       0x0046ab6f-0x0046ab7f (16 code bytes)
# span:         0x0046ab6f-0x0046ab7f (code 16, tables 0, padding 0)
# sha256:       9a869227786471952da167d10c52469e20bebf84a6c2d00c391099aaece6c137
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46ab6f_get_constant
# naming:       native port src/original_methods_fl36b.c:m46ab6f_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d200u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m46ab6f_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0046ab6f - 0x401000
.globl FUN_0046ab6f
FUN_0046ab6f:
    # block 0x0046ab6f: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0046ab6f
    {load} mov ebp, esp                          # 0046ab70
    push ecx                                     # 0046ab72
    mov dword ptr [ebp - local_4], ecx           # 0046ab73
    mov eax, 0x52d200                            # 0046ab76
    {load} mov esp, ebp                          # 0046ab7b
    pop ebp                                      # 0046ab7d
    ret                                          # 0046ab7e

