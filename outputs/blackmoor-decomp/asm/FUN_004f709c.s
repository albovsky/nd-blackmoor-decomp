# FUN_004f709c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f709c
# extent:       0x004f709c-0x004f70b0 (20 code bytes)
# span:         0x004f709c-0x004f70b0 (code 20, tables 0, padding 0)
# sha256:       f4378d19b5c3ab0dbd39cba983f59f6dc52989a4d7f3e5211057cd34d287503e
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f709c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1a0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/session_bindings_conditions.c:session_conditions_query_channel_record (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1a0, 0x1a0  # offset +0x1a0

# --- external targets -----------------------------------------------

.org 0x004f709c - 0x401000
.globl FUN_004f709c
FUN_004f709c:
    # block 0x004f709c: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004f709c
    {load} mov ebp, esp                          # 004f709d
    push ecx                                     # 004f709f
    mov dword ptr [ebp - local_4], ecx           # 004f70a0
    mov eax, dword ptr [ebp - local_4]           # 004f70a3
    mov eax, dword ptr [eax + field_1a0]         # 004f70a6
    {load} mov esp, ebp                          # 004f70ac
    pop ebp                                      # 004f70ae
    ret                                          # 004f70af

