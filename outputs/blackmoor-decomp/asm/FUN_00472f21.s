# FUN_00472f21
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472f21
# extent:       0x00472f21-0x00472f95 (116 code bytes)
# span:         0x00472f21-0x00472f95 (code 116, tables 0, padding 0)
# sha256:       1548a06d9268aeab239965496d053be3c296eb1f608812a2327e978f27fa7edf
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m472f21_lifted
# naming:       native port src/original_methods_fl40.c:m472f21_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 31/31 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1c50, FUN_00472fb7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m472f21_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00472fb7, .text + (0x00472fb7 - 0x401000)
.set FUN_004e1c50, .text + (0x004e1c50 - 0x401000)

.org 0x00472f21 - 0x401000
.globl FUN_00472f21
FUN_00472f21:
    # block 0x00472f21: entry, 31 instruction(s), calls FUN_004e1c50, FUN_00472fb7, ends with ret
    push ebp                                     # 00472f21
    {load} mov ebp, esp                          # 00472f22
    push -0x1                                    # 00472f24
    push 0x5282af                                # 00472f26
    mov eax, dword ptr fs:[0x0]                  # 00472f2b
    push eax                                     # 00472f31
    mov dword ptr fs:[0x0], esp                  # 00472f32
    push ecx                                     # 00472f39
    push edi                                     # 00472f3a
    mov dword ptr [ebp - local_10], ecx          # 00472f3b
    mov ecx, dword ptr [ebp - local_10]          # 00472f3e
    add ecx, 0x1a6                               # 00472f41
    call FUN_004e1c50                            # 00472f47
    mov dword ptr [ebp - local_4], 0x0           # 00472f4c
    mov eax, dword ptr [ebp - local_10]          # 00472f53
    mov dword ptr [eax], 0x52d448                # 00472f56
    mov ecx, 0x21                                # 00472f5c
    {load} xor eax, eax                          # 00472f61
    mov edi, 0x5a4b4e                            # 00472f63
    rep stosd dword ptr es:[edi], eax            # 00472f68
    mov dword ptr [0x5a4bce], 0xffffffff         # 00472f6a
    mov ecx, dword ptr [ebp - local_10]          # 00472f74
    call FUN_00472fb7                            # 00472f77
    mov dword ptr [ebp - local_4], 0xffffffff    # 00472f7c
    mov eax, dword ptr [ebp - local_10]          # 00472f83
    mov ecx, dword ptr [ebp - local_c]           # 00472f86
    mov dword ptr fs:[0x0], ecx                  # 00472f89
    pop edi                                      # 00472f90
    {load} mov esp, ebp                          # 00472f91
    pop ebp                                      # 00472f93
    ret                                          # 00472f94

