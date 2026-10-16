# FUN_0043eed0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eed0
# extent:       0x0043eed0-0x0043eefe (46 code bytes)
# span:         0x0043eed0-0x0043ef00 (code 46, tables 0, padding 2)
# sha256:       ca28b3892754861f8039263b15c15993076f18edc7d4930183c0a529f8d0c4ab
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043eed0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043eb59, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0043eb59, .text + (0x0043eb59 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0043eed0 - 0x401000
.globl FUN_0043eed0
FUN_0043eed0:
    # block 0x0043eed0: entry, 10 instruction(s), calls FUN_0043eb59, ends with je to 0x0043eef5 (forward)
    push ebp                                     # 0043eed0
    {load} mov ebp, esp                          # 0043eed1
    push ecx                                     # 0043eed3
    mov dword ptr [ebp - local_4], ecx           # 0043eed4
    mov ecx, dword ptr [ebp - local_4]           # 0043eed7
    call FUN_0043eb59                            # 0043eeda
    mov eax, dword ptr [ebp + arg_8]             # 0043eedf
    and eax, 0x1                                 # 0043eee2
    test eax, eax                                # 0043eee5
    je.d8 L_0043eef5                             # 0043eee7
    # block 0x0043eee9: entered by fall-through of je at 0x0043eee7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0043eef5
    mov ecx, dword ptr [ebp - local_4]           # 0043eee9
    push ecx                                     # 0043eeec
    call FUN_0051dc6c                            # 0043eeed
    add esp, 0x4                                 # 0043eef2
L_0043eef5:
    # block 0x0043eef5: entered by je at 0x0043eee7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0043eef5
    {load} mov esp, ebp                          # 0043eef8
    pop ebp                                      # 0043eefa
    ret 0x4                                      # 0043eefb

# --- data items (not part of the function) -------------------------
.org 0x0043eefe - 0x401000
PAD_0043eefe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

