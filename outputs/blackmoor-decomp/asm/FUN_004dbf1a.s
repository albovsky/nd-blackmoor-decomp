# FUN_004dbf1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbf1a
# extent:       0x004dbf1a-0x004dbf6e (84 code bytes)
# span:         0x004dbf1a-0x004dbf6e (code 84, tables 0, padding 0)
# sha256:       e7f38ae27902c33df144daa4d5d1645a3372bedc74c7353d3858e09c060ffa73
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4dbf1a_construct_base_set_vtable
# naming:       native port src/original_methods_fl36f.c:m4dbf1a_construct_base_set_vtable (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x51d716(this), stores 0x52e478u at [this], calls 0x4dbfbf(this), returns this; the SEH frame is not modelled. No branch; all 23 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_004dbfbf
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4dbf1a_construct_base_set_vtable (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004dbfbf, .text + (0x004dbfbf - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004dbf1a - 0x401000
.globl FUN_004dbf1a
FUN_004dbf1a:
    # block 0x004dbf1a: entry, 23 instruction(s), calls FUN_0051d716, FUN_004dbfbf, ends with ret
    push ebp                                     # 004dbf1a
    {load} mov ebp, esp                          # 004dbf1b
    push -0x1                                    # 004dbf1d
    push 0x52889d                                # 004dbf1f
    mov eax, dword ptr fs:[0x0]                  # 004dbf24
    push eax                                     # 004dbf2a
    mov dword ptr fs:[0x0], esp                  # 004dbf2b
    push ecx                                     # 004dbf32
    mov dword ptr [ebp - local_10], ecx          # 004dbf33
    mov ecx, dword ptr [ebp - local_10]          # 004dbf36
    call FUN_0051d716                            # 004dbf39
    mov dword ptr [ebp - local_4], 0x0           # 004dbf3e
    mov eax, dword ptr [ebp - local_10]          # 004dbf45
    mov dword ptr [eax], 0x52e478                # 004dbf48
    mov ecx, dword ptr [ebp - local_10]          # 004dbf4e
    call FUN_004dbfbf                            # 004dbf51
    mov dword ptr [ebp - local_4], 0xffffffff    # 004dbf56
    mov eax, dword ptr [ebp - local_10]          # 004dbf5d
    mov ecx, dword ptr [ebp - local_c]           # 004dbf60
    mov dword ptr fs:[0x0], ecx                  # 004dbf63
    {load} mov esp, ebp                          # 004dbf6a
    pop ebp                                      # 004dbf6c
    ret                                          # 004dbf6d

