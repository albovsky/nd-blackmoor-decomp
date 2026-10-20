# FUN_0045441d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045441d
# extent:       0x0045441d-0x0045445a (61 code bytes)
# span:         0x0045441d-0x0045445a (code 61, tables 0, padding 0)
# sha256:       13e023c737ea01badd9d1a9aef7eb8d94267af0d7bd4238590d4fbebac14e200
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_play_sound_unless_no_sound_c
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/45441d.c.txt, not original source) refers to the data labelled s_NO_SOUND_00549e1c
# name-note:    If the name field is not NO_SOUND, calls FUN_004fb2e3 (CSound::PlaySound) with the sound id field.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_697
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_697, 0x697  # offset +0x697

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x0045441d - 0x401000
.globl FUN_0045441d
FUN_0045441d:
    # block 0x0045441d: entry, 13 instruction(s), ends with je to 0x00454454 (forward)
    push ebp                                     # 0045441d
    {load} mov ebp, esp                          # 0045441e
    push ecx                                     # 00454420
    push esi                                     # 00454421
    push edi                                     # 00454422
    mov dword ptr [ebp - local_4], ecx           # 00454423
    mov edi, 0x549e1c                            # 00454426
    mov esi, dword ptr [ebp - local_4]           # 0045442b
    add esi, 0x676                               # 0045442e
    mov ecx, 0x9                                 # 00454434
    {load} xor eax, eax                          # 00454439
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045443b
    je.d8 L_00454454                             # 0045443d
    # block 0x0045443f: entered by fall-through of je at 0x0045443d, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00454454
    mov ecx, dword ptr [ebp - local_4]           # 0045443f
    mov dx, word ptr [ecx + field_697]           # 00454442
    push edx                                     # 00454449
    mov ecx, 0x5c3a67                            # 0045444a
    call FUN_004fb2e3                            # 0045444f
L_00454454:
    # block 0x00454454: entered by je at 0x0045443d, 5 instruction(s), ends with ret
    pop edi                                      # 00454454
    pop esi                                      # 00454455
    {load} mov esp, ebp                          # 00454456
    pop ebp                                      # 00454458
    ret                                          # 00454459

