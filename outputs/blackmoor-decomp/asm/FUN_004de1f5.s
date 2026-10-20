# FUN_004de1f5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de1f5
# extent:       0x004de1f5-0x004de214 (31 code bytes)
# span:         0x004de1f5-0x004de214 (code 31, tables 0, padding 0)
# sha256:       e69f20b8be8fb10814de0511f6487559b2dc8b0539a648ad1ba41738d3894c0b
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4de1f5_clear_flags
# naming:       native port src/original_methods_fl27a.c:m4de1f5_clear_flags (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4de1f5_clear_flags: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_991
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4de1f5_clear_flags (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------

.org 0x004de1f5 - 0x401000
.globl FUN_004de1f5
FUN_004de1f5:
    # block 0x004de1f5: entry, 10 instruction(s), ends with ret
    push ebp                                     # 004de1f5
    {load} mov ebp, esp                          # 004de1f6
    push ecx                                     # 004de1f8
    mov dword ptr [ebp - local_4], ecx           # 004de1f9
    mov eax, dword ptr [ebp - local_4]           # 004de1fc
    mov dword ptr [eax + field_991], 0x0         # 004de1ff
    mov byte ptr [0x5a161f], 0x0                 # 004de209
    {load} mov esp, ebp                          # 004de210
    pop ebp                                      # 004de212
    ret                                          # 004de213

