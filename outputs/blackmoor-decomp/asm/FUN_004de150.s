# FUN_004de150
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de150
# extent:       0x004de150-0x004de1a4 (84 code bytes)
# span:         0x004de150-0x004de1a4 (code 84, tables 0, padding 0)
# sha256:       aebf94c0ed31778c5f1e21e7c76fbc3703204d5b7587fd39fba0945be3cfa7cd
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4de150_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m4de150_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4eda10(this), stores 0x52e4ccu at [this], calls 0x4de1f5(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eda10, FUN_004de1f5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4de150_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004de1f5, .text + (0x004de1f5 - 0x401000)
.set FUN_004eda10, .text + (0x004eda10 - 0x401000)

.org 0x004de150 - 0x401000
.globl FUN_004de150
FUN_004de150:
    # block 0x004de150: entry, 23 instruction(s), calls FUN_004eda10, FUN_004de1f5, ends with ret
    push ebp                                     # 004de150
    {load} mov ebp, esp                          # 004de151
    push -0x1                                    # 004de153
    push 0x5288d9                                # 004de155
    mov eax, dword ptr fs:[0x0]                  # 004de15a
    push eax                                     # 004de160
    mov dword ptr fs:[0x0], esp                  # 004de161
    push ecx                                     # 004de168
    mov dword ptr [ebp - local_10], ecx          # 004de169
    mov ecx, dword ptr [ebp - local_10]          # 004de16c
    call FUN_004eda10                            # 004de16f
    mov dword ptr [ebp - local_4], 0x0           # 004de174
    mov eax, dword ptr [ebp - local_10]          # 004de17b
    mov dword ptr [eax], 0x52e4cc                # 004de17e
    mov ecx, dword ptr [ebp - local_10]          # 004de184
    call FUN_004de1f5                            # 004de187
    mov dword ptr [ebp - local_4], 0xffffffff    # 004de18c
    mov eax, dword ptr [ebp - local_10]          # 004de193
    mov ecx, dword ptr [ebp - local_c]           # 004de196
    mov dword ptr fs:[0x0], ecx                  # 004de199
    {load} mov esp, ebp                          # 004de1a0
    pop ebp                                      # 004de1a2
    ret                                          # 004de1a3

