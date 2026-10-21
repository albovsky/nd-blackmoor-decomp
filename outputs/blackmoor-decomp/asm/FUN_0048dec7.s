# FUN_0048dec7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048dec7
# extent:       0x0048dec7-0x0048ded7 (16 code bytes)
# span:         0x0048dec7-0x0048ded7 (code 16, tables 0, padding 0)
# sha256:       7abb03d0a7cfeab5e66a1dfe3b0893939b15078ef51fb85bd1bc38280c26043c
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48dec7_get_constant
# naming:       native port src/original_methods_fl36b.c:m48dec7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d9c8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m48dec7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0048dec7 - 0x401000
.globl FUN_0048dec7
FUN_0048dec7:
    # block 0x0048dec7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048dec7
    {load} mov ebp, esp                          # 0048dec8
    push ecx                                     # 0048deca
    mov dword ptr [ebp - local_4], ecx           # 0048decb
    mov eax, 0x52d9c8                            # 0048dece
    {load} mov esp, ebp                          # 0048ded3
    pop ebp                                      # 0048ded5
    ret                                          # 0048ded6

