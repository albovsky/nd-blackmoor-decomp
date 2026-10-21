# FUN_004640c9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004640c9
# extent:       0x004640c9-0x00464100 (55 code bytes)
# span:         0x004640c9-0x00464100 (code 55, tables 0, padding 0)
# sha256:       3323cb7c39822282970655a900e742e7e791cb1038805ad7daec398bb5a227f2
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4640c9_guard_set_table_flag
# naming:       native port src/original_methods_fl38a.c:m4640c9_guard_set_table_flag (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores dword 1 at 0x5d15a5+0x4a*int16[this+0x1c] when dword [this+0xb8] is set and the word is not -1; returns this. 18/18 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_b8; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m4640c9_guard_set_table_flag (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_b8, 0xb8  # offset +0xb8

# --- external targets -----------------------------------------------

.org 0x004640c9 - 0x401000
.globl FUN_004640c9
FUN_004640c9:
    # block 0x004640c9: entry, 7 instruction(s), ends with je to 0x004640fc (forward)
    push ebp                                     # 004640c9
    {load} mov ebp, esp                          # 004640ca
    push ecx                                     # 004640cc
    mov dword ptr [ebp - local_4], ecx           # 004640cd
    mov eax, dword ptr [ebp - local_4]           # 004640d0
    cmp dword ptr [eax + field_b8], 0x0          # 004640d3
    je.d8 L_004640fc                             # 004640da
    # block 0x004640dc: entered by fall-through of je at 0x004640da, 4 instruction(s), ends with je to 0x004640fc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004640dc
    movsx edx, word ptr [ecx + field_1c]         # 004640df
    cmp edx, -0x1                                # 004640e3
    je.d8 L_004640fc                             # 004640e6
    # block 0x004640e8: entered by fall-through of je at 0x004640e6, 4 instruction(s), falls into the block at 0x004640fc
    mov eax, dword ptr [ebp - local_4]           # 004640e8
    movsx ecx, word ptr [eax + field_1c]         # 004640eb
    imul ecx, ecx, 0x4a                          # 004640ef
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004640f2
L_004640fc:
    # block 0x004640fc: entered by je at 0x004640da; je at 0x004640e6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004640fc
    pop ebp                                      # 004640fe
    ret                                          # 004640ff

