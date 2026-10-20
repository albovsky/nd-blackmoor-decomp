# FUN_00467eb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00467eb0
# extent:       0x00467eb0-0x00467fcd (285 code bytes)
# span:         0x00467eb0-0x00467fcd (code 285, tables 0, padding 0)
# sha256:       87d78b903f12e432f9a1744a8d964a61ea7e2e134b4b20e6827ffe274f29928e
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00467eb0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c0, field_260, field_26c, field_278; [ecx + n] field_1aa, field_1b6, field_26c, field_278, field_2bc; [edx + n] field_1c4, field_240, field_278, field_383
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 73 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1aa, 0x1aa  # offset +0x1aa
.equ field_1b6, 0x1b6  # offset +0x1b6
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1c4, 0x1c4  # offset +0x1c4
.equ field_240, 0x240  # offset +0x240
.equ field_260, 0x260  # offset +0x260
.equ field_26c, 0x26c  # offset +0x26c
.equ field_278, 0x278  # offset +0x278
.equ field_2bc, 0x2bc  # offset +0x2bc
.equ field_383, 0x383  # offset +0x383

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x00467eb0 - 0x401000
.globl FUN_00467eb0
FUN_00467eb0:
    # block 0x00467eb0: entry, 8 instruction(s), ends with je to 0x00467ede (forward)
    push ebp                                     # 00467eb0
    {load} mov ebp, esp                          # 00467eb1
    sub esp, 0x8                                 # 00467eb3
    push edi                                     # 00467eb6
    mov dword ptr [ebp - local_8], ecx           # 00467eb7
    mov eax, dword ptr [ebp - local_8]           # 00467eba
    cmp dword ptr [eax + field_260], 0x0         # 00467ebd
    je.d8 L_00467ede                             # 00467ec4
    # block 0x00467ec6: entered by fall-through of je at 0x00467ec4, 3 instruction(s), ends with jne to 0x00467ede (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00467ec6
    cmp dword ptr [ecx + field_1b6], 0x0         # 00467ec9
    jne.d8 L_00467ede                            # 00467ed0
    # block 0x00467ed2: entered by fall-through of jne at 0x00467ed0, 3 instruction(s), ends with je to 0x00467ee3 (forward)
    mov edx, dword ptr [ebp - local_8]           # 00467ed2
    cmp dword ptr [edx + field_240], 0xb         # 00467ed5
    je.d8 L_00467ee3                             # 00467edc
L_00467ede:
    # block 0x00467ede: entered by je at 0x00467ec4; jne at 0x00467ed0; fall-through of je at 0x00467edc, 1 instruction(s), ends with forward jump to 0x00467fc8
    jmp.d32 L_00467fc8                           # 00467ede
L_00467ee3:
    # block 0x00467ee3: entered by je at 0x00467edc, 8 instruction(s), ends with forward jump to 0x00467f19
    mov ecx, 0x11                                # 00467ee3
    {load} xor eax, eax                          # 00467ee8
    mov edi, dword ptr [ebp - local_8]           # 00467eea
    add edi, 0x278                               # 00467eed
    rep stosd dword ptr es:[edi], eax            # 00467ef3
    mov eax, dword ptr [ebp - local_8]           # 00467ef5
    mov dword ptr [eax + field_26c], 0x0         # 00467ef8
    jmp.d8 L_00467f19                            # 00467f02
L_00467f04:
    # block 0x00467f04: entered by jmp at 0x00467f6f, 5 instruction(s), falls into the block at 0x00467f19
    mov ecx, dword ptr [ebp - local_8]           # 00467f04
    mov edx, dword ptr [ecx + field_26c]         # 00467f07
    add edx, 0x1                                 # 00467f0d
    mov eax, dword ptr [ebp - local_8]           # 00467f10
    mov dword ptr [eax + field_26c], edx         # 00467f13
