# FUN_00423000
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00423000
# extent:       0x00423000-0x00423021 (33 code bytes)
# span:         0x00423000-0x00423021 (code 33, tables 0, padding 0)
# sha256:       a6885fd177bb092e90845d8e21ce2149c4dcfe0ad3a5d010b1bfa833771666a6
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m423000_init_pair
# naming:       native port src/original_methods_fl16.c:m423000_init_pair (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m423000_init_pair ([this] := 0, [this+0x25] := 0, returns this).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_25
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m423000_init_pair (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_25, 0x25  # offset +0x25

# --- external targets -----------------------------------------------

.org 0x00423000 - 0x401000
.globl FUN_00423000
FUN_00423000:
    # block 0x00423000: entry, 12 instruction(s), ends with ret
    push ebp                                     # 00423000
    {load} mov ebp, esp                          # 00423001
    push ecx                                     # 00423003
    mov dword ptr [ebp - local_4], ecx           # 00423004
    mov eax, dword ptr [ebp - local_4]           # 00423007
    mov dword ptr [eax], 0x0                     # 0042300a
    mov ecx, dword ptr [ebp - local_4]           # 00423010
    mov dword ptr [ecx + field_25], 0x0          # 00423013
    mov eax, dword ptr [ebp - local_4]           # 0042301a
    {load} mov esp, ebp                          # 0042301d
    pop ebp                                      # 0042301f
    ret                                          # 00423020

