# FUN_0048cf50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048cf50
# extent:       0x0048cf50-0x0048cf7e (46 code bytes)
# span:         0x0048cf50-0x0048cf80 (code 46, tables 0, padding 2)
# sha256:       46bf2e9bc8ea743b7b72bf930d88e13c28df55c59d9831481e9c37b4cf10b6cc
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048cf50
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0048bafb, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0048bafb, .text + (0x0048bafb - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0048cf50 - 0x401000
.globl FUN_0048cf50
FUN_0048cf50:
    # block 0x0048cf50: entry, 10 instruction(s), calls FUN_0048bafb, ends with je to 0x0048cf75 (forward)
    push ebp                                     # 0048cf50
    {load} mov ebp, esp                          # 0048cf51
    push ecx                                     # 0048cf53
    mov dword ptr [ebp - local_4], ecx           # 0048cf54
    mov ecx, dword ptr [ebp - local_4]           # 0048cf57
    call FUN_0048bafb                            # 0048cf5a
    mov eax, dword ptr [ebp + arg_8]             # 0048cf5f
    and eax, 0x1                                 # 0048cf62
    test eax, eax                                # 0048cf65
    je.d8 L_0048cf75                             # 0048cf67
    # block 0x0048cf69: entered by fall-through of je at 0x0048cf67, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0048cf75
    mov ecx, dword ptr [ebp - local_4]           # 0048cf69
    push ecx                                     # 0048cf6c
    call FUN_0051dc6c                            # 0048cf6d
    add esp, 0x4                                 # 0048cf72
L_0048cf75:
    # block 0x0048cf75: entered by je at 0x0048cf67, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0048cf75
    {load} mov esp, ebp                          # 0048cf78
    pop ebp                                      # 0048cf7a
    ret 0x4                                      # 0048cf7b

# --- data items (not part of the function) -------------------------
.org 0x0048cf7e - 0x401000
PAD_0048cf7e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

