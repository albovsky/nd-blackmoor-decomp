# FUN_0044d087
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d087
# extent:       0x0044d087-0x0044d097 (16 code bytes)
# span:         0x0044d087-0x0044d097 (code 16, tables 0, padding 0)
# sha256:       fc52c7caeec7fe79954e219809949f20bf0dbd188a2ca7bccc4eb595115d3515
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44d087_get_constant
# naming:       native port src/original_methods_fl36b.c:m44d087_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cc00u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m44d087_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044d087 - 0x401000
.globl FUN_0044d087
FUN_0044d087:
    # block 0x0044d087: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044d087
    {load} mov ebp, esp                          # 0044d088
    push ecx                                     # 0044d08a
    mov dword ptr [ebp - local_4], ecx           # 0044d08b
    mov eax, 0x52cc00                            # 0044d08e
    {load} mov esp, ebp                          # 0044d093
    pop ebp                                      # 0044d095
    ret                                          # 0044d096

