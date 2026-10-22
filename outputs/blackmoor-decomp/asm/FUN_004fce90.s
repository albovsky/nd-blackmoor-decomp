# FUN_004fce90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fce90
# extent:       0x004fce90-0x004fcebe (46 code bytes)
# span:         0x004fce90-0x004fcebe (code 46, tables 0, padding 0)
# sha256:       7d5f2dde609e802ec2843d25cef82292295ffedff74c3cbee83dc24b92397463
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fce90_lifted
# naming:       native port src/original_methods_fl39d.c:m4fce90_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fa9e7, FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4fce90_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x004fcebe
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004fa9e7, .text + (0x004fa9e7 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004fce90 - 0x401000
.globl FUN_004fce90
FUN_004fce90:
    # block 0x004fce90: entry, 10 instruction(s), calls FUN_004fa9e7, ends with je to 0x004fceb5 (forward)
    push ebp                                     # 004fce90
    {load} mov ebp, esp                          # 004fce91
    push ecx                                     # 004fce93
    mov dword ptr [ebp - local_4], ecx           # 004fce94
    mov ecx, dword ptr [ebp - local_4]           # 004fce97
    call FUN_004fa9e7                            # 004fce9a
    mov eax, dword ptr [ebp + arg_8]             # 004fce9f
    and eax, 0x1                                 # 004fcea2
    test eax, eax                                # 004fcea5
    je.d8 L_004fceb5                             # 004fcea7
    # block 0x004fcea9: entered by fall-through of je at 0x004fcea7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004fceb5
    mov ecx, dword ptr [ebp - local_4]           # 004fcea9
    push ecx                                     # 004fceac
    call FUN_0051dc6c                            # 004fcead
    add esp, 0x4                                 # 004fceb2
L_004fceb5:
    # block 0x004fceb5: entered by je at 0x004fcea7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004fceb5
    {load} mov esp, ebp                          # 004fceb8
    pop ebp                                      # 004fceba
    ret 0x4                                      # 004fcebb

