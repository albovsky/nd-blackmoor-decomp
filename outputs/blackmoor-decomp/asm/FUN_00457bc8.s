# FUN_00457bc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457bc8
# extent:       0x00457bc8-0x00457bd8 (16 code bytes)
# span:         0x00457bc8-0x00457bd8 (code 16, tables 0, padding 0)
# sha256:       73ce334364f163d100995e9fc1518b1861dd25fa5ee330059d86dae3b1253eee
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m457bc8_get_constant
# naming:       native port src/original_methods_fl36b.c:m457bc8_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cdb8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m457bc8_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00457bc8 - 0x401000
.globl FUN_00457bc8
FUN_00457bc8:
    # block 0x00457bc8: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00457bc8
    {load} mov ebp, esp                          # 00457bc9
    push ecx                                     # 00457bcb
    mov dword ptr [ebp - local_4], ecx           # 00457bcc
    mov eax, 0x52cdb8                            # 00457bcf
    {load} mov esp, ebp                          # 00457bd4
    pop ebp                                      # 00457bd6
    ret                                          # 00457bd7

