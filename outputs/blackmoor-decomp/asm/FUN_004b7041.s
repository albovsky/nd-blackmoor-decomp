# FUN_004b7041
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b7041
# extent:       0x004b7041-0x004b7051 (16 code bytes)
# span:         0x004b7041-0x004b7051 (code 16, tables 0, padding 0)
# sha256:       145884e435643fa25a64a66276bfd142a7f9d4a602ff620a06d5d8e056792602
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b7041_get_constant
# naming:       native port src/original_methods_fl36b.c:m4b7041_get_constant (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the constant 0x52e100u; the object is not read. No branch; all 8 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36b.c:m4b7041_get_constant (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004b7041 - 0x401000
.globl FUN_004b7041
FUN_004b7041:
    # block 0x004b7041: entry, 8 instruction(s), ends with ret
    push ebp                                     # 004b7041
    {load} mov ebp, esp                          # 004b7042
    push ecx                                     # 004b7044
    mov dword ptr [ebp - local_4], ecx           # 004b7045
    mov eax, 0x52e100                            # 004b7048
    {load} mov esp, ebp                          # 004b704d
    pop ebp                                      # 004b704f
    ret                                          # 004b7050

