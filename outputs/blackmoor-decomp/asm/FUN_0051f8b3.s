# FUN_0051f8b3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f8b3
# extent:       0x0051f8b3-0x0051f8c4 (17 code bytes)
# span:         0x0051f8b3-0x0051f8c4 (code 17, tables 0, padding 0)
# sha256:       a1c7694f795057c33d1bc9e630e2ad5571d3e51f3623a5811db4b37ada73cc93
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# ending:       call-end (the code part ends in a call with no instruction after it; the call may or may not return, so it is counted only bound together with the range at 0x0051f8c4 that follows it, under the owner ruling of 2026-10-16)
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f8b3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls FUN_0051dc31, FUN_0050f997
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 5 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; the code part ends in a call with no instruction after it, whether the callee returns is not proven here, and the entry is counted only bound together with the range at 0x0051f8c4 that follows it (owner ruling of 2026-10-16); function ledger class nn_reviewed is a native-touch record, not a counterpart claim
# note:         call_without_fallthrough:0x0051f8bf
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050f997, .text + (0x0050f997 - 0x401000)
.set FUN_0051dc31, .text + (0x0051dc31 - 0x401000)

.org 0x0051f8b3 - 0x401000
.globl FUN_0051f8b3
FUN_0051f8b3:
    # block 0x0051f8b3: entry, 5 instruction(s), calls FUN_0051dc31, FUN_0050f997, ends with call 0x50f997 and no instruction after it in this entry; if the call returns, execution continues in the entry at 0x0051f8c4, which is bound together with this one
    push dword ptr [ebp + field_8]               # 0051f8b3
    call FUN_0051dc31                            # 0051f8b6
    push 0x0                                     # 0051f8bb
    push 0x0                                     # 0051f8bd
    call FUN_0050f997                            # 0051f8bf

