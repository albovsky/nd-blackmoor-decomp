# FUN_0050cb1b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050cb1b
# extent:       0x0050cb1b-0x0050cb26 (11 code bytes)
# span:         0x0050cb1b-0x0050cb26 (code 11, tables 0, padding 0)
# sha256:       de8e53f3edb8d03fe276f4726fdf910ba2b7b005346cdbdad94cf3cb7728cff7
# evidence:     ev_7c01bda5c208998c8b38f9e1693c1f9d27cef570b0e4d2e523c0f31431a0d762
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050cb1b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050ca90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 4 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050ca90, .text + (0x0050ca90 - 0x401000)

.org 0x0050cb1b - 0x401000
.globl FUN_0050cb1b
FUN_0050cb1b:
    # block 0x0050cb1b: entry, 4 instruction(s), calls FUN_0050ca90, ends with ret
    push dword ptr [esp + stk_4]                 # 0050cb1b
    call FUN_0050ca90                            # 0050cb1f
    pop ecx                                      # 0050cb24
    ret                                          # 0050cb25

