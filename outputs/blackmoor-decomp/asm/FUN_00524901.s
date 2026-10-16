# FUN_00524901
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524901
# extent:       0x00524901-0x00524921 (32 code bytes)
# span:         0x00524901-0x00524921 (code 32, tables 0, padding 0)
# sha256:       a14ea01908cd49a4addad0891b946195701b52efa3386db0fbecaf205caa1c68
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524901
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00524921, FUN_0050c604
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00524921
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050c604, .text + (0x0050c604 - 0x401000)
.set FUN_00524921, .text + (0x00524921 - 0x401000)

.org 0x00524901 - 0x401000
.globl FUN_00524901
FUN_00524901:
    # block 0x00524901: entry, 5 instruction(s), calls FUN_00524921, ends with je to 0x0052491b (forward)
    push esi                                     # 00524901
    {load} mov esi, ecx                          # 00524902
    call FUN_00524921                            # 00524904
    test byte ptr [esp + stk_8], 0x1             # 00524909
    je.d8 L_0052491b                             # 0052490e
    # block 0x00524910: entered by fall-through of je at 0x0052490e, 3 instruction(s), calls FUN_0050c604, falls into the block at 0x0052491b
    push esi                                     # 00524910
    mov ecx, 0x63c230                            # 00524911
    call FUN_0050c604                            # 00524916
L_0052491b:
    # block 0x0052491b: entered by je at 0x0052490e, 3 instruction(s), ends with ret 0x4
    {load} mov eax, esi                          # 0052491b
    pop esi                                      # 0052491d
    ret 0x4                                      # 0052491e

