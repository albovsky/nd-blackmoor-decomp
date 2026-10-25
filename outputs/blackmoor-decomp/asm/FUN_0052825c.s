# FUN_0052825c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052825c
# extent:       0x0052825c-0x00528265 (9 code bytes)
# span:         0x0052825c-0x00528265 (code 9, tables 0, padding 0)
# sha256:       794b1e2c5b995cab9a0e8fb2cf6bb17841e8ac5196e00e5be5a5cfd63a59902d
# evidence:     ev_7a152dca5b4d4270e26c3d32ca1ad001d44bfc411ed4e2c4ce09c304a9d9da5d
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Unwind@0052825c
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Compiler-generated exception-unwind funclet named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_1c
# callees:      calls FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 3 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
# note:         further_unindexed_code_at:0x00528265
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1c, 0x1c  # offset -0x1c

# --- external targets -----------------------------------------------
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)

.org 0x0052825c - 0x401000
.globl FUN_0052825c
FUN_0052825c:
    # block 0x0052825c: entry, 3 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [ebp - field_minus_1c]              # 0052825c
    call FUN_0051e7ba                            # 0052825f
    ret                                          # 00528264

