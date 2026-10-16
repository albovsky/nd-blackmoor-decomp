# FUN_004fc909
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fc909
# extent:       0x004fc909-0x004fc97d (116 code bytes)
# span:         0x004fc909-0x004fc97d (code 116, tables 0, padding 0)
# sha256:       b9ac5b3bf23c7355f00c045cf106a3e9daea0d182512b26066d2c43a1ce4f7ae
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fc909
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004f67be, FUN_004fa2a8, FUN_0050ca3e, FUN_0052139c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f67be, .text + (0x004f67be - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004fc909 - 0x401000
.globl FUN_004fc909
FUN_004fc909:
    # block 0x004fc909: entry, 7 instruction(s), ends with je to 0x004fc928 (forward)
    push ebp                                     # 004fc909
    {load} mov ebp, esp                          # 004fc90a
    push ecx                                     # 004fc90c
    mov dword ptr [ebp - local_4], ecx           # 004fc90d
    movsx eax, word ptr [0x63a4cd]               # 004fc910
    test eax, eax                                # 004fc917
    je.d8 L_004fc928                             # 004fc919
    # block 0x004fc91b: entered by fall-through of je at 0x004fc919, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fc928
    push 0x56095c                                # 004fc91b
    call FUN_0044a2b7                            # 004fc920
    add esp, 0x4                                 # 004fc925
L_004fc928:
    # block 0x004fc928: entered by je at 0x004fc919, 4 instruction(s), calls FUN_004f67be, ends with jne to 0x004fc979 (forward)
    mov ecx, 0x5cf1eb                            # 004fc928
    call FUN_004f67be                            # 004fc92d
    test eax, eax                                # 004fc932
    jne.d8 L_004fc979                            # 004fc934
    # block 0x004fc936: entered by fall-through of jne at 0x004fc934, 3 instruction(s), ends with je to 0x004fc979 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004fc936
    test ecx, ecx                                # 004fc93d
    je.d8 L_004fc979                             # 004fc93f
    # block 0x004fc941: entered by fall-through of je at 0x004fc93f, 14 instruction(s), calls FUN_004fa2a8, FUN_0050ca3e, FUN_0052139c, FUN_0044a2b7, falls into the block at 0x004fc979
    mov ecx, 0x5cf1eb                            # 004fc941
    call FUN_004fa2a8                            # 004fc946
    push eax                                     # 004fc94b
    push 0x560974                                # 004fc94c
    push 0x63888b                                # 004fc951
    call FUN_0050ca3e                            # 004fc956
    add esp, 0xc                                 # 004fc95b
    push 0x0                                     # 004fc95e
    push 0x0                                     # 004fc960
    push 0x63888b                                # 004fc962
    call FUN_0052139c                            # 004fc967
    push 0x63888b                                # 004fc96c
    call FUN_0044a2b7                            # 004fc971
    add esp, 0x4                                 # 004fc976
L_004fc979:
    # block 0x004fc979: entered by jne at 0x004fc934; je at 0x004fc93f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fc979
    pop ebp                                      # 004fc97b
    ret                                          # 004fc97c

