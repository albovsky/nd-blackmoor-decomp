# FUN_004befc8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004befc8
# extent:       0x004befc8-0x004bf024 (92 code bytes)
# span:         0x004befc8-0x004bf024 (code 92, tables 0, padding 0)
# sha256:       59a12f309ea0a419703659113e52ab7218197e292bba55a7ae5675dc04a8b197
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4befc8_bink_do_frame
# naming:       native port src/original_methods_fl27a.c:m4befc8_bink_do_frame (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4befc8_bink_do_frame: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_bc; [ecx + n] field_bc, field_2c0; [edx + n] field_bc
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkDoFrame@4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4befc8_bink_do_frame (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004befc8 - 0x401000
.globl FUN_004befc8
FUN_004befc8:
    # block 0x004befc8: entry, 10 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bf002 (forward)
    push ebp                                     # 004befc8
    {load} mov ebp, esp                          # 004befc9
    push ecx                                     # 004befcb
    mov dword ptr [ebp - local_4], ecx           # 004befcc
    mov ecx, dword ptr [ebp - local_4]           # 004befcf
    call FUN_004bf38c                            # 004befd2
    mov eax, dword ptr [ebp - local_4]           # 004befd7
    mov dword ptr [eax + field_bc], 0x0          # 004befda
    cmp dword ptr [ebp + arg_8], 0x0             # 004befe4
    jne.d8 L_004bf002                            # 004befe8
    # block 0x004befea: entered by fall-through of jne at 0x004befe8, 5 instruction(s), ends with forward jump to 0x004bf01e
    mov ecx, dword ptr [ebp - local_4]           # 004befea
    mov dword ptr [ecx + field_2c0], 0xfffffffd  # 004befed
    mov edx, dword ptr [ebp - local_4]           # 004beff7
    mov eax, dword ptr [edx + field_bc]          # 004beffa
    jmp.d8 L_004bf01e                            # 004bf000
L_004bf002:
    # block 0x004bf002: entered by jne at 0x004befe8, 7 instruction(s), calls binkw32.dll!_BinkDoFrame@4, falls into the block at 0x004bf01e
    mov eax, dword ptr [ebp + arg_8]             # 004bf002
    push eax                                     # 004bf005
    call dword ptr [0x52a528]                    # 004bf006
    mov ecx, dword ptr [ebp - local_4]           # 004bf00c
    mov dword ptr [ecx + field_bc], eax          # 004bf00f
    mov edx, dword ptr [ebp - local_4]           # 004bf015
    mov eax, dword ptr [edx + field_bc]          # 004bf018
L_004bf01e:
    # block 0x004bf01e: entered by jmp at 0x004bf000, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004bf01e
    pop ebp                                      # 004bf020
    ret 0x4                                      # 004bf021

