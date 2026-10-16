# FUN_00438120
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00438120
# extent:       0x00438120-0x0043814e (46 code bytes)
# span:         0x00438120-0x00438150 (code 46, tables 0, padding 2)
# sha256:       3133e9f608dcbfc16afeca6db457ebe78d80216b149013a7fa6ffabc8d39685d
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00438120
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043772f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0043772f, .text + (0x0043772f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00438120 - 0x401000
.globl FUN_00438120
FUN_00438120:
    # block 0x00438120: entry, 10 instruction(s), calls FUN_0043772f, ends with je to 0x00438145 (forward)
    push ebp                                     # 00438120
    {load} mov ebp, esp                          # 00438121
    push ecx                                     # 00438123
    mov dword ptr [ebp - local_4], ecx           # 00438124
    mov ecx, dword ptr [ebp - local_4]           # 00438127
    call FUN_0043772f                            # 0043812a
    mov eax, dword ptr [ebp + arg_8]             # 0043812f
    and eax, 0x1                                 # 00438132
    test eax, eax                                # 00438135
    je.d8 L_00438145                             # 00438137
    # block 0x00438139: entered by fall-through of je at 0x00438137, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00438145
    mov ecx, dword ptr [ebp - local_4]           # 00438139
    push ecx                                     # 0043813c
    call FUN_0051dc6c                            # 0043813d
    add esp, 0x4                                 # 00438142
L_00438145:
    # block 0x00438145: entered by je at 0x00438137, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00438145
    {load} mov esp, ebp                          # 00438148
    pop ebp                                      # 0043814a
    ret 0x4                                      # 0043814b

# --- data items (not part of the function) -------------------------
.org 0x0043814e - 0x401000
PAD_0043814e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

