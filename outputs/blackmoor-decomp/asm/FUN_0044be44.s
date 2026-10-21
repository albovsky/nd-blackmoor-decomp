# FUN_0044be44
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044be44
# extent:       0x0044be44-0x0044be54 (16 code bytes)
# span:         0x0044be44-0x0044be60 (code 16, tables 0, padding 12)
# sha256:       c9030a609fcb5dac07ccd3bb0c08ef83929e5438134f2b9f95de206c433fff40
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44be44_get_constant
# naming:       native port src/original_methods_fl38a.c:m44be44_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52cb78u; the object is not read. No branch; all 8 instructions run (the span adds 0xc int3 padding bytes).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m44be44_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0044be44 - 0x401000
.globl FUN_0044be44
FUN_0044be44:
    # block 0x0044be44: entry, 8 instruction(s), ends with ret
    push ebp                                     # 0044be44
    {load} mov ebp, esp                          # 0044be45
    push ecx                                     # 0044be47
    mov dword ptr [ebp - local_4], ecx           # 0044be48
    mov eax, 0x52cb78                            # 0044be4b
    {load} mov esp, ebp                          # 0044be50
    pop ebp                                      # 0044be52
    ret                                          # 0044be53

# --- data items (not part of the function) -------------------------
.org 0x0044be54 - 0x401000
PAD_0044be54:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

