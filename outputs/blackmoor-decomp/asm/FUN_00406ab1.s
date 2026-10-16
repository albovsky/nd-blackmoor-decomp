# FUN_00406ab1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406ab1
# extent:       0x00406ab1-0x00406af8 (71 code bytes)
# span:         0x00406ab1-0x00406af8 (code 71, tables 0, padding 0)
# sha256:       8f32847bac2075c566c0e57f82f04804c00e86f153037d38e26162196ad10d25
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406ab1
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

.org 0x00406ab1 - 0x401000
.globl FUN_00406ab1
FUN_00406ab1:
    # block 0x00406ab1: entry, 6 instruction(s), ends with jne to 0x00406acd (forward)
    push ebp                                     # 00406ab1
    {load} mov ebp, esp                          # 00406ab2
    push ecx                                     # 00406ab4
    mov dword ptr [ebp - local_4], ecx           # 00406ab5
    cmp dword ptr [0x5e3536], 0x1                # 00406ab8
    jne.d8 L_00406acd                            # 00406abf
    # block 0x00406ac1: entered by fall-through of jne at 0x00406abf, 2 instruction(s), ends with forward jump to 0x00406aec
    mov dword ptr [0x5e3536], 0x0                # 00406ac1
    jmp.d8 L_00406aec                            # 00406acb
L_00406acd:
    # block 0x00406acd: entered by jne at 0x00406abf, 4 instruction(s), ends with jne to 0x00406aec (forward)
    mov dword ptr [0x5e3536], 0x1                # 00406acd
    movsx eax, word ptr [0x5e335e]               # 00406ad7
    cmp eax, 0xb                                 # 00406ade
    jne.d8 L_00406aec                            # 00406ae1
    # block 0x00406ae3: entered by fall-through of jne at 0x00406ae1, 1 instruction(s), falls into the block at 0x00406aec
    mov word ptr [0x5e335e], 0xffff              # 00406ae3
L_00406aec:
    # block 0x00406aec: entered by jmp at 0x00406acb; jne at 0x00406ae1, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406aec
    call FUN_00404be1                            # 00406aef
    {load} mov esp, ebp                          # 00406af4
    pop ebp                                      # 00406af6
    ret                                          # 00406af7

