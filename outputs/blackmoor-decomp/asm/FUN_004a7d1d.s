# FUN_004a7d1d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7d1d
# extent:       0x004a7d1d-0x004a7da5 (136 code bytes)
# span:         0x004a7d1d-0x004a7da5 (code 136, tables 0, padding 0)
# sha256:       4115fb6e1b959d6a5e180466d6181458a246ad151fae194ec57f50cef9d8a979
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4a7d1d_lifted
# naming:       native port src/original_methods_fl39d.c:m4a7d1d_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (28 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_e6a; [ecx + n] field_e6a; [edx + n] field_1c, field_e6e
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004a7c7a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4a7d1d_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_e6a, 0xe6a  # offset +0xe6a
.equ field_e6e, 0xe6e  # offset +0xe6e

# --- external targets -----------------------------------------------
.set FUN_004a7c7a, .text + (0x004a7c7a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004a7d1d - 0x401000
.globl FUN_004a7d1d
FUN_004a7d1d:
    # block 0x004a7d1d: entry, 7 instruction(s), ends with je to 0x004a7d44 (forward)
    push ebp                                     # 004a7d1d
    {load} mov ebp, esp                          # 004a7d1e
    push ecx                                     # 004a7d20
    mov dword ptr [ebp - local_4], ecx           # 004a7d21
    mov eax, dword ptr [ebp - local_4]           # 004a7d24
    cmp dword ptr [eax + field_e6a], 0x0         # 004a7d27
    je.d8 L_004a7d44                             # 004a7d2e
    # block 0x004a7d30: entered by fall-through of je at 0x004a7d2e, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a7d44
    mov ecx, dword ptr [ebp - local_4]           # 004a7d30
    add ecx, 0xe6a                               # 004a7d33
    push ecx                                     # 004a7d39
    mov ecx, 0x5cf659                            # 004a7d3a
    call FUN_004c2dfb                            # 004a7d3f
L_004a7d44:
    # block 0x004a7d44: entered by je at 0x004a7d2e, 3 instruction(s), ends with je to 0x004a7d63 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004a7d44
    cmp dword ptr [edx + field_e6e], 0x0         # 004a7d47
    je.d8 L_004a7d63                             # 004a7d4e
    # block 0x004a7d50: entered by fall-through of je at 0x004a7d4e, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004a7d63
    mov eax, dword ptr [ebp - local_4]           # 004a7d50
    add eax, 0xe6e                               # 004a7d53
    push eax                                     # 004a7d58
    mov ecx, 0x5cf659                            # 004a7d59
    call FUN_004c2dfb                            # 004a7d5e
L_004a7d63:
    # block 0x004a7d63: entered by je at 0x004a7d4e, 8 instruction(s), ends with je to 0x004a7d99 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004a7d63
    mov dword ptr [ecx + field_e6a], 0x0         # 004a7d66
    mov edx, dword ptr [ebp - local_4]           # 004a7d70
    mov dword ptr [edx + field_e6e], 0x0         # 004a7d73
    mov eax, dword ptr [ebp - local_4]           # 004a7d7d
    movsx ecx, word ptr [eax + field_1c]         # 004a7d80
    cmp ecx, -0x1                                # 004a7d84
    je.d8 L_004a7d99                             # 004a7d87
    # block 0x004a7d89: entered by fall-through of je at 0x004a7d87, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004a7d99
    mov edx, dword ptr [ebp - local_4]           # 004a7d89
    mov ax, word ptr [edx + field_1c]            # 004a7d8c
    push eax                                     # 004a7d90
    call FUN_004d3992                            # 004a7d91
    add esp, 0x4                                 # 004a7d96
L_004a7d99:
    # block 0x004a7d99: entered by je at 0x004a7d87, 5 instruction(s), calls FUN_004a7c7a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004a7d99
    call FUN_004a7c7a                            # 004a7d9c
    {load} mov esp, ebp                          # 004a7da1
    pop ebp                                      # 004a7da3
    ret                                          # 004a7da4

