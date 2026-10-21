# FUN_004d58cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d58cf
# extent:       0x004d58cf-0x004d58eb (28 code bytes)
# span:         0x004d58cf-0x004d58eb (code 28, tables 0, padding 0)
# sha256:       dc247a26cac408cbff741e2ff177a1edbd677e306b87ef30458d2863ab892274
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d58cf_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4d58cf_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e454u at [this], returns 0x4d5b54(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d5b54
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4d58cf_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004d5b54, .text + (0x004d5b54 - 0x401000)

.org 0x004d58cf - 0x401000
.globl FUN_004d58cf
FUN_004d58cf:
    # block 0x004d58cf: entry, 11 instruction(s), calls FUN_004d5b54, ends with ret
    push ebp                                     # 004d58cf
    {load} mov ebp, esp                          # 004d58d0
    push ecx                                     # 004d58d2
    mov dword ptr [ebp - local_4], ecx           # 004d58d3
    mov eax, dword ptr [ebp - local_4]           # 004d58d6
    mov dword ptr [eax], 0x52e454                # 004d58d9
    mov ecx, dword ptr [ebp - local_4]           # 004d58df
    call FUN_004d5b54                            # 004d58e2
    {load} mov esp, ebp                          # 004d58e7
    pop ebp                                      # 004d58e9
    ret                                          # 004d58ea

