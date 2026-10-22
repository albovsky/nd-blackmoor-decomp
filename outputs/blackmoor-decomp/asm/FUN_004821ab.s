# FUN_004821ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004821ab
# extent:       0x004821ab-0x0048220e (99 code bytes)
# span:         0x004821ab-0x0048220e (code 99, tables 0, padding 0)
# sha256:       6a0760cd1c42a55bc340a3bff3e8a102cd0c32d40a8cb73208aaa0167767b0d7
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4821ab_lifted
# naming:       native port src/original_methods_fl39d.c:m4821ab_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (75 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_20; [ecx + n] field_1c; [edx + n] field_24
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0048217a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4821ab_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24

# --- external targets -----------------------------------------------
.set FUN_0048217a, .text + (0x0048217a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x004821ab - 0x401000
.globl FUN_004821ab
FUN_004821ab:
    # block 0x004821ab: entry, 7 instruction(s), ends with je to 0x004821cc (forward)
    push ebp                                     # 004821ab
    {load} mov ebp, esp                          # 004821ac
    push ecx                                     # 004821ae
    mov dword ptr [ebp - local_4], ecx           # 004821af
    mov eax, dword ptr [ebp - local_4]           # 004821b2
    cmp dword ptr [eax + field_20], 0x0          # 004821b5
    je.d8 L_004821cc                             # 004821b9
    # block 0x004821bb: entered by fall-through of je at 0x004821b9, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004821cc
    mov ecx, dword ptr [ebp - local_4]           # 004821bb
    add ecx, 0x20                                # 004821be
    push ecx                                     # 004821c1
    mov ecx, 0x5cf659                            # 004821c2
    call FUN_004c2dfb                            # 004821c7
L_004821cc:
    # block 0x004821cc: entered by je at 0x004821b9, 3 instruction(s), ends with je to 0x004821e6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004821cc
    cmp dword ptr [edx + field_24], 0x0          # 004821cf
    je.d8 L_004821e6                             # 004821d3
    # block 0x004821d5: entered by fall-through of je at 0x004821d3, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004821e6
    mov eax, dword ptr [ebp - local_4]           # 004821d5
    add eax, 0x24                                # 004821d8
    push eax                                     # 004821db
    mov ecx, 0x5cf659                            # 004821dc
    call FUN_004c2dfb                            # 004821e1
L_004821e6:
    # block 0x004821e6: entered by je at 0x004821d3, 4 instruction(s), ends with je to 0x00482202 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004821e6
    movsx edx, word ptr [ecx + field_1c]         # 004821e9
    cmp edx, -0x1                                # 004821ed
    je.d8 L_00482202                             # 004821f0
    # block 0x004821f2: entered by fall-through of je at 0x004821f0, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00482202
    mov eax, dword ptr [ebp - local_4]           # 004821f2
    mov cx, word ptr [eax + field_1c]            # 004821f5
    push ecx                                     # 004821f9
    call FUN_004d3992                            # 004821fa
    add esp, 0x4                                 # 004821ff
L_00482202:
    # block 0x00482202: entered by je at 0x004821f0, 5 instruction(s), calls FUN_0048217a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00482202
    call FUN_0048217a                            # 00482205
    {load} mov esp, ebp                          # 0048220a
    pop ebp                                      # 0048220c
    ret                                          # 0048220d

