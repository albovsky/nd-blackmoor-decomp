# FUN_004bed40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bed40
# extent:       0x004bed40-0x004bed6e (46 code bytes)
# span:         0x004bed40-0x004bed70 (code 46, tables 0, padding 2)
# sha256:       6ef6a7ed36b513841feeaeb37902ea38a793b445c80f0f44cc6df791d14c2f2b
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bed40
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004b9e1f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004b9e1f, .text + (0x004b9e1f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004bed40 - 0x401000
.globl FUN_004bed40
FUN_004bed40:
    # block 0x004bed40: entry, 10 instruction(s), calls FUN_004b9e1f, ends with je to 0x004bed65 (forward)
    push ebp                                     # 004bed40
    {load} mov ebp, esp                          # 004bed41
    push ecx                                     # 004bed43
    mov dword ptr [ebp - local_4], ecx           # 004bed44
    mov ecx, dword ptr [ebp - local_4]           # 004bed47
    call FUN_004b9e1f                            # 004bed4a
    mov eax, dword ptr [ebp + arg_8]             # 004bed4f
    and eax, 0x1                                 # 004bed52
    test eax, eax                                # 004bed55
    je.d8 L_004bed65                             # 004bed57
    # block 0x004bed59: entered by fall-through of je at 0x004bed57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004bed65
    mov ecx, dword ptr [ebp - local_4]           # 004bed59
    push ecx                                     # 004bed5c
    call FUN_0051dc6c                            # 004bed5d
    add esp, 0x4                                 # 004bed62
L_004bed65:
    # block 0x004bed65: entered by je at 0x004bed57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004bed65
    {load} mov esp, ebp                          # 004bed68
    pop ebp                                      # 004bed6a
    ret 0x4                                      # 004bed6b

# --- data items (not part of the function) -------------------------
.org 0x004bed6e - 0x401000
PAD_004bed6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

