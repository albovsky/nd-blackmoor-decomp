# FUN_00467e23
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467e23
# extent:       0x00467e23-0x00467e70 (77 code bytes)
# span:         0x00467e23-0x00467e70 (code 77, tables 0, padding 0)
# sha256:       4c1e319f7b757b0e8587ce3ec0e136f4a6174cf8e46a0dbebd5aaacfceec1d40
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m467e23_lifted
# naming:       native port src/original_methods_fl40.c:m467e23_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 9 seeds; oracle 22/22 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1aa, field_258; [ecx + n] field_254, field_321; [edx + n] field_254
# callees:      calls FUN_004fb2e3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m467e23_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_254, 0x254  # offset +0x254
.equ field_258, 0x258  # offset +0x258
.equ field_321, 0x321  # offset +0x321

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00467e23 - 0x401000
.globl FUN_00467e23
FUN_00467e23:
    # block 0x00467e23: entry, 7 instruction(s), ends with je to 0x00467e42 (forward)
    push ebp                                     # 00467e23
    {load} mov ebp, esp                          # 00467e24
    push ecx                                     # 00467e26
    mov dword ptr [ebp - local_4], ecx           # 00467e27
    mov eax, dword ptr [ebp - local_4]           # 00467e2a
    cmp dword ptr [eax + field_258], 0x0         # 00467e2d
    je.d8 L_00467e42                             # 00467e34
    # block 0x00467e36: entered by fall-through of je at 0x00467e34, 3 instruction(s), ends with je to 0x00467e44 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467e36
    cmp dword ptr [ecx + field_254], 0x0         # 00467e39
    je.d8 L_00467e44                             # 00467e40
L_00467e42:
    # block 0x00467e42: entered by je at 0x00467e34; fall-through of je at 0x00467e40, 1 instruction(s), ends with forward jump to 0x00467e6c
    jmp.d8 L_00467e6c                            # 00467e42
L_00467e44:
    # block 0x00467e44: entered by je at 0x00467e40, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00467e6c
    mov edx, dword ptr [ebp - local_4]           # 00467e44
    mov dword ptr [edx + field_254], 0x1         # 00467e47
    mov eax, dword ptr [ebp - local_4]           # 00467e51
    mov ecx, dword ptr [eax + field_1aa]         # 00467e54
    mov dx, word ptr [ecx + field_321]           # 00467e5a
    push edx                                     # 00467e61
    mov ecx, 0x5c3a67                            # 00467e62
    call FUN_004fb2e3                            # 00467e67
L_00467e6c:
    # block 0x00467e6c: entered by jmp at 0x00467e42, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00467e6c
    pop ebp                                      # 00467e6e
    ret                                          # 00467e6f

