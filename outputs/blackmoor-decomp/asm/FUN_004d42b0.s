# FUN_004d42b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d42b0
# extent:       0x004d42b0-0x004d42de (46 code bytes)
# span:         0x004d42b0-0x004d42e0 (code 46, tables 0, padding 2)
# sha256:       d381939a97675f4ddf6ca15848bc66b835db7ecbb7135a1f76cec291faa4d3fc
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d42b0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d3b6e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004d3b6e, .text + (0x004d3b6e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004d42b0 - 0x401000
.globl FUN_004d42b0
FUN_004d42b0:
    # block 0x004d42b0: entry, 10 instruction(s), calls FUN_004d3b6e, ends with je to 0x004d42d5 (forward)
    push ebp                                     # 004d42b0
    {load} mov ebp, esp                          # 004d42b1
    push ecx                                     # 004d42b3
    mov dword ptr [ebp - local_4], ecx           # 004d42b4
    mov ecx, dword ptr [ebp - local_4]           # 004d42b7
    call FUN_004d3b6e                            # 004d42ba
    mov eax, dword ptr [ebp + arg_8]             # 004d42bf
    and eax, 0x1                                 # 004d42c2
    test eax, eax                                # 004d42c5
    je.d8 L_004d42d5                             # 004d42c7
    # block 0x004d42c9: entered by fall-through of je at 0x004d42c7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004d42d5
    mov ecx, dword ptr [ebp - local_4]           # 004d42c9
    push ecx                                     # 004d42cc
    call FUN_0051dc6c                            # 004d42cd
    add esp, 0x4                                 # 004d42d2
L_004d42d5:
    # block 0x004d42d5: entered by je at 0x004d42c7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004d42d5
    {load} mov esp, ebp                          # 004d42d8
    pop ebp                                      # 004d42da
    ret 0x4                                      # 004d42db

# --- data items (not part of the function) -------------------------
.org 0x004d42de - 0x401000
PAD_004d42de:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

