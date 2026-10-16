# FUN_004a7b60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7b60
# extent:       0x004a7b60-0x004a7b8e (46 code bytes)
# span:         0x004a7b60-0x004a7b90 (code 46, tables 0, padding 2)
# sha256:       df5f4029f8a3f8424c80b68e63d875cd410facea5c00be5de2152d5aec94a07c
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a7b60
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004a636e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004a636e, .text + (0x004a636e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004a7b60 - 0x401000
.globl FUN_004a7b60
FUN_004a7b60:
    # block 0x004a7b60: entry, 10 instruction(s), calls FUN_004a636e, ends with je to 0x004a7b85 (forward)
    push ebp                                     # 004a7b60
    {load} mov ebp, esp                          # 004a7b61
    push ecx                                     # 004a7b63
    mov dword ptr [ebp - local_4], ecx           # 004a7b64
    mov ecx, dword ptr [ebp - local_4]           # 004a7b67
    call FUN_004a636e                            # 004a7b6a
    mov eax, dword ptr [ebp + arg_8]             # 004a7b6f
    and eax, 0x1                                 # 004a7b72
    test eax, eax                                # 004a7b75
    je.d8 L_004a7b85                             # 004a7b77
    # block 0x004a7b79: entered by fall-through of je at 0x004a7b77, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004a7b85
    mov ecx, dword ptr [ebp - local_4]           # 004a7b79
    push ecx                                     # 004a7b7c
    call FUN_0051dc6c                            # 004a7b7d
    add esp, 0x4                                 # 004a7b82
L_004a7b85:
    # block 0x004a7b85: entered by je at 0x004a7b77, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004a7b85
    {load} mov esp, ebp                          # 004a7b88
    pop ebp                                      # 004a7b8a
    ret 0x4                                      # 004a7b8b

# --- data items (not part of the function) -------------------------
.org 0x004a7b8e - 0x401000
PAD_004a7b8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

