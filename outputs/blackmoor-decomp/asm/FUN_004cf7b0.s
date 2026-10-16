# FUN_004cf7b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cf7b0
# extent:       0x004cf7b0-0x004cf7de (46 code bytes)
# span:         0x004cf7b0-0x004cf7e0 (code 46, tables 0, padding 2)
# sha256:       d09dc160474cea3251a914e4b395596e310bb996a4843d6caa4c451a1027c28a
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cf7b0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004ccd8f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004ccd8f, .text + (0x004ccd8f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004cf7b0 - 0x401000
.globl FUN_004cf7b0
FUN_004cf7b0:
    # block 0x004cf7b0: entry, 10 instruction(s), calls FUN_004ccd8f, ends with je to 0x004cf7d5 (forward)
    push ebp                                     # 004cf7b0
    {load} mov ebp, esp                          # 004cf7b1
    push ecx                                     # 004cf7b3
    mov dword ptr [ebp - local_4], ecx           # 004cf7b4
    mov ecx, dword ptr [ebp - local_4]           # 004cf7b7
    call FUN_004ccd8f                            # 004cf7ba
    mov eax, dword ptr [ebp + arg_8]             # 004cf7bf
    and eax, 0x1                                 # 004cf7c2
    test eax, eax                                # 004cf7c5
    je.d8 L_004cf7d5                             # 004cf7c7
    # block 0x004cf7c9: entered by fall-through of je at 0x004cf7c7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004cf7d5
    mov ecx, dword ptr [ebp - local_4]           # 004cf7c9
    push ecx                                     # 004cf7cc
    call FUN_0051dc6c                            # 004cf7cd
    add esp, 0x4                                 # 004cf7d2
L_004cf7d5:
    # block 0x004cf7d5: entered by je at 0x004cf7c7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004cf7d5
    {load} mov esp, ebp                          # 004cf7d8
    pop ebp                                      # 004cf7da
    ret 0x4                                      # 004cf7db

# --- data items (not part of the function) -------------------------
.org 0x004cf7de - 0x401000
PAD_004cf7de:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

