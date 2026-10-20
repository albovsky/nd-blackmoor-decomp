# FUN_004ee673
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee673
# extent:       0x004ee673-0x004ee69e (43 code bytes)
# span:         0x004ee673-0x004ee69e (code 43, tables 0, padding 0)
# sha256:       ae43cdb79497996bfc4d34f3cb51c416c9f0452731bfe2cc8c0dbff77dd9e6d6
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ee673_forward_if_set
# naming:       native port src/original_methods_fl31b.c:m4ee673_forward_if_set (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    When the dword at +0x252 is non-zero calls 0x4ef4f0 with ecx = this + 0x4b7 and the argument; 15/15 instructions, 2/2 jump directions. See tasks/fl31b-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_252
# callees:      calls FUN_004ef4f0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31b.c:m4ee673_forward_if_set (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_252, 0x252  # offset +0x252

# --- external targets -----------------------------------------------
.set FUN_004ef4f0, .text + (0x004ef4f0 - 0x401000)

.org 0x004ee673 - 0x401000
.globl FUN_004ee673
FUN_004ee673:
    # block 0x004ee673: entry, 7 instruction(s), ends with je to 0x004ee698 (forward)
    push ebp                                     # 004ee673
    {load} mov ebp, esp                          # 004ee674
    push ecx                                     # 004ee676
    mov dword ptr [ebp - local_4], ecx           # 004ee677
    mov eax, dword ptr [ebp - local_4]           # 004ee67a
    cmp dword ptr [eax + field_252], 0x0         # 004ee67d
    je.d8 L_004ee698                             # 004ee684
    # block 0x004ee686: entered by fall-through of je at 0x004ee684, 5 instruction(s), calls FUN_004ef4f0, falls into the block at 0x004ee698
    mov ecx, dword ptr [ebp + arg_8]             # 004ee686
    push ecx                                     # 004ee689
    mov ecx, dword ptr [ebp - local_4]           # 004ee68a
    add ecx, 0x4b7                               # 004ee68d
    call FUN_004ef4f0                            # 004ee693
L_004ee698:
    # block 0x004ee698: entered by je at 0x004ee684, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004ee698
    pop ebp                                      # 004ee69a
    ret 0x4                                      # 004ee69b

