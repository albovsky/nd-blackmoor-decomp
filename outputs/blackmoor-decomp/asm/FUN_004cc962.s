# FUN_004cc962
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cc962
# extent:       0x004cc962-0x004cca0e (172 code bytes)
# span:         0x004cc962-0x004cca0e (code 172, tables 0, padding 0)
# sha256:       f1a4e97941a74b657fd76d3a76ae28563151023be0ccac2b11e226743c716d75
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cc962
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_1c, field_2c, field_38, field_3c; [ecx + n] field_8, field_18, field_24, field_28, field_34; [edx + n] field_4, field_10, field_14, field_20, field_30
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_38, 0x38  # offset +0x38
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------

.org 0x004cc962 - 0x401000
.globl FUN_004cc962
FUN_004cc962:
    # block 0x004cc962: entry, 39 instruction(s), ends with ret 0x4
    push ebp                                     # 004cc962
    {load} mov ebp, esp                          # 004cc963
    push ecx                                     # 004cc965
    mov dword ptr [ebp - local_4], ecx           # 004cc966
    mov eax, dword ptr [ebp + arg_8]             # 004cc969
    mov dword ptr [eax + field_1c], 0x0          # 004cc96c
    mov ecx, dword ptr [ebp + arg_8]             # 004cc973
    mov dword ptr [ecx + field_18], 0x0          # 004cc976
    mov edx, dword ptr [ebp + arg_8]             # 004cc97d
    mov dword ptr [edx + field_10], 0x0          # 004cc980
    mov eax, dword ptr [ebp + arg_8]             # 004cc987
    mov dword ptr [eax + field_c], 0x0           # 004cc98a
    mov ecx, dword ptr [ebp + arg_8]             # 004cc991
    mov dword ptr [ecx + field_8], 0x0           # 004cc994
    mov edx, dword ptr [ebp + arg_8]             # 004cc99b
    mov dword ptr [edx + field_4], 0x0           # 004cc99e
    mov eax, dword ptr [ebp + arg_8]             # 004cc9a5
    mov dword ptr [eax + field_38], 0x0          # 004cc9a8
    mov ecx, dword ptr [ebp + arg_8]             # 004cc9af
    mov dword ptr [ecx + field_34], 0x0          # 004cc9b2
    mov edx, dword ptr [ebp + arg_8]             # 004cc9b9
    mov dword ptr [edx + field_30], 0x0          # 004cc9bc
    mov eax, dword ptr [ebp + arg_8]             # 004cc9c3
    mov dword ptr [eax + field_2c], 0x0          # 004cc9c6
    mov ecx, dword ptr [ebp + arg_8]             # 004cc9cd
    mov dword ptr [ecx + field_24], 0x0          # 004cc9d0
    mov edx, dword ptr [ebp + arg_8]             # 004cc9d7
    mov dword ptr [edx + field_20], 0x0          # 004cc9da
    mov eax, dword ptr [ebp + arg_8]             # 004cc9e1
    mov dword ptr [eax + field_3c], 0x3f800000   # 004cc9e4
    mov ecx, dword ptr [ebp + arg_8]             # 004cc9eb
    mov dword ptr [ecx + field_28], 0x3f800000   # 004cc9ee
    mov edx, dword ptr [ebp + arg_8]             # 004cc9f5
    mov dword ptr [edx + field_14], 0x3f800000   # 004cc9f8
    mov eax, dword ptr [ebp + arg_8]             # 004cc9ff
    mov dword ptr [eax], 0x3f800000              # 004cca02
    {load} mov esp, ebp                          # 004cca08
    pop ebp                                      # 004cca0a
    ret 0x4                                      # 004cca0b

