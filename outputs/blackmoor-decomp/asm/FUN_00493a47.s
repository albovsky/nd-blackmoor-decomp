# FUN_00493a47
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493a47
# extent:       0x00493a47-0x00493a54 (13 code bytes)
# span:         0x00493a47-0x00493a54 (code 13, tables 0, padding 0)
# sha256:       bdd6fe4ca5117b073e37ce330ee832ef6def9381df86be62b2fa4eefd966d5d0
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m493a47_zero
# naming:       native port src/original_methods_fl16.c:m493a47_zero (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m493a47_zero (returns 0).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m493a47_zero (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00493a47 - 0x401000
.globl FUN_00493a47
FUN_00493a47:
    # block 0x00493a47: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00493a47
    {load} mov ebp, esp                          # 00493a48
    push ecx                                     # 00493a4a
    mov dword ptr [ebp - local_4], ecx           # 00493a4b
    {load} xor eax, eax                          # 00493a4e
    {load} mov esp, ebp                          # 00493a50
    pop ebp                                      # 00493a52
    ret                                          # 00493a53

