# FUN_00478287
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478287
# extent:       0x00478287-0x004782be (55 code bytes)
# span:         0x00478287-0x004782be (code 55, tables 0, padding 0)
# sha256:       32a56184c97673b8667b8bd9a1ea63b84bdec60ec4ccd2f7ca5d7a08f59bbc71
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m478287_guard_set_table_flag
# naming:       native port src/original_methods_fl38a.c:m478287_guard_set_table_flag (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores dword 1 at 0x5d15a5+0x4a*int16[this+0x1c] when dword [this+0x157a] is set and the word is not -1; returns this. 18/18 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_157a; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m478287_guard_set_table_flag (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_157a, 0x157a  # offset +0x157a

# --- external targets -----------------------------------------------

.org 0x00478287 - 0x401000
.globl FUN_00478287
FUN_00478287:
    # block 0x00478287: entry, 7 instruction(s), ends with je to 0x004782ba (forward)
    push ebp                                     # 00478287
    {load} mov ebp, esp                          # 00478288
    push ecx                                     # 0047828a
    mov dword ptr [ebp - local_4], ecx           # 0047828b
    mov eax, dword ptr [ebp - local_4]           # 0047828e
    cmp dword ptr [eax + field_157a], 0x0        # 00478291
    je.d8 L_004782ba                             # 00478298
    # block 0x0047829a: entered by fall-through of je at 0x00478298, 4 instruction(s), ends with je to 0x004782ba (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0047829a
    movsx edx, word ptr [ecx + field_1c]         # 0047829d
    cmp edx, -0x1                                # 004782a1
    je.d8 L_004782ba                             # 004782a4
    # block 0x004782a6: entered by fall-through of je at 0x004782a4, 4 instruction(s), falls into the block at 0x004782ba
    mov eax, dword ptr [ebp - local_4]           # 004782a6
    movsx ecx, word ptr [eax + field_1c]         # 004782a9
    imul ecx, ecx, 0x4a                          # 004782ad
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004782b0
L_004782ba:
    # block 0x004782ba: entered by je at 0x00478298; je at 0x004782a4, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004782ba
    pop ebp                                      # 004782bc
    ret                                          # 004782bd

