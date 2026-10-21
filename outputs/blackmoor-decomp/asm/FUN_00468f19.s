# FUN_00468f19
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468f19
# extent:       0x00468f19-0x00468f68 (79 code bytes)
# span:         0x00468f19-0x00468f68 (code 79, tables 0, padding 0)
# sha256:       fa088a5b6ee73b5c89eb709dfa1bbb3c8dcebe3638b1dbdd680acd57583f19be
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m468f19_release_surface_call_tail
# naming:       native port src/original_methods_fl38a.c:m468f19_release_surface_call_tail (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4c2dfb(this+0x52c) if dword [this+0x52c] is set, 0x4d3992(word [this+0x7c]) if not -1, then 0x468e5a(this). 26/26 instructions, 4/4 branch directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_52c; [ecx + n] field_7c; [edx + n] field_7c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00468e5a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38a.c:m468f19_release_surface_call_tail (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7c, 0x7c  # offset +0x7c
.equ field_52c, 0x52c  # offset +0x52c

# --- external targets -----------------------------------------------
.set FUN_00468e5a, .text + (0x00468e5a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00468f19 - 0x401000
.globl FUN_00468f19
FUN_00468f19:
    # block 0x00468f19: entry, 7 instruction(s), ends with je to 0x00468f40 (forward)
    push ebp                                     # 00468f19
    {load} mov ebp, esp                          # 00468f1a
    push ecx                                     # 00468f1c
    mov dword ptr [ebp - local_4], ecx           # 00468f1d
    mov eax, dword ptr [ebp - local_4]           # 00468f20
    cmp dword ptr [eax + field_52c], 0x0         # 00468f23
    je.d8 L_00468f40                             # 00468f2a
    # block 0x00468f2c: entered by fall-through of je at 0x00468f2a, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00468f40
    mov ecx, dword ptr [ebp - local_4]           # 00468f2c
    add ecx, 0x52c                               # 00468f2f
    push ecx                                     # 00468f35
    mov ecx, 0x5cf659                            # 00468f36
    call FUN_004c2dfb                            # 00468f3b
L_00468f40:
    # block 0x00468f40: entered by je at 0x00468f2a, 4 instruction(s), ends with je to 0x00468f5c (forward)
    mov edx, dword ptr [ebp - local_4]           # 00468f40
    movsx eax, word ptr [edx + field_7c]         # 00468f43
    cmp eax, -0x1                                # 00468f47
    je.d8 L_00468f5c                             # 00468f4a
    # block 0x00468f4c: entered by fall-through of je at 0x00468f4a, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00468f5c
    mov ecx, dword ptr [ebp - local_4]           # 00468f4c
    mov dx, word ptr [ecx + field_7c]            # 00468f4f
    push edx                                     # 00468f53
    call FUN_004d3992                            # 00468f54
    add esp, 0x4                                 # 00468f59
L_00468f5c:
    # block 0x00468f5c: entered by je at 0x00468f4a, 5 instruction(s), calls FUN_00468e5a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00468f5c
    call FUN_00468e5a                            # 00468f5f
    {load} mov esp, ebp                          # 00468f64
    pop ebp                                      # 00468f66
    ret                                          # 00468f67

