# FUN_004d8f8d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d8f8d
# extent:       0x004d8f8d-0x004d8fb6 (41 code bytes)
# span:         0x004d8f8d-0x004d8fb6 (code 41, tables 0, padding 0)
# sha256:       c11a7e5ac546dfd7882509e63713d45998af568528c4e9ef93ede9c7ab4160e2
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d8f8d_lifted
# naming:       native port src/original_methods_fl39d.c:m4d8f8d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (25 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d8f8d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004d8f8d - 0x401000
.globl FUN_004d8f8d
FUN_004d8f8d:
    # block 0x004d8f8d: entry, 6 instruction(s), ends with jne to 0x004d8f9e (forward)
    push ebp                                     # 004d8f8d
    {load} mov ebp, esp                          # 004d8f8e
    sub esp, 0x8                                 # 004d8f90
    mov dword ptr [ebp - local_8], ecx           # 004d8f93
    cmp dword ptr [ebp + arg_8], 0x0             # 004d8f96
    jne.d8 L_004d8f9e                            # 004d8f9a
    # block 0x004d8f9c: entered by fall-through of jne at 0x004d8f9a, 1 instruction(s), ends with forward jump to 0x004d8fb0
    jmp.d8 L_004d8fb0                            # 004d8f9c
L_004d8f9e:
    # block 0x004d8f9e: entered by jne at 0x004d8f9a, 6 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004d8fb0
    mov eax, dword ptr [ebp + arg_8]             # 004d8f9e
    mov dword ptr [ebp - local_4], eax           # 004d8fa1
    mov ecx, dword ptr [ebp - local_4]           # 004d8fa4
    push ecx                                     # 004d8fa7
    call FUN_0051dc6c                            # 004d8fa8
    add esp, 0x4                                 # 004d8fad
L_004d8fb0:
    # block 0x004d8fb0: entered by jmp at 0x004d8f9c, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004d8fb0
    pop ebp                                      # 004d8fb2
    ret 0x4                                      # 004d8fb3

