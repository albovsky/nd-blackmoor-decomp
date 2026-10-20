# FUN_004bf38c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf38c
# extent:       0x004bf38c-0x004bf3a4 (24 code bytes)
# span:         0x004bf38c-0x004bf3a4 (code 24, tables 0, padding 0)
# sha256:       a1c2f103a01e920bab8fc372f17f8201807043ba9109585c31bcb10c4a2967f9
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf38c_clear_2c0
# naming:       native port src/original_methods_fl16.c:m4bf38c_clear_2c0 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4bf38c_clear_2c0 (dword +0x2c0 := 0).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4bf38c_clear_2c0 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------

.org 0x004bf38c - 0x401000
.globl FUN_004bf38c
FUN_004bf38c:
    # block 0x004bf38c: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004bf38c
    {load} mov ebp, esp                          # 004bf38d
    push ecx                                     # 004bf38f
    mov dword ptr [ebp - local_4], ecx           # 004bf390
    mov eax, dword ptr [ebp - local_4]           # 004bf393
    mov dword ptr [eax + field_2c0], 0x0         # 004bf396
    {load} mov esp, ebp                          # 004bf3a0
    pop ebp                                      # 004bf3a2
    ret                                          # 004bf3a3

