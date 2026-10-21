# FUN_004d3b0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3b0a
# extent:       0x004d3b0a-0x004d3b1a (16 code bytes)
# span:         0x004d3b0a-0x004d3b1a (code 16, tables 0, padding 0)
# sha256:       f6b692bf167b42c746fe3cfe8dbb9216ed0385bae5e9391d4eae9dff92ee23e1
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3b0a_get_constant
# naming:       native port src/original_methods_fl36b.c:m4d3b0a_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52e2d8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4d3b0a_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d3b0a - 0x401000
.globl FUN_004d3b0a
FUN_004d3b0a:
    # block 0x004d3b0a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004d3b0a
    {load} mov ebp, esp                          # 004d3b0b
    push ecx                                     # 004d3b0d
    mov dword ptr [ebp - local_4], ecx           # 004d3b0e
    mov eax, 0x52e2d8                            # 004d3b11
    {load} mov esp, ebp                          # 004d3b16
    pop ebp                                      # 004d3b18
    ret                                          # 004d3b19

