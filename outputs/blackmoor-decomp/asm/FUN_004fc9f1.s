# FUN_004fc9f1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc9f1
# extent:       0x004fc9f1-0x004fca60 (111 code bytes)
# span:         0x004fc9f1-0x004fca60 (code 111, tables 0, padding 0)
# sha256:       044538ad404b4d05a1e2793d0889026925a79e5fd7063c97d7719a125e44c67b
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fc9f1_lifted
# naming:       native port src/original_methods_fl41.c:m4fc9f1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 2 seeds; oracle: 29/29 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_146, field_152; [ecx + n] field_2, field_4, field_146; [edx + n] field_4, field_14a, field_14e
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4fc9f1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2, 0x2  # offset +0x2
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_146, 0x146  # offset +0x146
.equ field_14a, 0x14a  # offset +0x14a
.equ field_14e, 0x14e  # offset +0x14e
.equ field_152, 0x152  # offset +0x152

# --- external targets -----------------------------------------------

.org 0x004fc9f1 - 0x401000
.globl FUN_004fc9f1
FUN_004fc9f1:
    # block 0x004fc9f1: entry, 29 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret 0x4
    push ebp                                     # 004fc9f1
    {load} mov ebp, esp                          # 004fc9f2
    sub esp, 0x8                                 # 004fc9f4
    mov dword ptr [ebp - local_8], ecx           # 004fc9f7
    mov eax, dword ptr [ebp + arg_8]             # 004fc9fa
    movsx ecx, word ptr [eax]                    # 004fc9fd
    imul ecx, ecx, 0x5bb                         # 004fca00
    mov edx, dword ptr [ebp - local_8]           # 004fca06
    lea eax, [edx + ecx + field_4]               # 004fca09
    mov dword ptr [ebp - local_4], eax           # 004fca0d
    mov ecx, dword ptr [ebp + arg_8]             # 004fca10
    movsx edx, word ptr [ecx + field_2]          # 004fca13
    mov eax, dword ptr [ebp - local_4]           # 004fca17
    mov dword ptr [eax + field_146], edx         # 004fca1a
    mov ecx, dword ptr [ebp + arg_8]             # 004fca20
    fld dword ptr [ecx + field_4]                # 004fca23
    fdiv qword ptr [0x52c680]                    # 004fca26
    mov edx, dword ptr [ebp - local_4]           # 004fca2c
    fstp dword ptr [edx + field_14a]             # 004fca2f
    call dword ptr [0x52a23c]                    # 004fca35
    mov ecx, dword ptr [ebp - local_4]           # 004fca3b
    add eax, dword ptr [ecx + field_146]         # 004fca3e
    mov edx, dword ptr [ebp - local_4]           # 004fca44
    mov dword ptr [edx + field_14e], eax         # 004fca47
    mov eax, dword ptr [ebp - local_4]           # 004fca4d
    mov dword ptr [eax + field_152], 0x1         # 004fca50
    {load} mov esp, ebp                          # 004fca5a
    pop ebp                                      # 004fca5c
    ret 0x4                                      # 004fca5d

