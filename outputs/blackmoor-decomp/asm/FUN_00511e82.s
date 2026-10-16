# FUN_00511e82
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511e82
# extent:       0x00511e82-0x00511ea7 (37 code bytes)
# span:         0x00511e82-0x00511ea7 (code 37, tables 0, padding 0)
# sha256:       20bd8df7afd08b2f47d9de6d9218dfe3bd8f83bcbb751abca37118f88914c6d4
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511e82
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00511f30, FUN_0050ed50
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050ed50, .text + (0x0050ed50 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)

.org 0x00511e82 - 0x401000
.globl FUN_00511e82
FUN_00511e82:
    # block 0x00511e82: entry, 4 instruction(s), ends with je to 0x00511ea5 (forward)
    push edi                                     # 00511e82
    mov edi, dword ptr [esp + stk_c]             # 00511e83
    test edi, edi                                # 00511e87
    je.d8 L_00511ea5                             # 00511e89
    # block 0x00511e8b: entered by fall-through of je at 0x00511e89, 12 instruction(s), calls FUN_00511f30, FUN_0050ed50, falls into the block at 0x00511ea5
    push esi                                     # 00511e8b
    mov esi, dword ptr [esp + stk_c]             # 00511e8c
    push esi                                     # 00511e90
    call FUN_00511f30                            # 00511e91
    inc eax                                      # 00511e96
    push eax                                     # 00511e97
    push esi                                     # 00511e98
    {load} add esi, edi                          # 00511e99
    push esi                                     # 00511e9b
    call FUN_0050ed50                            # 00511e9c
    add esp, 0x10                                # 00511ea1
    pop esi                                      # 00511ea4
L_00511ea5:
    # block 0x00511ea5: entered by je at 0x00511e89, 2 instruction(s), ends with ret
    pop edi                                      # 00511ea5
    ret                                          # 00511ea6

