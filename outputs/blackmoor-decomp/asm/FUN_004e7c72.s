# FUN_004e7c72
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7c72
# extent:       0x004e7c72-0x004e7d04 (146 code bytes)
# span:         0x004e7c72-0x004e7d04 (code 146, tables 0, padding 0)
# sha256:       4aa77c5598be944f8cdf237fcaefea6a02bf419fd7565e5e23bac2a7103bdb7f
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e7c72_lifted
# naming:       native port src/original_methods_fl39d.c:m4e7c72_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (22 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_691, field_695, field_699; [edx + n] field_691, field_695, field_699
# callees:      calls FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e7c72_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_691, 0x691  # offset +0x691
.equ field_695, 0x695  # offset +0x695
.equ field_699, 0x699  # offset +0x699

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x004e7c72 - 0x401000
.globl FUN_004e7c72
FUN_004e7c72:
    # block 0x004e7c72: entry, 7 instruction(s), ends with je to 0x004e7ca6 (forward)
    push ebp                                     # 004e7c72
    {load} mov ebp, esp                          # 004e7c73
    push ecx                                     # 004e7c75
    mov dword ptr [ebp - local_4], ecx           # 004e7c76
    mov eax, dword ptr [ebp - local_4]           # 004e7c79
    cmp dword ptr [eax + field_699], 0x0         # 004e7c7c
    je.d8 L_004e7ca6                             # 004e7c83
    # block 0x004e7c85: entered by fall-through of je at 0x004e7c83, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e7ca6
    mov ecx, dword ptr [ebp - local_4]           # 004e7c85
    add ecx, 0x699                               # 004e7c88
    push ecx                                     # 004e7c8e
    mov ecx, 0x5cf659                            # 004e7c8f
    call FUN_004c2dfb                            # 004e7c94
    mov edx, dword ptr [ebp - local_4]           # 004e7c99
    mov dword ptr [edx + field_699], 0x0         # 004e7c9c
L_004e7ca6:
    # block 0x004e7ca6: entered by je at 0x004e7c83, 3 instruction(s), ends with je to 0x004e7cd3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e7ca6
    cmp dword ptr [eax + field_695], 0x0         # 004e7ca9
    je.d8 L_004e7cd3                             # 004e7cb0
    # block 0x004e7cb2: entered by fall-through of je at 0x004e7cb0, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e7cd3
    mov ecx, dword ptr [ebp - local_4]           # 004e7cb2
    add ecx, 0x695                               # 004e7cb5
    push ecx                                     # 004e7cbb
    mov ecx, 0x5cf659                            # 004e7cbc
    call FUN_004c2dfb                            # 004e7cc1
    mov edx, dword ptr [ebp - local_4]           # 004e7cc6
    mov dword ptr [edx + field_695], 0x0         # 004e7cc9
L_004e7cd3:
    # block 0x004e7cd3: entered by je at 0x004e7cb0, 3 instruction(s), ends with je to 0x004e7d00 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e7cd3
    cmp dword ptr [eax + field_691], 0x0         # 004e7cd6
    je.d8 L_004e7d00                             # 004e7cdd
    # block 0x004e7cdf: entered by fall-through of je at 0x004e7cdd, 7 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e7d00
    mov ecx, dword ptr [ebp - local_4]           # 004e7cdf
    add ecx, 0x691                               # 004e7ce2
    push ecx                                     # 004e7ce8
    mov ecx, 0x5cf659                            # 004e7ce9
    call FUN_004c2dfb                            # 004e7cee
    mov edx, dword ptr [ebp - local_4]           # 004e7cf3
    mov dword ptr [edx + field_691], 0x0         # 004e7cf6
L_004e7d00:
    # block 0x004e7d00: entered by je at 0x004e7cdd, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e7d00
    pop ebp                                      # 004e7d02
    ret                                          # 004e7d03

