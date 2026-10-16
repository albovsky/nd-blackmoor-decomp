# FUN_004b5a70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5a70
# extent:       0x004b5a70-0x004b5a9e (46 code bytes)
# span:         0x004b5a70-0x004b5aa0 (code 46, tables 0, padding 2)
# sha256:       163b996c3a5fb565646dd5f73e636efbc6e6e2f3510122b430d2aebec583c3cd
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b5a70
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004b3c3e, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004b3c3e, .text + (0x004b3c3e - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x004b5a70 - 0x401000
.globl FUN_004b5a70
FUN_004b5a70:
    # block 0x004b5a70: entry, 10 instruction(s), calls FUN_004b3c3e, ends with je to 0x004b5a95 (forward)
    push ebp                                     # 004b5a70
    {load} mov ebp, esp                          # 004b5a71
    push ecx                                     # 004b5a73
    mov dword ptr [ebp - local_4], ecx           # 004b5a74
    mov ecx, dword ptr [ebp - local_4]           # 004b5a77
    call FUN_004b3c3e                            # 004b5a7a
    mov eax, dword ptr [ebp + arg_8]             # 004b5a7f
    and eax, 0x1                                 # 004b5a82
    test eax, eax                                # 004b5a85
    je.d8 L_004b5a95                             # 004b5a87
    # block 0x004b5a89: entered by fall-through of je at 0x004b5a87, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x004b5a95
    mov ecx, dword ptr [ebp - local_4]           # 004b5a89
    push ecx                                     # 004b5a8c
    call FUN_0051dc6c                            # 004b5a8d
    add esp, 0x4                                 # 004b5a92
L_004b5a95:
    # block 0x004b5a95: entered by je at 0x004b5a87, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004b5a95
    {load} mov esp, ebp                          # 004b5a98
    pop ebp                                      # 004b5a9a
    ret 0x4                                      # 004b5a9b

# --- data items (not part of the function) -------------------------
.org 0x004b5a9e - 0x401000
PAD_004b5a9e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

