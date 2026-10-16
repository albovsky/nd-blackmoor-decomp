# FUN_004d5880
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d5880
# extent:       0x004d5880-0x004d58ae (46 code bytes)
# span:         0x004d5880-0x004d58b0 (code 46, tables 0, padding 2)
# sha256:       4a5916129eab9a3ec8e352a9fe681a6e2c335b864b1078dfee7cd9e1122606a3
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d5880
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d527f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004d527f, .text + (0x004d527f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004d5880 - 0x401000
.globl FUN_004d5880
FUN_004d5880:
    # block 0x004d5880: entry, 10 instruction(s), calls FUN_004d527f, ends with je to 0x004d58a5 (forward)
    push ebp                                     # 004d5880
    {load} mov ebp, esp                          # 004d5881
    push ecx                                     # 004d5883
    mov dword ptr [ebp - local_4], ecx           # 004d5884
    mov ecx, dword ptr [ebp - local_4]           # 004d5887
    call FUN_004d527f                            # 004d588a
    mov eax, dword ptr [ebp + arg_8]             # 004d588f
    and eax, 0x1                                 # 004d5892
    test eax, eax                                # 004d5895
    je.d8 L_004d58a5                             # 004d5897
    # block 0x004d5899: entered by fall-through of je at 0x004d5897, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004d58a5
    mov ecx, dword ptr [ebp - local_4]           # 004d5899
    push ecx                                     # 004d589c
    call FUN_0051dc6c                            # 004d589d
    add esp, 0x4                                 # 004d58a2
L_004d58a5:
    # block 0x004d58a5: entered by je at 0x004d5897, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004d58a5
    {load} mov esp, ebp                          # 004d58a8
    pop ebp                                      # 004d58aa
    ret 0x4                                      # 004d58ab

# --- data items (not part of the function) -------------------------
.org 0x004d58ae - 0x401000
PAD_004d58ae:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

