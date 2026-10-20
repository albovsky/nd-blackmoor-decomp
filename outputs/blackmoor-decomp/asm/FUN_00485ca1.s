# FUN_00485ca1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00485ca1
# extent:       0x00485ca1-0x00485d52 (177 code bytes)
# span:         0x00485ca1-0x00485d52 (code 177, tables 0, padding 0)
# sha256:       4c63a7987297a76e795c3140f0aac896ebbe5018fb598c1a86b3c57bec5e8ec1
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         pick_sound
# naming:       native port src/action_family_ea_runtime.c:pick_sound (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with pick_sound (record +0x6a7: NO SOUND test, copy, prepare, play, state 1, deadline tick+300). Body is a parameter; tick/sound are host callbacks; oracle aggregate.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_26, field_b87; [ecx + n] field_bac; [edx + n] field_b73, field_bc9
# callees:      calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_ea_runtime.c:pick_sound (function ledger class native_oracle_verified; also piece_sound; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 48 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_26, 0x26  # offset +0x26
.equ field_b73, 0xb73  # offset +0xb73
.equ field_b87, 0xb87  # offset +0xb87
.equ field_bac, 0xbac  # offset +0xbac
.equ field_bc9, 0xbc9  # offset +0xbc9

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x00485ca1 - 0x401000
.globl FUN_00485ca1
FUN_00485ca1:
    # block 0x00485ca1: entry, 18 instruction(s), ends with je to 0x00485d4c (forward)
    push ebp                                     # 00485ca1
    {load} mov ebp, esp                          # 00485ca2
    sub esp, 0x8                                 # 00485ca4
    push esi                                     # 00485ca7
    push edi                                     # 00485ca8
    mov dword ptr [ebp - local_8], ecx           # 00485ca9
    mov eax, dword ptr [ebp - local_8]           # 00485cac
    movsx ecx, word ptr [eax + field_26]         # 00485caf
    imul ecx, ecx, 0x8d                          # 00485cb3
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00485cb9
    mov dword ptr [ebp - local_4], edx           # 00485cbf
    mov edi, 0x54db48                            # 00485cc2
    mov esi, dword ptr [ebp - local_4]           # 00485cc7
    add esi, 0x6a7                               # 00485cca
    mov ecx, 0x9                                 # 00485cd0
    {load} xor eax, eax                          # 00485cd5
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00485cd7
    je.d8 L_00485d4c                             # 00485cd9
    # block 0x00485cdb: entered by fall-through of je at 0x00485cd9, 25 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, KERNEL32.dll!GetTickCount, falls into the block at 0x00485d4c
    mov esi, dword ptr [ebp - local_4]           # 00485cdb
    add esi, 0x6a7                               # 00485cde
    mov edi, dword ptr [ebp - local_8]           # 00485ce4
    add edi, 0xb52                               # 00485ce7
    mov ecx, 0xc                                 # 00485ced
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00485cf2
    movsb byte ptr es:[edi], byte ptr [esi]      # 00485cf4
    mov ecx, dword ptr [ebp - local_8]           # 00485cf5
    add ecx, 0xb52                               # 00485cf8
    push ecx                                     # 00485cfe
    mov ecx, 0x5c3a67                            # 00485cff
    call FUN_004fb77a                            # 00485d04
    mov edx, dword ptr [ebp - local_8]           # 00485d09
    mov ax, word ptr [edx + field_b73]           # 00485d0c
    push eax                                     # 00485d13
    mov ecx, 0x5c3a67                            # 00485d14
    call FUN_004fb2e3                            # 00485d19
    mov ecx, dword ptr [ebp - local_8]           # 00485d1e
    mov dword ptr [ecx + field_bac], 0x1         # 00485d21
    call dword ptr [0x52a23c]                    # 00485d2b
    add eax, 0x12c                               # 00485d31
    mov edx, dword ptr [ebp - local_8]           # 00485d36
    mov dword ptr [edx + field_bc9], eax         # 00485d39
    mov eax, dword ptr [ebp - local_8]           # 00485d3f
    mov dword ptr [eax + field_b87], 0x0         # 00485d42
L_00485d4c:
    # block 0x00485d4c: entered by je at 0x00485cd9, 5 instruction(s), ends with ret
    pop edi                                      # 00485d4c
    pop esi                                      # 00485d4d
    {load} mov esp, ebp                          # 00485d4e
    pop ebp                                      # 00485d50
    ret                                          # 00485d51

