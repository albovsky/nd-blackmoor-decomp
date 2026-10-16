# FUN_004e9add
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e9add
# extent:       0x004e9add-0x004e9b87 (170 code bytes)
# span:         0x004e9add-0x004e9b87 (code 170, tables 0, padding 0)
# sha256:       6b4e9e91064d62efa10f6c7a9980648dd825b4b678a1e815347eea8175be91d2
# evidence:     ev_e9c656b3eec0deb5a709812e8ef40c0b3c5e683a3969dfdbc8ffe3dad08e63a8
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e9add
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 52 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x004e9add - 0x401000
.globl FUN_004e9add
FUN_004e9add:
    # block 0x004e9add: entry, 13 instruction(s), calls FUN_0051dc43, ends with jne to 0x004e9b3f (forward)
    push ebp                                     # 004e9add
    {load} mov ebp, esp                          # 004e9ade
    sub esp, 0x8                                 # 004e9ae0
    mov dword ptr [ebp - local_8], ecx           # 004e9ae3
    push 0x2                                     # 004e9ae6
    call FUN_0051dc43                            # 004e9ae8
    add esp, 0x4                                 # 004e9aed
    mov dword ptr [ebp - local_4], eax           # 004e9af0
    mov eax, dword ptr [ebp + arg_8]             # 004e9af3
    mov ecx, dword ptr [ebp - local_4]           # 004e9af6
    mov dword ptr [eax], ecx                     # 004e9af9
    cmp dword ptr [ebp - local_4], 0x0           # 004e9afb
    jne.d8 L_004e9b3f                            # 004e9aff
    # block 0x004e9b01: entered by fall-through of jne at 0x004e9aff, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004e9b3f
    movsx edx, word ptr [0x5c39e3]               # 004e9b01
    push edx                                     # 004e9b08
    mov eax, dword ptr [0x5bb57b]                # 004e9b09
    push eax                                     # 004e9b0e
    push 0x55c834                                # 004e9b0f
    push 0x63888b                                # 004e9b14
    call FUN_0050ca3e                            # 004e9b19
    add esp, 0x10                                # 004e9b1e
    push 0x63888b                                # 004e9b21
    push 0x55c860                                # 004e9b26
    mov ecx, 0x583979                            # 004e9b2b
    call FUN_0042639d                            # 004e9b30
    mov ecx, 0x5cf659                            # 004e9b35
    call FUN_004c97b4                            # 004e9b3a
L_004e9b3f:
    # block 0x004e9b3f: entered by jne at 0x004e9aff, 19 instruction(s), ends with je to 0x004e9b81 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004e9b3f
    mov edx, dword ptr [ecx]                     # 004e9b42
    mov eax, dword ptr [ebp + arg_8]             # 004e9b44
    mov ecx, dword ptr [eax]                     # 004e9b47
    mov dx, word ptr [edx]                       # 004e9b49
    mov word ptr [ecx], dx                       # 004e9b4c
    mov eax, dword ptr [ebp + arg_10]            # 004e9b4f
    mov ecx, dword ptr [eax]                     # 004e9b52
    add ecx, 0x2                                 # 004e9b54
    mov edx, dword ptr [ebp + arg_10]            # 004e9b57
    mov dword ptr [edx], ecx                     # 004e9b5a
    mov eax, dword ptr [ebp + arg_c]             # 004e9b5c
    mov ecx, dword ptr [eax]                     # 004e9b5f
    add ecx, 0x2                                 # 004e9b61
    mov edx, dword ptr [ebp + arg_c]             # 004e9b64
    mov dword ptr [edx], ecx                     # 004e9b67
    movsx eax, word ptr [0x63a4cd]               # 004e9b69
    test eax, eax                                # 004e9b70
    je.d8 L_004e9b81                             # 004e9b72
    # block 0x004e9b74: entered by fall-through of je at 0x004e9b72, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004e9b81
    push 0x55c87c                                # 004e9b74
    call FUN_0044a2b7                            # 004e9b79
    add esp, 0x4                                 # 004e9b7e
L_004e9b81:
    # block 0x004e9b81: entered by je at 0x004e9b72, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004e9b81
    pop ebp                                      # 004e9b83
    ret 0xc                                      # 004e9b84

