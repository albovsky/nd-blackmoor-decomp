# FUN_0049c45c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c45c
# extent:       0x0049c45c-0x0049c46c (16 code bytes)
# span:         0x0049c45c-0x0049c46c (code 16, tables 0, padding 0)
# sha256:       3b36dff4501a21c7f246b163bad80b9f8385b7daf463dd8cce373bac1cad5e11
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m49c45c_get_constant
# naming:       native port src/original_methods_fl36b.c:m49c45c_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52dad8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m49c45c_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0049c45c - 0x401000
.globl FUN_0049c45c
FUN_0049c45c:
    # block 0x0049c45c: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0049c45c
    {load} mov ebp, esp                          # 0049c45d
    push ecx                                     # 0049c45f
    mov dword ptr [ebp - local_4], ecx           # 0049c460
    mov eax, 0x52dad8                            # 0049c463
    {load} mov esp, ebp                          # 0049c468
    pop ebp                                      # 0049c46a
    ret                                          # 0049c46b

