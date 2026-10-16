# FUN_00407466
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407466
# extent:       0x00407466-0x004074ad (71 code bytes)
# span:         0x00407466-0x004074ad (code 71, tables 0, padding 0)
# sha256:       72fdccd87dec639639b4e065592c518f1378c7aad502d98e37e26152212acae0
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407466
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

.org 0x00407466 - 0x401000
.globl FUN_00407466
FUN_00407466:
    # block 0x00407466: entry, 6 instruction(s), ends with jne to 0x00407482 (forward)
    push ebp                                     # 00407466
    {load} mov ebp, esp                          # 00407467
    push ecx                                     # 00407469
    mov dword ptr [ebp - local_4], ecx           # 0040746a
    cmp dword ptr [0x5e35c2], 0x1                # 0040746d
    jne.d8 L_00407482                            # 00407474
    # block 0x00407476: entered by fall-through of jne at 0x00407474, 2 instruction(s), ends with forward jump to 0x004074a1
    mov dword ptr [0x5e35c2], 0x0                # 00407476
    jmp.d8 L_004074a1                            # 00407480
L_00407482:
    # block 0x00407482: entered by jne at 0x00407474, 4 instruction(s), ends with jne to 0x004074a1 (forward)
    mov dword ptr [0x5e35c2], 0x1                # 00407482
    movsx eax, word ptr [0x5e335e]               # 0040748c
    cmp eax, 0x2e                                # 00407493
    jne.d8 L_004074a1                            # 00407496
    # block 0x00407498: entered by fall-through of jne at 0x00407496, 1 instruction(s), falls into the block at 0x004074a1
    mov word ptr [0x5e335e], 0xffff              # 00407498
L_004074a1:
    # block 0x004074a1: entered by jmp at 0x00407480; jne at 0x00407496, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004074a1
    call FUN_00404be1                            # 004074a4
    {load} mov esp, ebp                          # 004074a9
    pop ebp                                      # 004074ab
    ret                                          # 004074ac

