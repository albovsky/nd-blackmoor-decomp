# FUN_004542b5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004542b5
# extent:       0x004542b5-0x004542f2 (61 code bytes)
# span:         0x004542b5-0x004542f2 (code 61, tables 0, padding 0)
# sha256:       d9d871ab1b9e280bd5a9e3da45086e315d3f70b2d1c2702ed0020e857cf6a07e
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_play_sound_unless_no_sound
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4542b5.c.txt, not original source) refers to the data labelled s_NO_SOUND_00549de0
# name-note:    If the name field is not NO_SOUND, calls FUN_004fb2e3 (CSound::PlaySound) with the sound id field.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_571
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_571, 0x571  # offset +0x571

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004542b5 - 0x401000
.globl FUN_004542b5
FUN_004542b5:
    # block 0x004542b5: entry, 13 instruction(s), ends with je to 0x004542ec (forward)
    push ebp                                     # 004542b5
    {load} mov ebp, esp                          # 004542b6
    push ecx                                     # 004542b8
    push esi                                     # 004542b9
    push edi                                     # 004542ba
    mov dword ptr [ebp - local_4], ecx           # 004542bb
    mov edi, 0x549de0                            # 004542be
    mov esi, dword ptr [ebp - local_4]           # 004542c3
    add esi, 0x550                               # 004542c6
    mov ecx, 0x9                                 # 004542cc
    {load} xor eax, eax                          # 004542d1
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004542d3
    je.d8 L_004542ec                             # 004542d5
    # block 0x004542d7: entered by fall-through of je at 0x004542d5, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004542ec
    mov ecx, dword ptr [ebp - local_4]           # 004542d7
    mov dx, word ptr [ecx + field_571]           # 004542da
    push edx                                     # 004542e1
    mov ecx, 0x5c3a67                            # 004542e2
    call FUN_004fb2e3                            # 004542e7
L_004542ec:
    # block 0x004542ec: entered by je at 0x004542d5, 5 instruction(s), ends with ret
    pop edi                                      # 004542ec
    pop esi                                      # 004542ed
    {load} mov esp, ebp                          # 004542ee
    pop ebp                                      # 004542f0
    ret                                          # 004542f1

