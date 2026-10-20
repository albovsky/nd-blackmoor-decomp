# FUN_004a7a29
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a7a29
# extent:       0x004a7a29-0x004a7b5f (310 code bytes)
# span:         0x004a7a29-0x004a7b60 (code 310, tables 0, padding 1)
# sha256:       2ce9b3f2cccbffd5ff3a26a90e0e9e8798d8f9f8f886e9a25624693b14c12e98
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_safedial_overlay_renderer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a7a29.c.txt, not original source) refers to the data labelled s_SafeDial_Puzzle_Reset_Overlay_00550ad8, s_SafeDial_Puzzle_Set_Arrow_Down_00550a98
# name-note:    Redraws the SafeDial puzzle: background dial then Set Arrow Down/Up, Reset Overlay or Reset Spinning overlay depending on state.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004a7994, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 80 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004a7994, .text + (0x004a7994 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004a7a29 - 0x401000
.globl FUN_004a7a29
FUN_004a7a29:
    # block 0x004a7a29: entry, 11 instruction(s), ends with je to 0x004a7a58 (forward)
    push ebp                                     # 004a7a29
    {load} mov ebp, esp                          # 004a7a2a
    push ecx                                     # 004a7a2c
    movsx eax, word ptr [0x61d3bf]               # 004a7a2d
    imul eax, eax, 0x8d                          # 004a7a34
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a7a3a
    mov dword ptr [ebp - local_4], ecx           # 004a7a40
    {load} xor edx, edx                          # 004a7a43
    mov dl, byte ptr [0x61d3cd]                  # 004a7a45
    test edx, edx                                # 004a7a4b
    je.d8 L_004a7a58                             # 004a7a4d
    # block 0x004a7a4f: entered by fall-through of je at 0x004a7a4d, 2 instruction(s), ends with je to 0x004a7a62 (forward)
    cmp dword ptr [0x61d3c2], 0x1                # 004a7a4f
    je.d8 L_004a7a62                             # 004a7a56
L_004a7a58:
    # block 0x004a7a58: entered by je at 0x004a7a4d; fall-through of je at 0x004a7a56, 2 instruction(s), calls FUN_004a7994, falls into the block at 0x004a7a62
    mov ecx, 0x61d3a1                            # 004a7a58
    call FUN_004a7994                            # 004a7a5d
L_004a7a62:
    # block 0x004a7a62: entered by je at 0x004a7a56, 2 instruction(s), ends with jne to 0x004a7aa4 (forward)
    cmp dword ptr [0x61d3c6], 0x4                # 004a7a62
    jne.d8 L_004a7aa4                            # 004a7a69
    # block 0x004a7a6b: entered by fall-through of jne at 0x004a7a69, 2 instruction(s), ends with jne to 0x004a7aa4 (forward)
    cmp dword ptr [0x61d3c2], 0x6                # 004a7a6b
    jne.d8 L_004a7aa4                            # 004a7a72
    # block 0x004a7a74: entered by fall-through of jne at 0x004a7a72, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004a7b54
    push 0x550a98                                # 004a7a74
    push 0x61d411                                # 004a7a79
    mov eax, dword ptr [ebp - local_4]           # 004a7a7e
    add eax, 0x1e6                               # 004a7a81
    push eax                                     # 004a7a86
    mov ecx, dword ptr [0x5cf665]                # 004a7a87
    push ecx                                     # 004a7a8d
    mov edx, dword ptr [0x61d3d5]                # 004a7a8e
    push edx                                     # 004a7a94
    mov ecx, 0x5cf659                            # 004a7a95
    call FUN_004c5377                            # 004a7a9a
    jmp.d32 L_004a7b54                           # 004a7a9f
