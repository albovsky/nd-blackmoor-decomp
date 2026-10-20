# FUN_004e7d2e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7d2e
# extent:       0x004e7d2e-0x004e7dad (127 code bytes)
# span:         0x004e7d2e-0x004e7dad (code 127, tables 0, padding 0)
# sha256:       e48f0935980c1d28d513f60ed387634ae8408820fa33c0f19e55f85eb8da7337
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_ui_inventory_load_chunk
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4e7d2e.c.txt, not original source) refers to the data labelled s_CUIInventory__LoadChunk_____Tota_0055c530
# name-note:    Copies a 0xb2c-byte chunk into the CUIInventory object and reports a LoadChunk error if the supplied total size is smaller.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004e7d2e - 0x401000
.globl FUN_004e7d2e
FUN_004e7d2e:
    # block 0x004e7d2e: entry, 21 instruction(s), ends with jle to 0x004e7da5 (forward)
    push ebp                                     # 004e7d2e
    {load} mov ebp, esp                          # 004e7d2f
    sub esp, 0x8                                 # 004e7d31
    push esi                                     # 004e7d34
    push edi                                     # 004e7d35
    mov dword ptr [ebp - local_8], ecx           # 004e7d36
    mov dword ptr [ebp - local_4], 0x0           # 004e7d39
    mov edi, dword ptr [ebp - local_8]           # 004e7d40
    add edi, 0x6b20                              # 004e7d43
    mov ecx, 0x2cb                               # 004e7d49
    mov esi, dword ptr [ebp + arg_8]             # 004e7d4e
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004e7d51
    mov eax, dword ptr [ebp + arg_8]             # 004e7d53
    add eax, 0xb2c                               # 004e7d56
    mov dword ptr [ebp + arg_8], eax             # 004e7d5b
    mov ecx, dword ptr [ebp - local_4]           # 004e7d5e
    add ecx, 0xb2c                               # 004e7d61
    mov dword ptr [ebp - local_4], ecx           # 004e7d67
    mov edx, dword ptr [ebp - local_4]           # 004e7d6a
    cmp edx, dword ptr [ebp + arg_c]             # 004e7d6d
    jle.d8 L_004e7da5                            # 004e7d70
    # block 0x004e7d72: entered by fall-through of jle at 0x004e7d70, 13 instruction(s), calls FUN_0050ca3e, FUN_004264e8, FUN_004c97b4, falls into the block at 0x004e7da5
    mov eax, dword ptr [ebp + arg_c]             # 004e7d72
    push eax                                     # 004e7d75
    mov ecx, dword ptr [ebp - local_4]           # 004e7d76
    push ecx                                     # 004e7d79
    push 0x55c530                                # 004e7d7a
    push 0x63888b                                # 004e7d7f
    call FUN_0050ca3e                            # 004e7d84
    add esp, 0x10                                # 004e7d89
    push 0x63888b                                # 004e7d8c
    mov ecx, 0x583979                            # 004e7d91
    call FUN_004264e8                            # 004e7d96
    mov ecx, 0x5cf659                            # 004e7d9b
    call FUN_004c97b4                            # 004e7da0
L_004e7da5:
    # block 0x004e7da5: entered by jle at 0x004e7d70, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004e7da5
    pop esi                                      # 004e7da6
    {load} mov esp, ebp                          # 004e7da7
    pop ebp                                      # 004e7da9
    ret 0x8                                      # 004e7daa

