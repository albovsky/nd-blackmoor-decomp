# FUN_004bef11
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bef11
# extent:       0x004bef11-0x004bef85 (116 code bytes)
# span:         0x004bef11-0x004bef85 (code 116, tables 0, padding 0)
# sha256:       e9ce0dd56561605180e985e9637699c5ab7649490b7c968e103fdfd3570c35af
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bef11_bink_goto
# naming:       native port src/original_methods_fl27a.c:m4bef11_bink_goto (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the summary is the acceptance note
# summary:      1:1 with m4bef11_bink_goto: the oracle runs every instruction and both directions of every conditional jump (untaken edges only as listed in the handoff). See tasks/fl27a-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_8, field_2c0, field_2c4; [ecx + n] field_2c4
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkGoto@12
# track-n:      outputs/blackmoor-decomp/src/bink_player.h:bink_player_set_mode (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_2c4, 0x2c4  # offset +0x2c4

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bef11 - 0x401000
.globl FUN_004bef11
FUN_004bef11:
    # block 0x004bef11: entry, 8 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bef3c (forward)
    push ebp                                     # 004bef11
    {load} mov ebp, esp                          # 004bef12
    sub esp, 0x8                                 # 004bef14
    mov dword ptr [ebp - local_4], ecx           # 004bef17
    mov ecx, dword ptr [ebp - local_4]           # 004bef1a
    call FUN_004bf38c                            # 004bef1d
    cmp dword ptr [ebp + arg_8], 0x0             # 004bef22
    jne.d8 L_004bef3c                            # 004bef26
    # block 0x004bef28: entered by fall-through of jne at 0x004bef26, 4 instruction(s), ends with forward jump to 0x004bef7f
    mov eax, dword ptr [ebp - local_4]           # 004bef28
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bef2b
    mov eax, 0xfffffffd                          # 004bef35
    jmp.d8 L_004bef7f                            # 004bef3a
L_004bef3c:
    # block 0x004bef3c: entered by jne at 0x004bef26, 8 instruction(s), ends with je to 0x004bef6a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004bef3c
    mov edx, dword ptr [ebp + arg_c]             # 004bef3f
    mov dword ptr [ecx + field_2c4], edx         # 004bef42
    mov eax, dword ptr [ebp - local_4]           # 004bef48
    mov ecx, dword ptr [eax + field_2c4]         # 004bef4b
    mov dword ptr [ebp - local_8], ecx           # 004bef51
    cmp dword ptr [ebp - local_8], 0x1           # 004bef54
    je.d8 L_004bef6a                             # 004bef58
    # block 0x004bef5a: entered by fall-through of je at 0x004bef58, 6 instruction(s), calls binkw32.dll!_BinkGoto@12, ends with forward jump to 0x004bef7d
    push 0x0                                     # 004bef5a
    push 0x1                                     # 004bef5c
    mov edx, dword ptr [ebp + arg_8]             # 004bef5e
    push edx                                     # 004bef61
    call dword ptr [0x52a530]                    # 004bef62
    jmp.d8 L_004bef7d                            # 004bef68
L_004bef6a:
    # block 0x004bef6a: entered by je at 0x004bef58, 7 instruction(s), calls binkw32.dll!_BinkGoto@12, falls into the block at 0x004bef7d
    push 0x0                                     # 004bef6a
    mov eax, dword ptr [ebp + arg_8]             # 004bef6c
    mov ecx, dword ptr [eax + field_8]           # 004bef6f
    push ecx                                     # 004bef72
    mov edx, dword ptr [ebp + arg_8]             # 004bef73
    push edx                                     # 004bef76
    call dword ptr [0x52a530]                    # 004bef77
L_004bef7d:
    # block 0x004bef7d: entered by jmp at 0x004bef68, 1 instruction(s), falls into the block at 0x004bef7f
    {load} xor eax, eax                          # 004bef7d
L_004bef7f:
    # block 0x004bef7f: entered by jmp at 0x004bef3a, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004bef7f
    pop ebp                                      # 004bef81
    ret 0x8                                      # 004bef82

