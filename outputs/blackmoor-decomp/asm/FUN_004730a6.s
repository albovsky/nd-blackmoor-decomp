# FUN_004730a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004730a6
# extent:       0x004730a6-0x00473117 (113 code bytes)
# span:         0x004730a6-0x00473117 (code 113, tables 0, padding 0)
# sha256:       d9eae7bd7f7c610ceed9dfd0cc9ff7379d826f6b654f4bfe857d6db6ffb60202
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4730a6_lifted
# naming:       native port src/original_methods_fl40.c:m4730a6_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 5 seeds; oracle 37/37 instructions, 6/6 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_14; [ecx + n] field_14; [edx + n] field_8
# callees:      calls FUN_004e1d34, FUN_004c2dfb, FUN_004d3992, FUN_00472fb7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4730a6_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00472fb7, .text + (0x00472fb7 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)

.org 0x004730a6 - 0x401000
.globl FUN_004730a6
FUN_004730a6:
    # block 0x004730a6: entry, 10 instruction(s), calls FUN_004e1d34, ends with je to 0x004730d5 (forward)
    push ebp                                     # 004730a6
    {load} mov ebp, esp                          # 004730a7
    push ecx                                     # 004730a9
    mov dword ptr [ebp - local_4], ecx           # 004730aa
    mov ecx, dword ptr [ebp - local_4]           # 004730ad
    add ecx, 0x1a6                               # 004730b0
    call FUN_004e1d34                            # 004730b6
    mov eax, dword ptr [ebp - local_4]           # 004730bb
    cmp dword ptr [eax + field_4], 0x0           # 004730be
    je.d8 L_004730d5                             # 004730c2
    # block 0x004730c4: entered by fall-through of je at 0x004730c2, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004730d5
    mov ecx, dword ptr [ebp - local_4]           # 004730c4
    add ecx, 0x4                                 # 004730c7
    push ecx                                     # 004730ca
    mov ecx, 0x5cf659                            # 004730cb
    call FUN_004c2dfb                            # 004730d0
L_004730d5:
    # block 0x004730d5: entered by je at 0x004730c2, 3 instruction(s), ends with je to 0x004730ef (forward)
    mov edx, dword ptr [ebp - local_4]           # 004730d5
    cmp dword ptr [edx + field_8], 0x0           # 004730d8
    je.d8 L_004730ef                             # 004730dc
    # block 0x004730de: entered by fall-through of je at 0x004730dc, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004730ef
    mov eax, dword ptr [ebp - local_4]           # 004730de
    add eax, 0x8                                 # 004730e1
    push eax                                     # 004730e4
    mov ecx, 0x5cf659                            # 004730e5
    call FUN_004c2dfb                            # 004730ea
L_004730ef:
    # block 0x004730ef: entered by je at 0x004730dc, 4 instruction(s), ends with je to 0x0047310b (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004730ef
    movsx edx, word ptr [ecx + field_14]         # 004730f2
    cmp edx, -0x1                                # 004730f6
    je.d8 L_0047310b                             # 004730f9
    # block 0x004730fb: entered by fall-through of je at 0x004730f9, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0047310b
    mov eax, dword ptr [ebp - local_4]           # 004730fb
    mov cx, word ptr [eax + field_14]            # 004730fe
    push ecx                                     # 00473102
    call FUN_004d3992                            # 00473103
    add esp, 0x4                                 # 00473108
L_0047310b:
    # block 0x0047310b: entered by je at 0x004730f9, 5 instruction(s), calls FUN_00472fb7, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0047310b
    call FUN_00472fb7                            # 0047310e
    {load} mov esp, ebp                          # 00473113
    pop ebp                                      # 00473115
    ret                                          # 00473116

