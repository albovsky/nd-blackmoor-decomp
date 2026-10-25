# FUN_0044cb7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044cb7d
# extent:       0x0044cb7d-0x0044cde2 (613 code bytes)
# span:         0x0044cb7d-0x0044cde2 (code 613, tables 0, padding 0)
# sha256:       ed3ccd8048c0f146f6a8b0bb90bccf1dd6d35175dce62f60ba8115da2dc89df1
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_primary_secondary_threads_killer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/44cb7d.c.txt, not original source) refers to the data labelled s_KillPriSecThreads_____done____0054950c, s_KillPriSecThreads_____killed_pCo_00549430
# name-note:    KillPriSecThreads: stops and deletes four thread objects one by one under their locks, logging each kill and the final done message.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       12 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20, local_24, local_28, local_2c, local_30
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044c479, FUN_00449a94, FUN_0044c4ab, FUN_0044a2b7; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 144 instruction(s), 13 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ local_24, 0x24  # offset -0x24
.equ local_28, 0x28  # offset -0x28
.equ local_2c, 0x2c  # offset -0x2c
.equ local_30, 0x30  # offset -0x30

# --- external targets -----------------------------------------------
.set FUN_00449a94, .text + (0x00449a94 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)

.org 0x0044cb7d - 0x401000
.globl FUN_0044cb7d
FUN_0044cb7d:
    # block 0x0044cb7d: entry, 5 instruction(s), ends with je to 0x0044cbfb (forward)
    push ebp                                     # 0044cb7d
    {load} mov ebp, esp                          # 0044cb7e
    sub esp, 0x30                                # 0044cb80
    cmp dword ptr [0x617e9a], 0x0                # 0044cb83
    je.d8 L_0044cbfb                             # 0044cb8a
    # block 0x0044cb8c: entered by fall-through of je at 0x0044cb8a, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x0044cbd3 (forward)
    push 0x617e80                                # 0044cb8c
    call FUN_0044c479                            # 0044cb91
    add esp, 0x4                                 # 0044cb96
    mov dword ptr [0x617e80], 0x2                # 0044cb99
    mov ecx, dword ptr [0x617e9a]                # 0044cba3
    call FUN_00449a94                            # 0044cba9
    mov eax, dword ptr [0x617e9a]                # 0044cbae
    mov dword ptr [ebp - local_8], eax           # 0044cbb3
    mov ecx, dword ptr [ebp - local_8]           # 0044cbb6
    mov dword ptr [ebp - local_4], ecx           # 0044cbb9
    cmp dword ptr [ebp - local_4], 0x0           # 0044cbbc
    je.d8 L_0044cbd3                             # 0044cbc0
    # block 0x0044cbc2: entered by fall-through of je at 0x0044cbc0, 7 instruction(s), calls indirect dword ptr [eax], ends with forward jump to 0x0044cbda
    push 0x1                                     # 0044cbc2
    mov edx, dword ptr [ebp - local_4]           # 0044cbc4
    mov eax, dword ptr [edx]                     # 0044cbc7
    mov ecx, dword ptr [ebp - local_4]           # 0044cbc9
    call dword ptr [eax]                         # 0044cbcc
    mov dword ptr [ebp - local_24], eax          # 0044cbce
    jmp.d8 L_0044cbda                            # 0044cbd1
L_0044cbd3:
    # block 0x0044cbd3: entered by je at 0x0044cbc0, 1 instruction(s), falls into the block at 0x0044cbda
    mov dword ptr [ebp - local_24], 0x0          # 0044cbd3
L_0044cbda:
    # block 0x0044cbda: entered by jmp at 0x0044cbd1, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0044cbfb
    mov dword ptr [0x617e9a], 0x0                # 0044cbda
    push 0x617e80                                # 0044cbe4
    call FUN_0044c4ab                            # 0044cbe9
    add esp, 0x4                                 # 0044cbee
    mov dword ptr [0x617e80], 0x0                # 0044cbf1
L_0044cbfb:
    # block 0x0044cbfb: entered by je at 0x0044cb8a, 3 instruction(s), ends with je to 0x0044cc13 (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0044cbfb
    test ecx, ecx                                # 0044cc02
    je.d8 L_0044cc13                             # 0044cc04
    # block 0x0044cc06: entered by fall-through of je at 0x0044cc04, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044cc13
    push 0x549430                                # 0044cc06
    call FUN_0044a2b7                            # 0044cc0b
    add esp, 0x4                                 # 0044cc10
