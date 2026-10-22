# FUN_004ee9bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee9bb
# extent:       0x004ee9bb-0x004eead0 (277 code bytes)
# span:         0x004ee9bb-0x004eead0 (code 277, tables 0, padding 0)
# sha256:       c82b6824d3b6d805756e32065fd690823237bf8d82902f9aa2569c2f8e162352
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee9bb_lifted
# naming:       native port src/original_methods_fl39d.c:m4ee9bb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_16e, field_186, field_18a, field_19a, field_19e; [ecx + n] field_4, field_8, field_c, field_16a, field_182, field_196, field_1a2, field_1aa; [edx + n] field_8, field_162, field_166, field_18e, field_192, field_1a6
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ee9bb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16e, 0x16e  # offset +0x16e
.equ field_182, 0x182  # offset +0x182
.equ field_186, 0x186  # offset +0x186
.equ field_18a, 0x18a  # offset +0x18a
.equ field_18e, 0x18e  # offset +0x18e
.equ field_192, 0x192  # offset +0x192
.equ field_196, 0x196  # offset +0x196
.equ field_19a, 0x19a  # offset +0x19a
.equ field_19e, 0x19e  # offset +0x19e
.equ field_1a2, 0x1a2  # offset +0x1a2
.equ field_1a6, 0x1a6  # offset +0x1a6
.equ field_1aa, 0x1aa  # offset +0x1aa

# --- external targets -----------------------------------------------

.org 0x004ee9bb - 0x401000
.globl FUN_004ee9bb
FUN_004ee9bb:
    # block 0x004ee9bb: entry, 58 instruction(s), ends with ret
    push ebp                                     # 004ee9bb
    {load} mov ebp, esp                          # 004ee9bc
    push ecx                                     # 004ee9be
    push edi                                     # 004ee9bf
    mov dword ptr [ebp - local_4], ecx           # 004ee9c0
    mov eax, dword ptr [ebp - local_4]           # 004ee9c3
    mov dword ptr [eax + field_16e], 0x0         # 004ee9c6
    mov ecx, dword ptr [ebp - local_4]           # 004ee9d0
    mov dword ptr [ecx + field_4], 0x0           # 004ee9d3
    mov edx, dword ptr [ebp - local_4]           # 004ee9da
    mov dword ptr [edx + field_162], 0x0         # 004ee9dd
    mov eax, dword ptr [ebp - local_4]           # 004ee9e7
    mov dword ptr [eax + field_19e], 0x0         # 004ee9ea
    mov ecx, dword ptr [ebp - local_4]           # 004ee9f4
    mov dword ptr [ecx + field_16a], 0x0         # 004ee9f7
    mov edx, dword ptr [ebp - local_4]           # 004eea01
    mov dword ptr [edx + field_166], 0x0         # 004eea04
    mov eax, dword ptr [ebp - local_4]           # 004eea0e
    mov dword ptr [eax + field_186], 0x0         # 004eea11
    mov ecx, dword ptr [ebp - local_4]           # 004eea1b
    mov dword ptr [ecx + field_182], 0x0         # 004eea1e
    mov edx, dword ptr [ebp - local_4]           # 004eea28
    mov dword ptr [edx + field_18e], 0x0         # 004eea2b
    mov eax, dword ptr [ebp - local_4]           # 004eea35
    mov dword ptr [eax + field_18a], 0x0         # 004eea38
    mov ecx, dword ptr [ebp - local_4]           # 004eea42
    mov dword ptr [ecx + field_196], 0x0         # 004eea45
    mov edx, dword ptr [ebp - local_4]           # 004eea4f
    mov dword ptr [edx + field_192], 0x0         # 004eea52
    mov eax, dword ptr [ebp - local_4]           # 004eea5c
    mov dword ptr [eax + field_19a], 0x0         # 004eea5f
    mov ecx, dword ptr [ebp - local_4]           # 004eea69
    mov dword ptr [ecx + field_1a2], 0x0         # 004eea6c
    mov edx, dword ptr [ebp - local_4]           # 004eea76
    mov dword ptr [edx + field_8], 0x0           # 004eea79
    mov eax, dword ptr [ebp - local_4]           # 004eea80
    mov dword ptr [eax + field_c], 0x0           # 004eea83
    mov ecx, dword ptr [ebp - local_4]           # 004eea8a
    mov dword ptr [ecx + field_1aa], 0x0         # 004eea8d
    mov edx, dword ptr [ebp - local_4]           # 004eea97
    mov dword ptr [edx + field_1a6], 0x0         # 004eea9a
    mov ecx, 0x31                                # 004eeaa4
    {load} xor eax, eax                          # 004eeaa9
    mov edi, dword ptr [ebp - local_4]           # 004eeaab
    add edi, 0x18                                # 004eeaae
    rep stosd dword ptr es:[edi], eax            # 004eeab1
    stosw word ptr es:[edi], ax                  # 004eeab3
    {load} xor eax, eax                          # 004eeab5
    mov ecx, dword ptr [ebp - local_4]           # 004eeab7
    add ecx, 0x14e                               # 004eeaba
    mov dword ptr [ecx], eax                     # 004eeac0
    mov dword ptr [ecx + field_4], eax           # 004eeac2
    mov dword ptr [ecx + field_8], eax           # 004eeac5
    mov dword ptr [ecx + field_c], eax           # 004eeac8
    pop edi                                      # 004eeacb
    {load} mov esp, ebp                          # 004eeacc
    pop ebp                                      # 004eeace
    ret                                          # 004eeacf

