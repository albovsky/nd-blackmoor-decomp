# FUN_00407b10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407b10
# extent:       0x00407b10-0x00407b3e (46 code bytes)
# span:         0x00407b10-0x00407b40 (code 46, tables 0, padding 2)
# sha256:       d62fcf68e40f39ad7e72740ae9c7862c5882cb8a78217bb3eca45540b8864144
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407b10
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404af0, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00404af0, .text + (0x00404af0 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00407b10 - 0x401000
.globl FUN_00407b10
FUN_00407b10:
    # block 0x00407b10: entry, 10 instruction(s), calls FUN_00404af0, ends with je to 0x00407b35 (forward)
    push ebp                                     # 00407b10
    {load} mov ebp, esp                          # 00407b11
    push ecx                                     # 00407b13
    mov dword ptr [ebp - local_4], ecx           # 00407b14
    mov ecx, dword ptr [ebp - local_4]           # 00407b17
    call FUN_00404af0                            # 00407b1a
    mov eax, dword ptr [ebp + arg_8]             # 00407b1f
    and eax, 0x1                                 # 00407b22
    test eax, eax                                # 00407b25
    je.d8 L_00407b35                             # 00407b27
    # block 0x00407b29: entered by fall-through of je at 0x00407b27, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00407b35
    mov ecx, dword ptr [ebp - local_4]           # 00407b29
    push ecx                                     # 00407b2c
    call FUN_0051dc6c                            # 00407b2d
    add esp, 0x4                                 # 00407b32
L_00407b35:
    # block 0x00407b35: entered by je at 0x00407b27, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00407b35
    {load} mov esp, ebp                          # 00407b38
    pop ebp                                      # 00407b3a
    ret 0x4                                      # 00407b3b

# --- data items (not part of the function) -------------------------
.org 0x00407b3e - 0x401000
PAD_00407b3e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

