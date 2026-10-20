# FUN_00487bd7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00487bd7
# extent:       0x00487bd7-0x00487c92 (187 code bytes)
# span:         0x00487bd7-0x00487c92 (code 187, tables 0, padding 0)
# sha256:       58b86a0a188933ee37469e8b850989e4a3bdab8c3460ef93a080cde0eb74336f
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_orderitems_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/487bd7.c.txt, not original source) refers to the data labelled s_Loaded_AT_ORDERITEMS_PUZZLE_acti_0054ddd0, s_for_SCENE__d__pData_for_ACTION_R_0054dd88
# name-note:    Allocates a fixed-size scene action-record buffer (SCENE pData for ACTION message on failure), copies the record in and logs Loaded AT_ORDERITEMS_PUZZLE.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x00487bd7 - 0x401000
.globl FUN_00487bd7
FUN_00487bd7:
    # block 0x00487bd7: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x00487c3e (forward)
    push ebp                                     # 00487bd7
    {load} mov ebp, esp                          # 00487bd8
    sub esp, 0x8                                 # 00487bda
    push esi                                     # 00487bdd
    push edi                                     # 00487bde
    mov dword ptr [ebp - local_8], ecx           # 00487bdf
    push 0x5b3                                   # 00487be2
    call FUN_0051dc43                            # 00487be7
    add esp, 0x4                                 # 00487bec
    mov dword ptr [ebp - local_4], eax           # 00487bef
    mov eax, dword ptr [ebp + arg_8]             # 00487bf2
    mov ecx, dword ptr [ebp - local_4]           # 00487bf5
    mov dword ptr [eax], ecx                     # 00487bf8
    cmp dword ptr [ebp - local_4], 0x0           # 00487bfa
    jne.d8 L_00487c3e                            # 00487bfe
    # block 0x00487c00: entered by fall-through of jne at 0x00487bfe, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00487c3e
    movsx edx, word ptr [0x5c39e3]               # 00487c00
    push edx                                     # 00487c07
    mov eax, dword ptr [0x5bb57b]                # 00487c08
    push eax                                     # 00487c0d
    push 0x54dd88                                # 00487c0e
    push 0x63888b                                # 00487c13
    call FUN_0050ca3e                            # 00487c18
    add esp, 0x10                                # 00487c1d
    push 0x63888b                                # 00487c20
    push 0x54ddb4                                # 00487c25
    mov ecx, 0x583979                            # 00487c2a
    call FUN_0042639d                            # 00487c2f
    mov ecx, 0x5cf659                            # 00487c34
    call FUN_004c97b4                            # 00487c39
L_00487c3e:
    # block 0x00487c3e: entered by jne at 0x00487bfe, 21 instruction(s), ends with je to 0x00487c8a (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 00487c3e
    mov esi, dword ptr [ecx]                     # 00487c41
    mov edx, dword ptr [ebp + arg_8]             # 00487c43
    mov edi, dword ptr [edx]                     # 00487c46
    mov ecx, 0x16c                               # 00487c48
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00487c4d
    movsw word ptr es:[edi], word ptr [esi]      # 00487c4f
    movsb byte ptr es:[edi], byte ptr [esi]      # 00487c51
    mov eax, dword ptr [ebp + arg_10]            # 00487c52
    mov ecx, dword ptr [eax]                     # 00487c55
    add ecx, 0x5b3                               # 00487c57
    mov edx, dword ptr [ebp + arg_10]            # 00487c5d
    mov dword ptr [edx], ecx                     # 00487c60
    mov eax, dword ptr [ebp + arg_c]             # 00487c62
    mov ecx, dword ptr [eax]                     # 00487c65
    add ecx, 0x5b3                               # 00487c67
    mov edx, dword ptr [ebp + arg_c]             # 00487c6d
    mov dword ptr [edx], ecx                     # 00487c70
    movsx eax, word ptr [0x63a4cd]               # 00487c72
    test eax, eax                                # 00487c79
    je.d8 L_00487c8a                             # 00487c7b
    # block 0x00487c7d: entered by fall-through of je at 0x00487c7b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00487c8a
    push 0x54ddd0                                # 00487c7d
    call FUN_0044a2b7                            # 00487c82
    add esp, 0x4                                 # 00487c87
L_00487c8a:
    # block 0x00487c8a: entered by je at 0x00487c7b, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 00487c8a
    pop esi                                      # 00487c8b
    {load} mov esp, ebp                          # 00487c8c
    pop ebp                                      # 00487c8e
    ret 0xc                                      # 00487c8f

