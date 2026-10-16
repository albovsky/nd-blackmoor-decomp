# FUN_004fba86
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fba86
# extent:       0x004fba86-0x004fbaaf (41 code bytes)
# span:         0x004fba86-0x004fbaaf (code 41, tables 0, padding 0)
# sha256:       aa4fd83b00183d1ae0ae60c03fe7ef859567c68b4b293ec5a69d85001bb0ebf2
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fba86
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_21
# callees:      calls FUN_004fb77a, FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_21, 0x21  # offset +0x21

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)

.org 0x004fba86 - 0x401000
.globl FUN_004fba86
FUN_004fba86:
    # block 0x004fba86: entry, 16 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with ret 0x4
    push ebp                                     # 004fba86
    {load} mov ebp, esp                          # 004fba87
    push ecx                                     # 004fba89
    mov dword ptr [ebp - local_4], ecx           # 004fba8a
    mov eax, dword ptr [ebp + arg_8]             # 004fba8d
    push eax                                     # 004fba90
    mov ecx, dword ptr [ebp - local_4]           # 004fba91
    call FUN_004fb77a                            # 004fba94
    mov ecx, dword ptr [ebp + arg_8]             # 004fba99
    mov dx, word ptr [ecx + field_21]            # 004fba9c
    push edx                                     # 004fbaa0
    mov ecx, dword ptr [ebp - local_4]           # 004fbaa1
    call FUN_004fb2e3                            # 004fbaa4
    {load} mov esp, ebp                          # 004fbaa9
    pop ebp                                      # 004fbaab
    ret 0x4                                      # 004fbaac

