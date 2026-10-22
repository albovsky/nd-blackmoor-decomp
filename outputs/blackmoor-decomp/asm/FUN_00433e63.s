# FUN_00433e63
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00433e63
# extent:       0x00433e63-0x00433eaa (71 code bytes)
# span:         0x00433e63-0x00433eaa (code 71, tables 0, padding 0)
# sha256:       c665bd041a02d74636abf3ee268b3e8cbd55077f226171faedba76e7b62f94df
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m433e63_lifted
# naming:       native port src/original_methods_fl40.c:m433e63_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 4 seeds; oracle 21/21 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_1118; [edx + n] field_1118
# callees:      calls FUN_0051dc6c
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m433e63_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1118, 0x1118  # offset +0x1118

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00433e63 - 0x401000
.globl FUN_00433e63
FUN_00433e63:
    # block 0x00433e63: entry, 9 instruction(s), ends with je to 0x00433ea6 (forward)
    push ebp                                     # 00433e63
    {load} mov ebp, esp                          # 00433e64
    sub esp, 0x8                                 # 00433e66
    mov dword ptr [ebp - local_8], ecx           # 00433e69
    mov eax, dword ptr [ebp - local_8]           # 00433e6c
    mov dword ptr [eax], 0x52c7b8                # 00433e6f
    mov ecx, dword ptr [ebp - local_8]           # 00433e75
    cmp dword ptr [ecx + field_1118], 0x0        # 00433e78
    je.d8 L_00433ea6                             # 00433e7f
    # block 0x00433e81: entered by fall-through of je at 0x00433e7f, 9 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00433ea6
    mov edx, dword ptr [ebp - local_8]           # 00433e81
    mov eax, dword ptr [edx + field_1118]        # 00433e84
    mov dword ptr [ebp - local_4], eax           # 00433e8a
    mov ecx, dword ptr [ebp - local_4]           # 00433e8d
    push ecx                                     # 00433e90
    call FUN_0051dc6c                            # 00433e91
    add esp, 0x4                                 # 00433e96
    mov edx, dword ptr [ebp - local_8]           # 00433e99
    mov dword ptr [edx + field_1118], 0x0        # 00433e9c
L_00433ea6:
    # block 0x00433ea6: entered by je at 0x00433e7f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00433ea6
    pop ebp                                      # 00433ea8
    ret                                          # 00433ea9

