# FUN_0046f8ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046f8ae
# extent:       0x0046f8ae-0x0046f907 (89 code bytes)
# span:         0x0046f8ae-0x0046f907 (code 89, tables 0, padding 0)
# sha256:       bc8eeec1d9867dee3000b2d036dd83c158dd2f1abc188ad68057b73550a0d19a
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046f8ae
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004fba86, FUN_00448d11
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004fba86, .text + (0x004fba86 - 0x401000)

.org 0x0046f8ae - 0x401000
.globl FUN_0046f8ae
FUN_0046f8ae:
    # block 0x0046f8ae: entry, 13 instruction(s), ends with je to 0x0046f8de (forward)
    push ebp                                     # 0046f8ae
    {load} mov ebp, esp                          # 0046f8af
    push ecx                                     # 0046f8b1
    push esi                                     # 0046f8b2
    push edi                                     # 0046f8b3
    mov dword ptr [ebp - local_4], ecx           # 0046f8b4
    mov edi, 0x54c174                            # 0046f8b7
    mov esi, dword ptr [ebp + arg_8]             # 0046f8bc
    add esi, 0x64                                # 0046f8bf
    mov ecx, 0x9                                 # 0046f8c2
    {load} xor eax, eax                          # 0046f8c7
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0046f8c9
    je.d8 L_0046f8de                             # 0046f8cb
    # block 0x0046f8cd: entered by fall-through of je at 0x0046f8cb, 5 instruction(s), calls FUN_004fba86, falls into the block at 0x0046f8de
    mov ecx, dword ptr [ebp + arg_8]             # 0046f8cd
    add ecx, 0x64                                # 0046f8d0
    push ecx                                     # 0046f8d3
    mov ecx, 0x5c3a67                            # 0046f8d4
    call FUN_004fba86                            # 0046f8d9
L_0046f8de:
    # block 0x0046f8de: entered by je at 0x0046f8cb, 2 instruction(s), ends with je to 0x0046f8ff (forward)
    cmp dword ptr [0x5bb202], 0x0                # 0046f8de
    je.d8 L_0046f8ff                             # 0046f8e5
    # block 0x0046f8e7: entered by fall-through of je at 0x0046f8e5, 8 instruction(s), calls FUN_00448d11, falls into the block at 0x0046f8ff
    push 0x0                                     # 0046f8e7
    push -0x1                                    # 0046f8e9
    mov edx, dword ptr [ebp + arg_8]             # 0046f8eb
    push edx                                     # 0046f8ee
    mov eax, dword ptr [0x5d03b3]                # 0046f8ef
    push eax                                     # 0046f8f4
    mov ecx, 0x619a05                            # 0046f8f5
    call FUN_00448d11                            # 0046f8fa
L_0046f8ff:
    # block 0x0046f8ff: entered by je at 0x0046f8e5, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0046f8ff
    pop esi                                      # 0046f900
    {load} mov esp, ebp                          # 0046f901
    pop ebp                                      # 0046f903
    ret 0x4                                      # 0046f904

