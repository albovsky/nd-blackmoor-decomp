# FUN_004234c8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004234c8
# extent:       0x004234c8-0x004234dd (21 code bytes)
# span:         0x004234c8-0x004234dd (code 21, tables 0, padding 0)
# sha256:       fbe0bf544ff923eb04f90bf1340c6e9f4b42abeabaea01acc32ce5eea172ff87
# evidence:     ev_6aea749257e733e6a888071535cd523e265e1b5dc78f23c23f75e3654451d196
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4234c8_depth_reset
# naming:       native port src/original_methods_fl16.c:m4234c8_depth_reset (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4234c8_depth_reset ([this+4] := 0).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4234c8_depth_reset (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x004234c8 - 0x401000
.globl FUN_004234c8
FUN_004234c8:
    # block 0x004234c8: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004234c8
    {load} mov ebp, esp                          # 004234c9
    push ecx                                     # 004234cb
    mov dword ptr [ebp - local_4], ecx           # 004234cc
    mov eax, dword ptr [ebp - local_4]           # 004234cf
    mov dword ptr [eax + field_4], 0x0           # 004234d2
    {load} mov esp, ebp                          # 004234d9
    pop ebp                                      # 004234db
    ret                                          # 004234dc

