# FUN_004fc808
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc808
# extent:       0x004fc808-0x004fc878 (112 code bytes)
# span:         0x004fc808-0x004fc878 (code 112, tables 0, padding 0)
# sha256:       8a3072a589d1e623c814e0665396ac69dc9eb0041c5c2bcc00423a69bd99f0f8
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4fc808_clear_slot
# naming:       native port src/original_methods_fl28a.c:m4fc808_clear_slot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-19); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m4fc808_clear_slot: the oracle runs every instruction of 0x4fc808..0x4fc878 and both jump directions, comparing ordered host calls and memory. See tasks/fl28a-handoff.md.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_132
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004f356e
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl28a.c:m4fc808_clear_slot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 30 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_132, 0x132  # offset +0x132

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f356e, .text + (0x004f356e - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004fc808 - 0x401000
.globl FUN_004fc808
FUN_004fc808:
    # block 0x004fc808: entry, 7 instruction(s), ends with je to 0x004fc843 (forward)
    push ebp                                     # 004fc808
    {load} mov ebp, esp                          # 004fc809
    push ecx                                     # 004fc80b
    mov dword ptr [ebp - local_4], ecx           # 004fc80c
    movsx eax, word ptr [0x63a4cd]               # 004fc80f
    test eax, eax                                # 004fc816
    je.d8 L_004fc843                             # 004fc818
    # block 0x004fc81a: entered by fall-through of je at 0x004fc818, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004fc843
    mov ecx, dword ptr [ebp + arg_8]             # 004fc81a
    and ecx, 0xffff                              # 004fc81d
    push ecx                                     # 004fc823
    push 0x56090c                                # 004fc824
    push 0x63888b                                # 004fc829
    call FUN_0050ca3e                            # 004fc82e
    add esp, 0xc                                 # 004fc833
    push 0x63888b                                # 004fc836
    call FUN_0044a2b7                            # 004fc83b
    add esp, 0x4                                 # 004fc840
L_004fc843:
    # block 0x004fc843: entered by je at 0x004fc818, 13 instruction(s), calls FUN_004f356e, ends with ret 0x4
    mov edx, dword ptr [ebp + arg_8]             # 004fc843
    and edx, 0xffff                              # 004fc846
    push edx                                     # 004fc84c
    mov ecx, 0x5cf1eb                            # 004fc84d
    call FUN_004f356e                            # 004fc852
    mov eax, dword ptr [ebp + arg_8]             # 004fc857
    and eax, 0xffff                              # 004fc85a
    imul eax, eax, 0x5bb                         # 004fc85f
    mov ecx, dword ptr [ebp - local_4]           # 004fc865
    mov word ptr [ecx + eax + field_132], 0x0    # 004fc868
    {load} mov esp, ebp                          # 004fc872
    pop ebp                                      # 004fc874
    ret 0x4                                      # 004fc875

