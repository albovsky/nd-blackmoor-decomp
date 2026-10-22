# FUN_004dbc77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbc77
# extent:       0x004dbc77-0x004dbc96 (31 code bytes)
# span:         0x004dbc77-0x004dbca0 (code 31, tables 0, padding 10)
# sha256:       e26129d95d4270f4a21d54326ab1b15bd877c7321766996d9491fd45618bf586
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dbc77_lifted
# naming:       native port src/original_methods_fl39d.c:m4dbc77_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c; [ecx + n] field_20
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4dbc77_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x004dbc77 - 0x401000
.globl FUN_004dbc77
FUN_004dbc77:
    # block 0x004dbc77: entry, 11 instruction(s), ends with ret
    push ebp                                     # 004dbc77
    {load} mov ebp, esp                          # 004dbc78
    push ecx                                     # 004dbc7a
    mov dword ptr [ebp - local_4], ecx           # 004dbc7b
    mov eax, dword ptr [ebp - local_4]           # 004dbc7e
    mov dword ptr [eax + field_1c], 0x2710       # 004dbc81
    mov ecx, dword ptr [ebp - local_4]           # 004dbc88
    mov dword ptr [ecx + field_20], 0x2710       # 004dbc8b
    {load} mov esp, ebp                          # 004dbc92
    pop ebp                                      # 004dbc94
    ret                                          # 004dbc95

# --- data items (not part of the function) -------------------------
.org 0x004dbc96 - 0x401000
PAD_004dbc96:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

