# FUN_0050df94
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050df94
# extent:       0x0050df94-0x0050df9d (9 code bytes)
# span:         0x0050df94-0x0050df9d (code 9, tables 0, padding 0)
# sha256:       bb2d93be04097eee8168c41b39bd09980842772d62c7417d8e0b80865ad114e5
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0050df9d that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050df94
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00513c65
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0050df9d that follows it (owner ruling of 2026-10-16); function ledger class partial_native is a native-touch record, not a counterpart claim
# note:         call_without_fallthrough:0x0050df98
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00513c65, .text + (0x00513c65 - 0x401000)

.org 0x0050df94 - 0x401000
.globl FUN_0050df94
FUN_0050df94:
    # block 0x0050df94: entry, 2 instruction(s), calls FUN_00513c65, ends with call 0x513c65 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0050df9d, which is bound together with this one
    lea edx, [esp + stk_4]                       # 0050df94
    call FUN_00513c65                            # 0050df98

