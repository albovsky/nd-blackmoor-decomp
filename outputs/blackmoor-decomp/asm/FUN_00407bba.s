# FUN_00407bba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407bba
# extent:       0x00407bba-0x00407c29 (111 code bytes)
# span:         0x00407bba-0x00407c29 (code 111, tables 0, padding 0)
# sha256:       544125136c3b42abf9dbcf6f49ba60c9b72823cf8caa4ed8aec9b7d7ebb2fb0f
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m407bba_lifted
# naming:       native port src/original_methods_fl40.c:m407bba_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 31/31 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005217e4, FUN_0050cb26
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m407bba_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050cb26, .text + (0x0050cb26 - 0x401000)
.set FUN_005217e4, .text + (0x005217e4 - 0x401000)

.org 0x00407bba - 0x401000
.globl FUN_00407bba
FUN_00407bba:
    # block 0x00407bba: entry, 31 instruction(s), calls FUN_005217e4, FUN_0050cb26, ends with ret
    push ebp                                     # 00407bba
    {load} mov ebp, esp                          # 00407bbb
    push -0x1                                    # 00407bbd
    push 0x526d5d                                # 00407bbf
    mov eax, dword ptr fs:[0x0]                  # 00407bc4
    push eax                                     # 00407bca
    mov dword ptr fs:[0x0], esp                  # 00407bcb
    push ecx                                     # 00407bd2
    mov dword ptr [ebp - local_10], ecx          # 00407bd3
    push 0x0                                     # 00407bd6
    push 0x98                                    # 00407bd8
    mov ecx, dword ptr [ebp - local_10]          # 00407bdd
    call FUN_005217e4                            # 00407be0
    mov dword ptr [ebp - local_4], 0x0           # 00407be5
    push 0x401032                                # 00407bec
    push 0x401000                                # 00407bf1
    push 0x24                                    # 00407bf6
    push 0x40                                    # 00407bf8
    mov eax, dword ptr [ebp - local_10]          # 00407bfa
    add eax, 0x8c                                # 00407bfd
    push eax                                     # 00407c02
    call FUN_0050cb26                            # 00407c03
    mov ecx, dword ptr [ebp - local_10]          # 00407c08
    mov dword ptr [ecx], 0x52bed8                # 00407c0b
    mov dword ptr [ebp - local_4], 0xffffffff    # 00407c11
    mov eax, dword ptr [ebp - local_10]          # 00407c18
    mov ecx, dword ptr [ebp - local_c]           # 00407c1b
    mov dword ptr fs:[0x0], ecx                  # 00407c1e
    {load} mov esp, ebp                          # 00407c25
    pop ebp                                      # 00407c27
    ret                                          # 00407c28

