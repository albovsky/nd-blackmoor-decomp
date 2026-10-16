# FUN_004bf098
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf098
# extent:       0x004bf098-0x004bf10f (119 code bytes)
# span:         0x004bf098-0x004bf10f (code 119, tables 0, padding 0)
# sha256:       db2f5edd3e354c69850cfe30777772fc75860402a1608fc2e81e879b495d2c9e
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bf098
# arguments:    6 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c; ret 0x18 (callee pops 24 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_bc; [ecx + n] field_2c0; [edx + n] field_bc
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkCopyToBuffer@28
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ field_bc, 0xbc  # offset +0xbc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bf098 - 0x401000
.globl FUN_004bf098
FUN_004bf098:
    # block 0x004bf098: entry, 10 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bf0d2 (forward)
    push ebp                                     # 004bf098
    {load} mov ebp, esp                          # 004bf099
    push ecx                                     # 004bf09b
    mov dword ptr [ebp - local_4], ecx           # 004bf09c
    mov ecx, dword ptr [ebp - local_4]           # 004bf09f
    call FUN_004bf38c                            # 004bf0a2
    mov eax, dword ptr [ebp - local_4]           # 004bf0a7
    mov dword ptr [eax + field_bc], 0x0          # 004bf0aa
    cmp dword ptr [ebp + arg_8], 0x0             # 004bf0b4
    jne.d8 L_004bf0d2                            # 004bf0b8
    # block 0x004bf0ba: entered by fall-through of jne at 0x004bf0b8, 5 instruction(s), ends with forward jump to 0x004bf109
    mov ecx, dword ptr [ebp - local_4]           # 004bf0ba
    mov dword ptr [ecx + field_2c0], 0xfffffffd  # 004bf0bd
    mov edx, dword ptr [ebp - local_4]           # 004bf0c7
    mov eax, dword ptr [edx + field_bc]          # 004bf0ca
    jmp.d8 L_004bf109                            # 004bf0d0
L_004bf0d2:
    # block 0x004bf0d2: entered by jne at 0x004bf0b8, 20 instruction(s), calls binkw32.dll!_BinkCopyToBuffer@28, falls into the block at 0x004bf109
    mov eax, dword ptr [ebp - local_4]           # 004bf0d2
    mov ecx, dword ptr [eax + field_4]           # 004bf0d5
    push ecx                                     # 004bf0d8
    mov edx, dword ptr [ebp + arg_1c]            # 004bf0d9
    push edx                                     # 004bf0dc
    mov eax, dword ptr [ebp + arg_18]            # 004bf0dd
    push eax                                     # 004bf0e0
    mov ecx, dword ptr [ebp + arg_14]            # 004bf0e1
    push ecx                                     # 004bf0e4
    mov edx, dword ptr [ebp + arg_10]            # 004bf0e5
    push edx                                     # 004bf0e8
    mov eax, dword ptr [ebp + arg_c]             # 004bf0e9
    push eax                                     # 004bf0ec
    mov ecx, dword ptr [ebp + arg_8]             # 004bf0ed
    push ecx                                     # 004bf0f0
    call dword ptr [0x52a524]                    # 004bf0f1
    mov edx, dword ptr [ebp - local_4]           # 004bf0f7
    mov dword ptr [edx + field_bc], eax          # 004bf0fa
    mov eax, dword ptr [ebp - local_4]           # 004bf100
    mov eax, dword ptr [eax + field_bc]          # 004bf103
L_004bf109:
    # block 0x004bf109: entered by jmp at 0x004bf0d0, 3 instruction(s), ends with ret 0x18
    {load} mov esp, ebp                          # 004bf109
    pop ebp                                      # 004bf10b
    ret 0x18                                     # 004bf10c

