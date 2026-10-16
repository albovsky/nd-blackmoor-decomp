# FUN_00521833
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521833
# extent:       0x00521833-0x0052184f (28 code bytes)
# span:         0x00521833-0x0052184f (code 28, tables 0, padding 0)
# sha256:       5320bc63c1623c864298269f0ac4f2e0766060e9f1b1311c6d771734696cdeb8
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521833
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005218ea, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00521833 - 0x401000
.globl FUN_00521833
FUN_00521833:
    # block 0x00521833: entry, 5 instruction(s), calls FUN_005218ea, ends with je to 0x00521849 (forward)
    push esi                                     # 00521833
    {load} mov esi, ecx                          # 00521834
    call FUN_005218ea                            # 00521836
    test byte ptr [esp + stk_8], 0x1             # 0052183b
    je.d8 L_00521849                             # 00521840
    # block 0x00521842: entered by fall-through of je at 0x00521840, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00521849
    push esi                                     # 00521842
    call FUN_0051dc6c                            # 00521843
    pop ecx                                      # 00521848
L_00521849:
    # block 0x00521849: entered by je at 0x00521840, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00521849
    pop esi                                      # 0052184b
    ret 0x4                                      # 0052184c

