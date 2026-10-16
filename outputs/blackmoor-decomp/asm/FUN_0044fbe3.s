# FUN_0044fbe3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044fbe3
# extent:       0x0044fbe3-0x0044fc9b (184 code bytes)
# span:         0x0044fbe3-0x0044fc9b (code 184, tables 0, padding 0)
# sha256:       3baf723d765bb565083b6d65206fbcf6248cc4a475238b151d2225ffe539e791
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044fbe3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0044fbe3 - 0x401000
.globl FUN_0044fbe3
FUN_0044fbe3:
    # block 0x0044fbe3: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0044fc4a (forward)
    push ebp                                     # 0044fbe3
    {load} mov ebp, esp                          # 0044fbe4
    sub esp, 0x8                                 # 0044fbe6
    push esi                                     # 0044fbe9
    push edi                                     # 0044fbea
    mov dword ptr [ebp - local_8], ecx           # 0044fbeb
    push 0x4e8                                   # 0044fbee
    call FUN_0051dc43                            # 0044fbf3
    add esp, 0x4                                 # 0044fbf8
    mov dword ptr [ebp - local_4], eax           # 0044fbfb
    mov eax, dword ptr [ebp + arg_8]             # 0044fbfe
    mov ecx, dword ptr [ebp - local_4]           # 0044fc01
    mov dword ptr [eax], ecx                     # 0044fc04
    cmp dword ptr [ebp - local_4], 0x0           # 0044fc06
    jne.d8 L_0044fc4a                            # 0044fc0a
    # block 0x0044fc0c: entered by fall-through of jne at 0x0044fc0a, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x0044fc4a
    movsx edx, word ptr [0x5c39e3]               # 0044fc0c
    push edx                                     # 0044fc13
    mov eax, dword ptr [0x5bb57b]                # 0044fc14
    push eax                                     # 0044fc19
    push 0x54991c                                # 0044fc1a
    push 0x63888b                                # 0044fc1f
    call FUN_0050ca3e                            # 0044fc24
    add esp, 0x10                                # 0044fc29
    push 0x63888b                                # 0044fc2c
    push 0x549948                                # 0044fc31
    mov ecx, 0x583979                            # 0044fc36
    call FUN_0042639d                            # 0044fc3b
    mov ecx, 0x5cf659                            # 0044fc40
    call FUN_004c97b4                            # 0044fc45
L_0044fc4a:
    # block 0x0044fc4a: entered by jne at 0x0044fc0a, 19 instruction(s), ends with je to 0x0044fc93 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 0044fc4a
    mov esi, dword ptr [ecx]                     # 0044fc4d
    mov edx, dword ptr [ebp + arg_8]             # 0044fc4f
    mov edi, dword ptr [edx]                     # 0044fc52
    mov ecx, 0x13a                               # 0044fc54
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0044fc59
    mov eax, dword ptr [ebp + arg_10]            # 0044fc5b
    mov ecx, dword ptr [eax]                     # 0044fc5e
    add ecx, 0x4e8                               # 0044fc60
    mov edx, dword ptr [ebp + arg_10]            # 0044fc66
    mov dword ptr [edx], ecx                     # 0044fc69
    mov eax, dword ptr [ebp + arg_c]             # 0044fc6b
    mov ecx, dword ptr [eax]                     # 0044fc6e
    add ecx, 0x4e8                               # 0044fc70
    mov edx, dword ptr [ebp + arg_c]             # 0044fc76
    mov dword ptr [edx], ecx                     # 0044fc79
    movsx eax, word ptr [0x63a4cd]               # 0044fc7b
    test eax, eax                                # 0044fc82
    je.d8 L_0044fc93                             # 0044fc84
    # block 0x0044fc86: entered by fall-through of je at 0x0044fc84, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0044fc93
    push 0x549964                                # 0044fc86
    call FUN_0044a2b7                            # 0044fc8b
    add esp, 0x4                                 # 0044fc90
L_0044fc93:
    # block 0x0044fc93: entered by je at 0x0044fc84, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 0044fc93
    pop esi                                      # 0044fc94
    {load} mov esp, ebp                          # 0044fc95
    pop ebp                                      # 0044fc97
    ret 0xc                                      # 0044fc98

