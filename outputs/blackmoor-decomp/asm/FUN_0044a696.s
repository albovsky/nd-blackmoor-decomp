# FUN_0044a696
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044a696
# extent:       0x0044a696-0x0044a6f2 (92 code bytes)
# span:         0x0044a696-0x0044a6f2 (code 92, tables 0, padding 0)
# sha256:       3b4757063382e0b1e67e54181276c85f75f3a3bc2100a80708a21a792f717040
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_ace_game_ini_flag_writer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/44a696.c.txt, not original source) refers to the data labelled s_AcedTheGame_00548b0c, s_Nancy_Data_00548b2c, s_PlayerWonTheGame_00548b18
# name-note:    When the win flag is set once, writes PlayerWonTheGame=AcedTheGame into the Nancy Data section of the ini file.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!WritePrivateProfileStringA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0044a696 - 0x401000
.globl FUN_0044a696
FUN_0044a696:
    # block 0x0044a696: entry, 4 instruction(s), ends with jne to 0x0044a6d2 (forward)
    push ebp                                     # 0044a696
    {load} mov ebp, esp                          # 0044a697
    cmp dword ptr [0x586821], 0x1                # 0044a699
    jne.d8 L_0044a6d2                            # 0044a6a0
    # block 0x0044a6a2: entered by fall-through of jne at 0x0044a6a0, 3 instruction(s), ends with jne to 0x0044a6d2 (forward)
    movsx eax, word ptr [0x5bb218]               # 0044a6a2
    test eax, eax                                # 0044a6a9
    jne.d8 L_0044a6d2                            # 0044a6ab
    # block 0x0044a6ad: entered by fall-through of jne at 0x0044a6ab, 7 instruction(s), calls KERNEL32.dll!WritePrivateProfileStringA, ends with forward jump to 0x0044a6f0
    mov word ptr [0x5bb218], 0x1                 # 0044a6ad
    push 0x639897                                # 0044a6b6
    push 0x548b0c                                # 0044a6bb
    push 0x548b18                                # 0044a6c0
    push 0x548b2c                                # 0044a6c5
    call dword ptr [0x52a26c]                    # 0044a6ca
    jmp.d8 L_0044a6f0                            # 0044a6d0
L_0044a6d2:
    # block 0x0044a6d2: entered by jne at 0x0044a6a0; jne at 0x0044a6ab, 2 instruction(s), ends with jne to 0x0044a6f0 (forward)
    cmp dword ptr [0x586821], 0x0                # 0044a6d2
    jne.d8 L_0044a6f0                            # 0044a6d9
    # block 0x0044a6db: entered by fall-through of jne at 0x0044a6d9, 3 instruction(s), ends with je to 0x0044a6f0 (forward)
    movsx ecx, word ptr [0x5bb218]               # 0044a6db
    test ecx, ecx                                # 0044a6e2
    je.d8 L_0044a6f0                             # 0044a6e4
    # block 0x0044a6e6: entered by fall-through of je at 0x0044a6e4, 1 instruction(s), falls into the block at 0x0044a6f0
    mov dword ptr [0x586821], 0x1                # 0044a6e6
L_0044a6f0:
    # block 0x0044a6f0: entered by jmp at 0x0044a6d0; jne at 0x0044a6d9; je at 0x0044a6e4, 2 instruction(s), ends with ret
    pop ebp                                      # 0044a6f0
    ret                                          # 0044a6f1

