# FUN_004b3ddf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3ddf
# extent:       0x004b3ddf-0x004b3e99 (186 code bytes)
# span:         0x004b3ddf-0x004b3e99 (code 186, tables 0, padding 0)
# sha256:       6c262a2cfbb8d344aa921051789108eb0f1cf46ef691e9d003039d4347ac0e22
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_tower_puzzle_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4b3ddf.c.txt, not original source) refers to the data labelled s_Loaded_AT_TOWER_PUZZLE_action_re_00551928, s_Unable_to_allocate_memory_0055190c
# name-note:    Allocates and copies a TOWER_PUZZLE action record from scene data, aborting with 'Unable to allocate memory' on failure; the Loaded AT string names the action.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x004b3ddf - 0x401000
.globl FUN_004b3ddf
FUN_004b3ddf:
    # block 0x004b3ddf: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004b3e46 (forward)
    push ebp                                     # 004b3ddf
    {load} mov ebp, esp                          # 004b3de0
    sub esp, 0x8                                 # 004b3de2
    push esi                                     # 004b3de5
    push edi                                     # 004b3de6
    mov dword ptr [ebp - local_8], ecx           # 004b3de7
    push 0x8ae                                   # 004b3dea
    call FUN_0051dc43                            # 004b3def
    add esp, 0x4                                 # 004b3df4
    mov dword ptr [ebp - local_4], eax           # 004b3df7
    mov eax, dword ptr [ebp + arg_8]             # 004b3dfa
    mov ecx, dword ptr [ebp - local_4]           # 004b3dfd
    mov dword ptr [eax], ecx                     # 004b3e00
    cmp dword ptr [ebp - local_4], 0x0           # 004b3e02
    jne.d8 L_004b3e46                            # 004b3e06
    # block 0x004b3e08: entered by fall-through of jne at 0x004b3e06, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004b3e46
    movsx edx, word ptr [0x5c39e3]               # 004b3e08
    push edx                                     # 004b3e0f
    mov eax, dword ptr [0x5bb57b]                # 004b3e10
    push eax                                     # 004b3e15
    push 0x5518e0                                # 004b3e16
    push 0x63888b                                # 004b3e1b
    call FUN_0050ca3e                            # 004b3e20
    add esp, 0x10                                # 004b3e25
    push 0x63888b                                # 004b3e28
    push 0x55190c                                # 004b3e2d
    mov ecx, 0x583979                            # 004b3e32
    call FUN_0042639d                            # 004b3e37
    mov ecx, 0x5cf659                            # 004b3e3c
    call FUN_004c97b4                            # 004b3e41
L_004b3e46:
    # block 0x004b3e46: entered by jne at 0x004b3e06, 20 instruction(s), ends with je to 0x004b3e91 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004b3e46
    mov esi, dword ptr [ecx]                     # 004b3e49
    mov edx, dword ptr [ebp + arg_8]             # 004b3e4b
    mov edi, dword ptr [edx]                     # 004b3e4e
    mov ecx, 0x22b                               # 004b3e50
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b3e55
    movsw word ptr es:[edi], word ptr [esi]      # 004b3e57
    mov eax, dword ptr [ebp + arg_10]            # 004b3e59
    mov ecx, dword ptr [eax]                     # 004b3e5c
    add ecx, 0x8ae                               # 004b3e5e
    mov edx, dword ptr [ebp + arg_10]            # 004b3e64
    mov dword ptr [edx], ecx                     # 004b3e67
    mov eax, dword ptr [ebp + arg_c]             # 004b3e69
    mov ecx, dword ptr [eax]                     # 004b3e6c
    add ecx, 0x8ae                               # 004b3e6e
    mov edx, dword ptr [ebp + arg_c]             # 004b3e74
    mov dword ptr [edx], ecx                     # 004b3e77
    movsx eax, word ptr [0x63a4cd]               # 004b3e79
    test eax, eax                                # 004b3e80
    je.d8 L_004b3e91                             # 004b3e82
    # block 0x004b3e84: entered by fall-through of je at 0x004b3e82, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004b3e91
    push 0x551928                                # 004b3e84
    call FUN_0044a2b7                            # 004b3e89
    add esp, 0x4                                 # 004b3e8e
L_004b3e91:
    # block 0x004b3e91: entered by je at 0x004b3e82, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004b3e91
    pop esi                                      # 004b3e92
    {load} mov esp, ebp                          # 004b3e93
    pop ebp                                      # 004b3e95
    ret 0xc                                      # 004b3e96

