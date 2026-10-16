# FUN_00519a60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519a60
# extent:       0x00519a60-0x00519a78 (24 code bytes)
# span:         0x00519a60-0x00519a78 (code 24, tables 0, padding 0)
# sha256:       a1a0f1a615ad457b9d16cc2484a0df4efaab75f618026111d3669b097dd945ec
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519a60
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10
# callees:      calls FUN_005209a3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005209a3, .text + (0x005209a3 - 0x401000)

.org 0x00519a60 - 0x401000
.globl FUN_00519a60
FUN_00519a60:
    # block 0x00519a60: entry, 6 instruction(s), calls FUN_005209a3, ends with ret 0x10
    push dword ptr [esp + stk_10]                # 00519a60
    push dword ptr [esp + stk_10]                # 00519a64
    push dword ptr [esp + stk_10]                # 00519a68
    push dword ptr [esp + stk_10]                # 00519a6c
    call FUN_005209a3                            # 00519a70
    ret 0x10                                     # 00519a75

