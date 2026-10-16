# FUN_004bf5d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf5d0
# extent:       0x004bf5d0-0x004bf5fe (46 code bytes)
# span:         0x004bf5d0-0x004bf600 (code 46, tables 0, padding 2)
# sha256:       57300566afe835ffdcd834fa9b4d782803c9a9075e696677001f1dd664bb7f44
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bf5d0
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004bed99, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004bed99, .text + (0x004bed99 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004bf5d0 - 0x401000
.globl FUN_004bf5d0
FUN_004bf5d0:
    # block 0x004bf5d0: entry, 10 instruction(s), calls FUN_004bed99, ends with je to 0x004bf5f5 (forward)
    push ebp                                     # 004bf5d0
    {load} mov ebp, esp                          # 004bf5d1
    push ecx                                     # 004bf5d3
    mov dword ptr [ebp - local_4], ecx           # 004bf5d4
    mov ecx, dword ptr [ebp - local_4]           # 004bf5d7
    call FUN_004bed99                            # 004bf5da
    mov eax, dword ptr [ebp + arg_8]             # 004bf5df
    and eax, 0x1                                 # 004bf5e2
    test eax, eax                                # 004bf5e5
    je.d8 L_004bf5f5                             # 004bf5e7
    # block 0x004bf5e9: entered by fall-through of je at 0x004bf5e7, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004bf5f5
    mov ecx, dword ptr [ebp - local_4]           # 004bf5e9
    push ecx                                     # 004bf5ec
    call FUN_0051dc6c                            # 004bf5ed
    add esp, 0x4                                 # 004bf5f2
L_004bf5f5:
    # block 0x004bf5f5: entered by je at 0x004bf5e7, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004bf5f5
    {load} mov esp, ebp                          # 004bf5f8
    pop ebp                                      # 004bf5fa
    ret 0x4                                      # 004bf5fb

# --- data items (not part of the function) -------------------------
.org 0x004bf5fe - 0x401000
PAD_004bf5fe:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

