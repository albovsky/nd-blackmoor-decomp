# FUN_004ceb8c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ceb8c
# extent:       0x004ceb8c-0x004cec6c (224 code bytes)
# span:         0x004ceb8c-0x004cec6c (code 224, tables 0, padding 0)
# sha256:       44fb80510d553e1cdf123f23cd3233c79932517869fc7315240aaf9df249673b
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ceb8c_load_rect
# naming:       native port src/original_methods_fl28c.c:m4ceb8c_load_rect (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4ceb8c_load_rect (rectangle load with origin). Oracle: 60/60 instructions of the 224 code bytes, 6/6 jcc directions, 81 scenarios. See tasks/fl28c-handoff.md.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1f2, field_1f6, field_1fa, field_1fe, field_222, field_24a; [ecx + n] field_12, field_16, field_1a, field_1e, field_1e2, field_1e6, field_1ea, field_1ee, field_22a; [edx + n] field_2, field_6, field_a, field_e, field_22a, field_24a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_2d_runtime.c:set_rects (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 60 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_16, 0x16  # offset +0x16
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_1e2, 0x1e2  # offset +0x1e2
.equ field_1e6, 0x1e6  # offset +0x1e6
.equ field_1ea, 0x1ea  # offset +0x1ea
.equ field_1ee, 0x1ee  # offset +0x1ee
.equ field_1f2, 0x1f2  # offset +0x1f2
.equ field_1f6, 0x1f6  # offset +0x1f6
.equ field_1fa, 0x1fa  # offset +0x1fa
.equ field_1fe, 0x1fe  # offset +0x1fe
.equ field_222, 0x222  # offset +0x222
.equ field_22a, 0x22a  # offset +0x22a
.equ field_24a, 0x24a  # offset +0x24a

# --- external targets -----------------------------------------------

.org 0x004ceb8c - 0x401000
.globl FUN_004ceb8c
FUN_004ceb8c:
    # block 0x004ceb8c: entry, 7 instruction(s), ends with je to 0x004cebb9 (forward)
    push ebp                                     # 004ceb8c
    {load} mov ebp, esp                          # 004ceb8d
    sub esp, 0x8                                 # 004ceb8f
    mov dword ptr [ebp - local_8], ecx           # 004ceb92
    mov eax, dword ptr [ebp - local_8]           # 004ceb95
    cmp dword ptr [eax + field_222], 0x0         # 004ceb98
    je.d8 L_004cebb9                             # 004ceb9f
    # block 0x004ceba1: entered by fall-through of je at 0x004ceb9f, 3 instruction(s), ends with je to 0x004cebb9 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004ceba1
    cmp dword ptr [ecx + field_22a], 0x0         # 004ceba4
    je.d8 L_004cebb9                             # 004cebab
    # block 0x004cebad: entered by fall-through of je at 0x004cebab, 3 instruction(s), ends with jne to 0x004cebbe (forward)
    mov edx, dword ptr [ebp - local_8]           # 004cebad
    cmp dword ptr [edx + field_24a], -0x1        # 004cebb0
    jne.d8 L_004cebbe                            # 004cebb7
L_004cebb9:
    # block 0x004cebb9: entered by je at 0x004ceb9f; je at 0x004cebab; fall-through of jne at 0x004cebb7, 1 instruction(s), ends with forward jump to 0x004cec68
    jmp.d32 L_004cec68                           # 004cebb9
L_004cebbe:
    # block 0x004cebbe: entered by jne at 0x004cebb7, 43 instruction(s), falls into the block at 0x004cec68
    mov eax, dword ptr [ebp - local_8]           # 004cebbe
    mov ecx, dword ptr [eax + field_24a]         # 004cebc1
    imul ecx, ecx, 0x22                          # 004cebc7
    mov edx, dword ptr [ebp - local_8]           # 004cebca
    mov eax, dword ptr [edx + field_22a]         # 004cebcd
    {load} add eax, ecx                          # 004cebd3
    mov dword ptr [ebp - local_4], eax           # 004cebd5
    mov ecx, dword ptr [ebp - local_8]           # 004cebd8
    mov edx, dword ptr [ebp - local_4]           # 004cebdb
    mov eax, dword ptr [edx + field_6]           # 004cebde
    mov dword ptr [ecx + field_1e6], eax         # 004cebe1
    mov ecx, dword ptr [ebp - local_8]           # 004cebe7
    mov edx, dword ptr [ebp - local_4]           # 004cebea
    mov eax, dword ptr [edx + field_e]           # 004cebed
    mov dword ptr [ecx + field_1ee], eax         # 004cebf0
    mov ecx, dword ptr [ebp - local_8]           # 004cebf6
    mov edx, dword ptr [ebp - local_4]           # 004cebf9
    mov eax, dword ptr [edx + field_2]           # 004cebfc
    mov dword ptr [ecx + field_1e2], eax         # 004cebff
    mov ecx, dword ptr [ebp - local_8]           # 004cec05
    mov edx, dword ptr [ebp - local_4]           # 004cec08
    mov eax, dword ptr [edx + field_a]           # 004cec0b
    mov dword ptr [ecx + field_1ea], eax         # 004cec0e
    mov ecx, dword ptr [ebp - local_4]           # 004cec14
    mov edx, dword ptr [ecx + field_16]          # 004cec17
    add edx, dword ptr [0x58318a]                # 004cec1a
    mov eax, dword ptr [ebp - local_8]           # 004cec20
    mov dword ptr [eax + field_1f6], edx         # 004cec23
    mov ecx, dword ptr [ebp - local_4]           # 004cec29
    mov edx, dword ptr [ecx + field_1e]          # 004cec2c
    add edx, dword ptr [0x58318a]                # 004cec2f
    mov eax, dword ptr [ebp - local_8]           # 004cec35
    mov dword ptr [eax + field_1fe], edx         # 004cec38
    mov ecx, dword ptr [ebp - local_4]           # 004cec3e
    mov edx, dword ptr [ecx + field_12]          # 004cec41
    add edx, dword ptr [0x583186]                # 004cec44
    mov eax, dword ptr [ebp - local_8]           # 004cec4a
    mov dword ptr [eax + field_1f2], edx         # 004cec4d
    mov ecx, dword ptr [ebp - local_4]           # 004cec53
    mov edx, dword ptr [ecx + field_1a]          # 004cec56
    add edx, dword ptr [0x583186]                # 004cec59
    mov eax, dword ptr [ebp - local_8]           # 004cec5f
    mov dword ptr [eax + field_1fa], edx         # 004cec62
L_004cec68:
    # block 0x004cec68: entered by jmp at 0x004cebb9, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004cec68
    pop ebp                                      # 004cec6a
    ret                                          # 004cec6b

