# FUN_004145a7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004145a7
# extent:       0x004145a7-0x004145d0 (41 code bytes)
# span:         0x004145a7-0x004145d0 (code 41, tables 0, padding 0)
# sha256:       3ee99d2be1e9c00339dc50e9ce7e814fb4a29a0ff1624008ce88f61284b29bde
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4145a7_lifted
# naming:       native port src/original_methods_fl40.c:m4145a7_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 13/13 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c; [ecx + n] field_20; [edx + n] field_24
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4145a7_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------

.org 0x004145a7 - 0x401000
.globl FUN_004145a7
FUN_004145a7:
    # block 0x004145a7: entry, 13 instruction(s), ends with ret
    push ebp                                     # 004145a7
    {load} mov ebp, esp                          # 004145a8
    push ecx                                     # 004145aa
    mov dword ptr [ebp - local_4], ecx           # 004145ab
    mov eax, dword ptr [ebp - local_4]           # 004145ae
    mov dword ptr [eax + field_1c], 0x0          # 004145b1
    mov ecx, dword ptr [ebp - local_4]           # 004145b8
    mov dword ptr [ecx + field_20], 0x0          # 004145bb
    mov edx, dword ptr [ebp - local_4]           # 004145c2
    mov dword ptr [edx + field_24], 0x0          # 004145c5
    {load} mov esp, ebp                          # 004145cc
    pop ebp                                      # 004145ce
    ret                                          # 004145cf

