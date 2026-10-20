# FUN_004bee5f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bee5f
# extent:       0x004bee5f-0x004beeb3 (84 code bytes)
# span:         0x004bee5f-0x004beeb3 (code 84, tables 0, padding 0)
# sha256:       8c952b45a931280f127c297be77a8b90b5fca399a53e4119f3209d5a479aec7e
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bee5f_bink_summary
# naming:       native port src/original_methods_fl27a.c:m4bee5f_bink_summary (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4bee5f_bink_summary: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkGetSummary@8
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl27a.c:m4bee5f_bink_summary (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bee5f - 0x401000
.globl FUN_004bee5f
FUN_004bee5f:
    # block 0x004bee5f: entry, 9 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bee95 (forward)
    push ebp                                     # 004bee5f
    {load} mov ebp, esp                          # 004bee60
    push ecx                                     # 004bee62
    push edi                                     # 004bee63
    mov dword ptr [ebp - local_4], ecx           # 004bee64
    mov ecx, dword ptr [ebp - local_4]           # 004bee67
    call FUN_004bf38c                            # 004bee6a
    cmp dword ptr [ebp + arg_8], 0x0             # 004bee6f
    jne.d8 L_004bee95                            # 004bee73
    # block 0x004bee75: entered by fall-through of jne at 0x004bee73, 9 instruction(s), ends with forward jump to 0x004beeac
    mov ecx, 0x1f                                # 004bee75
    {load} xor eax, eax                          # 004bee7a
    mov edi, dword ptr [ebp - local_4]           # 004bee7c
    add edi, 0x8                                 # 004bee7f
    rep stosd dword ptr es:[edi], eax            # 004bee82
    mov eax, dword ptr [ebp - local_4]           # 004bee84
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bee87
    {load} xor eax, eax                          # 004bee91
    jmp.d8 L_004beeac                            # 004bee93
L_004bee95:
    # block 0x004bee95: entered by jne at 0x004bee73, 8 instruction(s), calls binkw32.dll!_BinkGetSummary@8, falls into the block at 0x004beeac
    mov ecx, dword ptr [ebp - local_4]           # 004bee95
    add ecx, 0x8                                 # 004bee98
    push ecx                                     # 004bee9b
    mov edx, dword ptr [ebp + arg_8]             # 004bee9c
    push edx                                     # 004bee9f
    call dword ptr [0x52a508]                    # 004beea0
    mov eax, dword ptr [ebp - local_4]           # 004beea6
    add eax, 0x8                                 # 004beea9
L_004beeac:
    # block 0x004beeac: entered by jmp at 0x004bee93, 4 instruction(s), ends with ret 0x4
    pop edi                                      # 004beeac
    {load} mov esp, ebp                          # 004beead
    pop ebp                                      # 004beeaf
    ret 0x4                                      # 004beeb0

