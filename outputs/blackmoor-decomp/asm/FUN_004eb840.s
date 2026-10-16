# FUN_004eb840
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eb840
# extent:       0x004eb840-0x004eb86e (46 code bytes)
# span:         0x004eb840-0x004eb870 (code 46, tables 0, padding 2)
# sha256:       7dd6819e89103c0fe45a7b6eaebc70c835cc040f49e3dcbc594a51b6c189ace9
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004eb840
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e7b37, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004e7b37, .text + (0x004e7b37 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004eb840 - 0x401000
.globl FUN_004eb840
FUN_004eb840:
    # block 0x004eb840: entry, 10 instruction(s), calls FUN_004e7b37, ends with je to 0x004eb865 (forward)
    push ebp                                     # 004eb840
    {load} mov ebp, esp                          # 004eb841
    push ecx                                     # 004eb843
    mov dword ptr [ebp - local_4], ecx           # 004eb844
    mov ecx, dword ptr [ebp - local_4]           # 004eb847
    call FUN_004e7b37                            # 004eb84a
    mov eax, dword ptr [ebp + arg_8]             # 004eb84f
    and eax, 0x1                                 # 004eb852
    test eax, eax                                # 004eb855
    je.d8 L_004eb865                             # 004eb857
    # block 0x004eb859: entered by fall-through of je at 0x004eb857, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004eb865
    mov ecx, dword ptr [ebp - local_4]           # 004eb859
    push ecx                                     # 004eb85c
    call FUN_0051dc6c                            # 004eb85d
    add esp, 0x4                                 # 004eb862
L_004eb865:
    # block 0x004eb865: entered by je at 0x004eb857, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004eb865
    {load} mov esp, ebp                          # 004eb868
    pop ebp                                      # 004eb86a
    ret 0x4                                      # 004eb86b

# --- data items (not part of the function) -------------------------
.org 0x004eb86e - 0x401000
PAD_004eb86e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

