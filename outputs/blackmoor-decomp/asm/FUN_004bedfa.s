# FUN_004bedfa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bedfa
# extent:       0x004bedfa-0x004bee2c (50 code bytes)
# span:         0x004bedfa-0x004bee2c (code 50, tables 0, padding 0)
# sha256:       5ee753ee08507e261aab21741a4d0dc9706c6d515c236b8c63a3185374072b97
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004bedfa
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls binkw32.dll!_BinkClose@4, FUN_004bedb5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_004bedb5, .text + (0x004bedb5 - 0x401000)

.org 0x004bedfa - 0x401000
.globl FUN_004bedfa
FUN_004bedfa:
    # block 0x004bedfa: entry, 7 instruction(s), ends with je to 0x004bee1e (forward)
    push ebp                                     # 004bedfa
    {load} mov ebp, esp                          # 004bedfb
    push ecx                                     # 004bedfd
    mov dword ptr [ebp - local_4], ecx           # 004bedfe
    mov eax, dword ptr [ebp + arg_8]             # 004bee01
    cmp dword ptr [eax], 0x0                     # 004bee04
    je.d8 L_004bee1e                             # 004bee07
    # block 0x004bee09: entered by fall-through of je at 0x004bee07, 6 instruction(s), calls binkw32.dll!_BinkClose@4, falls into the block at 0x004bee1e
    mov ecx, dword ptr [ebp + arg_8]             # 004bee09
    mov edx, dword ptr [ecx]                     # 004bee0c
    push edx                                     # 004bee0e
    call dword ptr [0x52a504]                    # 004bee0f
    mov eax, dword ptr [ebp + arg_8]             # 004bee15
    mov dword ptr [eax], 0x0                     # 004bee18
L_004bee1e:
    # block 0x004bee1e: entered by je at 0x004bee07, 5 instruction(s), calls FUN_004bedb5, ends with ret 0x4
    mov ecx, dword ptr [ebp - local_4]           # 004bee1e
    call FUN_004bedb5                            # 004bee21
    {load} mov esp, ebp                          # 004bee26
    pop ebp                                      # 004bee28
    ret 0x4                                      # 004bee29

