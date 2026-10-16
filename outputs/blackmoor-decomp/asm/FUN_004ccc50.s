# FUN_004ccc50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ccc50
# extent:       0x004ccc50-0x004ccc81 (49 code bytes)
# span:         0x004ccc50-0x004ccc81 (code 49, tables 0, padding 0)
# sha256:       0e05c2791931c7c8f234cff278b4160abdc8352ecd980ee230caa30c0d7d99c0
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ccc50
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8; [edx + n] field_4
# callees:      calls FUN_004ccc81
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_004ccc81, .text + (0x004ccc81 - 0x401000)

.org 0x004ccc50 - 0x401000
.globl FUN_004ccc50
FUN_004ccc50:
    # block 0x004ccc50: entry, 22 instruction(s), calls FUN_004ccc81, ends with ret 0xc
    push ebp                                     # 004ccc50
    {load} mov ebp, esp                          # 004ccc51
    push ecx                                     # 004ccc53
    mov dword ptr [ebp - local_4], ecx           # 004ccc54
    mov eax, dword ptr [ebp + arg_10]            # 004ccc57
    mov ecx, dword ptr [eax + field_8]           # 004ccc5a
    push ecx                                     # 004ccc5d
    mov edx, dword ptr [ebp + arg_10]            # 004ccc5e
    mov eax, dword ptr [edx + field_4]           # 004ccc61
    push eax                                     # 004ccc64
    mov ecx, dword ptr [ebp + arg_10]            # 004ccc65
    mov edx, dword ptr [ecx]                     # 004ccc68
    push edx                                     # 004ccc6a
    mov eax, dword ptr [ebp + arg_c]             # 004ccc6b
    push eax                                     # 004ccc6e
    mov ecx, dword ptr [ebp + arg_8]             # 004ccc6f
    push ecx                                     # 004ccc72
    mov ecx, dword ptr [ebp - local_4]           # 004ccc73
    call FUN_004ccc81                            # 004ccc76
    {load} mov esp, ebp                          # 004ccc7b
    pop ebp                                      # 004ccc7d
    ret 0xc                                      # 004ccc7e

