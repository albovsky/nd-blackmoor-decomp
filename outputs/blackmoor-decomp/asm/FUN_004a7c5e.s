# FUN_004a7c5e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7c5e
# extent:       0x004a7c5e-0x004a7c7a (28 code bytes)
# span:         0x004a7c5e-0x004a7c7a (code 28, tables 0, padding 0)
# sha256:       dc9390686a5a42becd42dc063df2d6f1136bdfefc54cc7fbd138d64077864441
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a7c5e_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4a7c5e_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52ddf0u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4a7c5e_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x004a7c5e - 0x401000
.globl FUN_004a7c5e
FUN_004a7c5e:
    # block 0x004a7c5e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 004a7c5e
    {load} mov ebp, esp                          # 004a7c5f
    push ecx                                     # 004a7c61
    mov dword ptr [ebp - local_4], ecx           # 004a7c62
    mov eax, dword ptr [ebp - local_4]           # 004a7c65
    mov dword ptr [eax], 0x52ddf0                # 004a7c68
    mov ecx, dword ptr [ebp - local_4]           # 004a7c6e
    call FUN_0051d730                            # 004a7c71
    {load} mov esp, ebp                          # 004a7c76
    pop ebp                                      # 004a7c78
    ret                                          # 004a7c79

