# FUN_004077ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004077ba
# extent:       0x004077ba-0x00407801 (71 code bytes)
# span:         0x004077ba-0x00407801 (code 71, tables 0, padding 0)
# sha256:       d5c6f2a4c02a2fe31d54f421802af3f6c66e4eda495c9a221950bf6e4e8dbd06
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004077ba
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

.org 0x004077ba - 0x401000
.globl FUN_004077ba
FUN_004077ba:
    # block 0x004077ba: entry, 6 instruction(s), ends with jne to 0x004077d6 (forward)
    push ebp                                     # 004077ba
    {load} mov ebp, esp                          # 004077bb
    push ecx                                     # 004077bd
    mov dword ptr [ebp - local_4], ecx           # 004077be
    cmp dword ptr [0x5e35f2], 0x1                # 004077c1
    jne.d8 L_004077d6                            # 004077c8
    # block 0x004077ca: entered by fall-through of jne at 0x004077c8, 2 instruction(s), ends with forward jump to 0x004077f5
    mov dword ptr [0x5e35f2], 0x0                # 004077ca
    jmp.d8 L_004077f5                            # 004077d4
L_004077d6:
    # block 0x004077d6: entered by jne at 0x004077c8, 4 instruction(s), ends with jne to 0x004077f5 (forward)
    mov dword ptr [0x5e35f2], 0x1                # 004077d6
    movsx eax, word ptr [0x5e335e]               # 004077e0
    cmp eax, 0x3a                                # 004077e7
    jne.d8 L_004077f5                            # 004077ea
    # block 0x004077ec: entered by fall-through of jne at 0x004077ea, 1 instruction(s), falls into the block at 0x004077f5
    mov word ptr [0x5e335e], 0xffff              # 004077ec
L_004077f5:
    # block 0x004077f5: entered by jmp at 0x004077d4; jne at 0x004077ea, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004077f5
    call FUN_00404be1                            # 004077f8
    {load} mov esp, ebp                          # 004077fd
    pop ebp                                      # 004077ff
    ret                                          # 00407800

