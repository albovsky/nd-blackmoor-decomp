# FUN_00463b00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00463b00
# extent:       0x00463b00-0x00463b10 (16 code bytes)
# span:         0x00463b00-0x00463b10 (code 16, tables 0, padding 0)
# sha256:       513cdd4bc97ac5df542811246d709e49f05a843093ebb1f9c83f1fa3e0b2d1a2
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m463b00_get_constant
# naming:       native port src/original_methods_fl36b.c:m463b00_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d060u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m463b00_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00463b00 - 0x401000
.globl FUN_00463b00
FUN_00463b00:
    # block 0x00463b00: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00463b00
    {load} mov ebp, esp                          # 00463b01
    push ecx                                     # 00463b03
    mov dword ptr [ebp - local_4], ecx           # 00463b04
    mov eax, 0x52d060                            # 00463b07
    {load} mov esp, ebp                          # 00463b0c
    pop ebp                                      # 00463b0e
    ret                                          # 00463b0f

