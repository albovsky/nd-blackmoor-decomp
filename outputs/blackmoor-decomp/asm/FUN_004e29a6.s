# FUN_004e29a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e29a6
# extent:       0x004e29a6-0x004e29b7 (17 code bytes)
# span:         0x004e29a6-0x004e29b7 (code 17, tables 0, padding 0)
# sha256:       56d9b148637ae04caedf51e503d219b7095a00c85651b319bb6b5e8bb60546cb
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e29a6_get_field
# naming:       native port src/original_methods_fl36e.c:m4e29a6_get_field (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns the dword at [this + 0x18]. No branch; all 9 instructions run. Nothing else is read or written.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_18
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m4e29a6_get_field (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x004e29a6 - 0x401000
.globl FUN_004e29a6
FUN_004e29a6:
    # block 0x004e29a6: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e29a6
    {load} mov ebp, esp                          # 004e29a7
    push ecx                                     # 004e29a9
    mov dword ptr [ebp - local_4], ecx           # 004e29aa
    mov eax, dword ptr [ebp - local_4]           # 004e29ad
    mov eax, dword ptr [eax + field_18]          # 004e29b0
    {load} mov esp, ebp                          # 004e29b3
    pop ebp                                      # 004e29b5
    ret                                          # 004e29b6

