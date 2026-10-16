# FUN_004a3670
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a3670
# extent:       0x004a3670-0x004a369e (46 code bytes)
# span:         0x004a3670-0x004a36a0 (code 46, tables 0, padding 2)
# sha256:       0a7af6cb49689b024a1da0eabf67b2aff1c665215915d7995f1f5b8610d4e5f0
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a3670
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004a1c2b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004a1c2b, .text + (0x004a1c2b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004a3670 - 0x401000
.globl FUN_004a3670
FUN_004a3670:
    # block 0x004a3670: entry, 10 instruction(s), calls FUN_004a1c2b, ends with je to 0x004a3695 (forward)
    push ebp                                     # 004a3670
    {load} mov ebp, esp                          # 004a3671
    push ecx                                     # 004a3673
    mov dword ptr [ebp - local_4], ecx           # 004a3674
    mov ecx, dword ptr [ebp - local_4]           # 004a3677
    call FUN_004a1c2b                            # 004a367a
    mov eax, dword ptr [ebp + arg_8]             # 004a367f
    and eax, 0x1                                 # 004a3682
    test eax, eax                                # 004a3685
    je.d8 L_004a3695                             # 004a3687
    # block 0x004a3689: entered by fall-through of je at 0x004a3687, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004a3695
    mov ecx, dword ptr [ebp - local_4]           # 004a3689
    push ecx                                     # 004a368c
    call FUN_0051dc6c                            # 004a368d
    add esp, 0x4                                 # 004a3692
L_004a3695:
    # block 0x004a3695: entered by je at 0x004a3687, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004a3695
    {load} mov esp, ebp                          # 004a3698
    pop ebp                                      # 004a369a
    ret 0x4                                      # 004a369b

# --- data items (not part of the function) -------------------------
.org 0x004a369e - 0x401000
PAD_004a369e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