L_0044cc13:
    # block 0x0044cc13: entered by je at 0x0044cc04, 2 instruction(s), ends with je to 0x0044cc8c (forward)
    cmp dword ptr [0x5b4e0c], 0x0                # 0044cc13
    je.d8 L_0044cc8c                             # 0044cc1a
    # block 0x0044cc1c: entered by fall-through of je at 0x0044cc1a, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x0044cc64 (forward)
    push 0x5b4c3a                                # 0044cc1c
    call FUN_0044c479                            # 0044cc21
    add esp, 0x4                                 # 0044cc26
    mov dword ptr [0x5b4c3a], 0x2                # 0044cc29
    mov ecx, dword ptr [0x5b4e0c]                # 0044cc33
    call FUN_00449a94                            # 0044cc39
    mov edx, dword ptr [0x5b4e0c]                # 0044cc3e
    mov dword ptr [ebp - local_10], edx          # 0044cc44
    mov eax, dword ptr [ebp - local_10]          # 0044cc47
    mov dword ptr [ebp - local_c], eax           # 0044cc4a
    cmp dword ptr [ebp - local_c], 0x0           # 0044cc4d
    je.d8 L_0044cc64                             # 0044cc51
    # block 0x0044cc53: entered by fall-through of je at 0x0044cc51, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x0044cc6b
    push 0x1                                     # 0044cc53
    mov ecx, dword ptr [ebp - local_c]           # 0044cc55
    mov edx, dword ptr [ecx]                     # 0044cc58
    mov ecx, dword ptr [ebp - local_c]           # 0044cc5a
    call dword ptr [edx]                         # 0044cc5d
    mov dword ptr [ebp - local_28], eax          # 0044cc5f
    jmp.d8 L_0044cc6b                            # 0044cc62
L_0044cc64:
    # block 0x0044cc64: entered by je at 0x0044cc51, 1 instruction(s), falls into the block at 0x0044cc6b
    mov dword ptr [ebp - local_28], 0x0          # 0044cc64
L_0044cc6b:
    # block 0x0044cc6b: entered by jmp at 0x0044cc62, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0044cc8c
    mov dword ptr [0x5b4e0c], 0x0                # 0044cc6b
    push 0x5b4c3a                                # 0044cc75
    call FUN_0044c4ab                            # 0044cc7a
    add esp, 0x4                                 # 0044cc7f
    mov dword ptr [0x5b4c3a], 0x0                # 0044cc82
L_0044cc8c:
    # block 0x0044cc8c: entered by je at 0x0044cc1a, 3 instruction(s), ends with je to 0x0044cca4 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044cc8c
    test eax, eax                                # 0044cc93
    je.d8 L_0044cca4                             # 0044cc95
    # block 0x0044cc97: entered by fall-through of je at 0x0044cc95, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044cca4
    push 0x549468                                # 0044cc97
    call FUN_0044a2b7                            # 0044cc9c
    add esp, 0x4                                 # 0044cca1
L_0044cca4:
    # block 0x0044cca4: entered by je at 0x0044cc95, 2 instruction(s), ends with je to 0x0044cd1d (forward)
    cmp dword ptr [0x5b5083], 0x0                # 0044cca4
    je.d8 L_0044cd1d                             # 0044ccab
    # block 0x0044ccad: entered by fall-through of je at 0x0044ccab, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x0044ccf5 (forward)
    push 0x5b4eb1                                # 0044ccad
    call FUN_0044c479                            # 0044ccb2
    add esp, 0x4                                 # 0044ccb7
    mov dword ptr [0x5b4eb1], 0x2                # 0044ccba
    mov ecx, dword ptr [0x5b5083]                # 0044ccc4
    call FUN_00449a94                            # 0044ccca
    mov ecx, dword ptr [0x5b5083]                # 0044cccf
    mov dword ptr [ebp - local_18], ecx          # 0044ccd5
    mov edx, dword ptr [ebp - local_18]          # 0044ccd8
    mov dword ptr [ebp - local_14], edx          # 0044ccdb
    cmp dword ptr [ebp - local_14], 0x0          # 0044ccde
    je.d8 L_0044ccf5                             # 0044cce2
    # block 0x0044cce4: entered by fall-through of je at 0x0044cce2, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x0044ccfc
    push 0x1                                     # 0044cce4
    mov eax, dword ptr [ebp - local_14]          # 0044cce6
    mov edx, dword ptr [eax]                     # 0044cce9
    mov ecx, dword ptr [ebp - local_14]          # 0044cceb
    call dword ptr [edx]                         # 0044ccee
    mov dword ptr [ebp - local_2c], eax          # 0044ccf0
    jmp.d8 L_0044ccfc                            # 0044ccf3
L_0044ccf5:
    # block 0x0044ccf5: entered by je at 0x0044cce2, 1 instruction(s), falls into the block at 0x0044ccfc
    mov dword ptr [ebp - local_2c], 0x0          # 0044ccf5
