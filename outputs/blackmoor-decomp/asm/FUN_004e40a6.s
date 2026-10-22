# FUN_004e40a6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e40a6
# extent:       0x004e40a6-0x004e40fb (85 code bytes)
# span:         0x004e40a6-0x004e40fb (code 85, tables 0, padding 0)
# sha256:       7ce57b365f42d5fc55f90afb83549b4b9b74b6c26962d7561d3be68b7cee74b0
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e40a6
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_10, arg_18, arg_1c, arg_20; ret 0x1c (callee pops 28 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4, field_4579; [edx + n] field_4, field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e40a6_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ field_4579, 0x4579  # offset +0x4579

# --- external targets -----------------------------------------------

.org 0x004e40a6 - 0x401000
.globl FUN_004e40a6
FUN_004e40a6:
    # block 0x004e40a6: entry, 28 instruction(s), ends with ret 0x1c
    push ebp                                     # 004e40a6
    {load} mov ebp, esp                          # 004e40a7
    sub esp, 0x8                                 # 004e40a9
    mov dword ptr [ebp - local_8], ecx           # 004e40ac
    mov eax, dword ptr [ebp + arg_18]            # 004e40af
    sub eax, dword ptr [ebp + arg_10]            # 004e40b2
    movsx ecx, word ptr [ebp + arg_20]           # 004e40b5
    {load} add eax, ecx                          # 004e40b9
    mov word ptr [ebp - local_4], ax             # 004e40bb
    movsx edx, word ptr [ebp + arg_8]            # 004e40bf
    movsx eax, word ptr [ebp - local_4]          # 004e40c3
    imul edx, eax                                # 004e40c7
    mov ecx, dword ptr [ebp + arg_10]            # 004e40ca
    {load} add ecx, edx                          # 004e40cd
    mov edx, dword ptr [ebp + arg_1c]            # 004e40cf
    mov dword ptr [edx + field_4], ecx           # 004e40d2
    mov eax, dword ptr [ebp + arg_1c]            # 004e40d5
    mov ecx, dword ptr [eax + field_4]           # 004e40d8
    add ecx, dword ptr [ebp + arg_18]            # 004e40db
    sub ecx, dword ptr [ebp + arg_10]            # 004e40de
    mov edx, dword ptr [ebp + arg_1c]            # 004e40e1
    mov dword ptr [edx + field_c], ecx           # 004e40e4
    mov eax, dword ptr [ebp - local_8]           # 004e40e7
    mov cx, word ptr [ebp + arg_8]               # 004e40ea
    mov word ptr [eax + field_4579], cx          # 004e40ee
    {load} mov esp, ebp                          # 004e40f5
    pop ebp                                      # 004e40f7
    ret 0x1c                                     # 004e40f8

