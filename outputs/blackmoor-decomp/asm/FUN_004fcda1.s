# FUN_004fcda1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fcda1
# extent:       0x004fcda1-0x004fce5e (189 code bytes)
# span:         0x004fcda1-0x004fce5e (code 189, tables 0, padding 0)
# sha256:       fbb7cb938dc3e123724e230f07623b7f2b6192c562beb85ed86cd58e6b6860f8
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_update_3d_sound_action_loader
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4fcda1.c.txt, not original source) refers to the data labelled s_Loaded_AT_UPDATE_3D_SOUND_action_00560a38, s_Unable_to_allocate_memory_00560a1c
# name-note:    Allocates and copies a UPDATE_3D_SOUND action record from scene data, aborting with 'Unable to allocate memory' on failure; the Loaded AT string names the action.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 59 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
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

.org 0x004fcda1 - 0x401000
.globl FUN_004fcda1
FUN_004fcda1:
    # block 0x004fcda1: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004fce11 (forward)
    push ebp                                     # 004fcda1
    {load} mov ebp, esp                          # 004fcda2
    sub esp, 0x8                                 # 004fcda4
    push esi                                     # 004fcda7
    push edi                                     # 004fcda8
    mov dword ptr [ebp - local_8], ecx           # 004fcda9
    push 0x16                                    # 004fcdac
    call FUN_0051dc43                            # 004fcdae
    add esp, 0x4                                 # 004fcdb3
    mov dword ptr [ebp - local_4], eax           # 004fcdb6
    mov eax, dword ptr [ebp + arg_8]             # 004fcdb9
    mov ecx, dword ptr [ebp - local_4]           # 004fcdbc
    mov dword ptr [eax], ecx                     # 004fcdbf
    cmp dword ptr [ebp - local_4], 0x0           # 004fcdc1
    jne.d8 L_004fce11                            # 004fcdc5
    # block 0x004fcdc7: entered by fall-through of jne at 0x004fcdc5, 16 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004fce56
    movsx edx, word ptr [0x5c39e3]               # 004fcdc7
    push edx                                     # 004fcdce
    mov eax, dword ptr [0x5bb57b]                # 004fcdcf
    push eax                                     # 004fcdd4
    push 0x5609f0                                # 004fcdd5
    push 0x63888b                                # 004fcdda
    call FUN_0050ca3e                            # 004fcddf
    add esp, 0x10                                # 004fcde4
    push 0x63888b                                # 004fcde7
    push 0x560a1c                                # 004fcdec
    mov ecx, 0x583979                            # 004fcdf1
    call FUN_0042639d                            # 004fcdf6
    mov dword ptr [0x63a58a], 0x5                # 004fcdfb
    mov ecx, 0x5cf659                            # 004fce05
    call FUN_004c97b4                            # 004fce0a
    jmp.d8 L_004fce56                            # 004fce0f
L_004fce11:
    # block 0x004fce11: entered by jne at 0x004fcdc5, 20 instruction(s), ends with je to 0x004fce56 (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004fce11
    mov esi, dword ptr [ecx]                     # 004fce14
    mov edx, dword ptr [ebp + arg_8]             # 004fce16
    mov edi, dword ptr [edx]                     # 004fce19
    mov ecx, 0x5                                 # 004fce1b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004fce20
    movsw word ptr es:[edi], word ptr [esi]      # 004fce22
    mov eax, dword ptr [ebp + arg_10]            # 004fce24
    mov ecx, dword ptr [eax]                     # 004fce27
    add ecx, 0x16                                # 004fce29
    mov edx, dword ptr [ebp + arg_10]            # 004fce2c
    mov dword ptr [edx], ecx                     # 004fce2f
    mov eax, dword ptr [ebp + arg_c]             # 004fce31
    mov ecx, dword ptr [eax]                     # 004fce34
    add ecx, 0x16                                # 004fce36
    mov edx, dword ptr [ebp + arg_c]             # 004fce39
    mov dword ptr [edx], ecx                     # 004fce3c
    movsx eax, word ptr [0x63a4cd]               # 004fce3e
    test eax, eax                                # 004fce45
    je.d8 L_004fce56                             # 004fce47
    # block 0x004fce49: entered by fall-through of je at 0x004fce47, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fce56
    push 0x560a38                                # 004fce49
    call FUN_0044a2b7                            # 004fce4e
    add esp, 0x4                                 # 004fce53
L_004fce56:
    # block 0x004fce56: entered by jmp at 0x004fce0f; je at 0x004fce47, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004fce56
    pop esi                                      # 004fce57
    {load} mov esp, ebp                          # 004fce58
    pop ebp                                      # 004fce5a
    ret 0xc                                      # 004fce5b

