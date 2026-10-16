# FUN_004d9d70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d9d70
# extent:       0x004d9d70-0x004d9df3 (131 code bytes)
# span:         0x004d9d70-0x004d9df3 (code 131, tables 0, padding 0)
# sha256:       71ad152a7eb69a09306e12a0a75588c884024d5755d501c91cd775379baa8e0f
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d9d70
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004d9df3, FUN_0044a2b7, FUN_004fb2a6, FUN_004da430
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 37 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004d9df3, .text + (0x004d9df3 - 0x401000)
.set FUN_004da430, .text + (0x004da430 - 0x401000)
.set FUN_004fb2a6, .text + (0x004fb2a6 - 0x401000)

.org 0x004d9d70 - 0x401000
.globl FUN_004d9d70
FUN_004d9d70:
    # block 0x004d9d70: entry, 7 instruction(s), ends with je to 0x004d9d90 (forward)
    push ebp                                     # 004d9d70
    {load} mov ebp, esp                          # 004d9d71
    push ecx                                     # 004d9d73
    mov eax, dword ptr [0x5839a1]                # 004d9d74
    mov dword ptr [ebp - local_4], eax           # 004d9d79
    cmp dword ptr [ebp - local_4], 0x0           # 004d9d7c
    je.d8 L_004d9d90                             # 004d9d80
    # block 0x004d9d82: entered by fall-through of je at 0x004d9d80, 2 instruction(s), ends with je to 0x004d9d97 (forward)
    cmp dword ptr [ebp - local_4], 0x1           # 004d9d82
    je.d8 L_004d9d97                             # 004d9d86
    # block 0x004d9d88: entered by fall-through of je at 0x004d9d86, 2 instruction(s), ends with je to 0x004d9dea (forward)
    cmp dword ptr [ebp - local_4], 0x2           # 004d9d88
    je.d8 L_004d9dea                             # 004d9d8c
    # block 0x004d9d8e: entered by fall-through of je at 0x004d9d8c, 1 instruction(s), ends with forward jump to 0x004d9def
    jmp.d8 L_004d9def                            # 004d9d8e
L_004d9d90:
    # block 0x004d9d90: entered by je at 0x004d9d80, 2 instruction(s), calls FUN_004d9df3, ends with forward jump to 0x004d9def
    call FUN_004d9df3                            # 004d9d90
    jmp.d8 L_004d9def                            # 004d9d95
L_004d9d97:
    # block 0x004d9d97: entered by je at 0x004d9d86, 3 instruction(s), ends with je to 0x004d9daf (forward)
    movsx ecx, word ptr [0x63a4cd]               # 004d9d97
    test ecx, ecx                                # 004d9d9e
    je.d8 L_004d9daf                             # 004d9da0
    # block 0x004d9da2: entered by fall-through of je at 0x004d9da0, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004d9daf
    push 0x55abe0                                # 004d9da2
    call FUN_0044a2b7                            # 004d9da7
    add esp, 0x4                                 # 004d9dac
L_004d9daf:
    # block 0x004d9daf: entered by je at 0x004d9da0, 9 instruction(s), calls FUN_004fb2a6, ends with je to 0x004d9de8 (forward)
    mov dx, word ptr [0x5b451f]                  # 004d9daf
    push edx                                     # 004d9db6
    push 0x5b452d                                # 004d9db7
    mov ecx, 0x5c3a67                            # 004d9dbc
    call FUN_004fb2a6                            # 004d9dc1
    mov dword ptr [0x5839a1], 0x2                # 004d9dc6
    movsx eax, word ptr [0x63a4cd]               # 004d9dd0
    test eax, eax                                # 004d9dd7
    je.d8 L_004d9de8                             # 004d9dd9
    # block 0x004d9ddb: entered by fall-through of je at 0x004d9dd9, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004d9de8
    push 0x55ac00                                # 004d9ddb
    call FUN_0044a2b7                            # 004d9de0
    add esp, 0x4                                 # 004d9de5
L_004d9de8:
    # block 0x004d9de8: entered by je at 0x004d9dd9, 1 instruction(s), ends with forward jump to 0x004d9def
    jmp.d8 L_004d9def                            # 004d9de8
L_004d9dea:
    # block 0x004d9dea: entered by je at 0x004d9d8c, 1 instruction(s), calls FUN_004da430, falls into the block at 0x004d9def
    call FUN_004da430                            # 004d9dea
L_004d9def:
    # block 0x004d9def: entered by jmp at 0x004d9d8e; jmp at 0x004d9d95; jmp at 0x004d9de8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d9def
    pop ebp                                      # 004d9df1
    ret                                          # 004d9df2

