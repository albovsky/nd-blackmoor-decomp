# FUN_004de009
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de009
# extent:       0x004de009-0x004de0cf (198 code bytes)
# span:         0x004de009-0x004de0cf (code 198, tables 0, padding 0)
# sha256:       725ee9dca9f2bc45f38a7c03b97f7bc8cdf7de4c46ab61110629c63921583027
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_save_query_hilite_buttons
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4de009.c.txt, not original source) refers to the data labelled s_UpdateSaveQueryHiliteButtons____e_0055b7c0, s_save_dialog_surface___hilite_but_0055b7ec
# name-note:    Highlights the selected of three save-query dialog buttons and clears the others; logs UpdateSaveQueryHiliteButtons.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 56 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004de009 - 0x401000
.globl FUN_004de009
FUN_004de009:
    # block 0x004de009: entry, 6 instruction(s), ends with je to 0x004de025 (forward)
    push ebp                                     # 004de009
    {load} mov ebp, esp                          # 004de00a
    push ecx                                     # 004de00c
    movsx eax, word ptr [0x63a4cd]               # 004de00d
    test eax, eax                                # 004de014
    je.d8 L_004de025                             # 004de016
    # block 0x004de018: entered by fall-through of je at 0x004de016, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004de025
    push 0x55b7c0                                # 004de018
    call FUN_0044a2b7                            # 004de01d
    add esp, 0x4                                 # 004de022
L_004de025:
    # block 0x004de025: entered by je at 0x004de016, 2 instruction(s), ends with forward jump to 0x004de039
    mov word ptr [ebp - local_4], 0x0            # 004de025
    jmp.d8 L_004de039                            # 004de02b
L_004de02d:
    # block 0x004de02d: entered by jmp at 0x004de0c6, 3 instruction(s), falls into the block at 0x004de039
    mov cx, word ptr [ebp - local_4]             # 004de02d
    add cx, 0x1                                  # 004de031
    mov word ptr [ebp - local_4], cx             # 004de035
L_004de039:
    # block 0x004de039: entered by jmp at 0x004de02b, 3 instruction(s), ends with jge to 0x004de0cb (forward)
    movsx edx, word ptr [ebp - local_4]          # 004de039
    cmp edx, 0x3                                 # 004de03d
    jge.d32 L_004de0cb                           # 004de040
    # block 0x004de046: entered by fall-through of jge at 0x004de040, 4 instruction(s), ends with jne to 0x004de08f (forward)
    movsx eax, word ptr [ebp - local_4]          # 004de046
    movsx ecx, word ptr [0x616872]               # 004de04a
    {load} cmp eax, ecx                          # 004de051
    jne.d8 L_004de08f                            # 004de053
    # block 0x004de055: entered by fall-through of jne at 0x004de053, 16 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004de0c6
    push 0x55b7ec                                # 004de055
    movsx edx, word ptr [ebp - local_4]          # 004de05a
    shl edx, 0x4                                 # 004de05e
    add edx, 0x6167b8                            # 004de061
    push edx                                     # 004de067
    movsx eax, word ptr [ebp - local_4]          # 004de068
    shl eax, 0x4                                 # 004de06c
    add eax, 0x6167f8                            # 004de06f
    push eax                                     # 004de074
    mov ecx, dword ptr [0x5cf665]                # 004de075
    push ecx                                     # 004de07b
    mov edx, dword ptr [0x5d2e75]                # 004de07c
    push edx                                     # 004de082
    mov ecx, 0x5cf659                            # 004de083
    call FUN_004c5377                            # 004de088
    jmp.d8 L_004de0c6                            # 004de08d
L_004de08f:
    # block 0x004de08f: entered by jne at 0x004de053, 15 instruction(s), calls FUN_004c5377, falls into the block at 0x004de0c6
    push 0x55b814                                # 004de08f
    movsx eax, word ptr [ebp - local_4]          # 004de094
    shl eax, 0x4                                 # 004de098
    add eax, 0x6167b8                            # 004de09b
    push eax                                     # 004de0a0
    movsx ecx, word ptr [ebp - local_4]          # 004de0a1
    shl ecx, 0x4                                 # 004de0a5
    add ecx, 0x6167b8                            # 004de0a8
    push ecx                                     # 004de0ae
    mov edx, dword ptr [0x5cf665]                # 004de0af
    push edx                                     # 004de0b5
    mov eax, dword ptr [0x5d2d4d]                # 004de0b6
    push eax                                     # 004de0bb
    mov ecx, 0x5cf659                            # 004de0bc
    call FUN_004c5377                            # 004de0c1
L_004de0c6:
    # block 0x004de0c6: entered by jmp at 0x004de08d, 1 instruction(s), ends with backward jump to 0x004de02d
    jmp.d32 L_004de02d                           # 004de0c6
L_004de0cb:
    # block 0x004de0cb: entered by jge at 0x004de040, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004de0cb
    pop ebp                                      # 004de0cd
    ret                                          # 004de0ce

