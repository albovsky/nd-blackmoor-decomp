# FUN_00407275
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407275
# extent:       0x00407275-0x004072bc (71 code bytes)
# span:         0x00407275-0x004072bc (code 71, tables 0, padding 0)
# sha256:       990770f7bac7b69061795d964f85f68a323a4019efb7b01406e22f0366d38900
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407275
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

.org 0x00407275 - 0x401000
.globl FUN_00407275
FUN_00407275:
    # block 0x00407275: entry, 6 instruction(s), ends with jne to 0x00407291 (forward)
    push ebp                                     # 00407275
    {load} mov ebp, esp                          # 00407276
    push ecx                                     # 00407278
    mov dword ptr [ebp - local_4], ecx           # 00407279
    cmp dword ptr [0x5e35a6], 0x1                # 0040727c
    jne.d8 L_00407291                            # 00407283
    # block 0x00407285: entered by fall-through of jne at 0x00407283, 2 instruction(s), ends with forward jump to 0x004072b0
    mov dword ptr [0x5e35a6], 0x0                # 00407285
    jmp.d8 L_004072b0                            # 0040728f
L_00407291:
    # block 0x00407291: entered by jne at 0x00407283, 4 instruction(s), ends with jne to 0x004072b0 (forward)
    mov dword ptr [0x5e35a6], 0x1                # 00407291
    movsx eax, word ptr [0x5e335e]               # 0040729b
    cmp eax, 0x27                                # 004072a2
    jne.d8 L_004072b0                            # 004072a5
    # block 0x004072a7: entered by fall-through of jne at 0x004072a5, 1 instruction(s), falls into the block at 0x004072b0
    mov word ptr [0x5e335e], 0xffff              # 004072a7
L_004072b0:
    # block 0x004072b0: entered by jmp at 0x0040728f; jne at 0x004072a5, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004072b0
    call FUN_00404be1                            # 004072b3
    {load} mov esp, ebp                          # 004072b8
    pop ebp                                      # 004072ba
    ret                                          # 004072bb

