# FUN_0043ebc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ebc9
# extent:       0x0043ebc9-0x0043ec4a (129 code bytes)
# span:         0x0043ebc9-0x0043ec4a (code 129, tables 0, padding 0)
# sha256:       05fc7c64fd932289a782c6ccd2ab87ba2813fec5e48002c470c00fa82398d262
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mainframe_on_activate_app_handler
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/43ebc9.c.txt, not original source) refers to the data labelled s_CMainFrame__OnActivateApp____jus_00547780, s_CMainFrame__OnActivateApp____jus_005477b4
# name-note:    CMainFrame::OnActivateApp: on deactivation sets state 2 and calls FUN_004fc909, on activation saves the previous state and sets state 0x12, logging both cases.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051ab4b, FUN_0044a2b7, FUN_004fc909
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004fc909, .text + (0x004fc909 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043ebc9 - 0x401000
.globl FUN_0043ebc9
FUN_0043ebc9:
    # block 0x0043ebc9: entry, 8 instruction(s), calls FUN_0051ab4b, ends with je to 0x0043ec18 (forward)
    push ebp                                     # 0043ebc9
    {load} mov ebp, esp                          # 0043ebca
    push ecx                                     # 0043ebcc
    mov dword ptr [ebp - local_4], ecx           # 0043ebcd
    mov ecx, dword ptr [ebp - local_4]           # 0043ebd0
    call FUN_0051ab4b                            # 0043ebd3
    cmp dword ptr [ebp + arg_8], 0x0             # 0043ebd8
    je.d8 L_0043ec18                             # 0043ebdc
    # block 0x0043ebde: entered by fall-through of je at 0x0043ebdc, 3 instruction(s), ends with je to 0x0043ebf6 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0043ebde
    test eax, eax                                # 0043ebe5
    je.d8 L_0043ebf6                             # 0043ebe7
    # block 0x0043ebe9: entered by fall-through of je at 0x0043ebe7, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043ebf6
    push 0x547780                                # 0043ebe9
    call FUN_0044a2b7                            # 0043ebee
    add esp, 0x4                                 # 0043ebf3
L_0043ebf6:
    # block 0x0043ebf6: entered by je at 0x0043ebe7, 5 instruction(s), ends with forward jump to 0x0043ec44
    mov dword ptr [0x58397d], 0x1                # 0043ebf6
    mov ecx, dword ptr [0x583981]                # 0043ec00
    mov dword ptr [0x583989], ecx                # 0043ec06
    mov dword ptr [0x583981], 0x12               # 0043ec0c
    jmp.d8 L_0043ec44                            # 0043ec16
L_0043ec18:
    # block 0x0043ec18: entered by je at 0x0043ebdc, 3 instruction(s), ends with je to 0x0043ec30 (forward)
    movsx edx, word ptr [0x63a4cd]               # 0043ec18
    test edx, edx                                # 0043ec1f
    je.d8 L_0043ec30                             # 0043ec21
    # block 0x0043ec23: entered by fall-through of je at 0x0043ec21, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0043ec30
    push 0x5477b4                                # 0043ec23
    call FUN_0044a2b7                            # 0043ec28
    add esp, 0x4                                 # 0043ec2d
L_0043ec30:
    # block 0x0043ec30: entered by je at 0x0043ec21, 3 instruction(s), calls FUN_004fc909, falls into the block at 0x0043ec44
    mov dword ptr [0x58397d], 0x2                # 0043ec30
    mov ecx, 0x5c3a67                            # 0043ec3a
    call FUN_004fc909                            # 0043ec3f
L_0043ec44:
    # block 0x0043ec44: entered by jmp at 0x0043ec16, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0043ec44
    pop ebp                                      # 0043ec46
    ret 0x8                                      # 0043ec47

