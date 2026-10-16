# FUN_00414490
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00414490
# extent:       0x00414490-0x004144be (46 code bytes)
# span:         0x00414490-0x004144c0 (code 46, tables 0, padding 2)
# sha256:       14686ed45256382b594056f0ec51ca2be74a25f57ed21c9388b5637aeef96d91
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00414490
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004110d7, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004110d7, .text + (0x004110d7 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00414490 - 0x401000
.globl FUN_00414490
FUN_00414490:
    # block 0x00414490: entry, 10 instruction(s), calls FUN_004110d7, ends with je to 0x004144b5 (forward)
    push ebp                                     # 00414490
    {load} mov ebp, esp                          # 00414491
    push ecx                                     # 00414493
    mov dword ptr [ebp - local_4], ecx           # 00414494
    mov ecx, dword ptr [ebp - local_4]           # 00414497
    call FUN_004110d7                            # 0041449a
    mov eax, dword ptr [ebp + arg_8]             # 0041449f
    and eax, 0x1                                 # 004144a2
    test eax, eax                                # 004144a5
    je.d8 L_004144b5                             # 004144a7
    # block 0x004144a9: entered by fall-through of je at 0x004144a7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004144b5
    mov ecx, dword ptr [ebp - local_4]           # 004144a9
    push ecx                                     # 004144ac
    call FUN_0051dc6c                            # 004144ad
    add esp, 0x4                                 # 004144b2
L_004144b5:
    # block 0x004144b5: entered by je at 0x004144a7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004144b5
    {load} mov esp, ebp                          # 004144b8
    pop ebp                                      # 004144ba
    ret 0x4                                      # 004144bb

# --- data items (not part of the function) -------------------------
.org 0x004144be - 0x401000
PAD_004144be:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

