# FUN_004079ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004079ab
# extent:       0x004079ab-0x004079f2 (71 code bytes)
# span:         0x004079ab-0x004079f2 (code 71, tables 0, padding 0)
# sha256:       683a48e18ee1e1634e036ba9c1e0b3d6108e500c3be31928e76391383a40a48e
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004079ab
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

.org 0x004079ab - 0x401000
.globl FUN_004079ab
FUN_004079ab:
    # block 0x004079ab: entry, 6 instruction(s), ends with jne to 0x004079c7 (forward)
    push ebp                                     # 004079ab
    {load} mov ebp, esp                          # 004079ac
    push ecx                                     # 004079ae
    mov dword ptr [ebp - local_4], ecx           # 004079af
    cmp dword ptr [0x5e360e], 0x1                # 004079b2
    jne.d8 L_004079c7                            # 004079b9
    # block 0x004079bb: entered by fall-through of jne at 0x004079b9, 2 instruction(s), ends with forward jump to 0x004079e6
    mov dword ptr [0x5e360e], 0x0                # 004079bb
    jmp.d8 L_004079e6                            # 004079c5
L_004079c7:
    # block 0x004079c7: entered by jne at 0x004079b9, 4 instruction(s), ends with jne to 0x004079e6 (forward)
    mov dword ptr [0x5e360e], 0x1                # 004079c7
    movsx eax, word ptr [0x5e335e]               # 004079d1
    cmp eax, 0x41                                # 004079d8
    jne.d8 L_004079e6                            # 004079db
    # block 0x004079dd: entered by fall-through of jne at 0x004079db, 1 instruction(s), falls into the block at 0x004079e6
    mov word ptr [0x5e335e], 0xffff              # 004079dd
L_004079e6:
    # block 0x004079e6: entered by jmp at 0x004079c5; jne at 0x004079db, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004079e6
    call FUN_00404be1                            # 004079e9
    {load} mov esp, ebp                          # 004079ee
    pop ebp                                      # 004079f0
    ret                                          # 004079f1

