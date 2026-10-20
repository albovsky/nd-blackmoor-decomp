# FUN_004ada0d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ada0d
# extent:       0x004ada0d-0x004ada56 (73 code bytes)
# span:         0x004ada0d-0x004ada56 (code 73, tables 0, padding 0)
# sha256:       d1dbc94fbd152fabc3015c390e55d34eb05c364854efc943ac2bccfb0537814b
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_play_unless_no_sound
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4ada0d.c.txt, not original source) refers to the data labelled s_NO_SOUND_005511d4
# name-note:    Compares a stored sound name against the NO_SOUND string and, if different, calls the PlaySound routine with the stored channel id.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c17; [ecx + n] field_2b7
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2b7, 0x2b7  # offset +0x2b7
.equ field_c17, 0xc17  # offset +0xc17

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004ada0d - 0x401000
.globl FUN_004ada0d
FUN_004ada0d:
    # block 0x004ada0d: entry, 14 instruction(s), ends with je to 0x004ada50 (forward)
    push ebp                                     # 004ada0d
    {load} mov ebp, esp                          # 004ada0e
    push ecx                                     # 004ada10
    push esi                                     # 004ada11
    push edi                                     # 004ada12
    mov dword ptr [ebp - local_4], ecx           # 004ada13
    mov edi, 0x5511d4                            # 004ada16
    mov eax, dword ptr [ebp - local_4]           # 004ada1b
    mov esi, dword ptr [eax + field_c17]         # 004ada1e
    add esi, 0x296                               # 004ada24
    mov ecx, 0x9                                 # 004ada2a
    {load} xor edx, edx                          # 004ada2f
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004ada31
    je.d8 L_004ada50                             # 004ada33
    # block 0x004ada35: entered by fall-through of je at 0x004ada33, 6 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004ada50
    mov eax, dword ptr [ebp - local_4]           # 004ada35
    mov ecx, dword ptr [eax + field_c17]         # 004ada38
    mov dx, word ptr [ecx + field_2b7]           # 004ada3e
    push edx                                     # 004ada45
    mov ecx, 0x5c3a67                            # 004ada46
    call FUN_004fb2e3                            # 004ada4b
L_004ada50:
    # block 0x004ada50: entered by je at 0x004ada33, 5 instruction(s), ends with ret
    pop edi                                      # 004ada50
    pop esi                                      # 004ada51
    {load} mov esp, ebp                          # 004ada52
    pop ebp                                      # 004ada54
    ret                                          # 004ada55

