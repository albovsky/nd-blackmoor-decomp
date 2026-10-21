# FUN_004dd3cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dd3cf
# extent:       0x004dd3cf-0x004dd3eb (28 code bytes)
# span:         0x004dd3cf-0x004dd3eb (code 28, tables 0, padding 0)
# sha256:       82aefc160cbea7659aaf6bcc48aef32aeb5c2012ed4b07839bf9dc25c8b57a1b
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dd3cf_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4dd3cf_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e4c8u at [this], returns 0x4dd3f6(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dd3f6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4dd3cf_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004dd3f6, .text + (0x004dd3f6 - 0x401000)

.org 0x004dd3cf - 0x401000
.globl FUN_004dd3cf
FUN_004dd3cf:
    # block 0x004dd3cf: entry, 11 instruction(s), calls FUN_004dd3f6, ends with ret
    push ebp                                     # 004dd3cf
    {load} mov ebp, esp                          # 004dd3d0
    push ecx                                     # 004dd3d2
    mov dword ptr [ebp - local_4], ecx           # 004dd3d3
    mov eax, dword ptr [ebp - local_4]           # 004dd3d6
    mov dword ptr [eax], 0x52e4c8                # 004dd3d9
    mov ecx, dword ptr [ebp - local_4]           # 004dd3df
    call FUN_004dd3f6                            # 004dd3e2
    {load} mov esp, ebp                          # 004dd3e7
    pop ebp                                      # 004dd3e9
    ret                                          # 004dd3ea

