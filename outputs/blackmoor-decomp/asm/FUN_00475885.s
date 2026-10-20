# FUN_00475885
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00475885
# extent:       0x00475885-0x004758e8 (99 code bytes)
# span:         0x00475885-0x004758e8 (code 99, tables 0, padding 0)
# sha256:       772100c299d4d41d65ca06b2790f130267baef44c900d6a346dc17b68ddc3e7c
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m475885_release
# naming:       native port src/original_methods_fl20a.c:m475885_release (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m475885_release. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 99 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20, field_24; [ecx + n] field_20; [edx + n] field_28
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_004757da
# track-n:      outputs/blackmoor-decomp/src/action_family_e4_runtime.h:e4r_cleanup (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_004757da, .text + (0x004757da - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00475885 - 0x401000
.globl FUN_00475885
FUN_00475885:
    # block 0x00475885: entry, 7 instruction(s), ends with je to 0x004758a6 (forward)
    push ebp                                     # 00475885
    {load} mov ebp, esp                          # 00475886
    push ecx                                     # 00475888
    mov dword ptr [ebp - local_4], ecx           # 00475889
    mov eax, dword ptr [ebp - local_4]           # 0047588c
    cmp dword ptr [eax + field_24], 0x0          # 0047588f
    je.d8 L_004758a6                             # 00475893
    # block 0x00475895: entered by fall-through of je at 0x00475893, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004758a6
    mov ecx, dword ptr [ebp - local_4]           # 00475895
    add ecx, 0x24                                # 00475898
    push ecx                                     # 0047589b
    mov ecx, 0x5cf659                            # 0047589c
    call FUN_004c2dfb                            # 004758a1
L_004758a6:
    # block 0x004758a6: entered by je at 0x00475893, 3 instruction(s), ends with je to 0x004758c0 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004758a6
    cmp dword ptr [edx + field_28], 0x0          # 004758a9
    je.d8 L_004758c0                             # 004758ad
    # block 0x004758af: entered by fall-through of je at 0x004758ad, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004758c0
    mov eax, dword ptr [ebp - local_4]           # 004758af
    add eax, 0x28                                # 004758b2
    push eax                                     # 004758b5
    mov ecx, 0x5cf659                            # 004758b6
    call FUN_004c2dfb                            # 004758bb
L_004758c0:
    # block 0x004758c0: entered by je at 0x004758ad, 4 instruction(s), ends with je to 0x004758dc (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004758c0
    movsx edx, word ptr [ecx + field_20]         # 004758c3
    cmp edx, -0x1                                # 004758c7
    je.d8 L_004758dc                             # 004758ca
    # block 0x004758cc: entered by fall-through of je at 0x004758ca, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x004758dc
    mov eax, dword ptr [ebp - local_4]           # 004758cc
    mov cx, word ptr [eax + field_20]            # 004758cf
    push ecx                                     # 004758d3
    call FUN_004d3992                            # 004758d4
    add esp, 0x4                                 # 004758d9
L_004758dc:
    # block 0x004758dc: entered by je at 0x004758ca, 5 instruction(s), calls FUN_004757da, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004758dc
    call FUN_004757da                            # 004758df
    {load} mov esp, ebp                          # 004758e4
    pop ebp                                      # 004758e6
    ret                                          # 004758e7

