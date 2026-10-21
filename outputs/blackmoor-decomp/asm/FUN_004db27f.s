# FUN_004db27f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db27f
# extent:       0x004db27f-0x004db29b (28 code bytes)
# span:         0x004db27f-0x004db29b (code 28, tables 0, padding 0)
# sha256:       8ce6fd741ca20207f6ac41d66ccbf390f400aec5faaab4f1120a7b3835a30f70
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db27f_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m4db27f_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52e458u at [this], returns 0x4db377(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db377
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m4db27f_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004db377, .text + (0x004db377 - 0x401000)

.org 0x004db27f - 0x401000
.globl FUN_004db27f
FUN_004db27f:
    # block 0x004db27f: entry, 11 instruction(s), calls FUN_004db377, ends with ret
    push ebp                                     # 004db27f
    {load} mov ebp, esp                          # 004db280
    push ecx                                     # 004db282
    mov dword ptr [ebp - local_4], ecx           # 004db283
    mov eax, dword ptr [ebp - local_4]           # 004db286
    mov dword ptr [eax], 0x52e458                # 004db289
    mov ecx, dword ptr [ebp - local_4]           # 004db28f
    call FUN_004db377                            # 004db292
    {load} mov esp, ebp                          # 004db297
    pop ebp                                      # 004db299
    ret                                          # 004db29a

