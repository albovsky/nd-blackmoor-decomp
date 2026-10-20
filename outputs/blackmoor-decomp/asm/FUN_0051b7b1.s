# FUN_0051b7b1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b7b1
# extent:       0x0051b7b1-0x0051b7c1 (16 code bytes)
# span:         0x0051b7b1-0x0051b7c1 (code 16, tables 0, padding 0)
# sha256:       b3bdc9ba0b4986fae89ae75e0b0722651b01f52a52e70ca7a6818ce10ad56b11
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0051b7c1 that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Catch@0051b7b1
# naming:       Ghidra name from function-index.json (not re-derived here); note is the ledger reason (compiler_eh_funclet, function-ledger-overrides.json not_needed_entries)
# name-note:    Catch@ handler of a library parent: AfxRegisterClass catch: unlocks global critical section (FUN_0052606a) and rethrows; tail is spilled AfxRegisterWndClass code. Parent just propagates
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0052606a, FUN_0050f997
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 6 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0051b7c1 that follows it (owner ruling of 2026-10-16); function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         call_without_fallthrough:0x0051b7bc
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0050f997, .text + (0x0050f997 - 0x401000)
.set FUN_0052606a, .text + (0x0052606a - 0x401000)

.org 0x0051b7b1 - 0x401000
.globl FUN_0051b7b1
FUN_0051b7b1:
    # block 0x0051b7b1: entry, 6 instruction(s), calls FUN_0052606a, FUN_0050f997, ends with call 0x50f997 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0051b7c1, which is bound together with this one
    push 0x1                                     # 0051b7b1
    call FUN_0052606a                            # 0051b7b3
    {load} xor ebx, ebx                          # 0051b7b8
    push ebx                                     # 0051b7ba
    push ebx                                     # 0051b7bb
    call FUN_0050f997                            # 0051b7bc

