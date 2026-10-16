# FUN_004be48a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be48a
# extent:       0x004be48a-0x004be4c7 (61 code bytes)
# span:         0x004be48a-0x004be4c7 (code 61, tables 0, padding 0)
# sha256:       3b6bab2e7a173d7ef8f9ee2cf7d6816f5dc60e5bcbc146a09cc2bc4469a6679d
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be48a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_3d0
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_3d0, 0x3d0  # offset +0x3d0

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004be48a - 0x401000
.globl FUN_004be48a
FUN_004be48a:
    # block 0x004be48a: entry, 13 instruction(s), ends with je to 0x004be4c1 (forward)
    push ebp                                     # 004be48a
    {load} mov ebp, esp                          # 004be48b
    push ecx                                     # 004be48d
    push esi                                     # 004be48e
    push edi                                     # 004be48f
    mov dword ptr [ebp - local_4], ecx           # 004be490
    mov edi, 0x552170                            # 004be493
    mov esi, dword ptr [ebp - local_4]           # 004be498
    add esi, 0x3af                               # 004be49b
    mov ecx, 0x9                                 # 004be4a1
    {load} xor eax, eax                          # 004be4a6
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004be4a8
    je.d8 L_004be4c1                             # 004be4aa
    # block 0x004be4ac: entered by fall-through of je at 0x004be4aa, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004be4c1
    mov ecx, dword ptr [ebp - local_4]           # 004be4ac
    mov dx, word ptr [ecx + field_3d0]           # 004be4af
    push edx                                     # 004be4b6
    mov ecx, 0x5c3a67                            # 004be4b7
    call FUN_004fb2e3                            # 004be4bc
L_004be4c1:
    # block 0x004be4c1: entered by je at 0x004be4aa, 5 instruction(s), ends with ret
    pop edi                                      # 004be4c1
    pop esi                                      # 004be4c2
    {load} mov esp, ebp                          # 004be4c3
    pop ebp                                      # 004be4c5
    ret                                          # 004be4c6

