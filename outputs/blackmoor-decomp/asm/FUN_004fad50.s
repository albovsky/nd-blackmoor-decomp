# FUN_004fad50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fad50
# extent:       0x004fad50-0x004fadc4 (116 code bytes)
# span:         0x004fad50-0x004fadc4 (code 116, tables 0, padding 0)
# sha256:       915e8d296deb854e8055692f6ca85c8b757836ddaad5a39a8da117567593080a
# evidence:     ev_d8c2dc1abacade9fcaea6f9166cbe932f044917e9393a6899ce49be1397e0396
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_close_sound_system
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4fad50.c.txt, not original source) refers to the data labelled s_CSound__CloseSoundSystem______00560578, s_CSound__CloseSoundSystem___error_00560598
# name-note:    Closes the DirectSound system and logs CSound::CloseSoundSystem, reporting an error string on failure.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004f3415, FUN_004fa2a8, FUN_0050ca3e, FUN_0052139c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004f3415, .text + (0x004f3415 - 0x401000)
.set FUN_004fa2a8, .text + (0x004fa2a8 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004fad50 - 0x401000
.globl FUN_004fad50
FUN_004fad50:
    # block 0x004fad50: entry, 7 instruction(s), ends with je to 0x004fad6f (forward)
    push ebp                                     # 004fad50
    {load} mov ebp, esp                          # 004fad51
    push ecx                                     # 004fad53
    mov dword ptr [ebp - local_4], ecx           # 004fad54
    movsx eax, word ptr [0x63a4cd]               # 004fad57
    test eax, eax                                # 004fad5e
    je.d8 L_004fad6f                             # 004fad60
    # block 0x004fad62: entered by fall-through of je at 0x004fad60, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fad6f
    push 0x560578                                # 004fad62
    call FUN_0044a2b7                            # 004fad67
    add esp, 0x4                                 # 004fad6c
L_004fad6f:
    # block 0x004fad6f: entered by je at 0x004fad60, 4 instruction(s), calls FUN_004f3415, ends with jne to 0x004fadc0 (forward)
    mov ecx, 0x5cf1eb                            # 004fad6f
    call FUN_004f3415                            # 004fad74
    test eax, eax                                # 004fad79
    jne.d8 L_004fadc0                            # 004fad7b
    # block 0x004fad7d: entered by fall-through of jne at 0x004fad7b, 10 instruction(s), calls FUN_004fa2a8, FUN_0050ca3e, ends with je to 0x004fadb2 (forward)
    mov ecx, 0x5cf1eb                            # 004fad7d
    call FUN_004fa2a8                            # 004fad82
    push eax                                     # 004fad87
    push 0x560598                                # 004fad88
    push 0x63888b                                # 004fad8d
    call FUN_0050ca3e                            # 004fad92
    add esp, 0xc                                 # 004fad97
    movsx ecx, word ptr [0x63a4cd]               # 004fad9a
    test ecx, ecx                                # 004fada1
    je.d8 L_004fadb2                             # 004fada3
    # block 0x004fada5: entered by fall-through of je at 0x004fada3, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004fadb2
    push 0x63888b                                # 004fada5
    call FUN_0044a2b7                            # 004fadaa
    add esp, 0x4                                 # 004fadaf
L_004fadb2:
    # block 0x004fadb2: entered by je at 0x004fada3, 4 instruction(s), calls FUN_0052139c, falls into the block at 0x004fadc0
    push 0x0                                     # 004fadb2
    push 0x0                                     # 004fadb4
    push 0x63888b                                # 004fadb6
    call FUN_0052139c                            # 004fadbb
L_004fadc0:
    # block 0x004fadc0: entered by jne at 0x004fad7b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004fadc0
    pop ebp                                      # 004fadc2
    ret                                          # 004fadc3

