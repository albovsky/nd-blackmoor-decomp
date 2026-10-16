# FUN_00407610
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407610
# extent:       0x00407610-0x00407657 (71 code bytes)
# span:         0x00407610-0x00407657 (code 71, tables 0, padding 0)
# sha256:       6f541ebc9169ccda1abda89e77e2a0e9b2fe9867f81f169347b9919568f6c889
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407610
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

.org 0x00407610 - 0x401000
.globl FUN_00407610
FUN_00407610:
    # block 0x00407610: entry, 6 instruction(s), ends with jne to 0x0040762c (forward)
    push ebp                                     # 00407610
    {load} mov ebp, esp                          # 00407611
    push ecx                                     # 00407613
    mov dword ptr [ebp - local_4], ecx           # 00407614
    cmp dword ptr [0x5e35da], 0x1                # 00407617
    jne.d8 L_0040762c                            # 0040761e
    # block 0x00407620: entered by fall-through of jne at 0x0040761e, 2 instruction(s), ends with forward jump to 0x0040764b
    mov dword ptr [0x5e35da], 0x0                # 00407620
    jmp.d8 L_0040764b                            # 0040762a
L_0040762c:
    # block 0x0040762c: entered by jne at 0x0040761e, 4 instruction(s), ends with jne to 0x0040764b (forward)
    mov dword ptr [0x5e35da], 0x1                # 0040762c
    movsx eax, word ptr [0x5e335e]               # 00407636
    cmp eax, 0x34                                # 0040763d
    jne.d8 L_0040764b                            # 00407640
    # block 0x00407642: entered by fall-through of jne at 0x00407640, 1 instruction(s), falls into the block at 0x0040764b
    mov word ptr [0x5e335e], 0xffff              # 00407642
L_0040764b:
    # block 0x0040764b: entered by jmp at 0x0040762a; jne at 0x00407640, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0040764b
    call FUN_00404be1                            # 0040764e
    {load} mov esp, ebp                          # 00407653
    pop ebp                                      # 00407655
    ret                                          # 00407656