L_0044ccfc:
    # block 0x0044ccfc: entered by jmp at 0x0044ccf3, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0044cd1d
    mov dword ptr [0x5b5083], 0x0                # 0044ccfc
    push 0x5b4eb1                                # 0044cd06
    call FUN_0044c4ab                            # 0044cd0b
    add esp, 0x4                                 # 0044cd10
    mov dword ptr [0x5b4eb1], 0x0                # 0044cd13
L_0044cd1d:
    # block 0x0044cd1d: entered by je at 0x0044ccab, 3 instruction(s), ends with je to 0x0044cd35 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044cd1d
    test eax, eax                                # 0044cd24
    je.d8 L_0044cd35                             # 0044cd26
    # block 0x0044cd28: entered by fall-through of je at 0x0044cd26, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044cd35
    push 0x5494a0                                # 0044cd28
    call FUN_0044a2b7                            # 0044cd2d
    add esp, 0x4                                 # 0044cd32
L_0044cd35:
    # block 0x0044cd35: entered by je at 0x0044cd26, 2 instruction(s), ends with je to 0x0044cdae (forward)
    cmp dword ptr [0x6381a5], 0x0                # 0044cd35
    je.d8 L_0044cdae                             # 0044cd3c
    # block 0x0044cd3e: entered by fall-through of je at 0x0044cd3c, 12 instruction(s), calls FUN_0044c479, FUN_00449a94, ends with je to 0x0044cd86 (forward)
    push 0x637fd3                                # 0044cd3e
    call FUN_0044c479                            # 0044cd43
    add esp, 0x4                                 # 0044cd48
    mov dword ptr [0x637fd3], 0x2                # 0044cd4b
    mov ecx, dword ptr [0x6381a5]                # 0044cd55
    call FUN_00449a94                            # 0044cd5b
    mov ecx, dword ptr [0x6381a5]                # 0044cd60
    mov dword ptr [ebp - local_20], ecx          # 0044cd66
    mov edx, dword ptr [ebp - local_20]          # 0044cd69
    mov dword ptr [ebp - local_1c], edx          # 0044cd6c
    cmp dword ptr [ebp - local_1c], 0x0          # 0044cd6f
    je.d8 L_0044cd86                             # 0044cd73
    # block 0x0044cd75: entered by fall-through of je at 0x0044cd73, 7 instruction(s), calls indirect dword ptr [edx], ends with forward jump to 0x0044cd8d
    push 0x1                                     # 0044cd75
    mov eax, dword ptr [ebp - local_1c]          # 0044cd77
    mov edx, dword ptr [eax]                     # 0044cd7a
    mov ecx, dword ptr [ebp - local_1c]          # 0044cd7c
    call dword ptr [edx]                         # 0044cd7f
    mov dword ptr [ebp - local_30], eax          # 0044cd81
    jmp.d8 L_0044cd8d                            # 0044cd84
L_0044cd86:
    # block 0x0044cd86: entered by je at 0x0044cd73, 1 instruction(s), falls into the block at 0x0044cd8d
    mov dword ptr [ebp - local_30], 0x0          # 0044cd86
L_0044cd8d:
    # block 0x0044cd8d: entered by jmp at 0x0044cd84, 5 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0044cdae
    mov dword ptr [0x6381a5], 0x0                # 0044cd8d
    push 0x637fd3                                # 0044cd97
    call FUN_0044c4ab                            # 0044cd9c
    add esp, 0x4                                 # 0044cda1
    mov dword ptr [0x637fd3], 0x0                # 0044cda4
L_0044cdae:
    # block 0x0044cdae: entered by je at 0x0044cd3c, 3 instruction(s), ends with je to 0x0044cdc6 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0044cdae
    test eax, eax                                # 0044cdb5
    je.d8 L_0044cdc6                             # 0044cdb7
    # block 0x0044cdb9: entered by fall-through of je at 0x0044cdb7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044cdc6
    push 0x5494d8                                # 0044cdb9
    call FUN_0044a2b7                            # 0044cdbe
    add esp, 0x4                                 # 0044cdc3
L_0044cdc6:
    # block 0x0044cdc6: entered by je at 0x0044cdb7, 3 instruction(s), ends with je to 0x0044cdde (forward)
    movsx ecx, word ptr [0x63a4cd]               # 0044cdc6
    test ecx, ecx                                # 0044cdcd
    je.d8 L_0044cdde                             # 0044cdcf
    # block 0x0044cdd1: entered by fall-through of je at 0x0044cdcf, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044cdde
    push 0x54950c                                # 0044cdd1
    call FUN_0044a2b7                            # 0044cdd6
    add esp, 0x4                                 # 0044cddb
L_0044cdde:
    # block 0x0044cdde: entered by je at 0x0044cdcf, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044cdde
    pop ebp                                      # 0044cde0
    ret                                          # 0044cde1

