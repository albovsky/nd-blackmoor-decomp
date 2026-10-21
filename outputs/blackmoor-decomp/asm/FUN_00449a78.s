# FUN_00449a78
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449a78
# extent:       0x00449a78-0x00449a94 (28 code bytes)
# span:         0x00449a78-0x00449a94 (code 28, tables 0, padding 0)
# sha256:       ce476cbcfc32b83486a126fa815f58091b0d3a1bd8d41166dc473764e45f425a
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m449a78_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m449a78_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cb5cu at [this], returns 0x449a94(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00449a94
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m449a78_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)

.org 0x00449a78 - 0x401000
.globl FUN_00449a78
FUN_00449a78:
    # block 0x00449a78: entry, 11 instruction(s), calls FUN_00449a94, ends with ret
    push ebp                                     # 00449a78
    {load} mov ebp, esp                          # 00449a79
    push ecx                                     # 00449a7b
    mov dword ptr [ebp - local_4], ecx           # 00449a7c
    mov eax, dword ptr [ebp - local_4]           # 00449a7f
    mov dword ptr [eax], 0x52cb5c                # 00449a82
    mov ecx, dword ptr [ebp - local_4]           # 00449a88
    call FUN_00449a94                            # 00449a8b
    {load} mov esp, ebp                          # 00449a90
    pop ebp                                      # 00449a92
    ret                                          # 00449a93

