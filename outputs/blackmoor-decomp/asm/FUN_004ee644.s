# FUN_004ee644
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee644
# extent:       0x004ee644-0x004ee673 (47 code bytes)
# span:         0x004ee644-0x004ee673 (code 47, tables 0, padding 0)
# sha256:       0e93a653443e2468b017c6266664b400006c7a695273846ce2e74d757d0f99c8
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee644_lifted
# naming:       native port src/original_methods_fl41.c:m4ee644_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 3 seeds; oracle: 19/19 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [ecx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4ee644_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004ee644 - 0x401000
.globl FUN_004ee644
FUN_004ee644:
    # block 0x004ee644: entry, 19 instruction(s), ends with ret 0x4
    push ebp                                     # 004ee644
    {load} mov ebp, esp                          # 004ee645
    push ecx                                     # 004ee647
    mov dword ptr [ebp - local_4], ecx           # 004ee648
    mov eax, dword ptr [ebp - local_4]           # 004ee64b
    add eax, 0x1c                                # 004ee64e
    mov ecx, dword ptr [ebp + arg_8]             # 004ee651
    mov edx, dword ptr [eax]                     # 004ee654
    mov dword ptr [ecx], edx                     # 004ee656
    mov edx, dword ptr [eax + field_4]           # 004ee658
    mov dword ptr [ecx + field_4], edx           # 004ee65b
    mov edx, dword ptr [eax + field_8]           # 004ee65e
    mov dword ptr [ecx + field_8], edx           # 004ee661
    mov eax, dword ptr [eax + field_c]           # 004ee664
    mov dword ptr [ecx + field_c], eax           # 004ee667
    mov eax, dword ptr [ebp + arg_8]             # 004ee66a
    {load} mov esp, ebp                          # 004ee66d
    pop ebp                                      # 004ee66f
    ret 0x4                                      # 004ee670

