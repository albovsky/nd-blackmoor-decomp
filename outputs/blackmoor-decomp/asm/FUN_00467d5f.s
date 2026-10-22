# FUN_00467d5f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467d5f
# extent:       0x00467d5f-0x00467e23 (196 code bytes)
# span:         0x00467d5f-0x00467e23 (code 196, tables 0, padding 0)
# sha256:       ba64a9452fc502fd25e7ae5b85f3a2d0909ac18f6f8bd2900fd6b0a9749903a0
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00467d5f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1aa, field_1c4, field_250, field_29a, field_2f0; [ecx + n] field_1aa, field_1c0, field_246, field_24c, field_296; [edx + n] field_1aa, field_1c0, field_1c4, field_240, field_24a
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_240, 0x240  # offset +0x240
.equ field_246, 0x246  # offset +0x246
.equ field_24a, 0x24a  # offset +0x24a
.equ field_24c, 0x24c  # offset +0x24c
.equ field_250, 0x250  # offset +0x250
.equ field_296, 0x296  # offset +0x296
.equ field_29a, 0x29a  # offset +0x29a
.equ field_2f0, 0x2f0  # offset +0x2f0

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00467d5f - 0x401000
.globl FUN_00467d5f
FUN_00467d5f:
    # block 0x00467d5f: entry, 7 instruction(s), ends with je to 0x00467d8a (forward)
    push ebp                                     # 00467d5f
    {load} mov ebp, esp                          # 00467d60
    push ecx                                     # 00467d62
    mov dword ptr [ebp - local_4], ecx           # 00467d63
    mov eax, dword ptr [ebp - local_4]           # 00467d66
    cmp dword ptr [eax + field_250], 0x0         # 00467d69
    je.d8 L_00467d8a                             # 00467d70
    # block 0x00467d72: entered by fall-through of je at 0x00467d70, 3 instruction(s), ends with jne to 0x00467d8a (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467d72
    cmp dword ptr [ecx + field_24c], 0x0         # 00467d75
    jne.d8 L_00467d8a                            # 00467d7c
    # block 0x00467d7e: entered by fall-through of jne at 0x00467d7c, 3 instruction(s), ends with je to 0x00467d8f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467d7e
    cmp dword ptr [edx + field_240], 0x1         # 00467d81
    je.d8 L_00467d8f                             # 00467d88
L_00467d8a:
    # block 0x00467d8a: entered by je at 0x00467d70; jne at 0x00467d7c; fall-through of je at 0x00467d88, 1 instruction(s), ends with forward jump to 0x00467e1f
    jmp.d32 L_00467e1f                           # 00467d8a
L_00467d8f:
    # block 0x00467d8f: entered by je at 0x00467d88, 6 instruction(s), ends with jne to 0x00467dc3 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00467d8f
    mov ecx, dword ptr [eax + field_1aa]         # 00467d92
    mov edx, dword ptr [ebp - local_4]           # 00467d98
    mov eax, dword ptr [edx + field_1c0]         # 00467d9b
    cmp eax, dword ptr [ecx + field_246]         # 00467da1
    jne.d8 L_00467dc3                            # 00467da7
    # block 0x00467da9: entered by fall-through of jne at 0x00467da7, 6 instruction(s), ends with je to 0x00467df7 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00467da9
    mov edx, dword ptr [ecx + field_1aa]         # 00467dac
    mov eax, dword ptr [ebp - local_4]           # 00467db2
    mov ecx, dword ptr [eax + field_1c4]         # 00467db5
    cmp ecx, dword ptr [edx + field_24a]         # 00467dbb
    je.d8 L_00467df7                             # 00467dc1
L_00467dc3:
    # block 0x00467dc3: entered by jne at 0x00467da7; fall-through of je at 0x00467dc1, 6 instruction(s), ends with jne to 0x00467e1f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467dc3
    mov eax, dword ptr [edx + field_1aa]         # 00467dc6
    mov ecx, dword ptr [ebp - local_4]           # 00467dcc
    mov edx, dword ptr [ecx + field_1c0]         # 00467dcf
    cmp edx, dword ptr [eax + field_29a]         # 00467dd5
    jne.d8 L_00467e1f                            # 00467ddb
    # block 0x00467ddd: entered by fall-through of jne at 0x00467ddb, 6 instruction(s), ends with jne to 0x00467e1f (forward)
    mov eax, dword ptr [ebp - local_4]           # 00467ddd
    mov ecx, dword ptr [eax + field_1aa]         # 00467de0
    mov edx, dword ptr [ebp - local_4]           # 00467de6
    mov eax, dword ptr [edx + field_1c4]         # 00467de9
    cmp eax, dword ptr [ecx + field_296]         # 00467def
    jne.d8 L_00467e1f                            # 00467df5
L_00467df7:
    # block 0x00467df7: entered by je at 0x00467dc1; fall-through of jne at 0x00467df5, 8 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00467e1f
    mov ecx, dword ptr [ebp - local_4]           # 00467df7
    mov dword ptr [ecx + field_24c], 0x1         # 00467dfa
    mov edx, dword ptr [ebp - local_4]           # 00467e04
    mov eax, dword ptr [edx + field_1aa]         # 00467e07
    mov cx, word ptr [eax + field_2f0]           # 00467e0d
    push ecx                                     # 00467e14
    mov ecx, 0x5c3a67                            # 00467e15
    call FUN_004fb2e3                            # 00467e1a
L_00467e1f:
    # block 0x00467e1f: entered by jmp at 0x00467d8a; jne at 0x00467ddb; jne at 0x00467df5, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00467e1f
    pop ebp                                      # 00467e21
    ret                                          # 00467e22

