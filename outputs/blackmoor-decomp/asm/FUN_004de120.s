# FUN_004de120
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de120
# extent:       0x004de120-0x004de14e (46 code bytes)
# span:         0x004de120-0x004de150 (code 46, tables 0, padding 2)
# sha256:       087245d20b2c2714b1e96f8aebe873f67d17f300ac6512b2e77bbd9709b36fbe
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de120
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dd3cf, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004dd3cf, .text + (0x004dd3cf - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004de120 - 0x401000
.globl FUN_004de120
FUN_004de120:
    # block 0x004de120: entry, 10 instruction(s), calls FUN_004dd3cf, ends with je to 0x004de145 (forward)
    push ebp                                     # 004de120
    {load} mov ebp, esp                          # 004de121
    push ecx                                     # 004de123
    mov dword ptr [ebp - local_4], ecx           # 004de124
    mov ecx, dword ptr [ebp - local_4]           # 004de127
    call FUN_004dd3cf                            # 004de12a
    mov eax, dword ptr [ebp + arg_8]             # 004de12f
    and eax, 0x1                                 # 004de132
    test eax, eax                                # 004de135
    je.d8 L_004de145                             # 004de137
    # block 0x004de139: entered by fall-through of je at 0x004de137, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004de145
    mov ecx, dword ptr [ebp - local_4]           # 004de139
    push ecx                                     # 004de13c
    call FUN_0051dc6c                            # 004de13d
    add esp, 0x4                                 # 004de142
L_004de145:
    # block 0x004de145: entered by je at 0x004de137, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004de145
    {load} mov esp, ebp                          # 004de148
    pop ebp                                      # 004de14a
    ret 0x4                                      # 004de14b

# --- data items (not part of the function) -------------------------
.org 0x004de14e - 0x401000
PAD_004de14e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

