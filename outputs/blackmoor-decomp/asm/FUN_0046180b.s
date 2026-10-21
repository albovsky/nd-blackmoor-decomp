# FUN_0046180b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046180b
# extent:       0x0046180b-0x00461827 (28 code bytes)
# span:         0x0046180b-0x00461827 (code 28, tables 0, padding 0)
# sha256:       eb76479ebf89a4cb7c1f0ede4c67f4d093cb6017448ce968faaaf1f6536cc4e2
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46180b_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m46180b_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52d080u at [this], returns 0x51d730(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m46180b_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0046180b - 0x401000
.globl FUN_0046180b
FUN_0046180b:
    # block 0x0046180b: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0046180b
    {load} mov ebp, esp                          # 0046180c
    push ecx                                     # 0046180e
    mov dword ptr [ebp - local_4], ecx           # 0046180f
    mov eax, dword ptr [ebp - local_4]           # 00461812
    mov dword ptr [eax], 0x52d080                # 00461815
    mov ecx, dword ptr [ebp - local_4]           # 0046181b
    call FUN_0051d730                            # 0046181e
    {load} mov esp, ebp                          # 00461823
    pop ebp                                      # 00461825
    ret                                          # 00461826

