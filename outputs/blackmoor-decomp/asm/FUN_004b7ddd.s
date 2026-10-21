# FUN_004b7ddd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7ddd
# extent:       0x004b7ddd-0x004b7ded (16 code bytes)
# span:         0x004b7ddd-0x004b7ded (code 16, tables 0, padding 0)
# sha256:       a99c220b8e70885e5ab658703062127efd6072103cc8316469e77236cd3c41d3
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7ddd_get_constant
# naming:       native port src/original_methods_fl36b.c:m4b7ddd_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52e188u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4b7ddd_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004b7ddd - 0x401000
.globl FUN_004b7ddd
FUN_004b7ddd:
    # block 0x004b7ddd: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004b7ddd
    {load} mov ebp, esp                          # 004b7dde
    push ecx                                     # 004b7de0
    mov dword ptr [ebp - local_4], ecx           # 004b7de1
    mov eax, 0x52e188                            # 004b7de4
    {load} mov esp, ebp                          # 004b7de9
    pop ebp                                      # 004b7deb
    ret                                          # 004b7dec

