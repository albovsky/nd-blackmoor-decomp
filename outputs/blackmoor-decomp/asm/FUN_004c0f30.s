# FUN_004c0f30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c0f30
# extent:       0x004c0f30-0x004c0f5e (46 code bytes)
# span:         0x004c0f30-0x004c0f60 (code 46, tables 0, padding 2)
# sha256:       17418d92e4fde17e8111a8fbda5de5a55c2e98b0b181a67f0e563f63361aecf6
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c0f30
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bf61f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004bf61f, .text + (0x004bf61f - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004c0f30 - 0x401000
.globl FUN_004c0f30
FUN_004c0f30:
    # block 0x004c0f30: entry, 10 instruction(s), calls FUN_004bf61f, ends with je to 0x004c0f55 (forward)
    push ebp                                     # 004c0f30
    {load} mov ebp, esp                          # 004c0f31
    push ecx                                     # 004c0f33
    mov dword ptr [ebp - local_4], ecx           # 004c0f34
    mov ecx, dword ptr [ebp - local_4]           # 004c0f37
    call FUN_004bf61f                            # 004c0f3a
    mov eax, dword ptr [ebp + arg_8]             # 004c0f3f
    and eax, 0x1                                 # 004c0f42
    test eax, eax                                # 004c0f45
    je.d8 L_004c0f55                             # 004c0f47
    # block 0x004c0f49: entered by fall-through of je at 0x004c0f47, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004c0f55
    mov ecx, dword ptr [ebp - local_4]           # 004c0f49
    push ecx                                     # 004c0f4c
    call FUN_0051dc6c                            # 004c0f4d
    add esp, 0x4                                 # 004c0f52
L_004c0f55:
    # block 0x004c0f55: entered by je at 0x004c0f47, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004c0f55
    {load} mov esp, ebp                          # 004c0f58
    pop ebp                                      # 004c0f5a
    ret 0x4                                      # 004c0f5b

# --- data items (not part of the function) -------------------------
.org 0x004c0f5e - 0x401000
PAD_004c0f5e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

