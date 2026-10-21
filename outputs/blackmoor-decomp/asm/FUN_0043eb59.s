# FUN_0043eb59
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eb59
# extent:       0x0043eb59-0x0043eb75 (28 code bytes)
# span:         0x0043eb59-0x0043eb75 (code 28, tables 0, padding 0)
# sha256:       7578814ea8a67ecb4788bbbca47ff8eadf557085a41efdd804efebc7e22d7b72
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43eb59_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m43eb59_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52c900u at [this], returns 0x5228a4(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005228a4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m43eb59_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_005228a4, .text + (0x005228a4 - 0x401000)

.org 0x0043eb59 - 0x401000
.globl FUN_0043eb59
FUN_0043eb59:
    # block 0x0043eb59: entry, 11 instruction(s), calls FUN_005228a4, ends with ret
    push ebp                                     # 0043eb59
    {load} mov ebp, esp                          # 0043eb5a
    push ecx                                     # 0043eb5c
    mov dword ptr [ebp - local_4], ecx           # 0043eb5d
    mov eax, dword ptr [ebp - local_4]           # 0043eb60
    mov dword ptr [eax], 0x52c900                # 0043eb63
    mov ecx, dword ptr [ebp - local_4]           # 0043eb69
    call FUN_005228a4                            # 0043eb6c
    {load} mov esp, ebp                          # 0043eb71
    pop ebp                                      # 0043eb73
    ret                                          # 0043eb74

