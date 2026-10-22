# FUN_004be18b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be18b
# extent:       0x004be18b-0x004be1dd (82 code bytes)
# span:         0x004be18b-0x004be1dd (code 82, tables 0, padding 0)
# sha256:       5e0b50481401be9a7b1378b6422034a1235cbfeba5ba3e5b605a5a25ac0fa72b
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4be18b_lifted
# naming:       native port src/original_methods_fl41.c:m4be18b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 30/30 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_4c, field_150; [ecx + n] field_4c; [edx + n] field_4
# callees:      calls FUN_004be2c6
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4be18b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_4c, 0x4c  # offset +0x4c
.equ field_150, 0x150  # offset +0x150

# --- external targets -----------------------------------------------
.set FUN_004be2c6, .text + (0x004be2c6 - 0x401000)

.org 0x004be18b - 0x401000
.globl FUN_004be18b
FUN_004be18b:
    # block 0x004be18b: entry, 7 instruction(s), ends with je to 0x004be1cc (forward)
    push ebp                                     # 004be18b
    {load} mov ebp, esp                          # 004be18c
    sub esp, 0xc                                 # 004be18e
    mov dword ptr [ebp - local_c], ecx           # 004be191
    mov eax, dword ptr [ebp - local_c]           # 004be194
    cmp dword ptr [eax + field_4c], 0x0          # 004be197
    je.d8 L_004be1cc                             # 004be19b
    # block 0x004be19d: entered by fall-through of je at 0x004be19b, 3 instruction(s), falls into the block at 0x004be1a6
    mov ecx, dword ptr [ebp - local_c]           # 004be19d
    mov edx, dword ptr [ecx + field_4c]          # 004be1a0
    mov dword ptr [ebp - local_4], edx           # 004be1a3
L_004be1a6:
    # block 0x004be1a6: entered by jmp at 0x004be1ca, 2 instruction(s), ends with je to 0x004be1cc (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004be1a6
    je.d8 L_004be1cc                             # 004be1aa
    # block 0x004be1ac: entered by fall-through of je at 0x004be1aa, 10 instruction(s), calls FUN_004be2c6, ends with backward jump to 0x004be1a6
    mov eax, dword ptr [ebp - local_4]           # 004be1ac
    mov ecx, dword ptr [eax + field_150]         # 004be1af
    mov dword ptr [ebp - local_8], ecx           # 004be1b5
    mov edx, dword ptr [ebp - local_4]           # 004be1b8
    push edx                                     # 004be1bb
    mov ecx, dword ptr [ebp - local_c]           # 004be1bc
    call FUN_004be2c6                            # 004be1bf
    mov eax, dword ptr [ebp - local_8]           # 004be1c4
    mov dword ptr [ebp - local_4], eax           # 004be1c7
    jmp.d8 L_004be1a6                            # 004be1ca
L_004be1cc:
    # block 0x004be1cc: entered by je at 0x004be19b; je at 0x004be1aa, 8 instruction(s), ends with ret
    {load} xor ecx, ecx                          # 004be1cc
    mov edx, dword ptr [ebp - local_c]           # 004be1ce
    add edx, 0x4c                                # 004be1d1
    mov dword ptr [edx], ecx                     # 004be1d4
    mov dword ptr [edx + field_4], ecx           # 004be1d6
    {load} mov esp, ebp                          # 004be1d9
    pop ebp                                      # 004be1db
    ret                                          # 004be1dc

