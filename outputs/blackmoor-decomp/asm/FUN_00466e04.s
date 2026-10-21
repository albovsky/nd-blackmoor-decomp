# FUN_00466e04
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00466e04
# extent:       0x00466e04-0x00466e14 (16 code bytes)
# span:         0x00466e04-0x00466e14 (code 16, tables 0, padding 0)
# sha256:       dea73b261fb07489ce1086b495d2ca21ea5e28f764e0aa078b4029802ddd8654
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m466e04_get_constant
# naming:       native port src/original_methods_fl36b.c:m466e04_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d170u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m466e04_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00466e04 - 0x401000
.globl FUN_00466e04
FUN_00466e04:
    # block 0x00466e04: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00466e04
    {load} mov ebp, esp                          # 00466e05
    push ecx                                     # 00466e07
    mov dword ptr [ebp - local_4], ecx           # 00466e08
    mov eax, 0x52d170                            # 00466e0b
    {load} mov esp, ebp                          # 00466e10
    pop ebp                                      # 00466e12
    ret                                          # 00466e13

