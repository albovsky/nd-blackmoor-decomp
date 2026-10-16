# FUN_004fc97d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc97d
# extent:       0x004fc97d-0x004fc9f1 (116 code bytes)
# span:         0x004fc97d-0x004fc9f1 (code 116, tables 0, padding 0)
# sha256:       39ea8e10da34aac36abd2870de833164da83a9a711e5ab5385f989a04660ac69
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fc97d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004f6810, FUN_004fa2a8, FUN_0050ca3e, FUN_0052139c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f6810, .text + (0x004f6810 - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004fc97d - 0x401000
.globl FUN_004fc97d
FUN_004fc97d:
    # block 0x004fc97d: entry, 7 instruction(s), ends with je to 0x004fc99c (forward)
    push ebp                                     # 004fc97d
    {load} mov ebp, esp                          # 004fc97e
    push ecx                                     # 004fc980
    mov dword ptr [ebp - local_4], ecx           # 004fc981
    movsx eax, word ptr [0x63a4cd]               # 004fc984
    test eax, eax                                # 004fc98b
    je.d8 L_004fc99c                             # 004fc98d
    # block 0x004fc98f: entered by fall-through of je at 0x004fc98d, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fc99c
    push 0x560994                                # 004fc98f
    call FUN_0044a2b7                            # 004fc994
    add esp, 0x4                                 # 004fc999
L_004fc99c:
    # block 0x004fc99c: entered by je at 0x004fc98d, 4 instruction(s), calls FUN_004f6810, ends with jne to 0x004fc9ed (forward)
    mov ecx, 0x5cf1eb                            # 004fc99c
    call FUN_004f6810                            # 004fc9a1
    test eax, eax                                # 004fc9a6
    jne.d8 L_004fc9ed                            # 004fc9a8
    # block 0x004fc9aa: entered by fall-through of jne at 0x004fc9a8, 3 instruction(s), ends with je to 0x004fc9ed (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004fc9aa
    test ecx, ecx                                # 004fc9b1
    je.d8 L_004fc9ed                             # 004fc9b3
    # block 0x004fc9b5: entered by fall-through of je at 0x004fc9b3, 14 instruction(s), calls FUN_004fa2a8, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, falls into the block at 0x004fc9ed
    mov ecx, 0x5cf1eb                            # 004fc9b5
    call FUN_004fa2a8                            # 004fc9ba
    push eax                                     # 004fc9bf
    push 0x5609b0                                # 004fc9c0
    push 0x63888b                                # 004fc9c5
    call FUN_0050ca3e                            # 004fc9ca
    add esp, 0xc                                 # 004fc9cf
    push 0x0                                     # 004fc9d2
    push 0x0                                     # 004fc9d4
    push 0x63888b                                # 004fc9d6
    call FUN_0052139c                            # 004fc9db
    push 0x63888b                                # 004fc9e0
    call FUN_0044a2b7                            # 004fc9e5
    add esp, 0x4                                 # 004fc9ea
L_004fc9ed:
    # block 0x004fc9ed: entered by jne at 0x004fc9a8; je at 0x004fc9b3, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fc9ed
    pop ebp                                      # 004fc9ef
    ret                                          # 004fc9f0

