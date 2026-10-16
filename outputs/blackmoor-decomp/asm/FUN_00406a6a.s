# FUN_00406a6a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00406a6a
# extent:       0x00406a6a-0x00406ab1 (71 code bytes)
# span:         0x00406a6a-0x00406ab1 (code 71, tables 0, padding 0)
# sha256:       ba321602dcb12e677d5bdf7e26a92aa092a5bfc69d82c95413e9bebe0d3ae281
# evidence:     ev_7e0487646cbf109e03053d69b2d5d595199e6535938b5dd843b65bab05dc6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00406a6a
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

.org 0x00406a6a - 0x401000
.globl FUN_00406a6a
FUN_00406a6a:
    # block 0x00406a6a: entry, 6 instruction(s), ends with jne to 0x00406a86 (forward)
    push ebp                                     # 00406a6a
    {load} mov ebp, esp                          # 00406a6b
    push ecx                                     # 00406a6d
    mov dword ptr [ebp - local_4], ecx           # 00406a6e
    cmp dword ptr [0x5e3532], 0x1                # 00406a71
    jne.d8 L_00406a86                            # 00406a78
    # block 0x00406a7a: entered by fall-through of jne at 0x00406a78, 2 instruction(s), ends with forward jump to 0x00406aa5
    mov dword ptr [0x5e3532], 0x0                # 00406a7a
    jmp.d8 L_00406aa5                            # 00406a84
L_00406a86:
    # block 0x00406a86: entered by jne at 0x00406a78, 4 instruction(s), ends with jne to 0x00406aa5 (forward)
    mov dword ptr [0x5e3532], 0x1                # 00406a86
    movsx eax, word ptr [0x5e335e]               # 00406a90
    cmp eax, 0xa                                 # 00406a97
    jne.d8 L_00406aa5                            # 00406a9a
    # block 0x00406a9c: entered by fall-through of jne at 0x00406a9a, 1 instruction(s), falls into the block at 0x00406aa5
    mov word ptr [0x5e335e], 0xffff              # 00406a9c
L_00406aa5:
    # block 0x00406aa5: entered by jmp at 0x00406a84; jne at 0x00406a9a, 5 instruction(s), calls FUN_00404be1, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00406aa5
    call FUN_00404be1                            # 00406aa8
    {load} mov esp, ebp                          # 00406aad
    pop ebp                                      # 00406aaf
    ret                                          # 00406ab0

