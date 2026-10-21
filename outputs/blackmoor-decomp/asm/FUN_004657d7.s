# FUN_004657d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004657d7
# extent:       0x004657d7-0x004657e7 (16 code bytes)
# span:         0x004657d7-0x004657e7 (code 16, tables 0, padding 0)
# sha256:       f0119fd6e037f937528bc65e709fce4073b66ee50450d7e664965270049ede88
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4657d7_get_constant
# naming:       native port src/original_methods_fl36b.c:m4657d7_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d0e8u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4657d7_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004657d7 - 0x401000
.globl FUN_004657d7
FUN_004657d7:
    # block 0x004657d7: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004657d7
    {load} mov ebp, esp                          # 004657d8
    push ecx                                     # 004657da
    mov dword ptr [ebp - local_4], ecx           # 004657db
    mov eax, 0x52d0e8                            # 004657de
    {load} mov esp, ebp                          # 004657e3
    pop ebp                                      # 004657e5
    ret                                          # 004657e6

