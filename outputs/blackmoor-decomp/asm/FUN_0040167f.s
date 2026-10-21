# FUN_0040167f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040167f
# extent:       0x0040167f-0x0040168f (16 code bytes)
# span:         0x0040167f-0x0040168f (code 16, tables 0, padding 0)
# sha256:       2ade8ba17c147b5aed409b8fb510513a234a8d19b24895a98072932962fe2588
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m40167f_get_constant
# naming:       native port src/original_methods_fl36b.c:m40167f_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52a6a0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m40167f_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0040167f - 0x401000
.globl FUN_0040167f
FUN_0040167f:
    # block 0x0040167f: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0040167f
    {load} mov ebp, esp                          # 00401680
    push ecx                                     # 00401682
    mov dword ptr [ebp - local_4], ecx           # 00401683
    mov eax, 0x52a6a0                            # 00401686
    {load} mov esp, ebp                          # 0040168b
    pop ebp                                      # 0040168d
    ret                                          # 0040168e

