# FUN_00465b3c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00465b3c
# extent:       0x00465b3c-0x00465b9f (99 code bytes)
# span:         0x00465b3c-0x00465b9f (code 99, tables 0, padding 0)
# sha256:       f936c5a9b12ab70bd6579bf15c6c645b5735d66ebedc2980aa06f0e9a5483a2d
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m465b3c_lifted
# naming:       native port src/original_methods_fl40.c:m465b3c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 6 seeds; oracle 34/34 instructions, 6/6 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_20; [ecx + n] field_1c; [edx + n] field_24
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00465b07
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m465b3c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_00465b07, .text + (0x00465b07 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00465b3c - 0x401000
.globl FUN_00465b3c
FUN_00465b3c:
    # block 0x00465b3c: entry, 7 instruction(s), ends with je to 0x00465b5d (forward)
    push ebp                                     # 00465b3c
    {load} mov ebp, esp                          # 00465b3d
    push ecx                                     # 00465b3f
    mov dword ptr [ebp - local_4], ecx           # 00465b40
    mov eax, dword ptr [ebp - local_4]           # 00465b43
    cmp dword ptr [eax + field_20], 0x0          # 00465b46
    je.d8 L_00465b5d                             # 00465b4a
    # block 0x00465b4c: entered by fall-through of je at 0x00465b4a, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00465b5d
    mov ecx, dword ptr [ebp - local_4]           # 00465b4c
    add ecx, 0x20                                # 00465b4f
    push ecx                                     # 00465b52
    mov ecx, 0x5cf659                            # 00465b53
    call FUN_004c2dfb                            # 00465b58
L_00465b5d:
    # block 0x00465b5d: entered by je at 0x00465b4a, 3 instruction(s), ends with je to 0x00465b77 (forward)
    mov edx, dword ptr [ebp - local_4]           # 00465b5d
    cmp dword ptr [edx + field_24], 0x0          # 00465b60
    je.d8 L_00465b77                             # 00465b64
    # block 0x00465b66: entered by fall-through of je at 0x00465b64, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00465b77
    mov eax, dword ptr [ebp - local_4]           # 00465b66
    add eax, 0x24                                # 00465b69
    push eax                                     # 00465b6c
    mov ecx, 0x5cf659                            # 00465b6d
    call FUN_004c2dfb                            # 00465b72
L_00465b77:
    # block 0x00465b77: entered by je at 0x00465b64, 4 instruction(s), ends with je to 0x00465b93 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00465b77
    movsx edx, word ptr [ecx + field_1c]         # 00465b7a
    cmp edx, -0x1                                # 00465b7e
    je.d8 L_00465b93                             # 00465b81
    # block 0x00465b83: entered by fall-through of je at 0x00465b81, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00465b93
    mov eax, dword ptr [ebp - local_4]           # 00465b83
    mov cx, word ptr [eax + field_1c]            # 00465b86
    push ecx                                     # 00465b8a
    call FUN_004d3992                            # 00465b8b
    add esp, 0x4                                 # 00465b90
L_00465b93:
    # block 0x00465b93: entered by je at 0x00465b81, 5 instruction(s), calls FUN_00465b07, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00465b93
    call FUN_00465b07                            # 00465b96
    {load} mov esp, ebp                          # 00465b9b
    pop ebp                                      # 00465b9d
    ret                                          # 00465b9e

