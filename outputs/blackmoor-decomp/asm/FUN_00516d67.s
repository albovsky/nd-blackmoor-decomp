# FUN_00516d67
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516d67
# extent:       0x00516d67-0x00516d7d (22 code bytes)
# span:         0x00516d67-0x00516d7d (code 22, tables 0, padding 0)
# sha256:       82378ad9a8eea270c8475bfcb0bb8369f7d1f62ba30504730cfb43f56d070bef
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516d67
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls FUN_00516be5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00516be5, .text + (0x00516be5 - 0x401000)

.org 0x00516d67 - 0x401000
.globl FUN_00516d67
FUN_00516d67:
    # block 0x00516d67: entry, 6 instruction(s), calls FUN_00516be5, ends with ret
    push 0x568cb8                                # 00516d67
    push dword ptr [esp + stk_c]                 # 00516d6c
    push dword ptr [esp + stk_c]                 # 00516d70
    call FUN_00516be5                            # 00516d74
    add esp, 0xc                                 # 00516d79
    ret                                          # 00516d7c

