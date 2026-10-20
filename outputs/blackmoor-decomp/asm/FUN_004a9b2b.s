# FUN_004a9b2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a9b2b
# extent:       0x004a9b2b-0x004a9e08 (733 code bytes)
# span:         0x004a9b2b-0x004a9e10 (code 733, tables 0, padding 8)
# sha256:       0c786c2fdd8d75ca4f6bcb95fd5eec767b4f2b737467edefe18a29415d4aef39
# evidence:     ev_f8b80bcdfd5ca2ee198de08d56d1d294d47bc0bea221b480c34a35dbdce25af4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_ripped_letter_puzzle_redraw
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4a9b2b.c.txt, not original source) refers to the data labelled s_Ripped_Letter_Puzzle_CURRENT_are_00550d74, s_Sort_puzzle_item_overlays_00550d58
# name-note:    Redraws the ripped letter puzzle: restores background, RES and CURRENT areas and blits item overlays, with surface blits tagged by Ripped_Letter_Puzzle and Sort_puzzle strings.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_43, field_4d, field_2cd; [ecx + n] field_45
# callees:      calls FUN_004c5377, FUN_004c5d4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 173 instruction(s), 10 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_43, 0x43  # offset +0x43
.equ field_45, 0x45  # offset +0x45
.equ field_4d, 0x4d  # offset +0x4d
.equ field_2cd, 0x2cd  # offset +0x2cd

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004c5d4b, .text + (0x004c5d4b - 0x401000)

.org 0x004a9b2b - 0x401000
.globl FUN_004a9b2b
FUN_004a9b2b:
    # block 0x004a9b2b: entry, 9 instruction(s), ends with je to 0x004a9bb4 (forward)
    push ebp                                     # 004a9b2b
    {load} mov ebp, esp                          # 004a9b2c
    sub esp, 0x14                                # 004a9b2e
    movsx eax, word ptr [0x627353]               # 004a9b31
    imul eax, eax, 0x8d                          # 004a9b38
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004a9b3e
    mov dword ptr [ebp - local_14], ecx          # 004a9b44
    cmp dword ptr [0x628197], 0x0                # 004a9b47
    je.d8 L_004a9bb4                             # 004a9b4e
    # block 0x004a9b50: entered by fall-through of je at 0x004a9b4e, 20 instruction(s), calls FUN_004c5377, falls into the block at 0x004a9bb4
    mov dword ptr [0x628197], 0x0                # 004a9b50
    push 0x550c58                                # 004a9b5a
    movsx edx, word ptr [0x62819d]               # 004a9b5f
    imul edx, edx, 0x90                          # 004a9b66
    movsx eax, word ptr [0x62819b]               # 004a9b6c
    shl eax, 0x4                                 # 004a9b73
    lea ecx, [edx + eax + 0x627355]              # 004a9b76
    push ecx                                     # 004a9b7d
    movsx edx, word ptr [0x62819d]               # 004a9b7e
    imul edx, edx, 0x90                          # 004a9b85
    movsx eax, word ptr [0x62819b]               # 004a9b8b
    shl eax, 0x4                                 # 004a9b92
    lea ecx, [edx + eax + 0x627865]              # 004a9b95
    push ecx                                     # 004a9b9c
    mov edx, dword ptr [0x5cf665]                # 004a9b9d
    push edx                                     # 004a9ba3
    mov eax, dword ptr [0x5d15e3]                # 004a9ba4
    push eax                                     # 004a9ba9
    mov ecx, 0x5cf659                            # 004a9baa
    call FUN_004c5377                            # 004a9baf
