# FUN_00465b9f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465b9f
# extent:       0x00465b9f-0x00465bd3 (52 code bytes)
# span:         0x00465b9f-0x00465bd3 (code 52, tables 0, padding 0)
# sha256:       829b432ac523bfe7e22b85c5d2d1001b4cce1286772bfaebf2e2c82ea9f21116
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m465b9f_guard_set_table_flag
# naming:       native port src/original_methods_fl38a.c:m465b9f_guard_set_table_flag (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores dword 1 at 0x5d15a5+0x4a*int16[this+0x1c] when dword [this+0x49] is set and the word is not -1; returns this. 18/18 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_49; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m465b9f_guard_set_table_flag (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------

.org 0x00465b9f - 0x401000
.globl FUN_00465b9f
FUN_00465b9f:
    # block 0x00465b9f: entry, 7 instruction(s), ends with je to 0x00465bcf (forward)
    push ebp                                     # 00465b9f
    {load} mov ebp, esp                          # 00465ba0
    push ecx                                     # 00465ba2
    mov dword ptr [ebp - local_4], ecx           # 00465ba3
    mov eax, dword ptr [ebp - local_4]           # 00465ba6
    cmp dword ptr [eax + field_49], 0x0          # 00465ba9
    je.d8 L_00465bcf                             # 00465bad
    # block 0x00465baf: entered by fall-through of je at 0x00465bad, 4 instruction(s), ends with je to 0x00465bcf (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00465baf
    movsx edx, word ptr [ecx + field_1c]         # 00465bb2
    cmp edx, -0x1                                # 00465bb6
    je.d8 L_00465bcf                             # 00465bb9
    # block 0x00465bbb: entered by fall-through of je at 0x00465bb9, 4 instruction(s), falls into the block at 0x00465bcf
    mov eax, dword ptr [ebp - local_4]           # 00465bbb
    movsx ecx, word ptr [eax + field_1c]         # 00465bbe
    imul ecx, ecx, 0x4a                          # 00465bc2
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 00465bc5
L_00465bcf:
    # block 0x00465bcf: entered by je at 0x00465bad; je at 0x00465bb9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00465bcf
    pop ebp                                      # 00465bd1
    ret                                          # 00465bd2

