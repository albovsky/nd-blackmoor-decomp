# FUN_004d3c31
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3c31
# extent:       0x004d3c31-0x004d3c42 (17 code bytes)
# span:         0x004d3c31-0x004d3c42 (code 17, tables 0, padding 0)
# sha256:       55b6e58404a3e0e3a48be30a93afd471c029dbaec0b52893db79c4f37241b821
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3c31_get_1c
# naming:       native port src/original_methods_fl16.c:m4d3c31_get_1c (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4d3c31_get_1c (returns dword [this+0x1c]).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:native_aaa_alloc_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------

.org 0x004d3c31 - 0x401000
.globl FUN_004d3c31
FUN_004d3c31:
    # block 0x004d3c31: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004d3c31
    {load} mov ebp, esp                          # 004d3c32
    push ecx                                     # 004d3c34
    mov dword ptr [ebp - local_4], ecx           # 004d3c35
    mov eax, dword ptr [ebp - local_4]           # 004d3c38
    mov eax, dword ptr [eax + field_1c]          # 004d3c3b
    {load} mov esp, ebp                          # 004d3c3e
    pop ebp                                      # 004d3c40
    ret                                          # 004d3c41

