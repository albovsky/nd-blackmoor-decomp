# FUN_00470d5e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470d5e
# extent:       0x00470d5e-0x00470d7a (28 code bytes)
# span:         0x00470d5e-0x00470d7a (code 28, tables 0, padding 0)
# sha256:       1e5b96a0eada9cdae246bcd030f13a82533c9e046eab75b3b37a5609cbdb01b5
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m470d5e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m470d5e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d3f8u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m470d5e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00470d5e - 0x401000
.globl FUN_00470d5e
FUN_00470d5e:
    # block 0x00470d5e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00470d5e
    {load} mov ebp, esp                          # 00470d5f
    push ecx                                     # 00470d61
    mov dword ptr [ebp - local_4], ecx           # 00470d62
    mov eax, dword ptr [ebp - local_4]           # 00470d65
    mov dword ptr [eax], 0x52d3f8                # 00470d68
    mov ecx, dword ptr [ebp - local_4]           # 00470d6e
    call FUN_0051d730                            # 00470d71
    {load} mov esp, ebp                          # 00470d76
    pop ebp                                      # 00470d78
    ret                                          # 00470d79

