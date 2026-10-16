# FUN_004674b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004674b0
# extent:       0x004674b0-0x004674de (46 code bytes)
# span:         0x004674b0-0x004674e0 (code 46, tables 0, padding 2)
# sha256:       5872acf049f48b213099811c706b3b871e8be1dae69e0ece6516253b44517409
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004674b0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00465aeb, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00465aeb, .text + (0x00465aeb - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004674b0 - 0x401000
.globl FUN_004674b0
FUN_004674b0:
    # block 0x004674b0: entry, 10 instruction(s), calls FUN_00465aeb, ends with je to 0x004674d5 (forward)
    push ebp                                     # 004674b0
    {load} mov ebp, esp                          # 004674b1
    push ecx                                     # 004674b3
    mov dword ptr [ebp - local_4], ecx           # 004674b4
    mov ecx, dword ptr [ebp - local_4]           # 004674b7
    call FUN_00465aeb                            # 004674ba
    mov eax, dword ptr [ebp + arg_8]             # 004674bf
    and eax, 0x1                                 # 004674c2
    test eax, eax                                # 004674c5
    je.d8 L_004674d5                             # 004674c7
    # block 0x004674c9: entered by fall-through of je at 0x004674c7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004674d5
    mov ecx, dword ptr [ebp - local_4]           # 004674c9
    push ecx                                     # 004674cc
    call FUN_0051dc6c                            # 004674cd
    add esp, 0x4                                 # 004674d2
L_004674d5:
    # block 0x004674d5: entered by je at 0x004674c7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004674d5
    {load} mov esp, ebp                          # 004674d8
    pop ebp                                      # 004674da
    ret 0x4                                      # 004674db

# --- data items (not part of the function) -------------------------
.org 0x004674de - 0x401000
PAD_004674de:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

