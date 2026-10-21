# FUN_0044afa7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044afa7
# extent:       0x0044afa7-0x0044afb7 (16 code bytes)
# span:         0x0044afa7-0x0044afb7 (code 16, tables 0, padding 0)
# sha256:       62d1a19b89b50b8c2d59c7a75b5b4259fe494f89a9b37e55eb1fb92ff4103c1f
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44afa7_get_constant
# naming:       native port src/original_methods_fl36b.c:m44afa7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cb60u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m44afa7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044afa7 - 0x401000
.globl FUN_0044afa7
FUN_0044afa7:
    # block 0x0044afa7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044afa7
    {load} mov ebp, esp                          # 0044afa8
    push ecx                                     # 0044afaa
    mov dword ptr [ebp - local_4], ecx           # 0044afab
    mov eax, 0x52cb60                            # 0044afae
    {load} mov esp, ebp                          # 0044afb3
    pop ebp                                      # 0044afb5
    ret                                          # 0044afb6

