# FUN_00449d60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00449d60
# extent:       0x00449d60-0x00449d8e (46 code bytes)
# span:         0x00449d60-0x00449d90 (code 46, tables 0, padding 2)
# sha256:       cfb255c95713a9892b7b2c064dae855e1ce526fbc0b365a1de6f2144316b1c85
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00449d60
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00449a78, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00449a78, .text + (0x00449a78 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00449d60 - 0x401000
.globl FUN_00449d60
FUN_00449d60:
    # block 0x00449d60: entry, 10 instruction(s), calls FUN_00449a78, ends with je to 0x00449d85 (forward)
    push ebp                                     # 00449d60
    {load} mov ebp, esp                          # 00449d61
    push ecx                                     # 00449d63
    mov dword ptr [ebp - local_4], ecx           # 00449d64
    mov ecx, dword ptr [ebp - local_4]           # 00449d67
    call FUN_00449a78                            # 00449d6a
    mov eax, dword ptr [ebp + arg_8]             # 00449d6f
    and eax, 0x1                                 # 00449d72
    test eax, eax                                # 00449d75
    je.d8 L_00449d85                             # 00449d77
    # block 0x00449d79: entered by fall-through of je at 0x00449d77, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00449d85
    mov ecx, dword ptr [ebp - local_4]           # 00449d79
    push ecx                                     # 00449d7c
    call FUN_0051dc6c                            # 00449d7d
    add esp, 0x4                                 # 00449d82
L_00449d85:
    # block 0x00449d85: entered by je at 0x00449d77, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00449d85
    {load} mov esp, ebp                          # 00449d88
    pop ebp                                      # 00449d8a
    ret 0x4                                      # 00449d8b

# --- data items (not part of the function) -------------------------
.org 0x00449d8e - 0x401000
PAD_00449d8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

