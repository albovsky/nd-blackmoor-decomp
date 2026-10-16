# FUN_004cca9c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cca9c
# extent:       0x004cca9c-0x004ccacf (51 code bytes)
# span:         0x004cca9c-0x004ccacf (code 51, tables 0, padding 0)
# sha256:       f682c8b11d7774cd67c1ed1212430377f213583442aee98ff0248f6544d89681
# evidence:     ev_5d7e582f83f0537e633fb10e380fdbc2f4e8820249923868fd009a4829ea2231
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cca9c
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_14; [edx + n] field_28
# callees:      calls FUN_004cc962
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ arg_14, 0x14  # offset +0x14
.equ field_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_004cc962, .text + (0x004cc962 - 0x401000)

.org 0x004cca9c - 0x401000
.globl FUN_004cca9c
FUN_004cca9c:
    # block 0x004cca9c: entry, 20 instruction(s), calls FUN_004cc962, ends with ret 0x10
    push ebp                                     # 004cca9c
    {load} mov ebp, esp                          # 004cca9d
    push ecx                                     # 004cca9f
    mov dword ptr [ebp - local_4], ecx           # 004ccaa0
    mov eax, dword ptr [ebp + arg_8]             # 004ccaa3
    push eax                                     # 004ccaa6
    mov ecx, dword ptr [ebp - local_4]           # 004ccaa7
    call FUN_004cc962                            # 004ccaaa
    mov ecx, dword ptr [ebp + arg_8]             # 004ccaaf
    mov edx, dword ptr [ebp + arg_c]             # 004ccab2
    mov dword ptr [ecx], edx                     # 004ccab5
    mov eax, dword ptr [ebp + arg_8]             # 004ccab7
    mov ecx, dword ptr [ebp + arg_10]            # 004ccaba
    mov dword ptr [eax + field_14], ecx          # 004ccabd
    mov edx, dword ptr [ebp + arg_8]             # 004ccac0
    mov eax, dword ptr [ebp + arg_14]            # 004ccac3
    mov dword ptr [edx + field_28], eax          # 004ccac6
    {load} mov esp, ebp                          # 004ccac9
    pop ebp                                      # 004ccacb
    ret 0x10                                     # 004ccacc

