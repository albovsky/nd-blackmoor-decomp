# FUN_00483eea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483eea
# extent:       0x00483eea-0x00483efa (16 code bytes)
# span:         0x00483eea-0x00483efa (code 16, tables 0, padding 0)
# sha256:       a05538e7cff73e484852e4b72a5a48650dfa74cca7c4e324e2490350b4d952b9
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m483eea_get_constant
# naming:       native port src/original_methods_fl36b.c:m483eea_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52d708u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m483eea_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x00483eea - 0x401000
.globl FUN_00483eea
FUN_00483eea:
    # block 0x00483eea: entry, 8 instruction(s), ends with ret
    push ebp                                     # 00483eea
    {load} mov ebp, esp                          # 00483eeb
    push ecx                                     # 00483eed
    mov dword ptr [ebp - local_4], ecx           # 00483eee
    mov eax, 0x52d708                            # 00483ef1
    {load} mov esp, ebp                          # 00483ef6
    pop ebp                                      # 00483ef8
    ret                                          # 00483ef9

