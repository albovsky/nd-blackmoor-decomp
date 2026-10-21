# FUN_004ac8be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac8be
# extent:       0x004ac8be-0x004ac8da (28 code bytes)
# span:         0x004ac8be-0x004ac8da (code 28, tables 0, padding 0)
# sha256:       1c47ab184a263e4d4662cd56ac1623f6f524431dc2018a1eba83a656fd239caf
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ac8be_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4ac8be_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52df88u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4ac8be_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004ac8be - 0x401000
.globl FUN_004ac8be
FUN_004ac8be:
    # block 0x004ac8be: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004ac8be
    {load} mov ebp, esp                          # 004ac8bf
    push ecx                                     # 004ac8c1
    mov dword ptr [ebp - local_4], ecx           # 004ac8c2
    mov eax, dword ptr [ebp - local_4]           # 004ac8c5
    mov dword ptr [eax], 0x52df88                # 004ac8c8
    mov ecx, dword ptr [ebp - local_4]           # 004ac8ce
    call FUN_0051d730                            # 004ac8d1
    {load} mov esp, ebp                          # 004ac8d6
    pop ebp                                      # 004ac8d8
    ret                                          # 004ac8d9

