# FUN_0044cde2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044cde2
# extent:       0x0044cde2-0x0044cf01 (287 code bytes)
# span:         0x0044cde2-0x0044cf01 (code 287, tables 0, padding 0)
# sha256:       9214383339341af5d603e5c4481117f7830ce587c50391d1263e8eb3e89dd563
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044cde2
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; no ret instruction in the code part; ecx is not read in the entry block before being written
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044c479, FUN_0051dc6c, FUN_00415176, FUN_0044c4ab, KERNEL32.dll!Sleep, FUN_0051ec84
# track-n:      outputs/blackmoor-decomp/src/avf_player.c:avf_player_worker_poll (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00415176, .text + (0x00415176 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051ec84, .text + (0x0051ec84 - 0x401000)

.org 0x0044cde2 - 0x401000
.globl FUN_0044cde2
FUN_0044cde2:
    # block 0x0044cde2: entry, 5 instruction(s), falls into the block at 0x0044cdee
    push ebp                                     # 0044cde2
    {load} mov ebp, esp                          # 0044cde3
    sub esp, 0xc                                 # 0044cde5
    mov eax, dword ptr [ebp + arg_8]             # 0044cde8
    mov dword ptr [ebp - local_4], eax           # 0044cdeb
L_0044cdee:
    # block 0x0044cdee: entered by jmp at 0x0044ceef, 3 instruction(s), ends with je to 0x0044cef4 (forward)
    mov ecx, 0x1                                 # 0044cdee
    test ecx, ecx                                # 0044cdf3
    je.d32 L_0044cef4                            # 0044cdf5
    # block 0x0044cdfb: entered by fall-through of je at 0x0044cdf5, 3 instruction(s), ends with je to 0x0044ce08 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0044cdfb
    cmp dword ptr [edx], 0x0                     # 0044cdfe
    je.d8 L_0044ce08                             # 0044ce01
    # block 0x0044ce03: entered by fall-through of je at 0x0044ce01, 1 instruction(s), ends with forward jump to 0x0044cef4
    jmp.d32 L_0044cef4                           # 0044ce03
L_0044ce08:
    # block 0x0044ce08: entered by je at 0x0044ce01, 3 instruction(s), ends with je to 0x0044ce18 (forward)
    movsx eax, word ptr [0x5b4e0a]               # 0044ce08
    test eax, eax                                # 0044ce0f
    je.d8 L_0044ce18                             # 0044ce11
    # block 0x0044ce13: entered by fall-through of je at 0x0044ce11, 1 instruction(s), ends with forward jump to 0x0044ceff
    jmp.d32 L_0044ceff                           # 0044ce13
L_0044ce18:
    # block 0x0044ce18: entered by je at 0x0044ce11, 6 instruction(s), calls FUN_0044c479, ends with jne to 0x0044ce32 (forward)
    push 0x5b4c3a                                # 0044ce18
    call FUN_0044c479                            # 0044ce1d
    add esp, 0x4                                 # 0044ce22
    movsx ecx, ax                                # 0044ce25
    cmp ecx, 0x2                                 # 0044ce28
    jne.d8 L_0044ce32                            # 0044ce2b
    # block 0x0044ce2d: entered by fall-through of jne at 0x0044ce2b, 1 instruction(s), ends with forward jump to 0x0044cefd
    jmp.d32 L_0044cefd                           # 0044ce2d
L_0044ce32:
    # block 0x0044ce32: entered by jne at 0x0044ce2b, 3 instruction(s), ends with jne to 0x0044ce88 (forward)
    movsx edx, word ptr [0x5b4dc8]               # 0044ce32
    test edx, edx                                # 0044ce39
    jne.d8 L_0044ce88                            # 0044ce3b
    # block 0x0044ce3d: entered by fall-through of jne at 0x0044ce3b, 2 instruction(s), ends with je to 0x0044ce64 (forward)
    cmp dword ptr [0x5b4dbc], 0x0                # 0044ce3d
    je.d8 L_0044ce64                             # 0044ce44
    # block 0x0044ce46: entered by fall-through of je at 0x0044ce44, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044ce64
    mov eax, dword ptr [0x5b4dbc]                # 0044ce46
    mov dword ptr [ebp - local_8], eax           # 0044ce4b
    mov ecx, dword ptr [ebp - local_8]           # 0044ce4e
    push ecx                                     # 0044ce51
    call FUN_0051dc6c                            # 0044ce52
    add esp, 0x4                                 # 0044ce57
    mov dword ptr [0x5b4dbc], 0x0                # 0044ce5a
