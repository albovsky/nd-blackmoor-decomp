# FUN_004a35c7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a35c7
# extent:       0x004a35c7-0x004a35d7 (16 code bytes)
# span:         0x004a35c7-0x004a35d7 (code 16, tables 0, padding 0)
# sha256:       f40f4726ac65afe09dc1bff30bf5f95f69c9f73f3cfa8bc53591f5340253d4ff
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a35c7_get_constant
# naming:       native port src/original_methods_fl36b.c:m4a35c7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52dc38u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4a35c7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004a35c7 - 0x401000
.globl FUN_004a35c7
FUN_004a35c7:
    # block 0x004a35c7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004a35c7
    {load} mov ebp, esp                          # 004a35c8
    push ecx                                     # 004a35ca
    mov dword ptr [ebp - local_4], ecx           # 004a35cb
    mov eax, 0x52dc38                            # 004a35ce
    {load} mov esp, ebp                          # 004a35d3
    pop ebp                                      # 004a35d5
    ret                                          # 004a35d6

