# FUN_00407a80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407a80
# extent:       0x00407a80-0x00407ac7 (71 code bytes)
# span:         0x00407a80-0x00407ac7 (code 71, tables 0, padding 0)
# sha256:       d1dc969580fa3b297502685eba85db0e0a21b15fcfeb03b78042f50fb5070e76
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407a80
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00404be1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00404be1, .text + (0x00404be1 - 0x401000)

.org 0x00407a80 - 0x401000
.globl FUN_00407a80
FUN_00407a80:
    # block 0x00407a80: entry, 6 instruction(s), ends with jne to 0x00407a9c (forward)
    push ebp                                     # 00407a80
    {load} mov ebp, esp                          # 00407a81
    push ecx                                     # 00407a83
    mov dword ptr [ebp - local_4], ecx           # 00407a84
    cmp dword ptr [0x5e361a], 0x1                # 00407a87
    jne.d8 L_00407a9c                            # 00407a8e
    # block 0x00407a90: entered by fall-through of jne at 0x00407a8e, 2 instruction(s), ends with forward jump to 0x00407abb
    mov dword ptr [0x5e361a], 0x0                # 00407a90
    jmp.d8 L_00407abb                            # 00407a9a
L_00407a9c:
    # block 0x00407a9c: entered by jne at 0x00407a8e, 4 instruction(s), ends with jne to 0x00407abb (forward)
    mov dword ptr [0x5e361a], 0x1                # 00407a9c
    movsx eax, word ptr [0x5e335e]               # 00407aa6
    cmp eax, 0x44                                # 00407aad
    jne.d8 L_00407abb                            # 00407ab0
    # block 0x00407ab2: entered by fall-through of jne at 0x00407ab0, 1 instruction(s), falls into the block at 0x00407abb
    mov word ptr [0x5e335e], 0xffff              # 00407ab2
L_00407abb:
    # block 0x00407abb: entered by jmp at 0x00407a9a; jne at 0x00407ab0, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00407abb
    call FUN_00404be1                            # 00407abe
    {load} mov esp, ebp                          # 00407ac3
    pop ebp                                      # 00407ac5
    ret                                          # 00407ac6