L_0044ce64:
    # block 0x0044ce64: entered by je at 0x0044ce44, 10 instruction(s), calls FUN_00415176, ends with forward jump to 0x0044ced1
    push 0x0                                     # 0044ce64
    push 0x0                                     # 0044ce66
    push 0x0                                     # 0044ce68
    mov dx, word ptr [0x5b4e00]                  # 0044ce6a
    push edx                                     # 0044ce71
    push 0x5b4c3e                                # 0044ce72
    mov ecx, 0x5e2dbe                            # 0044ce77
    call FUN_00415176                            # 0044ce7c
    mov dword ptr [0x5b4dbc], eax                # 0044ce81
    jmp.d8 L_0044ced1                            # 0044ce86
L_0044ce88:
    # block 0x0044ce88: entered by jne at 0x0044ce3b, 2 instruction(s), ends with je to 0x0044ceaf (forward)
    cmp dword ptr [0x5b4db8], 0x0                # 0044ce88
    je.d8 L_0044ceaf                             # 0044ce8f
    # block 0x0044ce91: entered by fall-through of je at 0x0044ce8f, 7 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0044ceaf
    mov eax, dword ptr [0x5b4db8]                # 0044ce91
    mov dword ptr [ebp - local_c], eax           # 0044ce96
    mov ecx, dword ptr [ebp - local_c]           # 0044ce99
    push ecx                                     # 0044ce9c
    call FUN_0051dc6c                            # 0044ce9d
    add esp, 0x4                                 # 0044cea2
    mov dword ptr [0x5b4db8], 0x0                # 0044cea5
L_0044ceaf:
    # block 0x0044ceaf: entered by je at 0x0044ce8f, 9 instruction(s), calls FUN_00415176, falls into the block at 0x0044ced1
    push 0x0                                     # 0044ceaf
    push 0x0                                     # 0044ceb1
    push 0x0                                     # 0044ceb3
    mov dx, word ptr [0x5b4e00]                  # 0044ceb5
    push edx                                     # 0044cebc
    push 0x5b4c3e                                # 0044cebd
    mov ecx, 0x5e2dbe                            # 0044cec2
    call FUN_00415176                            # 0044cec7
    mov dword ptr [0x5b4db8], eax                # 0044cecc
L_0044ced1:
    # block 0x0044ced1: entered by jmp at 0x0044ce86, 4 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0044cee7
    push 0x5b4c3a                                # 0044ced1
    call FUN_0044c4ab                            # 0044ced6
    add esp, 0x4                                 # 0044cedb
    mov word ptr [0x5b4e0a], 0x1                 # 0044cede
L_0044cee7:
    # block 0x0044cee7: entered by jmp at 0x0044cefd; jmp at 0x0044ceff, 3 instruction(s), calls KERNEL32.dll!Sleep, ends with backward jump to 0x0044cdee
    push 0x1                                     # 0044cee7
    call dword ptr [0x52a2b0]                    # 0044cee9
    jmp.d32 L_0044cdee                           # 0044ceef
L_0044cef4:
    # block 0x0044cef4: entered by je at 0x0044cdf5; jmp at 0x0044ce03, 3 instruction(s), calls FUN_0051ec84, falls into the block at 0x0044cefd
    push 0x1                                     # 0044cef4
    push 0x0                                     # 0044cef6
    call FUN_0051ec84                            # 0044cef8
L_0044cefd:
    # block 0x0044cefd: entered by jmp at 0x0044ce2d, 1 instruction(s), ends with backward jump to 0x0044cee7
    jmp.d8 L_0044cee7                            # 0044cefd
L_0044ceff:
    # block 0x0044ceff: entered by jmp at 0x0044ce13, 1 instruction(s), ends with backward jump to 0x0044cee7
    jmp.d8 L_0044cee7                            # 0044ceff

