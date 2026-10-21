# FUN_004b5b6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5b6e
# extent:       0x004b5b6e-0x004b5b8a (28 code bytes)
# span:         0x004b5b6e-0x004b5b8a (code 28, tables 0, padding 0)
# sha256:       a32bce1f107060471234e3084037f70b5796bac15ce89f3aafac191d01ef6c85
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4b5b6e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4b5b6e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e120u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4b5b6e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004b5b6e - 0x401000
.globl FUN_004b5b6e
FUN_004b5b6e:
    # block 0x004b5b6e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004b5b6e
    {load} mov ebp, esp                          # 004b5b6f
    push ecx                                     # 004b5b71
    mov dword ptr [ebp - local_4], ecx           # 004b5b72
    mov eax, dword ptr [ebp - local_4]           # 004b5b75
    mov dword ptr [eax], 0x52e120                # 004b5b78
    mov ecx, dword ptr [ebp - local_4]           # 004b5b7e
    call FUN_0051d730                            # 004b5b81
    {load} mov esp, ebp                          # 004b5b86
    pop ebp                                      # 004b5b88
    ret                                          # 004b5b89

