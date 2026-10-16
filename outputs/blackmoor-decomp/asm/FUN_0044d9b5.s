# FUN_0044d9b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d9b5
# extent:       0x0044d9b5-0x0044da08 (83 code bytes)
# span:         0x0044d9b5-0x0044da08 (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d9b5
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

.org 0x0044d9b5 - 0x401000
.globl FUN_0044d9b5
FUN_0044d9b5:
    # block 0x0044d9b5: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 0044d9b5
    {load} mov ebp, esp                          # 0044d9b6
    push ecx                                     # 0044d9b8
    mov dword ptr [ebp - local_4], ecx           # 0044d9b9
    mov eax, dword ptr [ebp + arg_8]             # 0044d9bc
    mov ecx, dword ptr [eax + field_4]           # 0044d9bf
    add ecx, dword ptr [0x58318a]                # 0044d9c2
    mov edx, dword ptr [ebp + arg_c]             # 0044d9c8
    mov dword ptr [edx + field_4], ecx           # 0044d9cb
    mov eax, dword ptr [ebp + arg_8]             # 0044d9ce
    mov ecx, dword ptr [eax + field_c]           # 0044d9d1
    add ecx, dword ptr [0x58318a]                # 0044d9d4
    mov edx, dword ptr [ebp + arg_c]             # 0044d9da
    mov dword ptr [edx + field_c], ecx           # 0044d9dd
    mov eax, dword ptr [ebp + arg_8]             # 0044d9e0
    mov ecx, dword ptr [eax]                     # 0044d9e3
    add ecx, dword ptr [0x583186]                # 0044d9e5
    mov edx, dword ptr [ebp + arg_c]             # 0044d9eb
    mov dword ptr [edx], ecx                     # 0044d9ee
    mov eax, dword ptr [ebp + arg_8]             # 0044d9f0
    mov ecx, dword ptr [eax + field_8]           # 0044d9f3
    add ecx, dword ptr [0x583186]                # 0044d9f6
    mov edx, dword ptr [ebp + arg_c]             # 0044d9fc
    mov dword ptr [edx + field_8], ecx           # 0044d9ff
    {load} mov esp, ebp                          # 0044da02
    pop ebp                                      # 0044da04
    ret 0x8                                      # 0044da05

