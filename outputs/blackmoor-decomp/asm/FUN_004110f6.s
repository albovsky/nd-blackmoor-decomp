# FUN_004110f6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004110f6
# extent:       0x004110f6-0x0041114f (89 code bytes)
# span:         0x004110f6-0x0041114f (code 89, tables 0, padding 0)
# sha256:       0f3fd959fd35d1bd7399aa7b2ceecba326d390d28b5ec924aac4adbbd75ba001
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4110f6_lifted
# naming:       native port src/original_methods_fl40.c:m4110f6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 24/24 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_6; [ecx + n] field_2930; [edx + n] field_12, field_2934
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4110f6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_6, 0x6  # offset +0x6
.equ field_12, 0x12  # offset +0x12
.equ field_2930, 0x2930  # offset +0x2930
.equ field_2934, 0x2934  # offset +0x2934

# --- external targets -----------------------------------------------

.org 0x004110f6 - 0x401000
.globl FUN_004110f6
FUN_004110f6:
    # block 0x004110f6: entry, 6 instruction(s), ends with forward jump to 0x00411111
    push ebp                                     # 004110f6
    {load} mov ebp, esp                          # 004110f7
    sub esp, 0x8                                 # 004110f9
    mov dword ptr [ebp - local_8], ecx           # 004110fc
    mov dword ptr [ebp - local_4], 0x0           # 004110ff
    jmp.d8 L_00411111                            # 00411106
L_00411108:
    # block 0x00411108: entered by jmp at 0x00411125, 3 instruction(s), falls into the block at 0x00411111
    mov eax, dword ptr [ebp - local_4]           # 00411108
    add eax, 0x1                                 # 0041110b
    mov dword ptr [ebp - local_4], eax           # 0041110e
L_00411111:
    # block 0x00411111: entered by jmp at 0x00411106, 2 instruction(s), ends with jge to 0x00411127 (forward)
    cmp dword ptr [ebp - local_4], 0x6           # 00411111
    jge.d8 L_00411127                            # 00411115
    # block 0x00411117: entered by fall-through of jge at 0x00411115, 4 instruction(s), ends with backward jump to 0x00411108
    mov ecx, dword ptr [ebp - local_4]           # 00411117
    mov edx, dword ptr [ebp - local_8]           # 0041111a
    mov dword ptr [edx + 4*ecx + field_12], 0xffffffff # 0041111d
    jmp.d8 L_00411108                            # 00411125
L_00411127:
    # block 0x00411127: entered by jge at 0x00411115, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 00411127
    mov dword ptr [eax + field_6], 0x0           # 0041112a
    mov ecx, dword ptr [ebp - local_8]           # 00411131
    mov dword ptr [ecx + field_2930], 0x0        # 00411134
    mov edx, dword ptr [ebp - local_8]           # 0041113e
    mov dword ptr [edx + field_2934], 0x1        # 00411141
    {load} mov esp, ebp                          # 0041114b
    pop ebp                                      # 0041114d
    ret                                          # 0041114e