L_004a7aa4:
    # block 0x004a7aa4: entered by jne at 0x004a7a69; jne at 0x004a7a72, 2 instruction(s), ends with jne to 0x004a7ada (forward)
    cmp dword ptr [0x61d3c2], 0x4                # 004a7aa4
    jne.d8 L_004a7ada                            # 004a7aab
    # block 0x004a7aad: entered by fall-through of jne at 0x004a7aab, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004a7b54
    push 0x550ab8                                # 004a7aad
    push 0x61d411                                # 004a7ab2
    mov eax, dword ptr [ebp - local_4]           # 004a7ab7
    add eax, 0x1d6                               # 004a7aba
    push eax                                     # 004a7abf
    mov ecx, dword ptr [0x5cf665]                # 004a7ac0
    push ecx                                     # 004a7ac6
    mov edx, dword ptr [0x5d15e3]                # 004a7ac7
    push edx                                     # 004a7acd
    mov ecx, 0x5cf659                            # 004a7ace
    call FUN_004c5377                            # 004a7ad3
    jmp.d8 L_004a7b54                            # 004a7ad8
L_004a7ada:
    # block 0x004a7ada: entered by jne at 0x004a7aab, 2 instruction(s), ends with jne to 0x004a7b19 (forward)
    cmp dword ptr [0x61d3c6], 0x1                # 004a7ada
    jne.d8 L_004a7b19                            # 004a7ae1
    # block 0x004a7ae3: entered by fall-through of jne at 0x004a7ae1, 2 instruction(s), ends with jne to 0x004a7b19 (forward)
    cmp dword ptr [0x61d3c2], 0x6                # 004a7ae3
    jne.d8 L_004a7b19                            # 004a7aea
    # block 0x004a7aec: entered by fall-through of jne at 0x004a7aea, 12 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004a7b54
    push 0x550ad8                                # 004a7aec
    push 0x61d401                                # 004a7af1
    mov eax, dword ptr [ebp - local_4]           # 004a7af6
    add eax, 0x1c6                               # 004a7af9
    push eax                                     # 004a7afe
    mov ecx, dword ptr [0x5cf665]                # 004a7aff
    push ecx                                     # 004a7b05
    mov edx, dword ptr [0x61d3d5]                # 004a7b06
    push edx                                     # 004a7b0c
    mov ecx, 0x5cf659                            # 004a7b0d
    call FUN_004c5377                            # 004a7b12
    jmp.d8 L_004a7b54                            # 004a7b17
L_004a7b19:
    # block 0x004a7b19: entered by jne at 0x004a7ae1; jne at 0x004a7aea, 4 instruction(s), ends with je to 0x004a7b54 (forward)
    {load} xor eax, eax                          # 004a7b19
    mov al, byte ptr [0x61d3cd]                  # 004a7b1b
    test eax, eax                                # 004a7b20
    je.d8 L_004a7b54                             # 004a7b22
    # block 0x004a7b24: entered by fall-through of je at 0x004a7b22, 2 instruction(s), ends with jne to 0x004a7b54 (forward)
    cmp dword ptr [0x61d3c2], 0x1                # 004a7b24
    jne.d8 L_004a7b54                            # 004a7b2b
    # block 0x004a7b2d: entered by fall-through of jne at 0x004a7b2b, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004a7b54
    push 0x550af8                                # 004a7b2d
    push 0x61d3f1                                # 004a7b32
    push 0x61d3e1                                # 004a7b37
    mov ecx, dword ptr [0x5cf665]                # 004a7b3c
    push ecx                                     # 004a7b42
    mov edx, dword ptr [0x61d3dd]                # 004a7b43
    push edx                                     # 004a7b49
    mov ecx, 0x5cf659                            # 004a7b4a
    call FUN_004c5377                            # 004a7b4f
L_004a7b54:
    # block 0x004a7b54: entered by jmp at 0x004a7a9f; jmp at 0x004a7ad8; jmp at 0x004a7b17; je at 0x004a7b22; more, 4 instruction(s), ends with ret
    mov byte ptr [0x61d3c1], 0x0                 # 004a7b54
    {load} mov esp, ebp                          # 004a7b5b
    pop ebp                                      # 004a7b5d
    ret                                          # 004a7b5e

# --- data items (not part of the function) -------------------------
.org 0x004a7b5f - 0x401000
PAD_004a7b5f:  # 1 byte(s) of int3 padding
    .fill 1, 1, 0xcc