L_00467f19:
    # block 0x00467f19: entered by jmp at 0x00467f02, 5 instruction(s), ends with jge to 0x00467f71 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00467f19
    mov edx, dword ptr [ebp - local_8]           # 00467f1c
    mov eax, dword ptr [ecx + field_26c]         # 00467f1f
    cmp eax, dword ptr [edx + field_240]         # 00467f25
    jge.d8 L_00467f71                            # 00467f2b
    # block 0x00467f2d: entered by fall-through of jge at 0x00467f2b, 13 instruction(s), ends with backward jump to 0x00467f04
    mov ecx, dword ptr [ebp - local_8]           # 00467f2d
    mov edx, dword ptr [ecx + field_26c]         # 00467f30
    mov eax, dword ptr [ebp - local_8]           # 00467f36
    mov ecx, dword ptr [eax + 8*edx + field_1c0] # 00467f39
    mov edx, dword ptr [ebp - local_8]           # 00467f40
    mov dword ptr [edx + 4*ecx + field_278], 0x1 # 00467f43
    mov eax, dword ptr [ebp - local_8]           # 00467f4e
    mov ecx, dword ptr [eax + field_26c]         # 00467f51
    mov edx, dword ptr [ebp - local_8]           # 00467f57
    mov eax, dword ptr [edx + 8*ecx + field_1c4] # 00467f5a
    mov ecx, dword ptr [ebp - local_8]           # 00467f61
    mov dword ptr [ecx + 4*eax + field_278], 0x1 # 00467f64
    jmp.d8 L_00467f04                            # 00467f6f
L_00467f71:
    # block 0x00467f71: entered by jge at 0x00467f2b, 2 instruction(s), ends with forward jump to 0x00467f83
    mov dword ptr [ebp - local_4], 0x0           # 00467f71
    jmp.d8 L_00467f83                            # 00467f78
L_00467f7a:
    # block 0x00467f7a: entered by jmp at 0x00467fab, 3 instruction(s), falls into the block at 0x00467f83
    mov edx, dword ptr [ebp - local_4]           # 00467f7a
    add edx, 0x1                                 # 00467f7d
    mov dword ptr [ebp - local_4], edx           # 00467f80
L_00467f83:
    # block 0x00467f83: entered by jmp at 0x00467f78, 2 instruction(s), ends with jge to 0x00467fad (forward)
    cmp dword ptr [ebp - local_4], 0x11          # 00467f83
    jge.d8 L_00467fad                            # 00467f87
    # block 0x00467f89: entered by fall-through of jge at 0x00467f87, 4 instruction(s), ends with je to 0x00467fab (forward)
    mov eax, dword ptr [ebp - local_4]           # 00467f89
    mov ecx, dword ptr [ebp - local_8]           # 00467f8c
    cmp dword ptr [ecx + 4*eax + field_2bc], 0x0 # 00467f8f
    je.d8 L_00467fab                             # 00467f97
    # block 0x00467f99: entered by fall-through of je at 0x00467f97, 4 instruction(s), ends with jne to 0x00467fab (forward)
    mov edx, dword ptr [ebp - local_4]           # 00467f99
    mov eax, dword ptr [ebp - local_8]           # 00467f9c
    cmp dword ptr [eax + 4*edx + field_278], 0x0 # 00467f9f
    jne.d8 L_00467fab                            # 00467fa7
    # block 0x00467fa9: entered by fall-through of jne at 0x00467fa7, 1 instruction(s), ends with forward jump to 0x00467fc8
    jmp.d8 L_00467fc8                            # 00467fa9
L_00467fab:
    # block 0x00467fab: entered by je at 0x00467f97; jne at 0x00467fa7, 1 instruction(s), ends with backward jump to 0x00467f7a
    jmp.d8 L_00467f7a                            # 00467fab
L_00467fad:
    # block 0x00467fad: entered by jge at 0x00467f87, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00467fc8
    mov ecx, dword ptr [ebp - local_8]           # 00467fad
    mov edx, dword ptr [ecx + field_1aa]         # 00467fb0
    mov ax, word ptr [edx + field_383]           # 00467fb6
    push eax                                     # 00467fbd
    mov ecx, 0x5c3a67                            # 00467fbe
    call FUN_004fb2e3                            # 00467fc3
L_00467fc8:
    # block 0x00467fc8: entered by jmp at 0x00467ede; jmp at 0x00467fa9, 4 instruction(s), ends with ret
    pop edi                                      # 00467fc8
    {load} mov esp, ebp                          # 00467fc9
    pop ebp                                      # 00467fcb
    ret                                          # 00467fcc

