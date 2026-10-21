# FUN_004ab38b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab38b
# extent:       0x004ab38b-0x004ab3a7 (28 code bytes)
# span:         0x004ab38b-0x004ab3a7 (code 28, tables 0, padding 0)
# sha256:       a3d346859a7b88c904052579c2a1d2c0b0bac3390a56effc1f7d39b0557287ca
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ab38b_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4ab38b_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52df00u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4ab38b_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004ab38b - 0x401000
.globl FUN_004ab38b
FUN_004ab38b:
    # block 0x004ab38b: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004ab38b
    {load} mov ebp, esp                          # 004ab38c
    push ecx                                     # 004ab38e
    mov dword ptr [ebp - local_4], ecx           # 004ab38f
    mov eax, dword ptr [ebp - local_4]           # 004ab392
    mov dword ptr [eax], 0x52df00                # 004ab395
    mov ecx, dword ptr [ebp - local_4]           # 004ab39b
    call FUN_0051d730                            # 004ab39e
    {load} mov esp, ebp                          # 004ab3a3
    pop ebp                                      # 004ab3a5
    ret                                          # 004ab3a6

