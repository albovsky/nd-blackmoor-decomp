# FUN_00407d70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407d70
# extent:       0x00407d70-0x00407d90 (32 code bytes)
# span:         0x00407d70-0x00407d90 (code 32, tables 0, padding 0)
# sha256:       e154f1fb044af7ccc22e6ab541e062bd3c6a1e7507df1bfc686e4bda8d7a9b31
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407d70_call_two_return_const
# naming:       native port src/original_methods_fl36e.c:m407d70_call_two_return_const (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x521b22(this) then 0x407ca7(this), returns 0x1u. No branch; all 12 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00521b22, FUN_00407ca7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36e.c:m407d70_call_two_return_const (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00407ca7, .text + (0x00407ca7 - 0x401000)
.set FUN_00521b22, .text + (0x00521b22 - 0x401000)

.org 0x00407d70 - 0x401000
.globl FUN_00407d70
FUN_00407d70:
    # block 0x00407d70: entry, 12 instruction(s), calls FUN_00521b22, FUN_00407ca7, ends with ret
    push ebp                                     # 00407d70
    {load} mov ebp, esp                          # 00407d71
    push ecx                                     # 00407d73
    mov dword ptr [ebp - local_4], ecx           # 00407d74
    mov ecx, dword ptr [ebp - local_4]           # 00407d77
    call FUN_00521b22                            # 00407d7a
    mov ecx, dword ptr [ebp - local_4]           # 00407d7f
    call FUN_00407ca7                            # 00407d82
    mov eax, 0x1                                 # 00407d87
    {load} mov esp, ebp                          # 00407d8c
    pop ebp                                      # 00407d8e
    ret                                          # 00407d8f

