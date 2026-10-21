# FUN_0044e74b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e74b
# extent:       0x0044e74b-0x0044e767 (28 code bytes)
# span:         0x0044e74b-0x0044e767 (code 28, tables 0, padding 0)
# sha256:       8d8f6b856163ab39bdc896bdf8d30eb79b82d8da79327940b964466fbaea1376
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m44e74b_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m44e74b_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52ccc0u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m44e74b_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0044e74b - 0x401000
.globl FUN_0044e74b
FUN_0044e74b:
    # block 0x0044e74b: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0044e74b
    {load} mov ebp, esp                          # 0044e74c
    push ecx                                     # 0044e74e
    mov dword ptr [ebp - local_4], ecx           # 0044e74f
    mov eax, dword ptr [ebp - local_4]           # 0044e752
    mov dword ptr [eax], 0x52ccc0                # 0044e755
    mov ecx, dword ptr [ebp - local_4]           # 0044e75b
    call FUN_0051d730                            # 0044e75e
    {load} mov esp, ebp                          # 0044e763
    pop ebp                                      # 0044e765
    ret                                          # 0044e766

