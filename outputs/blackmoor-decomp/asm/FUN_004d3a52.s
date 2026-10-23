# FUN_004d3a52
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3a52
# extent:       0x004d3a52-0x004d3a9d (75 code bytes)
# span:         0x004d3a52-0x004d3aa0 (code 75, tables 0, padding 3)
# sha256:       ab3ce9cb94fba5da43cdaf2749182d7f7715acb79690d2e1ad457d280c927376
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3a52_lifted
# naming:       native port src/original_methods_fl41.c:m4d3a52_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 1 seeds; oracle: 24/24 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4d3a52_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x004d3a52 - 0x401000
.globl FUN_004d3a52
FUN_004d3a52:
    # block 0x004d3a52: entry, 24 instruction(s), ends with ret
    push ebp                                     # 004d3a52
    {load} mov ebp, esp                          # 004d3a53
    mov eax, dword ptr [ebp + arg_8]             # 004d3a55
    mov ecx, dword ptr [eax + field_4]           # 004d3a58
    add ecx, dword ptr [0x58318a]                # 004d3a5b
    mov edx, dword ptr [ebp + arg_c]             # 004d3a61
    mov dword ptr [edx + field_4], ecx           # 004d3a64
    mov eax, dword ptr [ebp + arg_8]             # 004d3a67
    mov ecx, dword ptr [eax + field_c]           # 004d3a6a
    add ecx, dword ptr [0x58318a]                # 004d3a6d
    mov edx, dword ptr [ebp + arg_c]             # 004d3a73
    mov dword ptr [edx + field_c], ecx           # 004d3a76
    mov eax, dword ptr [ebp + arg_8]             # 004d3a79
    mov ecx, dword ptr [eax]                     # 004d3a7c
    add ecx, dword ptr [0x583186]                # 004d3a7e
    mov edx, dword ptr [ebp + arg_c]             # 004d3a84
    mov dword ptr [edx], ecx                     # 004d3a87
    mov eax, dword ptr [ebp + arg_8]             # 004d3a89
    mov ecx, dword ptr [eax + field_8]           # 004d3a8c
    add ecx, dword ptr [0x583186]                # 004d3a8f
    mov edx, dword ptr [ebp + arg_c]             # 004d3a95
    mov dword ptr [edx + field_8], ecx           # 004d3a98
    pop ebp                                      # 004d3a9b
    ret                                          # 004d3a9c

# --- data items (not part of the function) -------------------------
.org 0x004d3a9d - 0x401000
PAD_004d3a9d:  # 3 byte(s) of int3 padding
    .fill 3, 1, 0xcc

