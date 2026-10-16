# FUN_004cae90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cae90
# extent:       0x004cae90-0x004caebe (46 code bytes)
# span:         0x004cae90-0x004caec0 (code 46, tables 0, padding 2)
# sha256:       c7709df217ab652ebf9b197c2cdab1c37b266026f4191d5bd9e3ee54857f9187
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cae90
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c139a, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004c139a, .text + (0x004c139a - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004cae90 - 0x401000
.globl FUN_004cae90
FUN_004cae90:
    # block 0x004cae90: entry, 10 instruction(s), calls FUN_004c139a, ends with je to 0x004caeb5 (forward)
    push ebp                                     # 004cae90
    {load} mov ebp, esp                          # 004cae91
    push ecx                                     # 004cae93
    mov dword ptr [ebp - local_4], ecx           # 004cae94
    mov ecx, dword ptr [ebp - local_4]           # 004cae97
    call FUN_004c139a                            # 004cae9a
    mov eax, dword ptr [ebp + arg_8]             # 004cae9f
    and eax, 0x1                                 # 004caea2
    test eax, eax                                # 004caea5
    je.d8 L_004caeb5                             # 004caea7
    # block 0x004caea9: entered by fall-through of je at 0x004caea7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004caeb5
    mov ecx, dword ptr [ebp - local_4]           # 004caea9
    push ecx                                     # 004caeac
    call FUN_0051dc6c                            # 004caead
    add esp, 0x4                                 # 004caeb2
L_004caeb5:
    # block 0x004caeb5: entered by je at 0x004caea7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004caeb5
    {load} mov esp, ebp                          # 004caeb8
    pop ebp                                      # 004caeba
    ret 0x4                                      # 004caebb

# --- data items (not part of the function) -------------------------
.org 0x004caebe - 0x401000
PAD_004caebe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

