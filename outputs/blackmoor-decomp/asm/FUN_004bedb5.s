# FUN_004bedb5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bedb5
# extent:       0x004bedb5-0x004bede7 (50 code bytes)
# span:         0x004bedb5-0x004bede7 (code 50, tables 0, padding 0)
# sha256:       a70e2f308e15d41f5791c5bf5dc7d83a896dc040625fb8c5a5399dc10a6337f6
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bedb5_clear_state
# naming:       native port src/original_methods_fl16.c:m4bedb5_clear_state (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4bedb5_clear_state (dwords +0xbc, +0x2c0, +0x2c4 := 0).
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_bc; [ecx + n] field_2c0; [edx + n] field_2c4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m4bedb5_clear_state (function ledger class native_oracle_verified; also m4bede7_clear_state, m4bedfa_close_and_clear; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_bc, 0xbc  # offset +0xbc
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_2c4, 0x2c4  # offset +0x2c4

# --- external targets -----------------------------------------------

.org 0x004bedb5 - 0x401000
.globl FUN_004bedb5
FUN_004bedb5:
    # block 0x004bedb5: entry, 13 instruction(s), ends with ret
    push ebp                                     # 004bedb5
    {load} mov ebp, esp                          # 004bedb6
    push ecx                                     # 004bedb8
    mov dword ptr [ebp - local_4], ecx           # 004bedb9
    mov eax, dword ptr [ebp - local_4]           # 004bedbc
    mov dword ptr [eax + field_bc], 0x0          # 004bedbf
    mov ecx, dword ptr [ebp - local_4]           # 004bedc9
    mov dword ptr [ecx + field_2c0], 0x0         # 004bedcc
    mov edx, dword ptr [ebp - local_4]           # 004bedd6
    mov dword ptr [edx + field_2c4], 0x0         # 004bedd9
    {load} mov esp, ebp                          # 004bede3
    pop ebp                                      # 004bede5
    ret                                          # 004bede6

