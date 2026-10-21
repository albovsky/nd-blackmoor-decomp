# FUN_00447d2f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00447d2f
# extent:       0x00447d2f-0x00447d4b (28 code bytes)
# span:         0x00447d2f-0x00447d4b (code 28, tables 0, padding 0)
# sha256:       9f1fe68f0d91d6cf63e2371df35196d6f8df1fd26f90da7bfc77403240292d73
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m447d2f_init_vtable_call
# naming:       native port src/original_methods_fl36c.c:m447d2f_init_vtable_call (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores 0x52cac8u at [this], returns 0x447d60(this). No branch; all 11 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00447d60
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36c.c:m447d2f_init_vtable_call (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00447d60, .text + (0x00447d60 - 0x401000)

.org 0x00447d2f - 0x401000
.globl FUN_00447d2f
FUN_00447d2f:
    # block 0x00447d2f: entry, 11 instruction(s), calls FUN_00447d60, ends with ret
    push ebp                                     # 00447d2f
    {load} mov ebp, esp                          # 00447d30
    push ecx                                     # 00447d32
    mov dword ptr [ebp - local_4], ecx           # 00447d33
    mov eax, dword ptr [ebp - local_4]           # 00447d36
    mov dword ptr [eax], 0x52cac8                # 00447d39
    mov ecx, dword ptr [ebp - local_4]           # 00447d3f
    call FUN_00447d60                            # 00447d42
    {load} mov esp, ebp                          # 00447d47
    pop ebp                                      # 00447d49
    ret                                          # 00447d4a