L_004a9bb4:
    # block 0x004a9bb4: entered by je at 0x004a9b4e, 2 instruction(s), ends with je to 0x004a9be4 (forward)
    cmp dword ptr [0x628193], 0x0                # 004a9bb4
    je.d8 L_004a9be4                             # 004a9bbb
    # block 0x004a9bbd: entered by fall-through of je at 0x004a9bbb, 9 instruction(s), calls FUN_004c5377, falls into the block at 0x004a9be4
    push 0x550c8c                                # 004a9bbd
    push 0x62816b                                # 004a9bc2
    push 0x62814b                                # 004a9bc7
    mov ecx, dword ptr [0x5cf665]                # 004a9bcc
    push ecx                                     # 004a9bd2
    mov edx, dword ptr [0x5d15e3]                # 004a9bd3
    push edx                                     # 004a9bd9
    mov ecx, 0x5cf659                            # 004a9bda
    call FUN_004c5377                            # 004a9bdf
L_004a9be4:
    # block 0x004a9be4: entered by je at 0x004a9bbb, 2 instruction(s), ends with je to 0x004a9c4c (forward)
    cmp dword ptr [0x62818f], 0x0                # 004a9be4
    je.d8 L_004a9c4c                             # 004a9beb
    # block 0x004a9bed: entered by fall-through of je at 0x004a9beb, 2 instruction(s), ends with jne to 0x004a9c4c (forward)
    cmp dword ptr [0x628193], 0x0                # 004a9bed
    jne.d8 L_004a9c4c                            # 004a9bf4
    # block 0x004a9bf6: entered by fall-through of jne at 0x004a9bf4, 19 instruction(s), calls FUN_004c5377, falls into the block at 0x004a9c4c
    push 0x550cc4                                # 004a9bf6
    push 0x62816b                                # 004a9bfb
    push 0x62814b                                # 004a9c00
    mov eax, dword ptr [0x5cf665]                # 004a9c05
    push eax                                     # 004a9c0a
    mov ecx, dword ptr [0x5d15e3]                # 004a9c0b
    push ecx                                     # 004a9c11
    mov ecx, 0x5cf659                            # 004a9c12
    call FUN_004c5377                            # 004a9c17
    push 0x550cfc                                # 004a9c1c
    push 0x62817b                                # 004a9c21
    push 0x62815b                                # 004a9c26
    mov edx, dword ptr [0x5cf665]                # 004a9c2b
    push edx                                     # 004a9c31
    mov eax, dword ptr [0x5d15e3]                # 004a9c32
    push eax                                     # 004a9c37
    mov ecx, 0x5cf659                            # 004a9c38
    call FUN_004c5377                            # 004a9c3d
    mov dword ptr [0x62818f], 0x0                # 004a9c42
L_004a9c4c:
    # block 0x004a9c4c: entered by je at 0x004a9beb; jne at 0x004a9bf4, 2 instruction(s), ends with forward jump to 0x004a9c60
    mov word ptr [ebp - local_4], 0x0            # 004a9c4c
    jmp.d8 L_004a9c60                            # 004a9c52
L_004a9c54:
    # block 0x004a9c54: entered by jmp at 0x004a9dc0, 3 instruction(s), falls into the block at 0x004a9c60
    mov cx, word ptr [ebp - local_4]             # 004a9c54
    add cx, 0x1                                  # 004a9c58
    mov word ptr [ebp - local_4], cx             # 004a9c5c
L_004a9c60:
    # block 0x004a9c60: entered by jmp at 0x004a9c52, 5 instruction(s), ends with jge to 0x004a9dc5 (forward)
    movsx edx, word ptr [ebp - local_4]          # 004a9c60
    mov eax, dword ptr [ebp - local_14]          # 004a9c64
    movsx ecx, word ptr [eax + field_43]         # 004a9c67
    {load} cmp edx, ecx                          # 004a9c6b
    jge.d32 L_004a9dc5                           # 004a9c6d
    # block 0x004a9c73: entered by fall-through of jge at 0x004a9c6d, 2 instruction(s), ends with forward jump to 0x004a9c87
    mov word ptr [ebp - local_c], 0x0            # 004a9c73
    jmp.d8 L_004a9c87                            # 004a9c79
L_004a9c7b:
    # block 0x004a9c7b: entered by jmp at 0x004a9dbb, 3 instruction(s), falls into the block at 0x004a9c87
    mov dx, word ptr [ebp - local_c]             # 004a9c7b
    add dx, 0x1                                  # 004a9c7f
    mov word ptr [ebp - local_c], dx             # 004a9c83
