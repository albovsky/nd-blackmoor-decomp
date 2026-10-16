# FUN_0044f620
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044f620
# extent:       0x0044f620-0x0044f64e (46 code bytes)
# span:         0x0044f620-0x0044f650 (code 46, tables 0, padding 2)
# sha256:       b1f795a695edaab7521af01140112bab14cbe7abed64bc2893559790eb37a094
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044f620
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044e74b, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044e74b, .text + (0x0044e74b - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044f620 - 0x401000
.globl FUN_0044f620
FUN_0044f620:
    # block 0x0044f620: entry, 10 instruction(s), calls FUN_0044e74b, ends with je to 0x0044f645 (forward)
    push ebp                                     # 0044f620
    {load} mov ebp, esp                          # 0044f621
    push ecx                                     # 0044f623
    mov dword ptr [ebp - local_4], ecx           # 0044f624
    mov ecx, dword ptr [ebp - local_4]           # 0044f627
    call FUN_0044e74b                            # 0044f62a
    mov eax, dword ptr [ebp + arg_8]             # 0044f62f
    and eax, 0x1                                 # 0044f632
    test eax, eax                                # 0044f635
    je.d8 L_0044f645                             # 0044f637
    # block 0x0044f639: entered by fall-through of je at 0x0044f637, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044f645
    mov ecx, dword ptr [ebp - local_4]           # 0044f639
    push ecx                                     # 0044f63c
    call FUN_0051dc6c                            # 0044f63d
    add esp, 0x4                                 # 0044f642
L_0044f645:
    # block 0x0044f645: entered by je at 0x0044f637, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0044f645
    {load} mov esp, ebp                          # 0044f648
    pop ebp                                      # 0044f64a
    ret 0x4                                      # 0044f64b

# --- data items (not part of the function) -------------------------
.org 0x0044f64e - 0x401000
PAD_0044f64e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

