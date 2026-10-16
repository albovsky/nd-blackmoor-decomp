# FUN_00407582
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00407582
# extent:       0x00407582-0x004075c9 (71 code bytes)
# span:         0x00407582-0x004075c9 (code 71, tables 0, padding 0)
# sha256:       37e0f4d49bf77ce5870315211fac4c45484975b097b7f25ce0f132a4705211e9
# evidence:     ev_e9898ee3dd29de1cd9f576346b0a9ae1f1061f4efc32a7db77236610d8adfef6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00407582
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

.org 0x00407582 - 0x401000
.globl FUN_00407582
FUN_00407582:
    # block 0x00407582: entry, 6 instruction(s), ends with jne to 0x0040759e (forward)
    push ebp                                     # 00407582
    {load} mov ebp, esp                          # 00407583
    push ecx                                     # 00407585
    mov dword ptr [ebp - local_4], ecx           # 00407586
    cmp dword ptr [0x5e35d2], 0x1                # 00407589
    jne.d8 L_0040759e                            # 00407590
    # block 0x00407592: entered by fall-through of jne at 0x00407590, 2 instruction(s), ends with forward jump to 0x004075bd
    mov dword ptr [0x5e35d2], 0x0                # 00407592
    jmp.d8 L_004075bd                            # 0040759c
L_0040759e:
    # block 0x0040759e: entered by jne at 0x00407590, 4 instruction(s), ends with jne to 0x004075bd (forward)
    mov dword ptr [0x5e35d2], 0x1                # 0040759e
    movsx eax, word ptr [0x5e335e]               # 004075a8
    cmp eax, 0x32                                # 004075af
    jne.d8 L_004075bd                            # 004075b2
    # block 0x004075b4: entered by fall-through of jne at 0x004075b2, 1 instruction(s), falls into the block at 0x004075bd
    mov word ptr [0x5e335e], 0xffff              # 004075b4
L_004075bd:
    # block 0x004075bd: entered by jmp at 0x0040759c; jne at 0x004075b2, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004075bd
    call FUN_00404be1                            # 004075c0
    {load} mov esp, ebp                          # 004075c5
    pop ebp                                      # 004075c7
    ret                                          # 004075c8