L_004a9c87:
    # block 0x004a9c87: entered by jmp at 0x004a9c79, 5 instruction(s), ends with jge to 0x004a9dc0 (forward)
    movsx eax, word ptr [ebp - local_c]          # 004a9c87
    mov ecx, dword ptr [ebp - local_14]          # 004a9c8b
    movsx edx, word ptr [ecx + field_45]         # 004a9c8e
    {load} cmp eax, edx                          # 004a9c92
    jge.d32 L_004a9dc0                           # 004a9c94
    # block 0x004a9c9a: entered by fall-through of jge at 0x004a9c94, 2 instruction(s), ends with je to 0x004a9d1b (forward)
    cmp dword ptr [0x62818b], 0x0                # 004a9c9a
    je.d8 L_004a9d1b                             # 004a9ca1
    # block 0x004a9ca3: entered by fall-through of je at 0x004a9ca1, 7 instruction(s), ends with jne to 0x004a9d1b (forward)
    movsx eax, word ptr [ebp - local_4]          # 004a9ca3
    imul eax, eax, 0x36                          # 004a9ca7
    movsx ecx, word ptr [ebp - local_c]          # 004a9caa
    imul ecx, ecx, 0x6                           # 004a9cae
    movsx edx, word ptr [eax + ecx + 0x627d75]   # 004a9cb1
    cmp edx, -0xa                                # 004a9cb9
    jne.d8 L_004a9d1b                            # 004a9cbc
    # block 0x004a9cbe: entered by fall-through of jne at 0x004a9cbc, 21 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004a9dbb
    push 0x550d34                                # 004a9cbe
    movsx eax, word ptr [ebp - local_4]          # 004a9cc3
    imul eax, eax, 0x90                          # 004a9cc7
    movsx ecx, word ptr [ebp - local_c]          # 004a9ccd
    shl ecx, 0x4                                 # 004a9cd1
    lea edx, [eax + ecx + 0x627355]              # 004a9cd4
    push edx                                     # 004a9cdb
    movsx eax, word ptr [ebp - local_4]          # 004a9cdc
    imul eax, eax, 0x90                          # 004a9ce0
    movsx ecx, word ptr [ebp - local_c]          # 004a9ce6
    shl ecx, 0x4                                 # 004a9cea
    lea edx, [eax + ecx + 0x627865]              # 004a9ced
    push edx                                     # 004a9cf4
    mov eax, dword ptr [0x5cf665]                # 004a9cf5
    push eax                                     # 004a9cfa
    mov ecx, dword ptr [0x5d15e3]                # 004a9cfb
    push ecx                                     # 004a9d01
    mov ecx, 0x5cf659                            # 004a9d02
    call FUN_004c5377                            # 004a9d07
    mov dword ptr [0x62818b], 0x0                # 004a9d0c
    jmp.d32 L_004a9dbb                           # 004a9d16
