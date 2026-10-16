# FUN_004f5e35
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004f5e35
# extent:       0x004f5e35-0x004f5e95 (96 code bytes)
# span:         0x004f5e35-0x004f5e95 (code 96, tables 0, padding 0)
# sha256:       10a1975f386644097de8384ed4297b737d53dfde04a0b6c466df8684a281b3b2
# evidence:     ev_8e5ef5825dc8a261a7343a35a5c16f506372f91bfb53f8b1217f8abbe0377f59
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004f5e35
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10, field_3ca; [ecx + n] field_8, field_14, field_4c, field_3ca; [edx + n] field_c, field_3ca
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_4c, 0x4c  # offset +0x4c
.equ field_3ca, 0x3ca  # offset +0x3ca

# --- external targets -----------------------------------------------

.org 0x004f5e35 - 0x401000
.globl FUN_004f5e35
FUN_004f5e35:
    # block 0x004f5e35: entry, 28 instruction(s), calls indirect dword ptr [ecx + 0x4c], ends with jne to 0x004f5e8d (forward)
    push ebp                                     # 004f5e35
    {load} mov ebp, esp                          # 004f5e36
    push ecx                                     # 004f5e38
    mov dword ptr [ebp - local_4], ecx           # 004f5e39
    mov eax, dword ptr [ebp - local_4]           # 004f5e3c
    mov dword ptr [eax + field_3ca], 0x0         # 004f5e3f
    mov ecx, dword ptr [ebp + arg_c]             # 004f5e49
    mov edx, dword ptr [ecx + field_14]          # 004f5e4c
    push edx                                     # 004f5e4f
    mov eax, dword ptr [ebp + arg_c]             # 004f5e50
    mov ecx, dword ptr [eax + field_10]          # 004f5e53
    push ecx                                     # 004f5e56
    mov edx, dword ptr [ebp + arg_c]             # 004f5e57
    mov eax, dword ptr [edx + field_c]           # 004f5e5a
    push eax                                     # 004f5e5d
    mov ecx, dword ptr [ebp + arg_c]             # 004f5e5e
    mov edx, dword ptr [ecx + field_8]           # 004f5e61
    push edx                                     # 004f5e64
    mov eax, dword ptr [ebp + arg_8]             # 004f5e65
    mov ecx, dword ptr [eax]                     # 004f5e68
    mov edx, dword ptr [ebp + arg_8]             # 004f5e6a
    push edx                                     # 004f5e6d
    call dword ptr [ecx + field_4c]              # 004f5e6e
    mov ecx, dword ptr [ebp - local_4]           # 004f5e71
    mov dword ptr [ecx + field_3ca], eax         # 004f5e74
    mov edx, dword ptr [ebp - local_4]           # 004f5e7a
    cmp dword ptr [edx + field_3ca], 0x0         # 004f5e7d
    jne.d8 L_004f5e8d                            # 004f5e84
    # block 0x004f5e86: entered by fall-through of jne at 0x004f5e84, 2 instruction(s), ends with forward jump to 0x004f5e8f
    mov eax, 0x1                                 # 004f5e86
    jmp.d8 L_004f5e8f                            # 004f5e8b
L_004f5e8d:
    # block 0x004f5e8d: entered by jne at 0x004f5e84, 1 instruction(s), falls into the block at 0x004f5e8f
    {load} xor eax, eax                          # 004f5e8d
L_004f5e8f:
    # block 0x004f5e8f: entered by jmp at 0x004f5e8b, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004f5e8f
    pop ebp                                      # 004f5e91
    ret 0x8                                      # 004f5e92

