# FUN_00466db1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00466db1
# extent:       0x00466db1-0x00466e04 (83 code bytes)
# span:         0x00466db1-0x00466e04 (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00466db1
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x00466db1 - 0x401000
.globl FUN_00466db1
FUN_00466db1:
    # block 0x00466db1: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 00466db1
    {load} mov ebp, esp                          # 00466db2
    push ecx                                     # 00466db4
    mov dword ptr [ebp - local_4], ecx           # 00466db5
    mov eax, dword ptr [ebp + arg_8]             # 00466db8
    mov ecx, dword ptr [eax + field_4]           # 00466dbb
    add ecx, dword ptr [0x58318a]                # 00466dbe
    mov edx, dword ptr [ebp + arg_c]             # 00466dc4
    mov dword ptr [edx + field_4], ecx           # 00466dc7
    mov eax, dword ptr [ebp + arg_8]             # 00466dca
    mov ecx, dword ptr [eax + field_c]           # 00466dcd
    add ecx, dword ptr [0x58318a]                # 00466dd0
    mov edx, dword ptr [ebp + arg_c]             # 00466dd6
    mov dword ptr [edx + field_c], ecx           # 00466dd9
    mov eax, dword ptr [ebp + arg_8]             # 00466ddc
    mov ecx, dword ptr [eax]                     # 00466ddf
    add ecx, dword ptr [0x583186]                # 00466de1
    mov edx, dword ptr [ebp + arg_c]             # 00466de7
    mov dword ptr [edx], ecx                     # 00466dea
    mov eax, dword ptr [ebp + arg_8]             # 00466dec
    mov ecx, dword ptr [eax + field_8]           # 00466def
    add ecx, dword ptr [0x583186]                # 00466df2
    mov edx, dword ptr [ebp + arg_c]             # 00466df8
    mov dword ptr [edx + field_8], ecx           # 00466dfb
    {load} mov esp, ebp                          # 00466dfe
    pop ebp                                      # 00466e00
    ret 0x8                                      # 00466e01

