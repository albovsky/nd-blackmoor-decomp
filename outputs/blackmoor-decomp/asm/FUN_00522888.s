# FUN_00522888
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522888
# extent:       0x00522888-0x005228a4 (28 code bytes)
# span:         0x00522888-0x005228a4 (code 28, tables 0, padding 0)
# sha256:       287ba3b808aab9c0bc8e6541119e2297c4b66041068cf68a64f65a96e650928d
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522888
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005228a4, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_005228a4, .text + (0x005228a4 - 0x401000)

.org 0x00522888 - 0x401000
.globl FUN_00522888
FUN_00522888:
    # block 0x00522888: entry, 5 instruction(s), calls FUN_005228a4, ends with je to 0x0052289e (forward)
    push esi                                     # 00522888
    {load} mov esi, ecx                          # 00522889
    call FUN_005228a4                            # 0052288b
    test byte ptr [esp + stk_8], 0x1             # 00522890
    je.d8 L_0052289e                             # 00522895
    # block 0x00522897: entered by fall-through of je at 0x00522895, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0052289e
    push esi                                     # 00522897
    call FUN_0051dc6c                            # 00522898
    pop ecx                                      # 0052289d
L_0052289e:
    # block 0x0052289e: entered by je at 0x00522895, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0052289e
    pop esi                                      # 005228a0
    ret 0x4                                      # 005228a1

