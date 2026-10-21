# FUN_0040104e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040104e
# extent:       0x0040104e-0x0040105e (16 code bytes)
# span:         0x0040104e-0x0040105e (code 16, tables 0, padding 0)
# sha256:       c0552375ccc5d359619a7447ed7c6361427a10ddc630a09e654fd240550f762a
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40104e_get_constant
# naming:       native port src/original_methods_fl36b.c:m40104e_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52a550u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m40104e_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0040104e - 0x401000
.globl FUN_0040104e
FUN_0040104e:
    # block 0x0040104e: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0040104e
    {load} mov ebp, esp                          # 0040104f
    push ecx                                     # 00401051
    mov dword ptr [ebp - local_4], ecx           # 00401052
    mov eax, 0x52a550                            # 00401055
    {load} mov esp, ebp                          # 0040105a
    pop ebp                                      # 0040105c
    ret                                          # 0040105d

