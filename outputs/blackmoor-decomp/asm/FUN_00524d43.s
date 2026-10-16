# FUN_00524d43
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524d43
# extent:       0x00524d43-0x00524d5f (28 code bytes)
# span:         0x00524d43-0x00524d5f (code 28, tables 0, padding 0)
# sha256:       1c940b2fea3fbc525a27cf0c9adf462f61d2eb67abfcf7512bef843874d682b2
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524d43
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00524e1f, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524d5f
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_00524e1f, .text + (0x00524e1f - 0x401000)

.org 0x00524d43 - 0x401000
.globl FUN_00524d43
FUN_00524d43:
    # block 0x00524d43: entry, 5 instruction(s), calls FUN_00524e1f, ends with je to 0x00524d59 (forward)
    push esi                                     # 00524d43
    {load} mov esi, ecx                          # 00524d44
    call FUN_00524e1f                            # 00524d46
    test byte ptr [esp + stk_8], 0x1             # 00524d4b
    je.d8 L_00524d59                             # 00524d50
    # block 0x00524d52: entered by fall-through of je at 0x00524d50, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x00524d59
    push esi                                     # 00524d52
    call FUN_0051dc6c                            # 00524d53
    pop ecx                                      # 00524d58
L_00524d59:
    # block 0x00524d59: entered by je at 0x00524d50, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 00524d59
    pop esi                                      # 00524d5b
    ret 0x4                                      # 00524d5c

