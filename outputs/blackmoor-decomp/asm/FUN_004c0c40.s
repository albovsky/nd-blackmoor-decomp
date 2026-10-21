# FUN_004c0c40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0c40
# extent:       0x004c0c40-0x004c0c54 (20 code bytes)
# span:         0x004c0c40-0x004c0c54 (code 20, tables 0, padding 0)
# sha256:       4384f50c77452719aaf68339cd5e7ef84c4e61d0bdf53c785d1dd9708acceab9
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4c0c40_get_field
# naming:       native port src/original_methods_fl36e.c:m4c0c40_get_field (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the dword at [this + 0x216]. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_216
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4c0c40_get_field (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_216, 0x216  # offset +0x216

# --- external targets -----------------------------------------------

.org 0x004c0c40 - 0x401000
.globl FUN_004c0c40
FUN_004c0c40:
    # block 0x004c0c40: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004c0c40
    {load} mov ebp, esp                          # 004c0c41
    push ecx                                     # 004c0c43
    mov dword ptr [ebp - local_4], ecx           # 004c0c44
    mov eax, dword ptr [ebp - local_4]           # 004c0c47
    mov eax, dword ptr [eax + field_216]         # 004c0c4a
    {load} mov esp, ebp                          # 004c0c50
    pop ebp                                      # 004c0c52
    ret                                          # 004c0c53

