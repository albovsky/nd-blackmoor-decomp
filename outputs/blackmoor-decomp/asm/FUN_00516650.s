# FUN_00516650
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516650
# extent:       0x00516650-0x00516667 (23 code bytes)
# span:         0x00516650-0x00516667 (code 23, tables 0, padding 0)
# sha256:       6f5163e6e17273350132bd200a797e684818dec6b833734ddee7df5e5f98978a
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x00516667 that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516650
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514dd2, FUN_00518a16, FUN_0050d7f4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x00516667 that follows it (owner ruling of 2026-10-16)
# note:         call_without_fallthrough:0x00516662
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050d7f4, .text + (0x0050d7f4 - 0x401000)
.set FUN_00514dd2, .text + (0x00514dd2 - 0x401000)
.set FUN_00518a16, .text + (0x00518a16 - 0x401000)

.org 0x00516650 - 0x401000
.globl FUN_00516650
FUN_00516650:
    # block 0x00516650: entry, 8 instruction(s), calls FUN_00514dd2, FUN_00518a16, FUN_0050d7f4, ends with call 0x50d7f4 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x00516667, which is bound together with this one
    push 0xa                                     # 00516650
    call FUN_00514dd2                            # 00516652
    push 0x16                                    # 00516657
    call FUN_00518a16                            # 00516659
    pop ecx                                      # 0051665e
    pop ecx                                      # 0051665f
    push 0x3                                     # 00516660
    call FUN_0050d7f4                            # 00516662

