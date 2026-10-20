# FUN_0051dc77
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051dc77
# extent:       0x0051dc77-0x0051dcb1 (58 code bytes)
# span:         0x0051dc77-0x0051dcb1 (code 58, tables 0, padding 0)
# sha256:       aea4b77aede9a10724bbb6f07ec632cb1570c776b54cfdd5a503a186b2719f18
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_mfc_dialog_init_handler
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/51dc77.c.txt, not original source) refers to the data labelled s_CDialog_0052f190
# name-note:    On WM_INITDIALOG looks up the CDialog for the window handle and calls its virtual init handler.
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_bc; [esp + n] stk_4, stk_8
# callees:      calls FUN_0051ac0b, FUN_0051f5ab; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051dcb1
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------
.set FUN_0051ac0b, .text + (0x0051ac0b - 0x401000)
.set FUN_0051f5ab, .text + (0x0051f5ab - 0x401000)

.org 0x0051dc77 - 0x401000
.globl FUN_0051dc77
FUN_0051dc77:
    # block 0x0051dc77: entry, 2 instruction(s), ends with jne to 0x0051dcac (forward)
    cmp dword ptr [esp + stk_8], 0x110           # 0051dc77
    jne.d8 L_0051dcac                            # 0051dc7f
    # block 0x0051dc81: entered by fall-through of jne at 0x0051dc7f, 9 instruction(s), calls FUN_0051ac0b, FUN_0051f5ab, ends with je to 0x0051dca7 (forward)
    push dword ptr [esp + stk_4]                 # 0051dc81
    call FUN_0051ac0b                            # 0051dc85
    push eax                                     # 0051dc8a
    push 0x52f190                                # 0051dc8b
    call FUN_0051f5ab                            # 0051dc90
    pop ecx                                      # 0051dc95
    test eax, eax                                # 0051dc96
    pop ecx                                      # 0051dc98
    je.d8 L_0051dca7                             # 0051dc99
    # block 0x0051dc9b: entered by fall-through of je at 0x0051dc99, 4 instruction(s), calls indirect dword ptr [edx + 0xbc], ends with forward jump to 0x0051dcae
    mov edx, dword ptr [eax]                     # 0051dc9b
    {load} mov ecx, eax                          # 0051dc9d
    call dword ptr [edx + field_bc]              # 0051dc9f
    jmp.d8 L_0051dcae                            # 0051dca5
L_0051dca7:
    # block 0x0051dca7: entered by je at 0x0051dc99, 3 instruction(s), ends with forward jump to 0x0051dcae
    push 0x1                                     # 0051dca7
    pop eax                                      # 0051dca9
    jmp.d8 L_0051dcae                            # 0051dcaa
L_0051dcac:
    # block 0x0051dcac: entered by jne at 0x0051dc7f, 1 instruction(s), falls into the block at 0x0051dcae
    {load} xor eax, eax                          # 0051dcac
L_0051dcae:
    # block 0x0051dcae: entered by jmp at 0x0051dca5; jmp at 0x0051dcaa, 1 instruction(s), ends with ret 0x10
    ret 0x10                                     # 0051dcae

