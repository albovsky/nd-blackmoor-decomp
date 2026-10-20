# FUN_004de0cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de0cf
# extent:       0x004de0cf-0x004de113 (68 code bytes)
# span:         0x004de0cf-0x004de120 (code 68, tables 0, padding 13)
# sha256:       f02cea8424469d9142284f621cbe3253fcc59bef73a64a83d5207a5f5e855304
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_save_query_dialog_draw
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4de0cf.c.txt, not original source) refers to the data labelled s_Game_Save_Confirmation_0055b864, s_UpdateSaveQueryDialog____enter___0055b840
# name-note:    Draws the Game Save Confirmation image of the save query dialog; logs UpdateSaveQueryDialog.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_004c5377
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)

.org 0x004de0cf - 0x401000
.globl FUN_004de0cf
FUN_004de0cf:
    # block 0x004de0cf: entry, 5 instruction(s), ends with je to 0x004de0ea (forward)
    push ebp                                     # 004de0cf
    {load} mov ebp, esp                          # 004de0d0
    movsx eax, word ptr [0x63a4cd]               # 004de0d2
    test eax, eax                                # 004de0d9
    je.d8 L_004de0ea                             # 004de0db
    # block 0x004de0dd: entered by fall-through of je at 0x004de0db, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004de0ea
    push 0x55b840                                # 004de0dd
    call FUN_0044a2b7                            # 004de0e2
    add esp, 0x4                                 # 004de0e7
L_004de0ea:
    # block 0x004de0ea: entered by je at 0x004de0db, 11 instruction(s), calls FUN_004c5377, ends with ret
    push 0x55b864                                # 004de0ea
    push 0x6167a8                                # 004de0ef
    push 0x6167e8                                # 004de0f4
    mov ecx, dword ptr [0x5cf665]                # 004de0f9
    push ecx                                     # 004de0ff
    mov edx, dword ptr [0x5d2d4d]                # 004de100
    push edx                                     # 004de106
    mov ecx, 0x5cf659                            # 004de107
    call FUN_004c5377                            # 004de10c
    pop ebp                                      # 004de111
    ret                                          # 004de112

# --- data items (not part of the function) -------------------------
.org 0x004de113 - 0x401000
PAD_004de113:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

