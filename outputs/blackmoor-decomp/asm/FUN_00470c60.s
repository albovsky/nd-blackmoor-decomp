# FUN_00470c60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470c60
# extent:       0x00470c60-0x00470c8e (46 code bytes)
# span:         0x00470c60-0x00470c90 (code 46, tables 0, padding 2)
# sha256:       c9d77dd22dcd3e753d2b0dced7d3f1f6aa3ba3532d841dd681a23e3bb8acff24
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00470c60
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0046e66a, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0046e66a, .text + (0x0046e66a - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x00470c60 - 0x401000
.globl FUN_00470c60
FUN_00470c60:
    # block 0x00470c60: entry, 10 instruction(s), calls FUN_0046e66a, ends with je to 0x00470c85 (forward)
    push ebp                                     # 00470c60
    {load} mov ebp, esp                          # 00470c61
    push ecx                                     # 00470c63
    mov dword ptr [ebp - local_4], ecx           # 00470c64
    mov ecx, dword ptr [ebp - local_4]           # 00470c67
    call FUN_0046e66a                            # 00470c6a
    mov eax, dword ptr [ebp + arg_8]             # 00470c6f
    and eax, 0x1                                 # 00470c72
    test eax, eax                                # 00470c75
    je.d8 L_00470c85                             # 00470c77
    # block 0x00470c79: entered by fall-through of je at 0x00470c77, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00470c85
    mov ecx, dword ptr [ebp - local_4]           # 00470c79
    push ecx                                     # 00470c7c
    call FUN_0051dc6c                            # 00470c7d
    add esp, 0x4                                 # 00470c82
L_00470c85:
    # block 0x00470c85: entered by je at 0x00470c77, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 00470c85
    {load} mov esp, ebp                          # 00470c88
    pop ebp                                      # 00470c8a
    ret 0x4                                      # 00470c8b

# --- data items (not part of the function) -------------------------
.org 0x00470c8e - 0x401000
PAD_00470c8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

