# FUN_004bf024
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf024
# extent:       0x004bf024-0x004bf098 (116 code bytes)
# span:         0x004bf024-0x004bf098 (code 116, tables 0, padding 0)
# sha256:       419f96a4c3515a5219833f7ada7172b263f83816a17048d8cf1cdaef8f69b39f
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bf024
# arguments:    7 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_bc; [ecx + n] field_bc, field_2c0; [edx + n] field_bc
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkCopyToBuffer@28
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ field_bc, 0xbc  # offset +0xbc
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)

.org 0x004bf024 - 0x401000
.globl FUN_004bf024
FUN_004bf024:
    # block 0x004bf024: entry, 10 instruction(s), calls FUN_004bf38c, ends with jne to 0x004bf05e (forward)
    push ebp                                     # 004bf024
    {load} mov ebp, esp                          # 004bf025
    push ecx                                     # 004bf027
    mov dword ptr [ebp - local_4], ecx           # 004bf028
    mov ecx, dword ptr [ebp - local_4]           # 004bf02b
    call FUN_004bf38c                            # 004bf02e
    mov eax, dword ptr [ebp - local_4]           # 004bf033
    mov dword ptr [eax + field_bc], 0x0          # 004bf036
    cmp dword ptr [ebp + arg_8], 0x0             # 004bf040
    jne.d8 L_004bf05e                            # 004bf044
    # block 0x004bf046: entered by fall-through of jne at 0x004bf044, 5 instruction(s), ends with forward jump to 0x004bf092
    mov ecx, dword ptr [ebp - local_4]           # 004bf046
    mov dword ptr [ecx + field_2c0], 0xfffffffd  # 004bf049
    mov edx, dword ptr [ebp - local_4]           # 004bf053
    mov eax, dword ptr [edx + field_bc]          # 004bf056
    jmp.d8 L_004bf092                            # 004bf05c
L_004bf05e:
    # block 0x004bf05e: entered by jne at 0x004bf044, 19 instruction(s), calls binkw32.dll!_BinkCopyToBuffer@28, falls into the block at 0x004bf092
    mov eax, dword ptr [ebp + arg_20]            # 004bf05e
    push eax                                     # 004bf061
    mov ecx, dword ptr [ebp + arg_1c]            # 004bf062
    push ecx                                     # 004bf065
    mov edx, dword ptr [ebp + arg_18]            # 004bf066
    push edx                                     # 004bf069
    mov eax, dword ptr [ebp + arg_14]            # 004bf06a
    push eax                                     # 004bf06d
    mov ecx, dword ptr [ebp + arg_10]            # 004bf06e
    push ecx                                     # 004bf071
    mov edx, dword ptr [ebp + arg_c]             # 004bf072
    push edx                                     # 004bf075
    mov eax, dword ptr [ebp + arg_8]             # 004bf076
    push eax                                     # 004bf079
    call dword ptr [0x52a524]                    # 004bf07a
    mov ecx, dword ptr [ebp - local_4]           # 004bf080
    mov dword ptr [ecx + field_bc], eax          # 004bf083
    mov edx, dword ptr [ebp - local_4]           # 004bf089
    mov eax, dword ptr [edx + field_bc]          # 004bf08c
L_004bf092:
    # block 0x004bf092: entered by jmp at 0x004bf05c, 3 instruction(s), ends with ret 0x1c
    {load} mov esp, ebp                          # 004bf092
    pop ebp                                      # 004bf094
    ret 0x1c                                     # 004bf095

