# FUN_0044c2b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044c2b0
# extent:       0x0044c2b0-0x0044c2de (46 code bytes)
# span:         0x0044c2b0-0x0044c2e0 (code 46, tables 0, padding 2)
# sha256:       e44d995865c57aba1494b2638e723f389078f36f2bb6a263e251063d3bcc7db1
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044c2b0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044bea7, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044bea7, .text + (0x0044bea7 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044c2b0 - 0x401000
.globl FUN_0044c2b0
FUN_0044c2b0:
    # block 0x0044c2b0: entry, 10 instruction(s), calls FUN_0044bea7, ends with je to 0x0044c2d5 (forward)
    push ebp                                     # 0044c2b0
    {load} mov ebp, esp                          # 0044c2b1
    push ecx                                     # 0044c2b3
    mov dword ptr [ebp - local_4], ecx           # 0044c2b4
    mov ecx, dword ptr [ebp - local_4]           # 0044c2b7
    call FUN_0044bea7                            # 0044c2ba
    mov eax, dword ptr [ebp + arg_8]             # 0044c2bf
    and eax, 0x1                                 # 0044c2c2
    test eax, eax                                # 0044c2c5
    je.d8 L_0044c2d5                             # 0044c2c7
    # block 0x0044c2c9: entered by fall-through of je at 0x0044c2c7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044c2d5
    mov ecx, dword ptr [ebp - local_4]           # 0044c2c9
    push ecx                                     # 0044c2cc
    call FUN_0051dc6c                            # 0044c2cd
    add esp, 0x4                                 # 0044c2d2
L_0044c2d5:
    # block 0x0044c2d5: entered by je at 0x0044c2c7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0044c2d5
    {load} mov esp, ebp                          # 0044c2d8
    pop ebp                                      # 0044c2da
    ret 0x4                                      # 0044c2db

# --- data items (not part of the function) -------------------------
.org 0x0044c2de - 0x401000
PAD_0044c2de:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

