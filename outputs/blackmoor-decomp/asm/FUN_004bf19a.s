# FUN_004bf19a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf19a
# extent:       0x004bf19a-0x004bf1f0 (86 code bytes)
# span:         0x004bf19a-0x004bf1f0 (code 86, tables 0, padding 0)
# sha256:       e1d4bfba556921a1e9049bde018e652cb61afacfd2645daca3542d28abe35246
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4bf19a_bink_goto
# naming:       native port src/original_methods_fl29c.c:m4bf19a_bink_goto (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    Bink seek: thiscall 0x4bf38c, null handle word -3, signed frame<1 / unsigned frame>count rejections, else _BinkGoto@12 via slot 0x52a530 (result ignored) and 1. See fl29c-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_2c0; [ecx + n] field_8
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkGoto@12
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl29c.c:m4bf19a_bink_goto (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bf19a - 0x401000
.globl FUN_004bf19a
FUN_004bf19a:
    # block 0x004bf19a: entry, 8 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bf1c0 (forward)
    push ebp                                     # 004bf19a
    {load} mov ebp, esp                          # 004bf19b
    push ecx                                     # 004bf19d
    mov dword ptr [ebp - local_4], ecx           # 004bf19e
    mov ecx, dword ptr [ebp - local_4]           # 004bf1a1
    call FUN_004bf38c                            # 004bf1a4
    cmp dword ptr [ebp + arg_8], 0x0             # 004bf1a9
    jne.d8 L_004bf1c0                            # 004bf1ad
    # block 0x004bf1af: entered by fall-through of jne at 0x004bf1ad, 4 instruction(s), ends with forward jump to 0x004bf1ea
    mov eax, dword ptr [ebp - local_4]           # 004bf1af
    mov dword ptr [eax + field_2c0], 0xfffffffd  # 004bf1b2
    {load} xor eax, eax                          # 004bf1bc
    jmp.d8 L_004bf1ea                            # 004bf1be
L_004bf1c0:
    # block 0x004bf1c0: entered by jne at 0x004bf1ad, 2 instruction(s), ends with jl to 0x004bf1d1 (forward)
    cmp dword ptr [ebp + arg_c], 0x1             # 004bf1c0
    jl.d8 L_004bf1d1                             # 004bf1c4
    # block 0x004bf1c6: entered by fall-through of jl at 0x004bf1c4, 4 instruction(s), ends with jbe to 0x004bf1d5 (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 004bf1c6
    mov edx, dword ptr [ebp + arg_c]             # 004bf1c9
    cmp edx, dword ptr [ecx + field_8]           # 004bf1cc
    jbe.d8 L_004bf1d5                            # 004bf1cf
L_004bf1d1:
    # block 0x004bf1d1: entered by jl at 0x004bf1c4; fall-through of jbe at 0x004bf1cf, 2 instruction(s), ends with forward jump to 0x004bf1ea
    {load} xor eax, eax                          # 004bf1d1
    jmp.d8 L_004bf1ea                            # 004bf1d3
L_004bf1d5:
    # block 0x004bf1d5: entered by jbe at 0x004bf1cf, 7 instruction(s), calls binkw32.dll!_BinkGoto@12, falls into the block at 0x004bf1ea
    push 0x0                                     # 004bf1d5
    mov eax, dword ptr [ebp + arg_c]             # 004bf1d7
    push eax                                     # 004bf1da
    mov ecx, dword ptr [ebp + arg_8]             # 004bf1db
    push ecx                                     # 004bf1de
    call dword ptr [0x52a530]                    # 004bf1df
    mov eax, 0x1                                 # 004bf1e5
L_004bf1ea:
    # block 0x004bf1ea: entered by jmp at 0x004bf1be; jmp at 0x004bf1d3, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004bf1ea
    pop ebp                                      # 004bf1ec
    ret 0x8                                      # 004bf1ed

