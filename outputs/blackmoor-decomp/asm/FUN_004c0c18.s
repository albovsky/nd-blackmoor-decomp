# FUN_004c0c18
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0c18
# extent:       0x004c0c18-0x004c0c2c (20 code bytes)
# span:         0x004c0c18-0x004c0c2c (code 20, tables 0, padding 0)
# sha256:       943b3dc801809ae2575daa065bff97f3f22d307f3bf8fb64c6dfa2c0f5c3bf27
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c0c18_get_22a
# naming:       native port src/original_methods_fl16.c:m4c0c18_get_22a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4c0c18_get_22a (returns dword [this+0x22a]).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_22a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4c0c18_get_22a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_22a, 0x22a  # offset +0x22a

# --- external targets -----------------------------------------------

.org 0x004c0c18 - 0x401000
.globl FUN_004c0c18
FUN_004c0c18:
    # block 0x004c0c18: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004c0c18
    {load} mov ebp, esp                          # 004c0c19
    push ecx                                     # 004c0c1b
    mov dword ptr [ebp - local_4], ecx           # 004c0c1c
    mov eax, dword ptr [ebp - local_4]           # 004c0c1f
    mov eax, dword ptr [eax + field_22a]         # 004c0c22
    {load} mov esp, ebp                          # 004c0c28
    pop ebp                                      # 004c0c2a
    ret                                          # 004c0c2b

