# FUN_00472f95
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472f95
# extent:       0x00472f95-0x00472fb7 (34 code bytes)
# span:         0x00472f95-0x00472fb7 (code 34, tables 0, padding 0)
# sha256:       5af890fdaed91c04c81ab456352ba643b350d4daf96422cb84cfe635b298fe19
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m472f95_lifted
# naming:       native port src/original_methods_fl40.c:m472f95_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 12/12 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1c83
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m472f95_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e1c83, .text + (0x004e1c83 - 0x401000)

.org 0x00472f95 - 0x401000
.globl FUN_00472f95
FUN_00472f95:
    # block 0x00472f95: entry, 12 instruction(s), calls FUN_004e1c83, ends with ret
    push ebp                                     # 00472f95
    {load} mov ebp, esp                          # 00472f96
    push ecx                                     # 00472f98
    mov dword ptr [ebp - local_4], ecx           # 00472f99
    mov eax, dword ptr [ebp - local_4]           # 00472f9c
    mov dword ptr [eax], 0x52d448                # 00472f9f
    mov ecx, dword ptr [ebp - local_4]           # 00472fa5
    add ecx, 0x1a6                               # 00472fa8
    call FUN_004e1c83                            # 00472fae
    {load} mov esp, ebp                          # 00472fb3
    pop ebp                                      # 00472fb5
    ret                                          # 00472fb6

