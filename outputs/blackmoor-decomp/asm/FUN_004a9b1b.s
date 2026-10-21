# FUN_004a9b1b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9b1b
# extent:       0x004a9b1b-0x004a9b2b (16 code bytes)
# span:         0x004a9b1b-0x004a9b2b (code 16, tables 0, padding 0)
# sha256:       87224bc06cf0bd822aaf4297e05fb1ad1dd72d76d29f042d5a1e61b433b47b5d
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a9b1b_get_constant
# naming:       native port src/original_methods_fl36b.c:m4a9b1b_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52ddd0u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4a9b1b_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a9b1b - 0x401000
.globl FUN_004a9b1b
FUN_004a9b1b:
    # block 0x004a9b1b: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a9b1b
    {load} mov ebp, esp                          # 004a9b1c
    push ecx                                     # 004a9b1e
    mov dword ptr [ebp - local_4], ecx           # 004a9b1f
    mov eax, 0x52ddd0                            # 004a9b22
    {load} mov esp, ebp                          # 004a9b27
    pop ebp                                      # 004a9b29
    ret                                          # 004a9b2a

