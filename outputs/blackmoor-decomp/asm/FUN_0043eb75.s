# FUN_0043eb75
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eb75
# extent:       0x0043eb75-0x0043ebc9 (84 code bytes)
# span:         0x0043eb75-0x0043ebc9 (code 84, tables 0, padding 0)
# sha256:       2d1ce2b21697810a4c529a9b415c7f69c2a628aabc6da228562eedcfa06771bf
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mainframe_on_create_tail
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/43eb75.c.txt, not original source) refers to the data labelled s_End_CMainFrame__OnCreate____go_t_00547744
# name-note:    After the base create call FUN_005230f0 succeeds, sets state 1 and logs End CMainFrame::OnCreate; returns -1 if the base call returned -1.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005230f0, FUN_00522953, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_00522953, .text + (0x00522953 - 0x401000)
.set FUN_005230f0, .text + (0x005230f0 - 0x401000)

.org 0x0043eb75 - 0x401000
.globl FUN_0043eb75
FUN_0043eb75:
    # block 0x0043eb75: entry, 10 instruction(s), calls FUN_005230f0, ends with jne to 0x0043eb92 (forward)
    push ebp                                     # 0043eb75
    {load} mov ebp, esp                          # 0043eb76
    push ecx                                     # 0043eb78
    mov dword ptr [ebp - local_4], ecx           # 0043eb79
    mov eax, dword ptr [ebp + arg_8]             # 0043eb7c
    push eax                                     # 0043eb7f
    mov ecx, dword ptr [ebp - local_4]           # 0043eb80
    call FUN_005230f0                            # 0043eb83
    cmp eax, -0x1                                # 0043eb88
    jne.d8 L_0043eb92                            # 0043eb8b
    # block 0x0043eb8d: entered by fall-through of jne at 0x0043eb8b, 2 instruction(s), ends with forward jump to 0x0043ebc3
    or eax, -0x1                                 # 0043eb8d
    jmp.d8 L_0043ebc3                            # 0043eb90
L_0043eb92:
    # block 0x0043eb92: entered by jne at 0x0043eb8b, 7 instruction(s), calls FUN_00522953, ends with je to 0x0043ebc1 (forward)
    push 0x80                                    # 0043eb92
    mov ecx, dword ptr [ebp - local_4]           # 0043eb97
    call FUN_00522953                            # 0043eb9a
    mov dword ptr [0x583981], 0x1                # 0043eb9f
    movsx ecx, word ptr [0x63a4cd]               # 0043eba9
    test ecx, ecx                                # 0043ebb0
    je.d8 L_0043ebc1                             # 0043ebb2
    # block 0x0043ebb4: entered by fall-through of je at 0x0043ebb2, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043ebc1
    push 0x547744                                # 0043ebb4
    call FUN_0044a2b7                            # 0043ebb9
    add esp, 0x4                                 # 0043ebbe
L_0043ebc1:
    # block 0x0043ebc1: entered by je at 0x0043ebb2, 1 instruction(s), falls into the block at 0x0043ebc3
    {load} xor eax, eax                          # 0043ebc1
L_0043ebc3:
    # block 0x0043ebc3: entered by jmp at 0x0043eb90, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0043ebc3
    pop ebp                                      # 0043ebc5
    ret 0x4                                      # 0043ebc6

