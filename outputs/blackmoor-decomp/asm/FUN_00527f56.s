# FUN_00527f56
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00527f56
# extent:       0x00527f56-0x00527f5f (9 code bytes)
# span:         0x00527f56-0x00527f5f (code 9, tables 0, padding 0)
# sha256:       ab0583ff5695a6278ddb72698210c265eb9503f6b38f112c5bbba9ddc182a59e
# evidence:     ev_7a152dca5b4d4270e26c3d32ca1ad001d44bfc411ed4e2c4ce09c304a9d9da5d
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00527f56
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00527f5f
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x00527f56 - 0x401000
.globl FUN_00527f56
FUN_00527f56:
    # block 0x00527f56: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp + field_8]                     # 00527f56
    call FUN_0051e7ba                            # 00527f59
    ret                                          # 00527f5e

