# FUN_0049c490
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0049c490
# extent:       0x0049c490-0x0049c4be (46 code bytes)
# span:         0x0049c490-0x0049c4c0 (code 46, tables 0, padding 2)
# sha256:       4fee9ede1d845f17aabb4c60016a0f8cfb404e4cde80706f697daf553d83a9e8
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0049c490
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00490547, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00490547, .text + (0x00490547 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0049c490 - 0x401000
.globl FUN_0049c490
FUN_0049c490:
    # block 0x0049c490: entry, 10 instruction(s), calls FUN_00490547, ends with je to 0x0049c4b5 (forward)
    push ebp                                     # 0049c490
    {load} mov ebp, esp                          # 0049c491
    push ecx                                     # 0049c493
    mov dword ptr [ebp - local_4], ecx           # 0049c494
    mov ecx, dword ptr [ebp - local_4]           # 0049c497
    call FUN_00490547                            # 0049c49a
    mov eax, dword ptr [ebp + arg_8]             # 0049c49f
    and eax, 0x1                                 # 0049c4a2
    test eax, eax                                # 0049c4a5
    je.d8 L_0049c4b5                             # 0049c4a7
    # block 0x0049c4a9: entered by fall-through of je at 0x0049c4a7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0049c4b5
    mov ecx, dword ptr [ebp - local_4]           # 0049c4a9
    push ecx                                     # 0049c4ac
    call FUN_0051dc6c                            # 0049c4ad
    add esp, 0x4                                 # 0049c4b2
L_0049c4b5:
    # block 0x0049c4b5: entered by je at 0x0049c4a7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0049c4b5
    {load} mov esp, ebp                          # 0049c4b8
    pop ebp                                      # 0049c4ba
    ret 0x4                                      # 0049c4bb

# --- data items (not part of the function) -------------------------
.org 0x0049c4be - 0x401000
PAD_0049c4be:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

