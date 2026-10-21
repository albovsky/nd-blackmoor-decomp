# FUN_004617a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004617a7
# extent:       0x004617a7-0x004617b7 (16 code bytes)
# span:         0x004617a7-0x004617b7 (code 16, tables 0, padding 0)
# sha256:       d8b0583bbeaf3c245fbbc0650e111ab6d099153d662c3e614fb5a9f91cd4d5e0
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4617a7_get_constant
# naming:       native port src/original_methods_fl36b.c:m4617a7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d048u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4617a7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004617a7 - 0x401000
.globl FUN_004617a7
FUN_004617a7:
    # block 0x004617a7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004617a7
    {load} mov ebp, esp                          # 004617a8
    push ecx                                     # 004617aa
    mov dword ptr [ebp - local_4], ecx           # 004617ab
    mov eax, 0x52d048                            # 004617ae
    {load} mov esp, ebp                          # 004617b3
    pop ebp                                      # 004617b5
    ret                                          # 004617b6

