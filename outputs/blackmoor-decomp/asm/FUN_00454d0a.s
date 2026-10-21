# FUN_00454d0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454d0a
# extent:       0x00454d0a-0x00454d1a (16 code bytes)
# span:         0x00454d0a-0x00454d1a (code 16, tables 0, padding 0)
# sha256:       fae9433a12c64976055d33259d3f04237672049f0b1c3c8961c7a1653f690881
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m454d0a_get_constant
# naming:       native port src/original_methods_fl36b.c:m454d0a_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cd18u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m454d0a_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00454d0a - 0x401000
.globl FUN_00454d0a
FUN_00454d0a:
    # block 0x00454d0a: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00454d0a
    {load} mov ebp, esp                          # 00454d0b
    push ecx                                     # 00454d0d
    mov dword ptr [ebp - local_4], ecx           # 00454d0e
    mov eax, 0x52cd18                            # 00454d11
    {load} mov esp, ebp                          # 00454d16
    pop ebp                                      # 00454d18
    ret                                          # 00454d19

