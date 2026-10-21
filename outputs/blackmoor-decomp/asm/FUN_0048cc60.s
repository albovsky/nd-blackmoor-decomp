# FUN_0048cc60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048cc60
# extent:       0x0048cc60-0x0048cc70 (16 code bytes)
# span:         0x0048cc60-0x0048cc70 (code 16, tables 0, padding 0)
# sha256:       52f1edf7c1563712d019cd25040db212e9bf559cbfd6e6509de7c702e42577eb
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48cc60_get_constant
# naming:       native port src/original_methods_fl36b.c:m48cc60_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d940u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m48cc60_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0048cc60 - 0x401000
.globl FUN_0048cc60
FUN_0048cc60:
    # block 0x0048cc60: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048cc60
    {load} mov ebp, esp                          # 0048cc61
    push ecx                                     # 0048cc63
    mov dword ptr [ebp - local_4], ecx           # 0048cc64
    mov eax, 0x52d940                            # 0048cc67
    {load} mov esp, ebp                          # 0048cc6c
    pop ebp                                      # 0048cc6e
    ret                                          # 0048cc6f

