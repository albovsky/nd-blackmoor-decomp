# FUN_004fa9e7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fa9e7
# extent:       0x004fa9e7-0x004faa03 (28 code bytes)
# span:         0x004fa9e7-0x004faa03 (code 28, tables 0, padding 0)
# sha256:       b3f82f13fc1aca9d7b8979236fd8e14db694ec031dfc101dd8fdef7a7f6faf5d
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fa9e7_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4fa9e7_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e518u at [this], returns 0x4fad50(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fad50
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4fa9e7_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004fad50, .text + (0x004fad50 - 0x401000)

.org 0x004fa9e7 - 0x401000
.globl FUN_004fa9e7
FUN_004fa9e7:
    # block 0x004fa9e7: entry, 11 instruction(s), calls FUN_004fad50, ends with ret
    push ebp                                     # 004fa9e7
    {load} mov ebp, esp                          # 004fa9e8
    push ecx                                     # 004fa9ea
    mov dword ptr [ebp - local_4], ecx           # 004fa9eb
    mov eax, dword ptr [ebp - local_4]           # 004fa9ee
    mov dword ptr [eax], 0x52e518                # 004fa9f1
    mov ecx, dword ptr [ebp - local_4]           # 004fa9f7
    call FUN_004fad50                            # 004fa9fa
    {load} mov esp, ebp                          # 004fa9ff
    pop ebp                                      # 004faa01
    ret                                          # 004faa02

