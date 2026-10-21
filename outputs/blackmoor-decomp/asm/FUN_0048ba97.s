# FUN_0048ba97
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048ba97
# extent:       0x0048ba97-0x0048baa7 (16 code bytes)
# span:         0x0048ba97-0x0048baa7 (code 16, tables 0, padding 0)
# sha256:       ed9e2f182dc784bb61c37991046d4aad9f5ffcb99084080a477b66a2a1de7c40
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48ba97_get_constant
# naming:       native port src/original_methods_fl36b.c:m48ba97_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d928u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m48ba97_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0048ba97 - 0x401000
.globl FUN_0048ba97
FUN_0048ba97:
    # block 0x0048ba97: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0048ba97
    {load} mov ebp, esp                          # 0048ba98
    push ecx                                     # 0048ba9a
    mov dword ptr [ebp - local_4], ecx           # 0048ba9b
    mov eax, 0x52d928                            # 0048ba9e
    {load} mov esp, ebp                          # 0048baa3
    pop ebp                                      # 0048baa5
    ret                                          # 0048baa6

