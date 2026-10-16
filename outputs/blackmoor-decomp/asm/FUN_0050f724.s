# FUN_0050f724
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f724
# extent:       0x0050f724-0x0050f72d (9 code bytes)
# span:         0x0050f724-0x0050f72d (code 9, tables 0, padding 0)
# sha256:       fbc56f45ddea6a2f81dbd9c6e4733aeabc0c489acf81d5d11b3183ddbfa90690
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050f710 (+0x14)
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0050f72d that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f724
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00513c65
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 2 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0050f72d that follows it (owner ruling of 2026-10-16)
# note:         call_without_fallthrough:0x0050f728
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00513c65, .text + (0x00513c65 - 0x401000)

.org 0x0050f724 - 0x401000
.globl FUN_0050f724
FUN_0050f724:
    # block 0x0050f724: entry, 2 instruction(s), calls FUN_00513c65, ends with call 0x513c65 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0050f72d, which is bound together with this one
    lea edx, [esp + stk_4]                       # 0050f724
    call FUN_00513c65                            # 0050f728

