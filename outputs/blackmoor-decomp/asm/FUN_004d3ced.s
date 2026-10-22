# FUN_004d3ced
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3ced
# extent:       0x004d3ced-0x004d3d20 (51 code bytes)
# span:         0x004d3ced-0x004d3d20 (code 51, tables 0, padding 0)
# sha256:       cf297be3de52c63988f8733c869f0429f6ae6630fcbe03fe641287622ea81e84
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3ced_lifted
# naming:       native port src/original_methods_fl39d.c:m4d3ced_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (15 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_45e; [ecx + n] field_45a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d3ced_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_45a, 0x45a  # offset +0x45a
.equ field_45e, 0x45e  # offset +0x45e

# --- external targets -----------------------------------------------

.org 0x004d3ced - 0x401000
.globl FUN_004d3ced
FUN_004d3ced:
    # block 0x004d3ced: entry, 7 instruction(s), ends with je to 0x004d3d1c (forward)
    push ebp                                     # 004d3ced
    {load} mov ebp, esp                          # 004d3cee
    push ecx                                     # 004d3cf0
    mov dword ptr [ebp - local_4], ecx           # 004d3cf1
    mov eax, dword ptr [ebp - local_4]           # 004d3cf4
    cmp dword ptr [eax + field_45e], 0x0         # 004d3cf7
    je.d8 L_004d3d1c                             # 004d3cfe
    # block 0x004d3d00: entered by fall-through of je at 0x004d3cfe, 5 instruction(s), falls into the block at 0x004d3d1c
    mov ecx, dword ptr [ebp - local_4]           # 004d3d00
    mov edx, dword ptr [ecx + field_45a]         # 004d3d03
    mov dword ptr [0x5d1c4b], edx                # 004d3d09
    mov eax, dword ptr [ebp - local_4]           # 004d3d0f
    mov dword ptr [eax + field_45e], 0x0         # 004d3d12
L_004d3d1c:
    # block 0x004d3d1c: entered by je at 0x004d3cfe, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3d1c
    pop ebp                                      # 004d3d1e
    ret                                          # 004d3d1f

