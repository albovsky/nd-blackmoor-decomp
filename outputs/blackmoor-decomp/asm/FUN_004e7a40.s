# FUN_004e7a40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7a40
# extent:       0x004e7a40-0x004e7a6e (46 code bytes)
# span:         0x004e7a40-0x004e7a70 (code 46, tables 0, padding 2)
# sha256:       c77b9ff8574bb67b7aaf3b659c960a7d92674feb8e0db787f2ad31d8678a92bd
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7a40
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e7684, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e7684, .text + (0x004e7684 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004e7a40 - 0x401000
.globl FUN_004e7a40
FUN_004e7a40:
    # block 0x004e7a40: entry, 10 instruction(s), calls FUN_004e7684, ends with je to 0x004e7a65 (forward)
    push ebp                                     # 004e7a40
    {load} mov ebp, esp                          # 004e7a41
    push ecx                                     # 004e7a43
    mov dword ptr [ebp - local_4], ecx           # 004e7a44
    mov ecx, dword ptr [ebp - local_4]           # 004e7a47
    call FUN_004e7684                            # 004e7a4a
    mov eax, dword ptr [ebp + arg_8]             # 004e7a4f
    and eax, 0x1                                 # 004e7a52
    test eax, eax                                # 004e7a55
    je.d8 L_004e7a65                             # 004e7a57
    # block 0x004e7a59: entered by fall-through of je at 0x004e7a57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004e7a65
    mov ecx, dword ptr [ebp - local_4]           # 004e7a59
    push ecx                                     # 004e7a5c
    call FUN_0051dc6c                            # 004e7a5d
    add esp, 0x4                                 # 004e7a62
L_004e7a65:
    # block 0x004e7a65: entered by je at 0x004e7a57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004e7a65
    {load} mov esp, ebp                          # 004e7a68
    pop ebp                                      # 004e7a6a
    ret 0x4                                      # 004e7a6b

# --- data items (not part of the function) -------------------------
.org 0x004e7a6e - 0x401000
PAD_004e7a6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

