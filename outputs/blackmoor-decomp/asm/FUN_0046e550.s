# FUN_0046e550
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e550
# extent:       0x0046e550-0x0046e57e (46 code bytes)
# span:         0x0046e550-0x0046e580 (code 46, tables 0, padding 2)
# sha256:       58a359ea936b7cbc2f05b43160ba756ea462221f440c8ec9947f1275eab646c9
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046e550
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0046b56e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0046b56e, .text + (0x0046b56e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0046e550 - 0x401000
.globl FUN_0046e550
FUN_0046e550:
    # block 0x0046e550: entry, 10 instruction(s), calls FUN_0046b56e, ends with je to 0x0046e575 (forward)
    push ebp                                     # 0046e550
    {load} mov ebp, esp                          # 0046e551
    push ecx                                     # 0046e553
    mov dword ptr [ebp - local_4], ecx           # 0046e554
    mov ecx, dword ptr [ebp - local_4]           # 0046e557
    call FUN_0046b56e                            # 0046e55a
    mov eax, dword ptr [ebp + arg_8]             # 0046e55f
    and eax, 0x1                                 # 0046e562
    test eax, eax                                # 0046e565
    je.d8 L_0046e575                             # 0046e567
    # block 0x0046e569: entered by fall-through of je at 0x0046e567, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0046e575
    mov ecx, dword ptr [ebp - local_4]           # 0046e569
    push ecx                                     # 0046e56c
    call FUN_0051dc6c                            # 0046e56d
    add esp, 0x4                                 # 0046e572
L_0046e575:
    # block 0x0046e575: entered by je at 0x0046e567, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0046e575
    {load} mov esp, ebp                          # 0046e578
    pop ebp                                      # 0046e57a
    ret 0x4                                      # 0046e57b

# --- data items (not part of the function) -------------------------
.org 0x0046e57e - 0x401000
PAD_0046e57e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

