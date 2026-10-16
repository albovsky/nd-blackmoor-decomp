# FUN_0044be60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044be60
# extent:       0x0044be60-0x0044be8e (46 code bytes)
# span:         0x0044be60-0x0044be90 (code 46, tables 0, padding 2)
# sha256:       b9b23d145a090a85fffef0f61e61c23127c9ffc19eeff573dae0c75aaaf2c4a0
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044be60
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044afd6, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044afd6, .text + (0x0044afd6 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0044be60 - 0x401000
.globl FUN_0044be60
FUN_0044be60:
    # block 0x0044be60: entry, 10 instruction(s), calls FUN_0044afd6, ends with je to 0x0044be85 (forward)
    push ebp                                     # 0044be60
    {load} mov ebp, esp                          # 0044be61
    push ecx                                     # 0044be63
    mov dword ptr [ebp - local_4], ecx           # 0044be64
    mov ecx, dword ptr [ebp - local_4]           # 0044be67
    call FUN_0044afd6                            # 0044be6a
    mov eax, dword ptr [ebp + arg_8]             # 0044be6f
    and eax, 0x1                                 # 0044be72
    test eax, eax                                # 0044be75
    je.d8 L_0044be85                             # 0044be77
    # block 0x0044be79: entered by fall-through of je at 0x0044be77, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044be85
    mov ecx, dword ptr [ebp - local_4]           # 0044be79
    push ecx                                     # 0044be7c
    call FUN_0051dc6c                            # 0044be7d
    add esp, 0x4                                 # 0044be82
L_0044be85:
    # block 0x0044be85: entered by je at 0x0044be77, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 0044be85
    {load} mov esp, ebp                          # 0044be88
    pop ebp                                      # 0044be8a
    ret 0x4                                      # 0044be8b

# --- data items (not part of the function) -------------------------
.org 0x0044be8e - 0x401000
PAD_0044be8e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

