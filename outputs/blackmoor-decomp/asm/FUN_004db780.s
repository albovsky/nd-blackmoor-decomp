# FUN_004db780
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db780
# extent:       0x004db780-0x004db817 (151 code bytes)
# span:         0x004db780-0x004db817 (code 151, tables 0, padding 0)
# sha256:       d8c986b63a5bf00fce8e5aec637d9d823cd06c9b311f9213b7b4b8ce956e8eec
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db780_lifted
# naming:       native port src/original_methods_fl39d.c:m4db780_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (18 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_34, field_38, field_3c, field_40; [ecx + n] field_4, field_8, field_c; [edx + n] field_44, field_48, field_4c, field_50
# callees:      calls FUN_00493a54
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4db780_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_00493a54, .text + (0x00493a54 - 0x401000)

.org 0x004db780 - 0x401000
.globl FUN_004db780
FUN_004db780:
    # block 0x004db780: entry, 41 instruction(s), calls FUN_00493a54, ends with je to 0x004db813 (forward)
    push ebp                                     # 004db780
    {load} mov ebp, esp                          # 004db781
    push ecx                                     # 004db783
    mov dword ptr [ebp - local_4], ecx           # 004db784
    mov eax, dword ptr [ebp - local_4]           # 004db787
    mov ecx, dword ptr [eax + field_34]          # 004db78a
    sub ecx, dword ptr [0x583186]                # 004db78d
    mov edx, dword ptr [ebp - local_4]           # 004db793
    mov dword ptr [edx + field_44], ecx          # 004db796
    mov eax, dword ptr [ebp - local_4]           # 004db799
    mov ecx, dword ptr [eax + field_3c]          # 004db79c
    sub ecx, dword ptr [0x583186]                # 004db79f
    mov edx, dword ptr [ebp - local_4]           # 004db7a5
    mov dword ptr [edx + field_4c], ecx          # 004db7a8
    mov eax, dword ptr [ebp - local_4]           # 004db7ab
    mov ecx, dword ptr [eax + field_38]          # 004db7ae
    sub ecx, dword ptr [0x58318a]                # 004db7b1
    mov edx, dword ptr [ebp - local_4]           # 004db7b7
    mov dword ptr [edx + field_48], ecx          # 004db7ba
    mov eax, dword ptr [ebp - local_4]           # 004db7bd
    mov ecx, dword ptr [eax + field_40]          # 004db7c0
    sub ecx, dword ptr [0x58318a]                # 004db7c3
    mov edx, dword ptr [ebp - local_4]           # 004db7c9
    mov dword ptr [edx + field_50], ecx          # 004db7cc
    mov eax, dword ptr [ebp - local_4]           # 004db7cf
    add eax, 0x34                                # 004db7d2
    mov ecx, dword ptr [ebp - local_4]           # 004db7d5
    add ecx, 0x54                                # 004db7d8
    mov edx, dword ptr [eax]                     # 004db7db
    mov dword ptr [ecx], edx                     # 004db7dd
    mov edx, dword ptr [eax + field_4]           # 004db7df
    mov dword ptr [ecx + field_4], edx           # 004db7e2
    mov edx, dword ptr [eax + field_8]           # 004db7e5
    mov dword ptr [ecx + field_8], edx           # 004db7e8
    mov eax, dword ptr [eax + field_c]           # 004db7eb
    mov dword ptr [ecx + field_c], eax           # 004db7ee
    mov dword ptr [0x5d1683], 0x0                # 004db7f1
    mov ecx, 0x630a9a                            # 004db7fb
    call FUN_00493a54                            # 004db800
    test eax, eax                                # 004db805
    je.d8 L_004db813                             # 004db807
    # block 0x004db809: entered by fall-through of je at 0x004db807, 1 instruction(s), falls into the block at 0x004db813
    mov dword ptr [0x5d16cd], 0x1                # 004db809
L_004db813:
    # block 0x004db813: entered by je at 0x004db807, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004db813
    pop ebp                                      # 004db815
    ret                                          # 004db816

