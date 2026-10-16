# FUN_004b3b40
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3b40
# extent:       0x004b3b40-0x004b3b6e (46 code bytes)
# span:         0x004b3b40-0x004b3b70 (code 46, tables 0, padding 2)
# sha256:       9673f43e65be2ae989ceedf355c29142c254eaca57e150f8f33fcfbf2164e199
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b3b40
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004afd1e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004afd1e, .text + (0x004afd1e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004b3b40 - 0x401000
.globl FUN_004b3b40
FUN_004b3b40:
    # block 0x004b3b40: entry, 10 instruction(s), calls FUN_004afd1e, ends with je to 0x004b3b65 (forward)
    push ebp                                     # 004b3b40
    {load} mov ebp, esp                          # 004b3b41
    push ecx                                     # 004b3b43
    mov dword ptr [ebp - local_4], ecx           # 004b3b44
    mov ecx, dword ptr [ebp - local_4]           # 004b3b47
    call FUN_004afd1e                            # 004b3b4a
    mov eax, dword ptr [ebp + arg_8]             # 004b3b4f
    and eax, 0x1                                 # 004b3b52
    test eax, eax                                # 004b3b55
    je.d8 L_004b3b65                             # 004b3b57
    # block 0x004b3b59: entered by fall-through of je at 0x004b3b57, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004b3b65
    mov ecx, dword ptr [ebp - local_4]           # 004b3b59
    push ecx                                     # 004b3b5c
    call FUN_0051dc6c                            # 004b3b5d
    add esp, 0x4                                 # 004b3b62
L_004b3b65:
    # block 0x004b3b65: entered by je at 0x004b3b57, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004b3b65
    {load} mov esp, ebp                          # 004b3b68
    pop ebp                                      # 004b3b6a
    ret 0x4                                      # 004b3b6b

# --- data items (not part of the function) -------------------------
.org 0x004b3b6e - 0x401000
PAD_004b3b6e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

