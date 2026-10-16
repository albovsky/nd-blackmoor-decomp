# FUN_0046e9c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046e9c0
# extent:       0x0046e9c0-0x0046ea16 (86 code bytes)
# span:         0x0046e9c0-0x0046ea16 (code 86, tables 0, padding 0)
# sha256:       86189a382efc1cab15f36fc09a9cc8ec6acff3993698bd71b66f06de215271fb
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046e9c0
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0046e9c0 - 0x401000
.globl FUN_0046e9c0
FUN_0046e9c0:
    # block 0x0046e9c0: entry, 28 instruction(s), ends with ret 0x8
    push ebp                                     # 0046e9c0
    {load} mov ebp, esp                          # 0046e9c1
    push ecx                                     # 0046e9c3
    mov dword ptr [ebp - local_4], ecx           # 0046e9c4
    mov eax, dword ptr [ebp + arg_8]             # 0046e9c7
    mov ecx, dword ptr [eax + field_4]           # 0046e9ca
    add ecx, dword ptr [0x58318a]                # 0046e9cd
    mov edx, dword ptr [ebp + arg_c]             # 0046e9d3
    mov dword ptr [edx + field_4], ecx           # 0046e9d6
    mov eax, dword ptr [ebp + arg_8]             # 0046e9d9
    mov ecx, dword ptr [eax + field_c]           # 0046e9dc
    add ecx, dword ptr [0x58318a]                # 0046e9df
    mov edx, dword ptr [ebp + arg_c]             # 0046e9e5
    mov dword ptr [edx + field_c], ecx           # 0046e9e8
    mov eax, dword ptr [ebp + arg_8]             # 0046e9eb
    mov ecx, dword ptr [eax]                     # 0046e9ee
    add ecx, dword ptr [0x583186]                # 0046e9f0
    mov edx, dword ptr [ebp + arg_c]             # 0046e9f6
    mov dword ptr [edx], ecx                     # 0046e9f9
    mov eax, dword ptr [ebp + arg_8]             # 0046e9fb
    mov ecx, dword ptr [eax + field_8]           # 0046e9fe
    add ecx, dword ptr [0x583186]                # 0046ea01
    mov edx, dword ptr [ebp + arg_c]             # 0046ea07
    mov dword ptr [edx + field_8], ecx           # 0046ea0a
    mov eax, dword ptr [ebp + arg_c]             # 0046ea0d
    {load} mov esp, ebp                          # 0046ea10
    pop ebp                                      # 0046ea12
    ret 0x8                                      # 0046ea13

