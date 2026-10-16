# FUN_0040788f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040788f
# extent:       0x0040788f-0x004078d6 (71 code bytes)
# span:         0x0040788f-0x004078d6 (code 71, tables 0, padding 0)
# sha256:       4915d4ac979913b78b49736430fa3577acc72ba4bef8367c68bda256075f68f0
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040788f
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

.org 0x0040788f - 0x401000
.globl FUN_0040788f
FUN_0040788f:
    # block 0x0040788f: entry, 6 instruction(s), ends with jne to 0x004078ab (forward)
    push ebp                                     # 0040788f
    {load} mov ebp, esp                          # 00407890
    push ecx                                     # 00407892
    mov dword ptr [ebp - local_4], ecx           # 00407893
    cmp dword ptr [0x5e35fe], 0x1                # 00407896
    jne.d8 L_004078ab                            # 0040789d
    # block 0x0040789f: entered by fall-through of jne at 0x0040789d, 2 instruction(s), ends with forward jump to 0x004078ca
    mov dword ptr [0x5e35fe], 0x0                # 0040789f
    jmp.d8 L_004078ca                            # 004078a9
L_004078ab:
    # block 0x004078ab: entered by jne at 0x0040789d, 4 instruction(s), ends with jne to 0x004078ca (forward)
    mov dword ptr [0x5e35fe], 0x1                # 004078ab
    movsx eax, word ptr [0x5e335e]               # 004078b5
    cmp eax, 0x3d                                # 004078bc
    jne.d8 L_004078ca                            # 004078bf
    # block 0x004078c1: entered by fall-through of jne at 0x004078bf, 1 instruction(s), falls into the block at 0x004078ca
    mov word ptr [0x5e335e], 0xffff              # 004078c1
L_004078ca:
    # block 0x004078ca: entered by jmp at 0x004078a9; jne at 0x004078bf, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004078ca
    call FUN_00404be1                            # 004078cd
    {load} mov esp, ebp                          # 004078d2
    pop ebp                                      # 004078d4
    ret                                          # 004078d5

