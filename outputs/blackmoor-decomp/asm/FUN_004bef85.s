# FUN_004bef85
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bef85
# extent:       0x004bef85-0x004befc8 (67 code bytes)
# span:         0x004bef85-0x004befc8 (code 67, tables 0, padding 0)
# sha256:       69fa0a5113f4db405b458b2d2555b0f01ac768ce9f23535b1d843d2b47897902
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bef85_bink_wait
# naming:       native port src/original_methods_fl27a.c:m4bef85_bink_wait (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4bef85_bink_wait: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkWait@4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4bef85_bink_wait (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bef85 - 0x401000
.globl FUN_004bef85
FUN_004bef85:
    # block 0x004bef85: entry, 8 instruction(s), calls FUN_004bf38c, ends with jne to 0x004befab (forward)
    push ebp                                     # 004bef85
    {load} mov ebp, esp                          # 004bef86
    push ecx                                     # 004bef88
    mov dword ptr [ebp - local_4], ecx           # 004bef89
    mov ecx, dword ptr [ebp - local_4]           # 004bef8c
    call FUN_004bf38c                            # 004bef8f
    cmp dword ptr [ebp + arg_8], 0x0             # 004bef94
    jne.d8 L_004befab                            # 004bef98
    # block 0x004bef9a: entered by fall-through of jne at 0x004bef98, 4 instruction(s), ends with forward jump to 0x004befc2
    mov eax, dword ptr [ebp - local_4]           # 004bef9a
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bef9d
    {load} xor eax, eax                          # 004befa7
    jmp.d8 L_004befc2                            # 004befa9
L_004befab:
    # block 0x004befab: entered by jne at 0x004bef98, 5 instruction(s), calls binkw32.dll!_BinkWait@4, ends with je to 0x004befbd (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004befab
    push ecx                                     # 004befae
    call dword ptr [0x52a52c]                    # 004befaf
    test eax, eax                                # 004befb5
    je.d8 L_004befbd                             # 004befb7
    # block 0x004befb9: entered by fall-through of je at 0x004befb7, 2 instruction(s), ends with forward jump to 0x004befc2
    {load} xor eax, eax                          # 004befb9
    jmp.d8 L_004befc2                            # 004befbb
L_004befbd:
    # block 0x004befbd: entered by je at 0x004befb7, 1 instruction(s), falls into the block at 0x004befc2
    mov eax, 0x1                                 # 004befbd
L_004befc2:
    # block 0x004befc2: entered by jmp at 0x004befa9; jmp at 0x004befbb, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004befc2
    pop ebp                                      # 004befc4
    ret 0x4                                      # 004befc5

