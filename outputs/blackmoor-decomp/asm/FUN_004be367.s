# FUN_004be367
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004be367
# extent:       0x004be367-0x004be3d3 (108 code bytes)
# span:         0x004be367-0x004be3d3 (code 108, tables 0, padding 0)
# sha256:       f737f1d5ba74412737116a1f4340c473ce26d6fca3303a37689f911d64298070
# evidence:     ev_a820b7e2430f534e8ea0b1abf6360ab2ba44f046f8d29cae3bd3792d6b2f52d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004be367
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_50, field_14c; [ecx + n] field_4c, field_50, field_150; [edx + n] field_4c
# callees:      calls FUN_004be619
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50
.equ field_14c, 0x14c  # offset +0x14c
.equ field_150, 0x150  # offset +0x150

# --- external targets -----------------------------------------------
.set FUN_004be619, .text + (0x004be619 - 0x401000)

.org 0x004be367 - 0x401000
.globl FUN_004be367
FUN_004be367:
    # block 0x004be367: entry, 13 instruction(s), calls FUN_004be619, ends with jne to 0x004be3a5 (forward)
    push ebp                                     # 004be367
    {load} mov ebp, esp                          # 004be368
    sub esp, 0x8                                 # 004be36a
    mov dword ptr [ebp - local_8], ecx           # 004be36d
    mov dword ptr [ebp - local_4], 0x0           # 004be370
    push 0x154                                   # 004be377
    lea eax, [ebp - local_4]                     # 004be37c
    push eax                                     # 004be37f
    mov ecx, dword ptr [ebp - local_8]           # 004be380
    call FUN_004be619                            # 004be383
    mov ecx, dword ptr [ebp - local_8]           # 004be388
    cmp dword ptr [ecx + field_4c], 0x0          # 004be38b
    jne.d8 L_004be3a5                            # 004be38f
    # block 0x004be391: entered by fall-through of jne at 0x004be38f, 7 instruction(s), ends with forward jump to 0x004be3cc
    mov edx, dword ptr [ebp - local_8]           # 004be391
    mov eax, dword ptr [ebp - local_4]           # 004be394
    mov dword ptr [edx + field_4c], eax          # 004be397
    mov ecx, dword ptr [ebp - local_8]           # 004be39a
    mov edx, dword ptr [ebp - local_4]           # 004be39d
    mov dword ptr [ecx + field_50], edx          # 004be3a0
    jmp.d8 L_004be3cc                            # 004be3a3
L_004be3a5:
    # block 0x004be3a5: entered by jne at 0x004be38f, 11 instruction(s), falls into the block at 0x004be3cc
    mov eax, dword ptr [ebp - local_8]           # 004be3a5
    mov ecx, dword ptr [eax + field_50]          # 004be3a8
    mov edx, dword ptr [ebp - local_4]           # 004be3ab
    mov dword ptr [ecx + field_150], edx         # 004be3ae
    mov eax, dword ptr [ebp - local_4]           # 004be3b4
    mov ecx, dword ptr [ebp - local_8]           # 004be3b7
    mov edx, dword ptr [ecx + field_50]          # 004be3ba
    mov dword ptr [eax + field_14c], edx         # 004be3bd
    mov eax, dword ptr [ebp - local_8]           # 004be3c3
    mov ecx, dword ptr [ebp - local_4]           # 004be3c6
    mov dword ptr [eax + field_50], ecx          # 004be3c9
L_004be3cc:
    # block 0x004be3cc: entered by jmp at 0x004be3a3, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_4]           # 004be3cc
    {load} mov esp, ebp                          # 004be3cf
    pop ebp                                      # 004be3d1
    ret                                          # 004be3d2