L_004a9d1b:
    # block 0x004a9d1b: entered by je at 0x004a9ca1; jne at 0x004a9cbc, 7 instruction(s), ends with je to 0x004a9dbb (forward)
    movsx edx, word ptr [ebp - local_4]          # 004a9d1b
    imul edx, edx, 0x36                          # 004a9d1f
    movsx eax, word ptr [ebp - local_c]          # 004a9d22
    imul eax, eax, 0x6                           # 004a9d26
    movsx ecx, word ptr [edx + eax + 0x627d75]   # 004a9d29
    cmp ecx, -0xa                                # 004a9d31
    je.d32 L_004a9dbb                            # 004a9d34
    # block 0x004a9d3a: entered by fall-through of je at 0x004a9d34, 33 instruction(s), calls FUN_004c5377, falls into the block at 0x004a9dbb
    movsx edx, word ptr [ebp - local_4]          # 004a9d3a
    imul edx, edx, 0x36                          # 004a9d3e
    movsx eax, word ptr [ebp - local_c]          # 004a9d41
    imul eax, eax, 0x6                           # 004a9d45
    mov cx, word ptr [edx + eax + 0x627d75]      # 004a9d48
    mov word ptr [ebp - local_8], cx             # 004a9d50
    movsx edx, word ptr [ebp - local_4]          # 004a9d54
    imul edx, edx, 0x36                          # 004a9d58
    movsx eax, word ptr [ebp - local_c]          # 004a9d5b
    imul eax, eax, 0x6                           # 004a9d5f
    mov cx, word ptr [edx + eax + 0x627d77]      # 004a9d62
    mov word ptr [ebp - local_10], cx            # 004a9d6a
    push 0x550d58                                # 004a9d6e
    movsx edx, word ptr [ebp - local_4]          # 004a9d73
    imul edx, edx, 0x90                          # 004a9d77
    movsx eax, word ptr [ebp - local_c]          # 004a9d7d
    shl eax, 0x4                                 # 004a9d81
    lea ecx, [edx + eax + 0x627355]              # 004a9d84
    push ecx                                     # 004a9d8b
    movsx edx, word ptr [ebp - local_8]          # 004a9d8c
    imul edx, edx, 0x50                          # 004a9d90
    mov eax, dword ptr [ebp - local_14]          # 004a9d93
    lea ecx, [eax + edx + field_4d]              # 004a9d96
    movsx edx, word ptr [ebp - local_10]         # 004a9d9a
    shl edx, 0x4                                 # 004a9d9e
    {load} add ecx, edx                          # 004a9da1
    push ecx                                     # 004a9da3
    mov eax, dword ptr [0x5cf665]                # 004a9da4
    push eax                                     # 004a9da9
    mov ecx, dword ptr [0x62819f]                # 004a9daa
    push ecx                                     # 004a9db0
    mov ecx, 0x5cf659                            # 004a9db1
    call FUN_004c5377                            # 004a9db6
L_004a9dbb:
    # block 0x004a9dbb: entered by jmp at 0x004a9d16; je at 0x004a9d34, 1 instruction(s), ends with backward jump to 0x004a9c7b
    jmp.d32 L_004a9c7b                           # 004a9dbb
L_004a9dc0:
    # block 0x004a9dc0: entered by jge at 0x004a9c94, 1 instruction(s), ends with backward jump to 0x004a9c54
    jmp.d32 L_004a9c54                           # 004a9dc0
L_004a9dc5:
    # block 0x004a9dc5: entered by jge at 0x004a9c6d, 2 instruction(s), ends with je to 0x004a9e04 (forward)
    cmp dword ptr [0x628193], 0x0                # 004a9dc5
    je.d8 L_004a9e04                             # 004a9dcc
    # block 0x004a9dce: entered by fall-through of je at 0x004a9dcc, 13 instruction(s), calls FUN_004c5d4b, falls into the block at 0x004a9e04
    push 0x550d74                                # 004a9dce
    push 0x62817b                                # 004a9dd3
    movsx edx, word ptr [0x628149]               # 004a9dd8
    shl edx, 0x4                                 # 004a9ddf
    mov eax, dword ptr [ebp - local_14]          # 004a9de2
    lea ecx, [eax + edx + field_2cd]             # 004a9de5
    push ecx                                     # 004a9dec
    mov edx, dword ptr [0x5cf665]                # 004a9ded
    push edx                                     # 004a9df3
    mov eax, dword ptr [0x6281a3]                # 004a9df4
    push eax                                     # 004a9df9
    mov ecx, 0x5cf659                            # 004a9dfa
    call FUN_004c5d4b                            # 004a9dff
L_004a9e04:
    # block 0x004a9e04: entered by je at 0x004a9dcc, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004a9e04
    pop ebp                                      # 004a9e06
    ret                                          # 004a9e07

# --- data items (not part of the function) -------------------------
.org 0x004a9e08 - 0x401000
PAD_004a9e08:  # 8 byte(s) of int3 padding
    .fill 8, 1, 0xcc

